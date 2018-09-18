Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:43994 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729165AbeIRItE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 04:49:04 -0400
Date: Mon, 17 Sep 2018 23:18:30 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH V3 01/19] Fix xfs/009 to work with 64k block size
Message-ID: <20180918031830.GA15708@thunk.org>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
 <20180912062626.14349-2-chandan@linux.vnet.ibm.com>
 <20180917225925.GE4635@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180917225925.GE4635@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests@vger.kernel.org, guaneryu@gmail.com, linux-xfs@vger.kernel.org

On Mon, Sep 17, 2018 at 03:59:25PM -0700, Darrick J. Wong wrote:
> 
> Hm.  Certain filesystems draw a distinction between the fundamental
> block size and the minimum file block mapping size.  ocfs2 supports
> having a file cluster size (mkfs.ocfs2 -C) that is greater than the fs
> block size, and (I think) xfs can achieve something similar for files on
> a realtime device via the mkfs.xfs -r extsize= option.
> 
> If you're dealing with writing things into a file for a test, I think
> you have to use _get_file_block_size to make sure that you don't fall
> afoul of the cluster/block difference.  I don't know if you've checked
> that for this patch series...?
> 
> (Granted, I suspect that many tests have been sloppy about this...)

Indeed, we have a number of failures in ext4 bigalloc which are
because of this block size vs. cluster size difference.  IIRC, a while
back Eric Whitney had tried to start a discussion about how to best
deal with this issue, but it wasn't clear what was the right way to
add the necessary infrastructure to xfstests.  I had assumed it was an
ext4-only problem, and no one had time to try to come up with a
solution.

As far as I know, we still don't have any general infrastructure to
support this in xfstests.  Is this correct, or am I missing something?

	     		      	   	    - Ted
