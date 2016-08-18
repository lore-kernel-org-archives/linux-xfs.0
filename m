Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 348817CA1
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 12:47:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A71F8AC002
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:47:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id GuKG8WCWPDKuh3fR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2016 10:47:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.85_2 #1 (Red
	Hat Linux)) id 1baRPq-00048h-2m
	for xfs@oss.sgi.com; Thu, 18 Aug 2016 17:47:42 +0000
Date: Thu, 18 Aug 2016 10:47:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: RFC: dropping IRIX support in xfsprogs
Message-ID: <20160818174742.GA14464@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Hi all,

I'd like to know if anyone would complain about removing IRIX support
in xfsprogs?  It very much looks unmaintained for years, and due to
the IRIX differences in type defintions and kernel interfaces it's
actually a bit of a drag on xfsprogs, so unlike the other ports
to FreeBSD and Darwin it would actually be really helpful to remove
it.

I'd volunteer to prepare patches to remove the IRIX support and do
the resulting cleanups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
