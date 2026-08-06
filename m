Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7E83C3F60;
	Thu,  6 Aug 2026 18:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786042150; cv=none; b=UiQwbuMEh4wfTgGfL2x/RSI27mpYd8/jz6E5cqgCTMZsHjbmoOhW2HLXaBuwDdG3MCmzp48/sD2ueZhhCBc/LVNo0M1ryZIJH3okGtC9o6rtE09cCT717Z4P/oGkQTfQ+76UBBqASyRGVHHEX66ShBH7tYeAqRetHEYidREK6gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786042150; c=relaxed/simple;
	bh=9Yw0ukhFp4UBdkYBr4f+shaFsc/jYGJFGtwPtVQ2Jpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UP723770oW3Gc96rOzae4WieeFu5azh/8p+DkXZw3qzpkUpx3332bn56t2J6tcZ0uC4nA0lzEulEkfblykVNFRgtEEe4XJxuY+3t+XM1Dzsnless/Za9P97tCwKKraaFXvK1IXasg38vUTDiYDa1dUWcQebFBS/8nGR8md7T8Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W7QdrNxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W7QdrNxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B52D1F000E9;
	Thu,  6 Aug 2026 18:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786042143;
	bh=DOWEjceKcmMv9Bc2yQdiEO+jKuGFe1bkVaEPBXOpZKo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W7QdrNxEVBdUngyfwpF04fKb1FyfrNrIlz8+ptpAqSz1ErLY2RPf8etcQpM9Ri79b
	 Z+/B2NGQ9Ng4eBvBM3qZR9AIMDmt77DtwsaKiYfVXjaw+kI++PnN9mXFKXhnDtJ12W
	 tiEXI29NZaXkUPxQnpzf+DTCO3fPCRlPGb+8mfM+Mfjoby9HlZaBjvbEb8BhiuHCAU
	 ezkSDSXdGBYt27VSCSXGHP+sjXP5xyyfgFUlnZ+BWJdb+UFARr3QhL1PvWuAZIl84X
	 m2ViVRy+wTxKPzmz6lXKEH1bMu8DW75Cbc24rFt7mjXKwSZlaKHAhkkhIDIQ4SaaRN
	 oFfskrQZER35g==
Date: Thu, 6 Aug 2026 13:49:00 -0500
From: sergeh@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 2/5] capability: Add new capable_noaudit
Message-ID: <anTXHNBNPeGQ0oWb@AUS2MQ6190Y76.amd.com>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-3-cem@kernel.org>

On Tue, Aug 04, 2026 at 11:45:52AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> In some situations (quota enforcement bypass in this case) we'd like to
> check for a specific capability without triggering spurious audit
> messages from security modules like selinux.
> 
> Add a new helper so we don't need to use ns_capable_noaudit() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Serge Hallyn <sergeh@kernel.org>

> ---
> 
> V4: Mention capable_noaudit check for process effective capabilities
> V3: remove the extern declaration
> 
>  include/linux/capability.h |  5 +++++
>  kernel/capability.c        | 18 ++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 37db92b3d6f8..f8532d92fcad 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -145,6 +145,7 @@ extern bool has_capability_noaudit(struct task_struct *t, int cap);
>  extern bool has_ns_capability_noaudit(struct task_struct *t,
>  				      struct user_namespace *ns, int cap);
>  extern bool capable(int cap);
> +bool capable_noaudit(int cap);
>  extern bool ns_capable(struct user_namespace *ns, int cap);
>  extern bool ns_capable_noaudit(struct user_namespace *ns, int cap);
>  extern bool ns_capable_setid(struct user_namespace *ns, int cap);
> @@ -167,6 +168,10 @@ static inline bool capable(int cap)
>  {
>  	return true;
>  }
> +static inline bool capable_noaudit(int cap)
> +{
> +	return true;
> +}
>  static inline bool ns_capable(struct user_namespace *ns, int cap)
>  {
>  	return true;
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 829f49ae07b9..f4a7f1963c9d 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -416,6 +416,24 @@ bool capable(int cap)
>  	return ns_capable(&init_user_ns, cap);
>  }
>  EXPORT_SYMBOL(capable);
> +
> +/**
> + * capable_noaudit - Determine if the current task has a superior
> + * capability in effect by checking the process's effective
> + * capabilities (unaudited).
> + * @cap: The capability to be tested for
> + *
> + * This is the same as capable(), except it uses CAP_OPT_NOAUDIT as to prevent
> + * issuing spurious audit messages.
> + *
> + * This sets PF_SUPERPRIV on the task if the capability is available on the
> + * assumption that it's about to be used.
> + */
> +bool capable_noaudit(int cap)
> +{
> +	return ns_capable_noaudit(&init_user_ns, cap);
> +}
> +EXPORT_SYMBOL(capable_noaudit);
>  #endif /* CONFIG_MULTIUSER */
>  
>  /**
> -- 
> 2.55.0
> 
