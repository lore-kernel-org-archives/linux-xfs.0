Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40356 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751731AbdBMUdb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2017 15:33:31 -0500
Message-ID: <1487018008.3125.52.camel@HansenPartnership.com>
Subject: Re: xfs: fix inode uid/gid initialization
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 13 Feb 2017 12:33:28 -0800
In-Reply-To: <20170213194337.GA9852@infradead.org>
References: <1487008001.3125.41.camel@HansenPartnership.com>
         <20170213194337.GA9852@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>, Seth Forshee <seth.forshee@canonical.com>

On Mon, 2017-02-13 at 11:43 -0800, Christoph Hellwig wrote:
> On Mon, Feb 13, 2017 at 09:46:41AM -0800, James Bottomley wrote:
> > I was debugging a creation failure using a vfs shifting patch set
> > and
> > discovered that xfs itself doesn't actually respect the superblock
> > namespace in a couple of places (these showed up as files with the
> > wrong ownership in my tests).
> 
> Can you submit your test case to xfstests?  I would be good to have
> testing for this in the regular test runs.

I will eventually ... I'm planning on adding a whole set.  This issue
was just found by untarring a container image and then finding the ids
were wrong ... 

> > The fix is to convert xfs away from hand
> > rolling inode_init_owner() and to use the i_uid/gid_read/write
> > functions.
> 
> What about the various quota users of xfs_kuid_to_uid/gid in
> the create / symlink path?

Yes, looking at it again, xfs_qm_vop_dqalloc() is in terms of the
filesystem view, so current_fsuid(), which gives the uid in the kernel
view, needs to be transformed through the s_user_ns to get it into that
view.

Probably there needs to be an inode_fsuid/fsgid() (similar to i_uid/gid
_read())that returns the filesystem view of fsuid/fsgid

>   I suspect they should be handle the same.
> 
> Also with your patch the di_uid/gid fields should probably just
> go away as they are pointless now.  Something like the patch below,
> although it still doesn't take care of the quota issues pointed out
> above.

Yes, I'll go for that.

James

