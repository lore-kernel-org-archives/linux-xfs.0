Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84EE77F54
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 05:17:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F0A6AC00D
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:17:15 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 88hFkG09UDxVGxpV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:17:13 -0800 (PST)
Date: Mon, 18 Jan 2016 03:17:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfsprogs: misc uClibc patches: use statfs() instead
	of ustat()
Message-ID: <20160118111712.GC17495@infradead.org>
References: <569CBE99.4000309@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569CBE99.4000309@gentoo.org>
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
To: Joshua Kinard <kumba@gentoo.org>
Cc: xfs@oss.sgi.com

A similar but slightly cleaner patch was posted recently, but we'll
try to solve this in an even better although more invasive way.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
