Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F8837CA0
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 04:12:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 321FA304066
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 02:12:17 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VeGsV2tSBfgDZRbx (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 02:12:15 -0700 (PDT)
Date: Thu, 25 Aug 2016 02:12:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] libxcmd: fix mount option parsing to find rt/log
	devices
Message-ID: <20160825091212.GD5685@infradead.org>
References: <147200546481.15538.12724000421579716885.stgit@birch.djwong.org>
	<147200548998.15538.11330546457799095768.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147200548998.15538.11330546457799095768.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 23, 2016 at 07:24:50PM -0700, Darrick J. Wong wrote:
> It turns out that glibc's hasmntopt implementation returns NULL
> if the opt parameter ends with an equals ('=').  Therefore, we
> cannot directly search for the option 'rtdev='; we must instead
> have hasmntopt look for 'rtdev' and look for the trailing equals
> sign ourselves.  This fixes xfs_info's reporting of external
> log and realtime device paths, and xfs_scrub will need it for
> data block scrubbing of realtime extents.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
