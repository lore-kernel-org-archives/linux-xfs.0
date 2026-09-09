Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479772931DF;
	Wed,  9 Sep 2026 01:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788916192; cv=none; b=XF71361GPQE5BqhmVEP168vXtnrhPLbfBSZEEryttbxCVB4Fkzx1/bdIdOx6mSQubZMyd5IQt+KPKi5IhbaP8fn1ZfiKNIyjskdgv2Rpbx0r0R6b96OKJWNvLIiOQbgI0TLMIFD/5Askgb6ARQzUC9HoeGUm36A7P/jhDOSkjws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788916192; c=relaxed/simple;
	bh=ei4CJKSBX+0XhUzNXVKSUcQg5ErIoFZEKxRK8mO7+NA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwbtDwe+UH1UUk6g9Tk9+TSqixt9j5PQ4p1Vk7i3UToKEH3mH0JDFCzkixuuerdaxx/RlkSTQDX288eebx3lUcCmW+Cssh0B0FGMyAreaEVpWoLLaqhBIQ60cTDGAVviS0+QBO2ATyy+yA+7WxVQZN7yj+cT19JFDdi1i8WAL0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=LD5D10Vl; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=R9J9dOAc; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="LD5D10Vl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="R9J9dOAc"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 748197A0137;
	Tue,  8 Sep 2026 21:09:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 08 Sep 2026 21:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1788916189;
	 x=1789002589; bh=fkMIiEIrILqEL7Wey6xMHBmtt9EgvuVUfO6oqn+GF1Q=; b=
	LD5D10VlbPSPQ/k3+oIKQ7RhRdwQhacAC7zIkNJBWYHmcFkmcMyTvsk32PbZApCl
	xKDwNJo5Ju3TnLoHNGSoa/gOARbKh58q+ZEpxDDmps1H6KGFRcv6GO8zxIQdHvaZ
	INO8LoKyOuKGJAqndquBGbMliHE4P5wtjleIeURgzL8y0JvwjTjL2RAS8onAKNs9
	r2dlZZbKlHa/CT7RXFin6SBxHtqQfy2KDmvsFlnj+6eMberdnCpX2mS8x9VOh308
	BqbP4Z5hzajC/qL6XAZ4Mx7LJlsvID+BKPk9vRq0MyzXDTmtiXDhe2X8j0VNVTqF
	O4pyXItKWVg7Q7LLg53/9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788916189; x=
	1789002589; bh=fkMIiEIrILqEL7Wey6xMHBmtt9EgvuVUfO6oqn+GF1Q=; b=R
	9J9dOAcW+6043eZgptdqYgvIpKZDoArLskIdu6Sz0g3AGQ2nNOzMg3/dio2U2L1e
	Rs52yD0OJjK99NCOti9+FTElP5n6b74WF9/wRTmJNcJtJqQgrdYNHdVYdtAJY273
	t2zMpj7xTqN/7aGG2Zl8dC2w1Rz6mvsEE7b+IGScCa6ylQXh3lUxAAkvlaIjV4gz
	BwVRuznCENEtk17gxVPqse1UyfJiunAwsFliybOIM4JbLXZgyHU+GTOnR+c8EKFX
	waddt11vTI7eSxpH88Pmvvc5tM2JPyoYAZSh/EMzDFgMWni5zTud/sggCbYgwPk4
	HllglvpK1+ajKY1pfV5Sg==
X-ME-Sender: <xms:3bGgaq6Z5JN-0Zzld0-sC5xRmkIukCX_TRmcpUXH_pcpYg9_sUCdMQ>
    <xme:3bGgalbtcHAUCnCFprEnLBwo3Aa051iJq_I2FzVxSYU5d7xEVHryhcomOum4d-ntW
    ZofVeqj0VL1jIFbqupwQTgieBy_VUj2UVVSBlqFtdNfeOM8b59CSuKC_Q>
X-ME-Received: <xmr:3bGgapgOrul8b-rki5QxVzbb5PI52_Q3n7R5MNkSdQSPNUOO2eWm2IAZNrlnoZFnaOYGwcz20JfobHVTjeaX4yvs>
X-ME-Proxy-Cause: dmFkZTGEAv5fg+wcke1DSNBEvDRG+tvrwCJBkRg+GLkMxqB2HvJkEBN1VfcdAUWjws6mDC
    JcPtD/z695C1UcibIkKRYOTtnqcsurzJMnCzLpkDmSr2GDyAaMlWkjUewpNAhS0/ucurcF
    wFQEE2oHWswOEwDtHQrMOo6dG6rA7bC9sQwtORzOQKeKi6hAGWjmD/tbpr+2pbbOVUIWkH
    8UtJLCC2C7VArLMhEGhfQldx53nu6dzgI26TkEsRmPo7xSTYXp5zKFnbtyBokm1XuO/zCN
    HwTUQ7J3RX54+QExFGnZ1fKJcv6DfXbp7ubcym8LPDzbThnQSZiDCWZKrXzIzkkZTFFjiJ
    Z8Nuoo6LF09C7k/xNsVL+NEaicnL7yMuN9J8627IBQ999ymrv++wk/VBvmMEe5WMtV0Xvw
    dezTyoRrnFpbfM6gyyRi5DtdhAwVdLtoK5Wro0ie2Msn5mZS+OFDd4l5im5YZORD8c0ZfG
    MjwkoGI2p4wgW44ZC7xpG0zFYwrXYgRb7Rl8Dh3rcREg/tyx71Vd3UCX1sFGPTlN6fYPVW
    7vcyt5cTT6ku9NN2z90tBER9AfkVONNBgPFtpbLVvdAkqGVLh3vrsYvnuLYzg5w29CG/e7
    X1ppboD+085IgF2y+yaQK6ORi/h+oAO8KdCzFgLWzjy0Z6oh/8H8cLUVvQ9g
X-ME-Proxy: <xmx:3bGgam8gVSi8SIO3Ihy3T0LvExLf2Mmiy5u-wCqPsZkGUXnen_N84A>
    <xmx:3bGgakrR7yXO29UY1QCsw4EjRO7PYBFz0325txuw4NVxBVrUG5T8HA>
    <xmx:3bGgauXZzbAmVptM603sTvuybcRV_CyZl1sx8O1uXnDYOaHr4o-2ug>
    <xmx:3bGgajDfSPfRcbIUYUoLycvcS9mWgFcmo4HXkyCZ2mQI9dC9cOWnJg>
    <xmx:3bGgalsVgW08aSaHvr8sQ3cMctqiSDuyNThHpHHZ6gpVZ1GmzTrZ4ztt>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 21:09:48 -0400 (EDT)
Message-ID: <1c5bebcd-76f5-407f-b3af-a6170fff2497@sandeen.net>
Date: Tue, 8 Sep 2026 20:09:47 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs: add per-mount read/write I/O completion counters
To: Eric Peterson <linuxinstalled@gmail.com>, Carlos Maiolino
 <cem@kernel.org>, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Peterson <eric.peterson@hpe.com>
References: <20260828033429.4070267-1-linuxinstalled@gmail.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260828033429.4070267-1-linuxinstalled@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/27/26 10:34 PM, Eric Peterson wrote:
> From: Eric Peterson <eric.peterson@hpe.com>
> 
> Add two per-mount statistics counters, xs_read_completions and
> xs_write_completions, to complement the existing xs_read_calls and
> xs_write_calls counters. The existing counters count I/O submissions
> (entries); the new counters count I/O completions. The pair (calls,
> completions) lets a consumer compute outstanding I/O as a queue depth
> (calls - completions) and, via Little's law, derive an approximate
> response time in userspace without any hot-path timestamping.

After reading through this thread, it occurs to me that it might
be worth asking my favorite question: what problem are you trying
to solve?

Please don't answer with LLM output.

Thanks,
-Eric

> The counters are plain monotonic increments (no clock reads), so they
> add negligible cost to the read/write path. Per-op timestamping was
> deliberately not used: a clock read on the hot path costs ~20-30 ns on
> TSC but hundreds of ns to ~1 us on HPET, which would be a regression for
> general users. Queue depth from completion counters is an approximation
> (instantaneous depth); this is a deliberate design choice, not
> a placeholder.
> 
> Completions are accounted at exactly the same sites where XFS already
> accounts the xs_*_bytes counters, so their semantics match the existing
> byte counters per path:
> 
>   - Reads are counted at the frame in xfs_file_read_iter and
>     xfs_file_splice_read.
>   - Buffered writes are counted at the frame, i.e. when data reaches
>     the page cache, mirroring how xs_write_bytes is accounted for
>     buffered writes -- not at physical writeback.
>   - DAX writes are counted at the frame after the synchronous
>     dax_iomap_rw copy returns, mirroring xs_write_bytes for DAX.
>   - Direct I/O writes are counted at true completion in
>     xfs_dio_write_end_io, which is async-safe and fires for both sync
>     and async DIO, mirroring xs_write_bytes for DIO.
> 
> Caveat: async O_DIRECT reads are counted at submission, not completion,
> because XFS has no read end_io today (iomap_dio_rw is called with NULL
> ops for reads). This matches the existing read-byte semantics.
> 
> The counters are uint32_t and wrap like the existing xs_*_calls
> counters; userspace diffs handle wrap.
> 
> The per-mount stats file gains a new appended "rwcmpl" line printing
> write and read completions. The existing "rw" line is unchanged, so
> positional parsers of "rw" are unaffected:
> 
>   rw     <write_calls>       <read_calls>
>   rwcmpl <write_completions> <read_completions>
> 
> Signed-off-by: Eric Peterson <eric.peterson@hpe.com>
> ---
> 
> Notes for reviewers (not part of the commit log):
> 
> * Placement: the new "rwcmpl" group is inserted between "rw" and
>   "attr" in the xstats[] table. The "rw" line itself is unchanged,
>   and "rwcmpl" is appended after it, but lines below "rw" in
>   /proc/fs/xfs/stat shift by one for strictly positional parsers. I
>   can instead append the group at the END of the table if preferred.
> 
> * checkpatch --strict reports two CHECKs preferring u32 over uint32_t
>   for the new fields. They are kept as uint32_t to match struct
>   __xfsstats, whose every field is uint32_t; changing only these two
>   would break local consistency.
> 
> * Testing: fstests -g auto on v6.12.74 shows baseline and patched
>   fail the identical 6/1277 tests -- zero regressions. The rwcmpl
>   interface was verified on hardware (rw >= rwcmpl, counters
>   advance under load). This for-next port applies cleanly with no
>   drift and compiles clean; a runtime -g quick smoke on for-next was
>   omitted as the logic is identical to the tested v6.12.74 patch.
>  fs/xfs/xfs_file.c  | 11 +++++++++--
>  fs/xfs/xfs_stats.c |  3 ++-
>  fs/xfs/xfs_stats.h |  2 ++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 426a67b813..3ecd4ed534 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -347,8 +347,10 @@ xfs_file_read_iter(
>  	else
>  		ret = xfs_file_buffered_read(iocb, to);
>  
> -	if (ret > 0)
> +	if (ret > 0) {
>  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
> +		XFS_STATS_INC(mp, xs_read_completions);
> +	}
>  	return ret;
>  }
>  
> @@ -375,8 +377,10 @@ xfs_file_splice_read(
>  	xfs_ilock(ip, XFS_IOLOCK_SHARED);
>  	ret = filemap_splice_read(in, ppos, pipe, len, flags);
>  	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
> -	if (ret > 0)
> +	if (ret > 0) {
>  		XFS_STATS_ADD(mp, xs_read_bytes, ret);
> +		XFS_STATS_INC(mp, xs_read_completions);
> +	}
>  	return ret;
>  }
>  
> @@ -663,6 +667,7 @@ xfs_dio_write_end_io(
>  	 * for it on submission.
>  	 */
>  	XFS_STATS_ADD(ip->i_mount, xs_write_bytes, size);
> +	XFS_STATS_INC(ip->i_mount, xs_write_completions);
>  
>  	/*
>  	 * We can allocate memory here while doing writeback on behalf of
> @@ -1032,6 +1037,7 @@ xfs_file_dax_write(
>  
>  	if (ret > 0) {
>  		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
> +		XFS_STATS_INC(ip->i_mount, xs_write_completions);
>  
>  		/* Handle various SYNC-type writes */
>  		ret = generic_write_sync(iocb, ret);
> @@ -1098,6 +1104,7 @@ xfs_file_buffered_write(
>  
>  	if (ret > 0) {
>  		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
> +		XFS_STATS_INC(ip->i_mount, xs_write_completions);
>  		/* Handle various SYNC-type writes */
>  		ret = generic_write_sync(iocb, ret);
>  	}
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index c13d600732..5b276666b6 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -40,7 +40,8 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		{ "log",		xfsstats_offset(xs_try_logspace)},
>  		{ "push_ail",		xfsstats_offset(xs_xstrat_quick)},
>  		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
> -		{ "rw",			xfsstats_offset(xs_attr_get)	},
> +		{ "rw",			xfsstats_offset(xs_write_completions)	},
> +		{ "rwcmpl",		xfsstats_offset(xs_attr_get)	},
>  		{ "attr",		xfsstats_offset(xs_iflush_count)},
>  		{ "icluster",		xfsstats_offset(xs_inodes_active) },
>  		{ "vnodes",		xfsstats_offset(xb_get)		},
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 57c32b86c3..608d12d0c6 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -93,6 +93,8 @@ struct __xfsstats {
>  	uint32_t		xs_xstrat_split;
>  	uint32_t		xs_write_calls;
>  	uint32_t		xs_read_calls;
> +	uint32_t		xs_write_completions;
> +	uint32_t		xs_read_completions;
>  	uint32_t		xs_attr_get;
>  	uint32_t		xs_attr_set;
>  	uint32_t		xs_attr_remove;

