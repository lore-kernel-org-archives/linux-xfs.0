Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C823115A2
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 10:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771581703; cv=none; b=NGbEJclOxk6Dsp5sqAcbW3aEFUeSC+KAhTSzw0/JzqSbtX8EAjXYm+PHBthICQQhQ1SyqrNEhz//0ZJzx/GDX5AasZVrZtc+V/GQECn3mspyqAtoLtg6KesR0enB8it21QGzSi7f9CM+rF5CQ52JfIJCsg2mbAAVP7S1uxvXmTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771581703; c=relaxed/simple;
	bh=jBiCFIM1TY02SGwb/3Blp2Q9yS47V/hSmv/Fa0fXxII=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=r5JsYBuOuXoEG00CXoWOJ+zKwEX6aYbWmGAEWfu9IEKK/tI+gV0igcw15oV9qQTZv3guLgvvffn94ox1UwNdj1CfE70dc4cH05+LMaMF+MJvJhnEMb9TTolzkWqAgXMsB9xKTmeqdFnQ0IVp7A/g8cZxPVN7OMGLVCeS4YDEAW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MBJw7qDd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MBJw7qDd"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2aaf9191da3so11771265ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 02:01:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771581701; x=1772186501; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZqELffXnpUaFWM6UP5mc2YGiMCwLhF/CT8oL4oYv+s=;
        b=MBJw7qDdKjJiQA43VxYICMohOUFF7uroWwWNZa2AH/LRcwWdNBGQCfycCawd8vfU5V
         KmnZfnQM4Bf9KSmR4OG9rZGlm71cApSWOcA3GeDjzJk5xlQ17lCPUy03LYHy43arfu3n
         vwpmymlieHiQZboVNQ8cJVZlru6Ya7x1Dt3v9ERptGMOBm4pJDpO3eGwXa6CrzjJRBfU
         CJD7It9SPebdCvGoNE8mOq3vV1mQjuDD7rtVWj4rW7cvSCU/sNrPIjpmLft5tvrZNzD1
         +ZKm7JMmcATn2g/taF3JpTi+hR5Dw95vwK8fw3wiEmBTMgzfwMgUIngh7h/bkAhzU/25
         mWLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771581701; x=1772186501;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mZqELffXnpUaFWM6UP5mc2YGiMCwLhF/CT8oL4oYv+s=;
        b=chOJpbKpm0/Qx8XokZbG3Jj8j8DqBpJnoB4IRDrqs0yOUqNbNfwo0c0tUJWNyQi6tC
         T3Wu/WS5VoeTDhiFrMRs0/x6gmdGAH/iVoJEw6azeMGdlUlL24fUHeIPtMub4y1Mu1KF
         m6hw6Kf104XvPWD7Mqt+P7OV0f9Lx9KSOUEIYZkHe9HNxLHESIIK1/FQA72w9NpjXKcS
         Rn+BjxOoLG4UzhubBDVvhiOKurr8e8eaolQzD/YltGdw273k5EWyoXDrISvfnVml+7/p
         Vmzc6yH/cKpO0+0h5D/MNuLloK+/MktgwGyCfuMxx4hYoQXWQpdc8iX+ft2xRghgRhK7
         VTmQ==
X-Forwarded-Encrypted: i=1; AJvYcCViVfzQVK2oZHgpTZ98W3QfhaqYFDGB877ZTYginZ/oQ3QxIGTqa7GHLZVTrvxWczg3/b1ljKNzVas=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFS4Ui9KfsMECbZK8aGIUU8ikGbil8zSVaRxee878KaKuEMkyG
	8EsUE1Yf4iwB1jwpR0iLbnKD0Fue5foPK0yAkXCjVcTVmd0ay96Job8z
X-Gm-Gg: AZuq6aIPdT8WkgPf5WFsL8UeJu+LwmzUhq21rTjXkA8Hb6/T1h+6Nfb6YIP4NyoPsBt
	sIeRwmZ8BwH4gWmH1IdAB0FsccGIu46qmLDibFuCwSPUv0k8uhFxap2265FCh9lxtkjIPsuHqFY
	3zIU7KOXkLBYA0ntMNpDZLTI2nevVfXZimPF2LZtz/AyWyRyHN8SVEnBUemDa3T+EFUL4silD3o
	lkRTbQXSs/bID7EV5m0uCd7D8+fqxphaqtxtN/8dcTaYiJ40Jf3PxowRedbFy37CEurToIsG/Ck
	xxnjP2/CJixiZCAr+dRbClTTH6WW9A0hjIExAW0e9JoodIhfBEE4uHRVw/W4MCToshrPiyEiwzf
	fODts3RI2KXjoa+ReutoGcjHzyd05SdmzJ4bYOIZj/r0VWsos22+8nEEByppMz1VBFKjirkPQh8
	Oh3pAFHH2Jx5R1YQ4AMmoAu3jLdA37RKpfKwIcREbKJCMLY8Bi9KpzxjpFewA67jzhWArnfm3TT
	Lch
X-Received: by 2002:a17:903:19eb:b0:2aa:f2f3:bcb0 with SMTP id d9443c01a7336-2ad50f9881fmr81093265ad.47.1771581701209;
        Fri, 20 Feb 2026 02:01:41 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a6fa5cbsm244689215ad.9.2026.02.20.02.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 02:01:40 -0800 (PST)
Message-ID: <f4b1f5024a17098b29d4623f1a5c60519194ad52.camel@gmail.com>
Subject: Re: [PATCH v4] xfs: Fix error pointer dereference
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: Ethan Tidmore <ethantidmore06@gmail.com>, cem@kernel.org,
 djwong@kernel.org
Cc: brauner@kernel.org, neil@brown.name, jlayton@kernel.org,
 amir73il@gmail.com,  linux-xfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 20 Feb 2026 15:31:35 +0530
In-Reply-To: <20260220033825.1153487-1-ethantidmore06@gmail.com>
References: <20260220033825.1153487-1-ethantidmore06@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-02-19 at 21:38 -0600, Ethan Tidmore wrote:
> The function try_lookup_noperm() can return an error pointer and is not
> checked for one.
> 
> Add checks for error pointer in xrep_adoption_check_dcache() and
> xrep_adoption_zap_dcache().
> 
> Detected by Smatch:
> fs/xfs/scrub/orphanage.c:449 xrep_adoption_check_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> fs/xfs/scrub/orphanage.c:485 xrep_adoption_zap_dcache() error:
> 'd_child' dereferencing possible ERR_PTR()
> 
> Fixes: 73597e3e42b4 ("xfs: ensure dentry consistency when the orphanage adopts a file")
> Cc: <stable@vger.kernel.org> # v6.16
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
> v4:
> - Add blank line after closing brace.
> v3:
> - Add dput(d_orphanage) before returning error code in 
>   xrep_adoption_check_dcache().
> - Revert xrep_adoption_zap_dcache() change back to v1 version.
> - Include function names where error pointer checks were added.
> v2:
> - Propagate the error back in xrep_adoption_check_dcache().
> - Add Cc to stable.
> - Add correct Fixes tag.
>  fs/xfs/scrub/orphanage.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
> index 52a108f6d5f4..33c6db6b4498 100644
> --- a/fs/xfs/scrub/orphanage.c
> +++ b/fs/xfs/scrub/orphanage.c
> @@ -442,6 +442,11 @@ xrep_adoption_check_dcache(
>  		return 0;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> +	if (IS_ERR(d_child)) {
> +		dput(d_orphanage);
> +		return PTR_ERR(d_child);
> +	}
> +
>  	if (d_child) {
>  		trace_xrep_adoption_check_child(sc->mp, d_child);
>  
> @@ -479,7 +484,7 @@ xrep_adoption_zap_dcache(
>  		return;
>  
>  	d_child = try_lookup_noperm(&qname, d_orphanage);
> -	while (d_child != NULL) {
> +	while (!IS_ERR_OR_NULL(d_child)) {
>  		trace_xrep_adoption_invalidate_child(sc->mp, d_child);
>  
>  		ASSERT(d_is_negative(d_child));

Okay, so you sent a v4. I gave my RB in v3 - also giving it here too.
Based on my reviews in the previous version[1], this looks good to me.
Reviewed-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
[1] https://lore.kernel.org/all/61386abf00c817e65ab70c994ed584fde339f9ed.camel@gmail.com/
--NR

