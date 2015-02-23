Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC10E7F50
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 14:48:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F5B9AC002
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 12:48:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id dXJdtIT8YbAhx6lc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 12:48:23 -0800 (PST)
Date: Mon, 23 Feb 2015 12:48:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs: Ensure we have target_ip for RENAME_EXCHANGE
Message-ID: <20150223204822.GA13522@infradead.org>
References: <54EB782F.8020201@redhat.com>
 <54EB787F.5090600@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54EB787F.5090600@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Carlos Maiolino <cmaiolin@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Seems a little pointless, but given that we overload these
different operations over ->rename making Coverity happy might
not be the worst idea.  Maybe we should just add a different
->rename_exchange methods given that there's not much shared
code anywhere.

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
