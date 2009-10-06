Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9692ifS042755 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 04:02:46 -0500
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A1741323A0F
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 02:04:09 -0700 (PDT)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id pEOrLMWCvMX763VP for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 02:04:09 -0700 (PDT)
Message-ID: <4ACB080D.3010708@news-service.com>
Date: Tue, 06 Oct 2009 11:04:13 +0200
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
References: <20090930124104.GA7463@infradead.org>	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
In-Reply-To: <20091005214348.GA15448@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> It helps a bit, but not so much.  I suspect it could be a double free
> of an inode, and I have identified a possible race window that could
> explain it.  But all the traces are really weird and I think only show
> later symptoms of something that happened earlier.  I'll come up with
> a patch for the race window ASAP, but could you in the meantime turn on
> CONFIG_XFS_DEBUG for the test kernel to see if it triggers somehwere
> and additionally apply the tiny patch below for additional debugging?

Will try this.

Could this by any change be releated (from 2.6.32.2)?

commit 2f0ffb7ef75a9ad6140899f6d4df45e8a73a013e
Author: Jan Kara <jack@suse.cz>
Date:   Mon Sep 21 17:01:06 2009 -0700

   fs: make sure data stored into inode is properly seen before 
unlocking  new inode

     commit 580be0837a7a59b207c3d5c661d044d8dd0a6a30 upstream.

     In theory it could happen that on one CPU we initialize a new inode 
but clearing of I_NEW | I_LOCK gets reordered before some of the
     initialization.  Thus on another CPU we return not fully uptodate inode
     from iget_locked().

     This seems to fix a corruption issue on ext3 mounted over NFS.

Thanks,

Patrick Schreurs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
