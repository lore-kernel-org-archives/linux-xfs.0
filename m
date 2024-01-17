Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A49633
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 02:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.111.4.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705458821; cv=none; b=erufUTG4UVrmG6iY1u/uqMeZF2uIJa4A8Dclkn4DBwLh6dSHkLUYCKfA29+vWeJagZhe5N5KPivGFKoWBhEa/E7DJ4Ak1YJ3byvZh23KoRHnISPdCL60P0fssjDXYDRjx1WTgBa3omfr4Lt0m6RTyEcV1ZdP47kKiUSRk0hd9M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705458821; c=relaxed/simple;
	bh=GZs7/Wnhj/mPPVBAb77kLP/UDrcXTZNKx8eStJsyAME=;
	h=Received:Received:DKIM-Signature:DKIM-Signature:X-ME-Sender:
	 X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding; b=FmQk6gtoV0VZDU14yGcO0o3R9HiA/gHl9w4ERbjaE96eu2BDja4S9FtHdpMRM2GnnVZo6iCSZvssRZcIE7TuTBz9NeXDvYUh1fC+H72sE4oJ90+K2V0wgDlmylj357MpUhct3m3tXl1Ne9O6xD8xXA1LjS0RTWL6Za4CayeyVyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net; spf=none smtp.mailfrom=themaw.net; dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b=D2Sb7Hba; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=oUFqPhcz; arc=none smtp.client-ip=66.111.4.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=themaw.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="D2Sb7Hba";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="oUFqPhcz"
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id AF6565C0130;
	Tue, 16 Jan 2024 21:33:37 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 16 Jan 2024 21:33:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1705458817;
	 x=1705545217; bh=CKdZ0gJoQmOf0TOyntsm5ahqJuQaXDddBXduglAh+mg=; b=
	D2Sb7HbaKCqZa2zgnvkPUTrQyTOJ3fGkwS73h/5rUq4fsE8l3wElsSMmcEN+tctk
	O9AlHAWl86XMyoFNOA++Y+UvD2K78OReFv1OqkQfdFCG6LWqbkm2KzeUDNiDWqst
	8N9vDyE8Zws1z4J9VUihGHHxIutdaYwuMK2QiZ4u5dBiwQpc6F+Fd29EY1hXLQPi
	hebkUaB0Q+p6l8qLfvDHjKzhmUmzvsfZBQ5EqRLa6kgOLZycdqhji94r6bZLS5wR
	cE68cORyPLf/SFUpY3AQ99uXgdPt8yGl1iHKr1JnhdQbPgXrD9rrTTqt/wii9q4O
	w07JSMFouqqXS65OQK5ksg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1705458817; x=
	1705545217; bh=CKdZ0gJoQmOf0TOyntsm5ahqJuQaXDddBXduglAh+mg=; b=o
	UFqPhczeWX+dQCjaIHRsrCqdPBEzHRLEK/ELf0TD5i9JGcrwxUIKhUKmFZ7gPZtv
	FB3197M8itZb8up9gF+DfvOVtRVJXL0ecMfyiJ7dCOulY4GseqT3oUVvYTx964yE
	XxdB5rgdtdhT3uB6Z3AZYe/5K+05mU3eJbnfJyLxnrG539dv99uG8ppBNj/885NS
	BAIKevNThudj+QVxde7UL+foodqSKZv5gDXE8dbvAoIugrwxli56bd60umtzz5Rv
	8QQrAWHdkPJ8QVKdtPhFf0FZhq81r8aljDZEin6qkJ1JMCpFHZ7ZFZmH8O5BRoU3
	vFHmHrMeknZmKSGm3gD3A==
X-ME-Sender: <xms:gTynZVV0qyKZu9dF-XNYYxZjugA2C6MH4FeMGBOSpyIfk7EqaQPCVw>
    <xme:gTynZVkC1wnn1_nTnrNoE6T2a7wz2y2njBHSxQQiCLp52vze7r_HRW9UW-vUHIRAG
    btTcHkkBXrq>
X-ME-Received: <xmr:gTynZRZOFKxRUmBaDoV3lY9UMnI2qbdicQhO9Ve9P4wzEmuhd-aD5jP9D0UHVAkVSqvvxwTzBLv8auwQbcSecnWLO_LPdDlLEC3LPwrxJqbz4bPMULRWw419>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrvdejgedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfgfuvfevfhfhjggtgfesth
    ejredttdefjeenucfhrhhomhepkfgrnhcumfgvnhhtuceorhgrvhgvnhesthhhvghmrgif
    rdhnvghtqeenucggtffrrghtthgvrhhnpeeuhfeuieeijeeuveekgfeitdethefguddtle
    ffhfelfeelhfduuedvfefhgefhheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:gTynZYVv-NcB3gZ0bLpu3MLAMduXVqChoZJr3G3fvGl4adOAq9zUag>
    <xmx:gTynZfm92IkyjHlsHNb3cyy1jkfsnxomZ1bAn1X_n5IAg6flKyozwQ>
    <xmx:gTynZVc1afxykjaPg9qgCx_zVb1zZAtYCUteLNzT6d6lnNAD653XNg>
    <xmx:gTynZevXmOZULvAIbfrZsFOzXncoLZIrknW9mtbSdadVMonRErGENg>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 16 Jan 2024 21:33:35 -0500 (EST)
Message-ID: <94b7d2bd-a07c-1648-f3da-c1b395ca61bc@themaw.net>
Date: Wed, 17 Jan 2024 10:33:32 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] xfs: read only mounts with fsopen mount API are busted
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: chandan.babu@oracle.com
References: <20240116043307.893574-1-david@fromorbit.com>
Content-Language: en-US
From: Ian Kent <raven@themaw.net>
In-Reply-To: <20240116043307.893574-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 16/1/24 12:33, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Recently xfs/513 started failing on my test machines testing "-o
> ro,norecovery" mount options. This was being emitted in dmesg:
>
> [ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.
>
> Turns out, readonly mounts with the fsopen()/fsconfig() mount API
> have been busted since day zero. It's only taken 5 years for debian
> unstable to start using this "new" mount API, and shortly after this
> I noticed xfs/513 had started to fail as per above.
>
> The syscall trace is:
>
> fsopen("xfs", FSOPEN_CLOEXEC)           = 3
> mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
> .....
> fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
> fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
> fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
> fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
> close(3)                                = 0
>
> Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
> what threw out the error.
>
> During mount instantiation, we call xfs_fs_validate_params() which
> does:
>
>          /* No recovery flag requires a read-only mount */
>          if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
>                  xfs_warn(mp, "no-recovery mounts must be read-only.");
>                  return -EINVAL;
>          }
>
> and xfs_is_readonly() checks internal mount flags for read only
> state. This state is set in xfs_init_fs_context() from the
> context superblock flag state:
>
>          /*
>           * Copy binary VFS mount flags we are interested in.
>           */
>          if (fc->sb_flags & SB_RDONLY)
>                  set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
>
> With the old mount API, all of the VFS specific superblock flags
> had already been parsed and set before xfs_init_fs_context() is
> called, so this all works fine.
>
> However, in the brave new fsopen/fsconfig world,
> xfs_init_fs_context() is called from fsopen() context, before any
> VFS superblock have been set or parsed. Hence if we use fsopen(),
> the internal XFS readonly state is *never set*. Hence anything that
> depends on xfs_is_readonly() actually returning true for read only
> mounts is broken if fsopen() has been used to mount the filesystem.
>
> Fix this by moving this internal state initialisation to
> xfs_fs_fill_super() before we attempt to validate the parameters
> that have been set prior to the FSCONFIG_CMD_CREATE call being made.

Wow, good catch, and equally good analysis, Dave.


Ian

>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Fixes: 73e5fff98b64 ("xfs: switch to use the new mount-api")
> cc: stable@vger.kernel.org
> ---
>   fs/xfs/xfs_super.c | 27 +++++++++++++++++----------
>   1 file changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 96cb00e94551..0506632b5cf2 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1508,6 +1508,18 @@ xfs_fs_fill_super(
>   
>   	mp->m_super = sb;
>   
> +	/*
> +	 * Copy VFS mount flags from the context now that all parameter parsing
> +	 * is guaranteed to have been completed by either the old mount API or
> +	 * the newer fsopen/fsconfig API.
> +	 */
> +	if (fc->sb_flags & SB_RDONLY)
> +		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> +	if (fc->sb_flags & SB_DIRSYNC)
> +		mp->m_features |= XFS_FEAT_DIRSYNC;
> +	if (fc->sb_flags & SB_SYNCHRONOUS)
> +		mp->m_features |= XFS_FEAT_WSYNC;
> +
>   	error = xfs_fs_validate_params(mp);
>   	if (error)
>   		return error;
> @@ -1977,6 +1989,11 @@ static const struct fs_context_operations xfs_context_ops = {
>   	.free        = xfs_fs_free,
>   };
>   
> +/*
> + * WARNING: do not initialise any parameters in this function that depend on
> + * mount option parsing having already been performed as this can be called from
> + * fsopen() before any parameters have been set.
> + */
>   static int xfs_init_fs_context(
>   	struct fs_context	*fc)
>   {
> @@ -2008,16 +2025,6 @@ static int xfs_init_fs_context(
>   	mp->m_logbsize = -1;
>   	mp->m_allocsize_log = 16; /* 64k */
>   
> -	/*
> -	 * Copy binary VFS mount flags we are interested in.
> -	 */
> -	if (fc->sb_flags & SB_RDONLY)
> -		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> -	if (fc->sb_flags & SB_DIRSYNC)
> -		mp->m_features |= XFS_FEAT_DIRSYNC;
> -	if (fc->sb_flags & SB_SYNCHRONOUS)
> -		mp->m_features |= XFS_FEAT_WSYNC;
> -
>   	fc->s_fs_info = mp;
>   	fc->ops = &xfs_context_ops;
>   
