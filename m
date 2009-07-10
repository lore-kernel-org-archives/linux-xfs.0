Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6AG1oIk107714 for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 11:01:53 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B690E1B51C2A
	for <xfs@oss.sgi.com>; Fri, 10 Jul 2009 09:02:27 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 05LquwRG3tDQExdS for
	<xfs@oss.sgi.com>; Fri, 10 Jul 2009 09:02:27 -0700 (PDT)
Date: Fri, 10 Jul 2009 12:02:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: inconsistent lock state on 2.6.30?
Message-ID: <20090710160225.GA14288@infradead.org>
References: <Pine.LNX.4.64.0906230925420.20462@cobra.newdream.net>
	<20090623170844.GA23971@infradead.org>
	<Pine.LNX.4.64.0906241438100.24641@cobra.newdream.net>
	<20090626173558.GA402@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090626173558.GA402@infradead.org>
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
To: Sage Weil <sage@newdream.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

FYI all these warnings are due to the new in reclaim state tracking
that was added to lockdep recently.  I now have a tree fixing all these
warnings including those two you see.  It's all still a bit hacky, but
I'll soon post a patch series to fix them all in one way or another.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
