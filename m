Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2FA297F37
	for <xfs@oss.sgi.com>; Mon,  9 Nov 2015 01:54:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8EFB6AC004
	for <xfs@oss.sgi.com>; Sun,  8 Nov 2015 23:54:41 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id AvqCXFfFklREoZtP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Nov 2015 23:54:39 -0800 (PST)
Date: Sun, 8 Nov 2015 23:54:38 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 03/51] xfs_io: support reflink and dedupe of file ranges
Message-ID: <20151109075438.GA17974@infradead.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050533.1504.66249.stgit@birch.djwong.org>
	<20151014053656.GJ10397@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151014053656.GJ10397@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Any reason why the dedup command is called 'dedupe'?  Is this a revenge
for the missing 'e' in the creat syscall? :)

Either way it would be good to get this support in ASAP so we can have
the command ready for xfstests and we can merge the test.  They are
useful for btrfs and NFS already, so I'd love to fast track them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
