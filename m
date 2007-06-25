Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 14:56:32 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PLuPtL009830
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 14:56:26 -0700
Date: Mon, 25 Jun 2007 15:56:25 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070625215625.GL5181@schatzie.adilger.int>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625135051.GH1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625135051.GH1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, David Chinner <dgc@sgi.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Jun 25, 2007  19:20 +0530, Amit K. Arora wrote:
> @@ -2499,7 +2500,8 @@ long ext4_fallocate(struct inode *inode,
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_
>  	 */
> -	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
> +	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
> +		!(mode == FA_ALLOCATE || mode == FA_RESV_SPACE))
>  		return -EOPNOTSUPP;

This should probably just check for the individual flags it can support
(e.g. no FA_FL_DEALLOC, no FA_FL_DEL_DATA).

I also thought another proposed flag was to determine whether mtime (and
maybe ctime) is changed when doing prealloc/dealloc space?  Default should
probably be to change mtime/ctime, and have FA_FL_NO_MTIME.  Someone else
should decide if we want to allow changing the file w/o changing ctime, if
that is required even though the file is not visibly changing.  Maybe the
ctime update should be implicit if the size or mtime are changing?

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
