Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6440C3B1ED7;
	Thu,  6 Aug 2026 18:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786042469; cv=none; b=Y54I7Jh6ku6SKmCnjL5y/LAU4C50Un0EGwGIs0dhgMtFYjl45bWdUZb9cUjAGSKuCYjg2od2Yjp2/HoEsuUTeB4pvgrW3tUZbnJx5vR2eKupdOvjCDLLfd90MIeyOiqF0belynm809vmZpM+KnnrKlliszdGXo/pUSRvd7wRpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786042469; c=relaxed/simple;
	bh=H3d5IXeh0BUAZRA9eb0bLcxZt7PdIEsq+EUyBANoUUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hohy57tulfZJiytM7mjVuhfOawMY1iZfwQqK0njBR+BqameC192ooGZ3X0LW3L8Rpl1rOTPjT9YtJ7RAc2tDU9UTC8anpYyPi/CR+KQLrrAcPZDS+vX7UEgm/mC2uLl4pgBH6y22k9nJwCOBE6vb/45Kb2cvVy53wWnbNLwdkuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOd1MDAN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOd1MDAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879ED1F000E9;
	Thu,  6 Aug 2026 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786042466;
	bh=yTQwx8DZ0uJA43/wKJkNy7LctDIRrYT/TZI/rx/kc5s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XOd1MDANVXFL9oP9qBzDZrjI4VafxA681D/Mo8YDhtvSfOqCMZILuKCFGa/pvc+U/
	 PIhrUwcFJN+q51Z/q5e5+Wh8NKL39HSr8L3ho8Z0v3tguiY8QyrYLT2teHozlatPyF
	 7MOQYwSNfRebaFeOkhIo9Nay5zCeo0HQ8zGD3e8uoF+foMYFKexA83j0ESYqUiu2IH
	 brizaLXSW/Y+8rFjbZGL0ZxQwsfeLySBkta7eI82FU/ovi6m8C6J7p5CFzdskA1DOH
	 tBh4hkRWpBeVSQn25ThfEcdIby+53BAh8XTQiYeIDUFT7TdQdhVuYCFq6aSvj1Lw12
	 1q2pABnNMONgQ==
Date: Thu, 6 Aug 2026 13:54:23 -0500
From: sergeh@kernel.org
To: cem@kernel.org
Cc: jack@suse.cz, djwong@kernel.org, hch@lst.de, serge@hallyn.com,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 5/5] capability: unexport has_capability_noaudit
Message-ID: <anTYXy17kYz6MivZ@AUS2MQ6190Y76.amd.com>
References: <20260804094602.84766-1-cem@kernel.org>
 <20260804094602.84766-6-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804094602.84766-6-cem@kernel.org>

On Tue, Aug 04, 2026 at 11:45:55AM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> This has been originally exported to be used in xfs. Giving we are not
> using it anymore, unexport for consistency.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Serge Hallyn <sergeh@kernel.org>

Thanks, Carlos.

Should these all just go in through the xfs tree?

> ---
>  kernel/capability.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index f4a7f1963c9d..90e6ab62f6db 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -326,7 +326,6 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
>  {
>  	return has_ns_capability_noaudit(t, &init_user_ns, cap);
>  }
> -EXPORT_SYMBOL(has_capability_noaudit);
>  
>  static bool ns_capable_common(struct user_namespace *ns,
>  			      int cap,
> -- 
> 2.55.0
> 
