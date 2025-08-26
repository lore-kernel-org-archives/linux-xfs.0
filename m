Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC2E1A76B1
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220084; cv=none; b=V5c2iOW6RP2wbwXYh0Qt6iGeoKmNgPOBw+N2NQjXQH2eh8ZuSQsyQQ6KBUS9m0lwbUOlBRWR5LRbFpV5lmKBdnR/opP41Q2I/P7IpaUsHlSoy1dwcRfZ80KdFUK95mjBtTdEylMmihj1AHZdpi3lzHVSyMQVGfFFrwvz24cc7pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220084; c=relaxed/simple;
	bh=JN7tUhYPm2yMFYqBruoae9GivgjipaUXNjEamr9hp14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F8qZ7+m2BSJTN1k+RQ0NkPywt8kKTS5c6v+XwV9kWjg323T91kgzp/ZHoj1OSXWNqVqPAIhdKlgyzhL2rGocdXYaPrIwhIa/IHLWp8efNmClvo18Z7D2QxoXgOasf0idKn4jd8khoXdZR+zhBDUPPAvWCAGSzWwcKh4PBsFSyl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpZMq1Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpZMq1Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B7AC4CEF1;
	Tue, 26 Aug 2025 14:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756220083;
	bh=JN7tUhYPm2yMFYqBruoae9GivgjipaUXNjEamr9hp14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpZMq1FftT5hA94xgsxw1psPTI/XqlkghPYgCpvynAYVatoj/ggimP2AJt5OvizDc
	 vIlaZ25/mW9/1iI1OrueKXB3DnFU/OkN5pl9fZGEFmU8kuCf3hclUHEbs5kIh2mi16
	 kkSiq8SB8YXpFQaxp5X+EUE09ZpRkZ67F3yqr3PR7STHNV9TDwwhovKUIEy3N/G6Yd
	 XyY04UJGMVJ4ObK68GYk4yXlDz6J6qBnShrgq9jrjliiH/50h9BTVElLlr2HmYAk0o
	 8dw8JH5XLpcImOghpk/zq/rrp4lTmWO+r4xkbjm0iCxyKdjL7fqeS7ISsR/LbQdog3
	 ddXUewXuF03Gg==
Date: Tue, 26 Aug 2025 07:54:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: aalbersh@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] Improve information about logbsize valid values
Message-ID: <20250826145442.GA19817@frogsfrogsfrogs>
References: <20250826122320.237816-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826122320.237816-1-cem@kernel.org>

On Tue, Aug 26, 2025 at 02:23:12PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Valid values for logbsize depends on whether log_sunit is set
> on the filesystem or not and if logbsize is manually set or not.
> 
> When manually set, logbsize must be one of the speficied values -
> 32k to 256k inclusive in power-of-to increments. And, the specified
> value must also be a multiple of log_sunit.
> 
> The default configuration for v2 logs uses a relaxed restriction,
> setting logbsize to log_sunit, independent if it is one of the valid
> values or not - also implicitly ignoring the power of two restriction.
> 
> Instead of changing valid possible values for logbsize, increasing the
> testing matrix and allowing users to use some dubious configuration,
> just update the man page to describe this difference in behavior when
> manually setting logbsize or leave it to defaults.
> 
> This has originally been found by an user attempting to manually set
> logbsize to the same value picked by the default configuration just so
> to receive an error message as result.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  man/man5/xfs.5 | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/man/man5/xfs.5 b/man/man5/xfs.5
> index f9c046d4721a..b2069d17b0fe 100644
> --- a/man/man5/xfs.5
> +++ b/man/man5/xfs.5
> @@ -246,16 +246,18 @@ controls the size of each buffer and so is also relevant to
>  this case.
>  .TP
>  .B logbsize=value
> -Set the size of each in-memory log buffer.  The size may be
> +Set the size of each in-memory log buffer. The size may be
>  specified in bytes, or in kibibytes (KiB) with a "k" suffix.
> +If set manually, logbsize must be one of the specified valid
> +sizes and a multiple of the log stripe unit - configured at mkfs time.
> +.sp
>  Valid sizes for version 1 and version 2 logs are 16384 (value=16k)
>  and 32768 (value=32k).  Valid sizes for version 2 logs also
> -include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k). The
> -logbsize must be an integer multiple of the log
> -stripe unit configured at mkfs time.
> +include 65536 (value=64k), 131072 (value=128k) and 262144 (value=256k).
>  .sp
>  The default value for version 1 logs is 32768, while the
> -default value for version 2 logs is max(32768, log_sunit).
> +default value for version 2 logs is max(32768, log_sunit) even if
> +log_sunit does not match one of the valid values above.

Weird, but as a documentation stopgap until someone figures out if
there are any bad effects of non-power-of-2 logbsizes,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  .TP
>  .BR logdev=device " and " rtdev=device
>  Use an external log (metadata journal) and/or real-time device.
> -- 
> 2.51.0
> 
> 
