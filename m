Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA001391505;
	Fri, 26 Jun 2026 15:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487018; cv=none; b=BO+r7+tz6iBj3eg51aYmaCsSScmzienqzg/e1RGM//wLf2wWG9H748vaYZfoiLRBuuws+7OmchT+OUWTZ+MF6QLQ6PbWeHcgsekGReUHuJwuyB1TTqs7eKTOo39sQMKOdQM3kWSoyW67+nDJDJ93k7YQvc9De1IXGFNJawMiU/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487018; c=relaxed/simple;
	bh=bKJUGbLEj+PKwuuvq0QPZEp0+8e3cs1fTf31rzz4AjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tsiapm8A/R6WS1ivJx2w44PTaQ5/Uxu9CvZhGfJwhEAEHCtpw2qbtBV9hhJqse3i4wdse4co3kfX2GjLq0we2mWSkQw9wuZeifwFsZ76TMx38PmNrFKGFd9ktgjtcOeQE8Hypxx9OUIO1ApfMetlYPGI+y4GY6gWV4ifE4r3Q+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XECLZGOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XECLZGOw"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5170C1F000E9;
	Fri, 26 Jun 2026 15:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782487017;
	bh=yPrSA3TnI0R8uq4PXOryhjCI9KvQp9dLsVTaqmcmmGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XECLZGOwNDofiOoSN/SztkrDttTHbES5pgRyCSa5jPMRwiPLUaMW7517HiFhDv0rP
	 QcOYCp+Y2usoZgF7s+PpwroV/OJCql0uh681gS1B39+I8EEoYHjzrTZ71j/B2VY3F3
	 SY1CByGGJtfZQZo/a8qAmpd/YEFdNAtMTp7rc66s3WJvFvIDoRrHMLmwK36n5Upbjq
	 0CEY4yCwfbnqgYN3GTGA6tSddHjIUkOakh93m+8GSD4HQuZbj3rWQ3r4xrdjLi4vYe
	 WXoB/i8k+XDzfgj4ZY9KmQjnAnx7B/7NAFjftWYQ7Mn+93pM+BANsSCx62dsA7+Uw6
	 3uLrmvHgvr1Xg==
Date: Fri, 26 Jun 2026 08:16:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] capabily: Add new capable_noaudit
Message-ID: <20260626151656.GT6078@frogsfrogsfrogs>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-2-cem@kernel.org>

s/capabily/capability/ in the subject even if the typo actually makes it
easier to find the thread.

On Fri, Jun 26, 2026 at 01:45:20PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> In some situations (quota enforcement bypass in this case) we'd like to
> check for a specific capability without triggering spurious audit
> messages from security modules like selinux.
> 
> Add a new helper so we don't need to use ns_capable_noaudit() directly.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  include/linux/capability.h |  5 +++++
>  kernel/capability.c        | 17 +++++++++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index 37db92b3d6f8..873416ba884c 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -145,6 +145,7 @@ extern bool has_capability_noaudit(struct task_struct *t, int cap);
>  extern bool has_ns_capability_noaudit(struct task_struct *t,
>  				      struct user_namespace *ns, int cap);
>  extern bool capable(int cap);
> +extern bool capable_noaudit(int cap);
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

Can you mention that this checks the current process' effective
capabilities (as opposed to the real ones)?  So that nobody else has to
suffer the confusion I pointed out in [1] which was the source of the
security bugs in the first place?

(I do like the wrapper though)

--D

[1] https://lore.kernel.org/linux-xfs/20260625160317.GY6078@frogsfrogsfrogs/

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
