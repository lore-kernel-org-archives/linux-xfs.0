Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8AG7dJ0225860 for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 11:07:56 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6686443F2AD
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2009 09:08:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id umhFa49IH2OCxAR4 for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2009 09:08:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MlmC3-0005XK-PP
	for xfs@oss.sgi.com; Thu, 10 Sep 2009 16:08:19 +0000
Date: Thu, 10 Sep 2009 12:08:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH] xfs: implement .dirty_inode to fix timestamp handling
Message-ID: <20090910160819.GA21031@infradead.org>
References: <20090827031242.GB6147@infradead.org>
	<20090901180820.GB26071@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090901180820.GB26071@infradead.org>
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
To: xfs@oss.sgi.com

On Tue, Sep 01, 2009 at 02:08:20PM -0400, Christoph Hellwig wrote:
> I managed to trigger the ASSERT in the reclaim path, so it looks both
> this version and our previous code is buggy.  It's back to the drawing
> board for now until I gifure out what's going on.

Okay, figured it out - didn't actually test the asserts as the were
added last minute.  Looks like we could always (before and after the
patch) get into the reclaim path with the timestamp in the xfs inode not
uptodate, and due to the I_CLEAR check we would never update it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
