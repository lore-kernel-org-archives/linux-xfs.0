Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4770D7CA0
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 11:33:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C6A75AC007
	for <xfs@oss.sgi.com>; Thu, 26 May 2016 09:33:01 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xYyHFK2SHxQk4jSU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 26 May 2016 09:32:59 -0700 (PDT)
Date: Thu, 26 May 2016 09:32:49 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: question about xfs/122
Message-ID: <20160526163249.GA4595@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
	<5746A64D.6080309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5746A64D.6080309@cn.fujitsu.com>
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
To: Xiao Yang <yangx.jy@cn.fujitsu.com>
Cc: xfs@oss.sgi.com

On Thu, May 26, 2016 at 03:31:25PM +0800, Xiao Yang wrote:
> Hi Darrick
> 
> When i run xfstests test case xfs/122 on RHEL7.2GA with xfsprog-dev(4.5.0),
> I always get such error about xfs/122:
> ---------------------------------------------------------
>  sizeof(struct xfs_extent_data_info) = 32
>  sizeof(struct xfs_fs_eofblocks) = 128
>  sizeof(struct xfs_icreate_log) = 28
> -sizeof(struct xfs_refcount_key) = 4
> -sizeof(struct xfs_refcount_rec) = 12
> -sizeof(struct xfs_rmap_key) = 4
> -sizeof(struct xfs_rmap_rec) = 24
> -sizeof(struct xfs_rmapx_key) = 20
>  sizeof(xfs_agf_t) = 224
>  sizeof(xfs_agfl_t) = 36
>  sizeof(xfs_agi_t) = 336
> ---------------------------------------------------------
> 
> This case can pass with modern xfsprogs(i.e. 4.3+ and all the new v5 stuff) as you said.
> Could you tell me which specific version can support this case. In addition, what can be
> done to work around this failure.

The missing fields are for the reflink and rmap btrees.  I could say
to just ignore it, but I don't want to establish a precedent of
ignoring xfs/122 errors...

I'm wondering if perhaps this test ought to filter out /missing/ lines
in the test output?

--D

> 
> Please advise. Thanks very much.
> 
> Regards,
> Xiao Yang
> 
> 
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
