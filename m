Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QBRJrH153535 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 06:27:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34DD3160DE00
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 04:33:08 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	itjAk8oFeKjOoYPN for <xfs@oss.sgi.com>;
	Mon, 26 Sep 2011 04:33:08 -0700 (PDT)
Date: Mon, 26 Sep 2011 07:27:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: test timestamps before the epoch
Message-ID: <20110926112716.GA22382@infradead.org>
References: <4E778C51.7040100@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E778C51.7040100@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

This one actually ends up failing on XFS for me:

@@ -1,5 +1,5 @@
 QA output created by 258
 Creating file with timestamp of Jan 1, 1960
 -Stat of file yields: -315593940
 +Stat of file yields: -315615540
  Remounting to flush cache
 -Stat of file yields: -315593940
 +Stat of file yields: -315615540

Note that we still get the same for both, it just seems XFS rounds it
a bit different.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
