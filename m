Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4FCD97F3F
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 23:31:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 40F20304053
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 21:31:27 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id U11VTN7hUI7JTFSi (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 21:31:24 -0800 (PST)
Date: Tue, 5 Jan 2016 21:31:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4] xfs: eliminate committed arg from xfs_bmap_finish
Message-ID: <20160106053123.GA19935@infradead.org>
References: <56441B8E.6070603@redhat.com> <5644BEF8.6070201@sandeen.net>
	<568C131C.9080907@sandeen.net> <568C917C.9050509@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <568C917C.9050509@sandeen.net>
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

Looks great!

Reviewed-by: Christoph Hellwig <hch@lst.de>

Note that the "if (*tpp != tp)" trick also works in xfs_bmap_finish, which
will allows us to fold __xfs_trans_roll into xfs_trans_roll in a follow
on patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
