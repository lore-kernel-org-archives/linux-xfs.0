Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BBA391512;
	Fri, 26 Jun 2026 15:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782487142; cv=none; b=uevR3PQl0ZEc1Hgpl4FJmpQyE5TEt+pyTCxKQpLoW8X2KrdhiRLe/YN21R1X/gbPGq8TwK4ZpZyL5Pp83pe6Bt74NXw8smdUh4jrdJcHejm4LUnyi1VYejZNm8gf+6k2ZyYyk7IMisltCjYGItAUX8VZUVThH1psjMa9NffdTPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782487142; c=relaxed/simple;
	bh=VsCpFTpL6yAZSqxK0Vh1leQW+rLz2J4T7VmwBqe8RWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NOCK3QJJqzCpr89T92L4Y8hzFKQqCQ4pRpOwUvyvMU2G9QMzcwCNR45BIO/CRed0A1IIVab5xRJmeOQHjXsQS8Eo7RYL7JIoQOmmaPgjWrQmfyfpAxIqtBTv0PTAMxenmYdz0nmUylPAxRuUXufUsXVOa9u+JzkuJZ5U/hAL//Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlKPFbhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlKPFbhe"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CEE931F000E9;
	Fri, 26 Jun 2026 15:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782487140;
	bh=/6dcRh5YwQJ6YXME3WEFAwVDWkDCzYtVTyn+fEUb4jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hlKPFbheT7gPM+H1RPyrGbWjDg/dN3E7QGGZFS05c+yxEMHidNnQoDLeDYrO0QxU7
	 GoJcVPstyUiw/ZijObi+V79XL+GEdLbpXln+AeSsSSgjkXjjKnPENoeYhQ+B2jrAJa
	 2yGU2uKn52HfXmZsrHtJJNw4d251kNphTNaqmqFv24kVyRde3BS0PfP7bWNGszoVSu
	 bfJ+B65gzobB2GwXg9ZP+TxbWJP1GXXrFcNG3eFAyblJpyOs7Jw9qdVH8CIpKppHt1
	 QgFDtmwk/Rm4e2ctSK45v8xj3kguGgXv9wJA8cOh4nfF/0F0QLbJDQzl9jdV1e12jz
	 okE/yC3JMpAJA==
Date: Fri, 26 Jun 2026 08:19:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org
Cc: linux-fsdevel@vger.kernel.org, jack@suze.cz, hch@lst.de,
	serge@hallyn.com, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] xfs: replace ns_capable_noaudit()
Message-ID: <20260626151900.GV6078@frogsfrogsfrogs>
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

Might as well do the one in xfs_fsmap.c too, since it was originally a
capable() call.

--D

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
> 
> 
