Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AA32D5C97
	for <linux-xfs@vger.kernel.org>; Wed, 14 Jan 2026 07:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768377576; cv=none; b=Y71Kmpa0VFWqkaM2qfXYRVwl4dc10dixlvZtBwxisHY/hI4WOs6MtVDbxZ5fJ/Gb1nnwk6Og7MWFJIPe8KHI+cVQAusYqX0ppJ0GdYNGoghDnoQ5ea/jKq+Wbr84JaSyTdD0aJwasHNUSQO9QFIcvcU8lVTckRPrbAb/87B9d+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768377576; c=relaxed/simple;
	bh=1aUKYIRl2BwEm914CynRUZT9PGBuxECbpl4PjADuaek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdOW8qXkP88KoGUVlcbd+u9hYmMTRGZe/SpMuXEHmKoln+p5enBp9NPRM2iaHpI1seaFOJvcEarpSTBa8iYZ9O0ezr6kljBES8YbvBhpC5r/RvAqqxbx8gbibfftGlml9P0UYb7BX9I1UvYXrinsbnjUfBDSeFRAAHcp350+SXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfDgOx7g; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=muCquDrG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfDgOx7g";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="muCquDrG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768377570;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ttw7mSCoUtfFUMLK1cUNknHOhK7ms79WYyJovBvM2fs=;
	b=PfDgOx7gu56odT1roEdkxiGvX6ooinSo3vWWYtIRisZkfwyjRJY7NfuVfOKYCv8saaw7sA
	zT8LcLOPmEa2OLr9CP4vZnu1Wi+PyDfP0+T8Cb5dHiTHSVw6FGOnwGvibyIWTk/Sd8lZJq
	kx9isWhQaLhjYQWLgq4PHhN8Zfit2xM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-HqpMnhAaMpaOZCLx3cx-2g-1; Wed, 14 Jan 2026 02:59:28 -0500
X-MC-Unique: HqpMnhAaMpaOZCLx3cx-2g-1
X-Mimecast-MFC-AGG-ID: HqpMnhAaMpaOZCLx3cx-2g_1768377567
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47d62cc05daso54842595e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jan 2026 23:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768377567; x=1768982367; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ttw7mSCoUtfFUMLK1cUNknHOhK7ms79WYyJovBvM2fs=;
        b=muCquDrGNfBFYex6dW5o3kdcTn9fFxcmeyd5rLbS2Mgk69P+L5JvjRd9FERAb3jPNN
         XGe7E4ZyRFrUpn+OtMhBmJ3evLgrNyJCesM03rLHZR8UUShf8ZyTCsUVwFs4+j98FNbP
         d7ny4i8ZaHLX81s51hFAIHNFwSpkmlxhCXnuBnEpOzr9LmJ6oeAdcQfUT6Ed4y0jmruE
         tdQL9YIRjG/iZ0aOtKBbrR5r2/+q4sERsnk4u6a/NeOZg4KoNib2hUasIMemijDN5tk/
         QZsRCiG9fNDqR/6IkwPAsqCaBwKLnqJHzlnMXqQoJ66GoMcP5GOC9dI2zpXy3bHohbHy
         GG1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768377567; x=1768982367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ttw7mSCoUtfFUMLK1cUNknHOhK7ms79WYyJovBvM2fs=;
        b=QtJyq8+dgy22a8L9kuH3VKnvOBo78B/00A5/UoPoADa2lNeIm3vT0oTBNXcwxrKRaP
         FPmUZm+DO66ckoKULWYM0J2wQESRk87SrIEaq0/m1mIZD2AFmLEwpsVaEJZKxMuRO0p1
         3y/Zh/26KgfZrZeD7Usrzx2WyazFUJWabWZm33BPGqwW4AwORhN35dlboxP9r9uzBxUj
         6Ro/7PTfQAhQ1wbvUXxpd8glaET4q2w8GiaYJWvJjoM6fBO5RH2ZjBxY+GcqOoxkS/JS
         tEtIWMu3a1uytOlSmDQCADA3FpfVxhFxO5okidBRLALwYLUamzPyyRxPor2T/j1uGWtx
         SQEg==
X-Forwarded-Encrypted: i=1; AJvYcCWIOIOj+GVKBeFIlUEHdd3kWmaaF/W8ieclfKHlcdVem4+I1pyhp3beP9CKjfmSQrKSVYwjMbsRcIY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRwOq8/mer0gZYQ34Xfo6qba+DHnVq5jh6h/b3aMOCFGt8aEn4
	CB8/Mx9+2wVXY/8N0bUeXk7p0uuy/9RBa1H93JfHQzH3jQ8VUzGdYv0qRi+fQ4Pp3r7/FmSNdmb
	8GCeiguet5LO1QQApewb5LSZE+jULjl0CKl/qPv0yhW5h3/zPFagJuqBCeDOr
X-Gm-Gg: AY/fxX7mlO6d8xJz0LFmZkoLljTzfTQqiz/Lf7QdJ4dnIWNY1e6kAsL/qNjx3GW34Mi
	KZckj8ddsGHmG4CiY9fOazU4G72Y9G9YGKk/AclnqfqnoYg8Dx1so8zbYs4UTdZdkBiiK22AIob
	o2XLJpv5HX0FHedrTDq7L41gxx5kJ2CRQTulOp5lkxySXAkz3R7Oy5ULg1krKAu+tkacZfWAbVz
	8o1jcJ44qhUeX967fwPx2GZ4VroRZFM6CMHcVtHH8V9qHQjELGVThyU2dtpsNata17F6ClHk4Vc
	sBmPp/kHZzS/+tlSEACyw6VYcqeF4qBjhoxEXnrZBVYZTvJRaHAON05ZdTRo1Vj6O3Bl53TOK9w
	=
X-Received: by 2002:a05:600c:4f4d:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47ee338a84cmr18465415e9.32.1768377567233;
        Tue, 13 Jan 2026 23:59:27 -0800 (PST)
X-Received: by 2002:a05:600c:4f4d:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47ee338a84cmr18465175e9.32.1768377566779;
        Tue, 13 Jan 2026 23:59:26 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee54b8c9bsm14967685e9.3.2026.01.13.23.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 23:59:26 -0800 (PST)
Date: Wed, 14 Jan 2026 08:59:25 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fsverity@lists.linux.dev, 
	linux-xfs@vger.kernel.org, ebiggers@kernel.org, linux-fsdevel@vger.kernel.org, 
	aalbersh@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v2 13/22] xfs: introduce XFS_FSVERITY_REGION_START
 constant
Message-ID: <dktp3ghx5h4eqcfgam6dj2eaajfbje6kis2z27ofovuz63lfe2@37pwttncu4ki>
References: <cover.1768229271.patch-series@thinky>
 <qwtd222f5dtszwvacl5ywnommg2xftdtunco2eq4sni4pyyps7@ritrh57jm2eg>
 <20260112224631.GO15551@frogsfrogsfrogs>
 <5ax7476dl472kpg3djnlojoxo2k4pmfbzwzsw4mo4jnaoqumeh@t3l4aesjfhwz>
 <20260113180655.GY15551@frogsfrogsfrogs>
 <20260114064735.GD10876@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114064735.GD10876@lst.de>

On 2026-01-14 07:47:35, Christoph Hellwig wrote:
> On Tue, Jan 13, 2026 at 10:06:55AM -0800, Darrick J. Wong wrote:
> > > hmm right, check in begin_enable() will be probably enough
> > 
> > I think that would probably be more of a mount-time prohibition?
> > 
> > Which would be worse -- any fsverity filesystem refuses to mount on
> > 32-bit; or it mounts but none of the fsverity files are readable?
> > 
> > Alternately I guess for 32-bit you could cheat in ->iomap_begin
> > by loading the fsverity artifacts into the pagecache at 1<<39 instead of
> > 1<<53, provided the file is smaller than 1<<39 bytes.  Writing the
> > fsverity metadata would perform the reverse translation.
> > 
> > (Or again we just don't allow mounting of fsverity on 32-bit kernels.)
> 
> What are the other file systems doing here?  Unless we have a good
> reason to differ we should just follow the precedence.
> 

The ext4/f2fs/btrfs does this

	round_up(inode->i_size, 65536);

It's not fixed offset but next block after EOF. As EOF won't move
this is fine. So, this works for both 32/64bits

-- 
- Andrey

