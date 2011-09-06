Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86Estak085707 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 09:54:55 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 699A51E85C46
	for <xfs@oss.sgi.com>; Tue,  6 Sep 2011 07:54:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vmF6eep3peeepmmJ for
	<xfs@oss.sgi.com>; Tue, 06 Sep 2011 07:54:55 -0700 (PDT)
Date: Tue, 6 Sep 2011 16:54:46 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfs: fix possible overflow in xfs_ioc_trim()
In-Reply-To: <20110906140238.GA11643@infradead.org>
Message-ID: <alpine.LFD.2.00.1109061629490.6026@dhcp-27-109.brq.redhat.com>
References: <1315233205-27093-1-git-send-email-lczerner@redhat.com>
	<20110906140238.GA11643@infradead.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Tue, 6 Sep 2011, Christoph Hellwig wrote:

> On Mon, Sep 05, 2011 at 04:33:25PM +0200, Lukas Czerner wrote:
> > In xfs_ioc_trim it is possible that start+len might overflow. Fix it by
> > decrementing the len so that start+len equals to the file system size in
> > the worst case.
> 
> The idea of the check looks reasonable, but I think it needs to be done
> a bit different.  Was this caught by the new testcase you just sent?

Actually I have found the problem in other file systems too (ext4 and
btrfs) while doing test similar to the one sent recently to xfstests.
Then I fixed the problems, and then I have created the xfstests test for
it so it is clear what the correct behaviour should look like. So yes,
the testcase would have caught the problem.

> 
> > +	xfs_fsblock_t		max_blks =  XFS_MAX_DBLOCKS(&(mp->m_sb));
> 
> XFS_MAX_DBLOCKS is the maximum number of blocks that the given
> geometry could support.  But the last AG could be shorter than the
> others.  I think you really want to check against mp->m_sb.sb_dblocks.
> 

ah, ok, I'll change that. Thanks!

-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
