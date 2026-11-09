Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794224348;
	b=pXX5Qccz68tUA6COaIR0o6XJyo9J5AuFvvosqKZnMGg+kpxiGDQKVImRUH+gjYyPAsM/
	 twdRH2Udt6u+DTNviCG/5yEFfmLk6g+UOgFM33nGepXOrQFSu17RRA/8Iqhd0Z9WYoAnc
	 vgg9Ewv9Lq1P//mEvjm1Su6NxzqovKgAFwWGIYW8Ryx4UM8yt1u1zBkQFtzXf+dOg2CKF
	 8CjLaIn7ihSiBGEpX08x8Q4TMJKZsIfztPc6kxwFzmVlpAfYPt8a922WPoG0cx2tJMwww
	 Kf+FM6Ff/aTJl0iAXBtxlYxRMSNLvCt0LQWnEnwi5Rno6O0jDcevUOn2fW9DW8RqeWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794224348;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zA2OWXurtcJmLjbDPu8a55Z6x9XixN6agkZLvC8K0Wc=;
	b=epmSZgyse10WQK+aFoTgSF5Oc4FKZLekcrzkFm5fxgmCkKU/E9YScfHTfmDsZey1dDAa
	 JEz3hohdJgiKD/Nc/dhsEGkYarqCWyzVZZbmbTudzb9N5lbFqS+3kSU2tC9++rAmVwx5v
	 UUbgnb5f/UDNZcpOf63+NZx+LLIvN4mqVD6mlG1bcxOrtG1oVWfJA+NG4CmybqivyNLxz
	 vqoelPTt3PdfqrlRtMPiYLKomHgeHL5zmXqt/SDwquJnoa/j1l5FauAKoJsHAJEcJ6PpR
	 M9L7ogMsY94PUEZYl2ZhyEZTbKZc4sXO7KuETDa9PTJXHlfuVjDzHmp4XKHl15ttYgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ypixy9FP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E624D606A33A
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ypixy9FP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13631F0089F;
	Mon,  9 Nov 2026 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794224347;
	bh=zA2OWXurtcJmLjbDPu8a55Z6x9XixN6agkZLvC8K0Wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ypixy9FP5b8VHGWKDSOaP9beSamCXa+EFjzo8d/azGEEV1YKw4PpOhB9VXG1uUKP6
	 TGSAxgkDAxZ57YBh70RqFNupNbdvDF9UxmYsnOp677Zajd/W3qJwFUo17t2umUUk6t
	 cLZ4AqM85EnPXMpGeTMRmR9a4zK8LlKDRkcovjCVFe5dPjrn6iHdcWnFKxoPcdDv4J
	 6k30UgwqiY/5QyQ6YGB1nrz0QnkCMUTdDF9p7vDaoJO3/Mtr/m/wK0yuWK8WSpJOFW
	 Iyt5zM7yTh0HLz88I9UP4GnCgwcpVxcFXyO3XT3v0hgaZ6i9DhFIGiNof/wTup5HEc
	 29Tfy76TUWNPA==
Date: Mon, 9 Nov 2026 12:39:02 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: capture error return of cache_node_allocate()
Message-ID: <avGwBNlcTtV9kbF0@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20261106211129.3042825-1-sandeen@redhat.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106211129.3042825-1-sandeen@redhat.com>

On 2026-11-06 15:11:29, Eric Sandeen wrote:
> I guess during the revisions of this series I managed to lose the
> actual error return of the cache node allocation failure

nope, that's me, I dropped the hunk with if (error > 0) based on the
review, while applying. Didn't noticed the 'error =' is actually
what matters here, sorry :(

> , which pretty
> much defeated the purpose of the change. Fix that.
> 
> Fixes: 92d45f83 ("libxfs: Return -ENOMEM on actual cache node allocation failures")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  libxfs/cache.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libxfs/cache.c b/libxfs/cache.c
> index 5cf6bef1..81509cee 100644
> --- a/libxfs/cache.c
> +++ b/libxfs/cache.c
> @@ -475,7 +475,7 @@ next_object:
>  		/*
>  		 * not found, allocate a new entry
>  		 */
> -		cache_node_allocate(cache, key, &node);
> +		error = cache_node_allocate(cache, key, &node);
>  		if (node)
>  			break;
>  
> -- 
> 2.56.0
> 
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
