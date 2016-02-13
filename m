Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F69E7CA2
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 02:03:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D526304051
	for <xfs@oss.sgi.com>; Sat, 13 Feb 2016 00:03:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id egHKaO6SL5K8tXbR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 13 Feb 2016 00:03:23 -0800 (PST)
Date: Sat, 13 Feb 2016 00:03:21 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4.2 00/32] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20160213080321.GB2151@infradead.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
	<20160213012659.GA14668@dastard>
	<20160213043834.GC26204@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160213043834.GC26204@birch.djwong.org>
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
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Feb 12, 2016 at 08:38:34PM -0800, Darrick J. Wong wrote:
> > Followup patch, anyway, because I'm about to push out everything
> > that was in your second pull req (i.e. with the aiocp fix).
> 
> xfs_io "bmap -c" is a new switch that dumps the CoW fork of a file.
> AFAICT there isn't any way to check that an xfs_io command supports
> a particular switch, though it wouldn't be difficult to add a check.

Just test for it the same way we test for the existance of xfs_io
subcommmand.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
