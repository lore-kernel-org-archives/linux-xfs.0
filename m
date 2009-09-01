Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n81I7O9P198127 for <xfs@oss.sgi.com>; Tue, 1 Sep 2009 13:07:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0BA1159E3B8
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2009 11:08:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nenOO104O2S2QQF5 for
	<xfs@oss.sgi.com>; Tue, 01 Sep 2009 11:08:20 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MiXmG-0008DM-L0
	for xfs@oss.sgi.com; Tue, 01 Sep 2009 18:08:20 +0000
Date: Tue, 1 Sep 2009 14:08:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH] xfs: implement .dirty_inode to fix timestamp handling
Message-ID: <20090901180820.GB26071@infradead.org>
References: <20090827031242.GB6147@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090827031242.GB6147@infradead.org>
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

I managed to trigger the ASSERT in the reclaim path, so it looks both
this version and our previous code is buggy.  It's back to the drawing
board for now until I gifure out what's going on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
