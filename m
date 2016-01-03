Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 14D9D7F5A
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 06:22:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A7A7CAC003
	for <xfs@oss.sgi.com>; Sun,  3 Jan 2016 04:22:12 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gXQiAyWowKdBHDCb (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jan 2016 04:22:11 -0800 (PST)
Date: Sun, 3 Jan 2016 04:22:10 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/22] xfsdocs: fix asciidoc confusion w.r.t. include
	file newline at EOF
Message-ID: <20160103122210.GA14361@infradead.org>
References: <20151219091208.15558.65013.stgit@birch.djwong.org>
	<20151219091215.15558.79820.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151219091215.15558.79820.stgit@birch.djwong.org>
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
Cc: hch@infradead.org, xfs@oss.sgi.com

On Sat, Dec 19, 2015 at 01:12:15AM -0800, Darrick J. Wong wrote:
> Space each include one line apart so that asciidoc knows that each
> section has ended at included file's EOF.  This prevents it from
> spewing horribly confused XML that blows up xmllint if each included
> file doesn't itself end with a blank line.

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
