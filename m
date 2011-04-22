Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3M6lqMT202681 for <xfs@oss.sgi.com>; Fri, 22 Apr 2011 01:47:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D52EF1D5EDCC
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 23:51:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 6XoMZm4XLukBG3qZ for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2011 23:51:20 -0700 (PDT)
Date: Fri, 22 Apr 2011 02:51:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] xfsprogs: fixes a regression hang in xfs_repair phase 4
Message-ID: <20110422065120.GB14189@infradead.org>
References: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTikBSadR7K2RfiS2k60nEOPncaDfyw@mail.gmail.com>
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
To: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Cc: xfs@oss.sgi.com

The patch looks good to me.  But I'm a bit worried about the lack of
test coverage.  As Eric said if you're able to get a metadump of
a filesystem that shows this issue it would come in useful for
regression testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
