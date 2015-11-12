Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A0437F62
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 10:58:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4C65AC004
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 08:58:04 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cM8DqH4jKGBlB0nn (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 08:58:02 -0800 (PST)
Date: Thu, 12 Nov 2015 08:58:01 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] xfs: create helper for bmap finish & trans join in
	attr code
Message-ID: <20151112165801.GA14854@infradead.org>
References: <56441B8E.6070603@redhat.com>
 <5644BEF8.6070201@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5644BEF8.6070201@sandeen.net>
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
Cc: xfs@oss.sgi.com

I think the problem here is simply that our interfaces suck.
xfs_trans_roll really needs to rejoin any inode to the new transaction
to that was joined to the previous one.  Once we've fixed that we can
get rid of the silly committed arguments and everyone will be happy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
