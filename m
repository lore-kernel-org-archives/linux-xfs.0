Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C28C30D400;
	Thu,  2 Jul 2026 15:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783007767; cv=none; b=MxRJBelmUqGMAAvtVOlpxvaWm03RXSKOGBLvjx/Bd7QfZvz3EGnf6O69pLRNh/T9R/eVv83zHMXTuwDGbKIuAEcaEgMDt1spu8l8OgmRnlmlMy7rrU5eq7fBdaWOYwKzj6OSwkiR6FdbItp5tRl3J4kZhwp44NTj9XregD5YBd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783007767; c=relaxed/simple;
	bh=yLsZmQMux0ygxcrYMOFGfc5TWB2i9Up5MrZUsJ0wygs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fRPwGDOo+P1lw0EK7wqYBqXgVbzls4oNcMznqAfDsV2EZyzwWH5jst45BCPpCZ7TfTDGRhqA8XnApOMDgzj1CYpC6vI5dWewRNGGDQh59j+D3jR6m8fBPce7vLRoK6evCuhAggcfve+dkXnxwQjPItBR3rRVsqj7WpTWF1/KzkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Me5Wxx6p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Me5Wxx6p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04E9F1F000E9;
	Thu,  2 Jul 2026 15:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783007766;
	bh=O77koWr7SeU/8PCz2s/A0CB50aq+2Nj8DFXspCWAMjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Me5Wxx6psC0R1I/DAw9W4P1ZDEl9Kk9VDxz5ZSr2pCbjnFAVjMmah8khJn82oi8RE
	 mg39ht7dbG5m2SjBLeyDwjkyO6SMqL/Fg6ZgyKsDKU9QkuNfwpfCjSmT7RXo+/bUvO
	 0693fwZ2DWqWNXxCAVaWdZA0VFNq71jsjdkysEyqvWod9Hnh+RDgdFWvy60558Cy+j
	 sDrSQNXQGAs3woVkeek4HC55gX8SIdqU9TGyJkaAT5SMybNY4CVH9ZI9DQdtd9u0+T
	 iCiflKcmA4KN/pnKQxH8mcwHFpFU1ToPdLGWbGavHazPUqQFUgfaZpRjxIetEJWhzY
	 gk1eLLFgSBPpw==
Date: Thu, 2 Jul 2026 08:56:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Serge Hallyn <serge@hallyn.com>
Subject: Re: [PATCH v3 2/5] capability: Add new capable_noaudit
Message-ID: <20260702155605.GE9392@frogsfrogsfrogs>
References: <20260702093324.127450-1-cem@kernel.org>
 <20260702093324.127450-5-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093324.127450-5-cem@kernel.org>

On Thu, Jul 02, 2026 at 11:33:19AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> In some situations (quota enforcement bypass in this case) we'd like to
> check for a specific capability without triggering spurious audit
> messages from security modules like selinux.
> 
> Add a new helper so we don't need to use ns_capable_noaudit() directly.
> 
> V3: remove the extern declaration
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Eric Sandeen <sandeen@redhat.com>
> Cc: Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
> Cc: linux-xfs@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-security-module@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> ---
>  include/linux/capability.h |  5 +++++
>  kernel/capability.c        | 17 +++++++++++++++++
>  2 files changed, 22 insertions(+)
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
> index 829f49ae07b9..2c2d1e8300bd 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -416,6 +416,23 @@ bool capable(int cap)
>  	return ns_capable(&init_user_ns, cap);
>  }
>  EXPORT_SYMBOL(capable);
> +
> +/**
> + * capable_noaudit - Determine if the current task has a superior
> + * capability in effect (unaudited).
> + * @cap: The capability to be tested for
> + *
> + * This is the same as capable(), except it uses CAP_OPT_NOAUDIT as to prevent
> + * issuing spurious audit messages.
> + *
> + * This sets PF_SUPERPRIV on the task if the capability is available on the
> + * assumption that it's about to be used.

Same complaint about the documentation as last time:
https://lore.kernel.org/linux-fsdevel/20260626151656.GT6078@frogsfrogsfrogs/

--D

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
> 2.54.0
> 
> 
