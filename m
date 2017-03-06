Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753339AbdCFN7n (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Mar 2017 08:59:43 -0500
Date: Mon, 6 Mar 2017 08:05:01 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Significantly longer fallocate times with Flag Unwritten Extents
 disabled
Message-ID: <20170306130500.GA3223@bfoster.bfoster>
References: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEOfVRnuTD0AWNSE+_-3KVL_xTcgrq5Q8+mm0mEQYua7gaGQiQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill McDuck <billmcdave@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 06, 2017 at 12:02:01PM +0000, Bill McDuck wrote:
> Hello.
> 
> I have been testing the performance of XFS with "Flag Unwritten
> Extents" enabled and disabled.
> 
> For security reasons I know XFS flags all unwritten extents by
> default, so that uninitialized disk space cannot be read by the user.
> In my application I actually want to have access to this uninitialized
> disk space. I have been modifying the superblocks using xfs_repair to
> enable this functionality.
> 
> Interestingly, I have found that creating a 10 GB file using fallocate
> is significantly slower with unwritten flag extents disabled.  For
> instance, creating a 10GB file takes 32 seconds on my (slow) machine,
> whereas with the flag enabled, the process is almost instantaneous.
> 
> Does anyone know why creating an uninitialized file is so much slower
> when the unwritten extents flag functionality is disabled?  I know
> that the disk is not being initialized to zero, as I can read back non
> zero content.
> 

On a quick fallocate test, it is actually zeroing out the blocks in the
post-fallocate setattr (to set the inode size). If the fallocate changes
the size of the file, we call xfs_vn_setattr_size(). That eventually
calls an xfs_zero_range() on the blocks between the old eof and new eof.
I suspect this occurs regardless of whether you've disabled the
unwritten flag bit, but the iomap_zero_range() codepath can shortcut
through the extents when they are marked as unwritten. You can get
around this by truncating the file before the fallocate.

BTW, if you are hitting this behavior and can read non-zero data
afterwards that you are sure you have not written or is not already
inside eof at the time of the falloc, you may be hitting a bug. Please
verify and follow up with details of your test case if you can indeed
reproduce that behavior. I don't reproduce it in my test env (without a
truncate first)..

Brian

> For my application I'm interested in creating large uninitialised
> files quickly, so I'm very interested to know what additional
> operations are being performed with the flagging disabled.
> 
> Thanks for the help.
> 
> Bill.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
