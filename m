Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 649737F4E
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:15:31 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 471B4304032
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:15:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HP63iPaVZujyrl1p (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:15:25 -0800 (PST)
Date: Sun, 3 Jan 2016 04:15:25 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/76] libxfs: pack the agfl header structure so
	XFS_AGFL_SIZE is correct
Message-ID: <20160103121525.GB28429@infradead.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
	<20151219085655.12713.60317.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219085655.12713.60317.stgit@birch.djwong.org>
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

On Sat, Dec 19, 2015 at 12:56:55AM -0800, Darrick J. Wong wrote:
> Because struct xfs_agfl is 36 bytes long and has a 64-bit integer
> inside it, gcc will quietly round the structure size up to the nearest
> 64 bits -- in this case, 40 bytes.  This results in the XFS_AGFL_SIZE
> macro returning incorrect results for v5 filesystems on 64-bit
> machines (118 items instead of 119).  As a result, a 32-bit xfs_repair
> will see garbage in AGFL item 119 and complain.
> 
> Therefore, tell gcc not to pad the structure so that the AGFL size
> calculation is correct.

Do you have a testcase for this?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
