Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5E8DDCD
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 09:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTYYkgnd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1F0C433C7;
	Fri, 24 Nov 2023 09:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700817373;
	bh=mQIIQpwua+89im/CfU44x972pIbCSmT2i3TsnCcYYb0=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:From;
	b=cTYYkgnd+oo2BtGdmAKDVXsVB6HEqRaCyT5MEYmDaN3R5cshBxpSTgR5pDJF9NoUf
	 h9gGb1ZkLdIT/KNrVh9nCGEjRe19IpPIy1STGCVCgNVDf9sX7sQ26Hqfisw0MymQ5S
	 VfgiRn6xp6gXLRlq8/0pUWnaYQMMhO6zUrxSuSOtAK5ob3If5Eu67X9ln1l9XW8uE2
	 wiwS9JNQpBgLDEtlbUBFuabLhUp4NP0PrcIR7ZA7uGOA/hAZ7cNp/UG96IKHcTAkaF
	 G4la8TCX/o/av5U0Fl7uQWJH5P1Hb3ykZZyCk3Sg3+8+49cFvB78nvpOnJuthg1KV/
	 DL65GgtVsZkFw==
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069444804.1865809.10101273264911340367.stgit@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs_mdrestore: emit newlines for fatal errors
Date: Fri, 24 Nov 2023 14:42:20 +0530
In-reply-to: <170069444804.1865809.10101273264911340367.stgit@frogsfrogsfrogs>
Message-ID: <87cyvzwlyd.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Nov 22, 2023 at 03:07:28 PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Spit out a newline after a fatal error message.
>

Looks good to me.

Reviewed-by: Chandan Babu R <chandanbabu@kernel.org>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  mdrestore/xfs_mdrestore.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
>
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 5dfc423493e..3190e07e478 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -275,10 +275,10 @@ read_header_v2(
>  		fatal("error reading from metadump file\n");
>  
>  	if (h->v2.xmh_incompat_flags != 0)
> -		fatal("Metadump header has unknown incompat flags set");
> +		fatal("Metadump header has unknown incompat flags set\n");
>  
>  	if (h->v2.xmh_reserved != 0)
> -		fatal("Metadump header's reserved field has a non-zero value");
> +		fatal("Metadump header's reserved field has a non-zero value\n");
>  
>  	want_external_log = !!(be32_to_cpu(h->v2.xmh_incompat_flags) &
>  			XFS_MD2_COMPAT_EXTERNALLOG);


-- 
Chandan
