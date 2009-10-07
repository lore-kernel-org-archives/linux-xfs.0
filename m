Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n971I1Xn148849 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 20:18:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6E544A8DE1
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 18:19:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7lcqmU7v8UPAxrfe for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 18:19:27 -0700 (PDT)
Date: Tue, 6 Oct 2009 21:19:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.31 xfs_fs_destroy_inode: cannot reclaim
Message-ID: <20091007011926.GB32032@infradead.org>
References: <20090930124104.GA7463@infradead.org>
	<4AC60D27.9060703@news-service.com>
	<20091005214348.GA15448@infradead.org>
	<4ACB080D.3010708@news-service.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ACB080D.3010708@news-service.com>
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
To: Patrick Schreurs <patrick@news-service.com>
Cc: Christoph Hellwig <hch@infradead.org>, Tommy van Leeuwen <tommy@news-service.com>, Bas Couwenberg <bas@news-service.com>, XFS List <xfs@oss.sgi.com>

On Tue, Oct 06, 2009 at 11:04:13AM +0200, Patrick Schreurs wrote:
> Christoph Hellwig wrote:
>> It helps a bit, but not so much.  I suspect it could be a double free
>> of an inode, and I have identified a possible race window that could
>> explain it.  But all the traces are really weird and I think only show
>> later symptoms of something that happened earlier.  I'll come up with
>> a patch for the race window ASAP, but could you in the meantime turn on
>> CONFIG_XFS_DEBUG for the test kernel to see if it triggers somehwere
>> and additionally apply the tiny patch below for additional debugging?
>
> Will try this.
>
> Could this by any change be releated (from 2.6.32.2)?

I doubt it, but it's losely in the same area.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
