Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795633259;
	b=HNh7GXrHsyCAbbBdVc5Yfrofgq5BmHrFQQU5X7lcYdqBdTn9R+UvtvmtwkoBTwzCcvRC
	 43oLDEfKK/GlvNMoBxAbx+6txexgi8QAo4+X7IMTmKUbjTbLjexypt1MUMQNxDtJYMW3c
	 SiSbPYYieGg3JQ7j+tUjYNp+qqTan8Nfco5xOQfyT1NKgk6ml9ByOfSE2LmcYF7IJ+lfG
	 b2eUl0atic0pZ/mUbw1KgeQQ32pB5qQ3wLQ36a9SUZm9TJMziFEUYzdlLWfbYMboOdztq
	 7m7YqAQdF6EZH6XD3GMehIWjC2a3kkWDUiklkysdwV/A7K/RaTDAa77xcCepN9vjVKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795633259;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=A5fJXJsaw5DVzFBK0JDIPUD/Katfy4DFiHQ4rw7N4bc=;
	b=0tj2JNDzJgB/mZj5glm2yg1jyOVVidOmax7ymPx0hb5jOAfPS6rwfveo5tngO0DHx0AH
	 SMC/I1w04yUN9s3haLFWdiqG3abBTdHOR79Prs0kcUKPMNxcAodC1vRT3nXqivW7tUHRV
	 Ht6iUXZGdDfGieoPcP/GB0C0et0OexJY5xG05m9mmXJi4gd58jW3Anvey2hNO+oAcSBWX
	 1w7oa03nlcAPbDS1eJAnvttLAZiIjaUjwzt+Fm+wSur/d3mLqfSE8aKAqbjAdME8JfN2b
	 pkbLxVCh75cIqo5eR3vAIB/nAfmKUG0obv6npP1oNhtgcMGgD2rSfT/HKjRPAlQMYQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rd7yi2PS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741BC606A321
	for <linux-xfs@vger.kernel.org>; Wed, 25 Nov 2026 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rd7yi2PS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7561F000C0;
	Wed, 25 Nov 2026 19:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795633259;
	bh=A5fJXJsaw5DVzFBK0JDIPUD/Katfy4DFiHQ4rw7N4bc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rd7yi2PSgRpr8bbGyfbWQYQTqfOkwOkmm61IKzMniJiuhXA7IsCs6lkHMxwrL7IHs
	 O9LuD22C3aIngYzEmVYk/nOzuYvGk1BGa3YEvvh6VZXy/3y8f4RkeIAeIjkg/6q2Cs
	 GDP3LWG/whCn4hytlVhDOTPdiqK9Uk/qTDkn+d17H+OMVJ6geNmP8i0ltIWoMmZMCw
	 hryPGE1dwim/AQjv0G3a8kwamn4h7JV7WugRbsVGS7kKNOZ+lEM9tttMeuxn+ehLRD
	 EKbNvOyPW3YjqDzSvtl9vf9FYpaB7Oi5i6izxbpH6ZGbkfTVAyE5ieVOx6ecK2Vdo9
	 ipbtgedcBfedg==
Date: Wed, 25 Nov 2026 20:00:54 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Remove incorrect use of '&'
Message-ID: <awcwWruHQY0S2kh8@cronus.toxiclabs.cc>
References: <3783cf39b873890896eb889c8c09edb455559fce.1795626969.git.alx@kernel.org>
 <awccmN95lHSd7vp2@cronus.toxiclabs.cc>
 <awckyI8cAWM_kLzb@devuan>
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
In-Reply-To: <awckyI8cAWM_kLzb@devuan>

On Wed, Nov 25, 2026 at 07:11:48PM +0100, Alejandro Colomar wrote:
> Hi Carlos,
> 
> > Date: 2026-11-25 18:38:11+0100
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > On Wed, Nov 25, 2026 at 06:16:45PM +0100, Alejandro Colomar wrote:
> > > We want to pass the character array, not a pointer to it.
> > > 
> > > This seems an obvious typo, introduced in a48373e7d35a (2026-01-20;
> > > "xfs: start creating infrastructure for health monitoring").
> > > 
> > > Cc: Darrick J. Wong <djwong@kernel.org>
> > > Cc: Christoph Hellwig <hch@lst.de>
> > > Signed-off-by: Alejandro Colomar <alx@kernel.org>
> > > ---
> > >  fs/xfs/xfs_healthmon.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> > > index 2bdd747f1ead..56d19ffb02b3 100644
> > > --- a/fs/xfs/xfs_healthmon.c
> > > +++ b/fs/xfs/xfs_healthmon.c
> > > @@ -1061,7 +1061,7 @@ xfs_healthmon_validate(
> > >  		return false;
> > >  	if (hmo->format != XFS_HEALTH_MONITOR_FMT_V0)
> > >  		return false;
> > > -	if (memchr_inv(&hmo->pad, 0, sizeof(hmo->pad)))
> > > +	if (memchr_inv(hmo->pad, 0, sizeof(hmo->pad)))
> > >  		return false;
> > >  	return true;
> > 
> > Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Thanks!  Will you take the patch?

Yes I will

> 
> 
> Cheers,
> Alex
> 
> > 
> > >  }
> > > -- 
> > > 2.55.0
> > > 
> > 
> > 
> 
> -- 
> <https://www.alejandro-colomar.es>


