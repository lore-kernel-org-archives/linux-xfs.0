Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26B157F66
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 11:35:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 169D9304032
	for <xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:35:05 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qxP6HWJB0VBEA9TB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 12 Nov 2015 09:35:02 -0800 (PST)
Date: Thu, 12 Nov 2015 09:34:27 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFCv3.1 00/11] xfstests: test the nfs/cifs/btrfs/xfs
	reflink/dedupe ioctls
Message-ID: <20151112173427.GC2217@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
	<20151112090756.GA25685@infradead.org>
	<20151112125115.GA28822@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151112125115.GA28822@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

On Thu, Nov 12, 2015 at 04:51:15AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 12, 2015 at 01:07:56AM -0800, Christoph Hellwig wrote:
> > Looks fine:
> > 
> > Acked-by: Christoph Hellwig <hch@lst.de>
> 
> Actually I take this back.  I had though this was the existing series
> with my fixes, but this one still incorrectly assumes that if reflink
> works dedup works as well, leading to lots of false failures on nfs.

Bleargh, _require_*_dedupe forgot to check for ENOTTY output, so all the dedupe
tests should have _notrun.

Also, generic/806 was calling the wrong _require.

I'll start renumbering tests; Christoph, did you see anything else?

--D

> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
