Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7454D9901;
	Thu, 23 Jul 2026 13:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784813391; cv=none; b=PvrIvQcsRYpG1m01+6Pu1mLf6E8QtpMlOUk9AwTX65dUBamS80Zsc0jEuWZnIOuKCF5IRaTzs7GrbmNfLDy7XV48QWWrnCGMg/38mCSskL78vGRDxlER+Y+idVjtb/UMQWawkllj04QpOSVxj4L7dMx9IeoRUgmqxsYT05z+AUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784813391; c=relaxed/simple;
	bh=Q/g/SVS6Vi1wW3ZBW1eEw+RoaB7Xl/as5+9mEdu2mYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INQCeAJ5g2lNKaQMvRnx6wbweCL4YW0nstoarpwJpWpbueh6JpKGpFKgBabROkQH1yRWzjMCHT1TH45jTs1bq9+EuFPPEbF9NZ5vjHGbjt/viN0RG+GGKIOmUbD3xX2FQbEBd7FCVGu3Vpth+lfsKrksbbpurqE8UcV0XAjPmZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=pass smtp.mailfrom=mail.hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=paHp8U+S; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="paHp8U+S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1784813385; bh=Q/g/SVS6Vi1wW3ZBW1eEw+RoaB7Xl/as5+9mEdu2mYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=paHp8U+S7A5RFLJ6ePL467CDPO14LXE+QIO/UeHQxQ7SVD+CxJ2RbtEtsHPoQPesN
	 lReo0cArupueM8HeMNpq89bG9o629wW9TynXT0c/rt5+GVSA8nZ8ZdBSG1ZSdj95LP
	 8Xgs3aexyDGI1a/lP6ZMhzPJSmeCXnI0bAB+rPoRXFZZ+Pjuwn8A4B6ScvDX+XIsJT
	 Pkf8Zm++DToeAIAhgqexUhXSaVf+nW4nweGFMFOZZQ6yCKa7Y2Lge8rtUJLiDTaVXf
	 fbYOJ6SE8WxC514SZ9hcFlbJkrl5PRYQcOpZVtJzwZ2swa62gObuP4OxGMVLSYv2Y3
	 66vE6BcrEx24Q==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 54EDB630; Thu, 23 Jul 2026 08:29:45 -0500 (CDT)
Date: Thu, 23 Jul 2026 08:29:45 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, djwong@kernel.org,
	hch@lst.de, serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Message-ID: <amIXSTSc47vQUOgk@mail.hallyn.com>
References: <20260626114533.102138-1-cem@kernel.org>
 <20260626114533.102138-4-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626114533.102138-4-cem@kernel.org>

On Fri, Jun 26, 2026 at 01:45:22PM +0200, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> We don't need to use ns_capable_noaudit() as all we care is the initial
> user namespace, use capable_noaudit() instead.

Looks like some of your other xfs fixes conflict with this.  Do
you mind sending out a new set, and I'll pull them into the caps-next
branch?

thanks,
-serge

> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_trans_dquot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 50e5b323f7f1..30c2f6ec0aac 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -835,7 +835,7 @@ xfs_trans_dqresv(
>  	if ((flags & XFS_QMOPT_FORCE_RES) == 0 &&
>  	    dqp->q_id &&
>  	    xfs_dquot_is_enforced(dqp) &&
> -	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_RESOURCE)) {
> +	    !capable_noaudit(CAP_SYS_RESOURCE)) {
>  		int		quota_nl;
>  		bool		fatal;
>  
> -- 
> 2.54.0
