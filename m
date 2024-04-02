Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAAC179BC
	for <linux-xfs@vger.kernel.org>; Tue,  2 Apr 2024 12:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061478; cv=none; b=ur0K4pdUQDrvidWSpjht4tX2rcpoIsSNGQdyIyLi2DaxnEOI18xIypKwLNvseHjKbBehYeLrKYbvFpymZso4uNLn2J8F882MXrZQNhxLrMi2nwI9TyKghwFStXAwO1kx9u0so41eS4Xa5mq3utNcYqtPoYM+oAqb6wPSGNaECvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061478; c=relaxed/simple;
	bh=mTKiK/bd4B5Snb61jQKfVAlk1Uk8dcd9CCgYlmgpV9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hevEC7JAAQT2B+lb4w7X6Z/bEERuLDeplfWhV+vRVupc0e4JKvkQsEux3Oq/PTTSG18o/ZtbqMqqozi/ehMCFzOc6pU7vvIuYsz3Kftn711dQBNDyMy726OVbLLXoEKotEoujzfQPXUtdgBt9Ctwn4VS69aA/mZfC1fYblPMMAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WmYZTt7I; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmYZTt7I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712061474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g6k4yhaZw6MRRje/zJwwEymZQjJ1fk5zRXcMKDtCSjQ=;
	b=WmYZTt7IrxcBuuQyxsN7Y4R8kk9S5MIcrws/mU8LZ1LetyivSt8AtjQzz8PAVH6QSV3rel
	aA3ahYl/INOXjTK4jQYPB6JZNamihwasCTBGrfr0IcmDW9qFQTfCGaw4C5AnD/1sbw2YG6
	7vhgyPUVN4mMcRBofNNWFKWB23rgo7Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-358-5UYIB6V_NUSN4-H0wrP29Q-1; Tue, 02 Apr 2024 08:37:53 -0400
X-MC-Unique: 5UYIB6V_NUSN4-H0wrP29Q-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e7d12a221so73514066b.0
        for <linux-xfs@vger.kernel.org>; Tue, 02 Apr 2024 05:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712061472; x=1712666272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g6k4yhaZw6MRRje/zJwwEymZQjJ1fk5zRXcMKDtCSjQ=;
        b=IE/SGLE8Vt3r+WNbQWohKAWpCsZ2KkDWhAiL66Xzga07jJT1AN6ioT/5Ao3yjiUEjt
         MewzM3oC1vBlIYrsYKPvQvyjZyKJRGbNT9ADG8fxAeDjQjh+JYdH7flWKGCLXgN4zOX2
         MUkSDPaoDMNBp15OYBQt0WSDw38VCAmwv1q+zC3q3477vo8ksMU9mT4AhTvd6Jtkzmg3
         yJcL3xvJQvD/sayhCrOvPXJmVjloWOqA8l5RH9VyK97TdNZSyLHlcVnuZasaCohP5zuJ
         iwy+cp8brbaZSLwymqbjdmzjV73jwmDZwwDqrAzCr13YUBfV1ywgFJCvxCKCwXvLhlkz
         zcfA==
X-Forwarded-Encrypted: i=1; AJvYcCXaCfHURg6qpcTWPwzpyGSvXBF4JK+i1RZVA0g4Mm3smxYKZzdaLIlbPSugHU+qbAuKuhQoIhlfKd7STCQ/uHt8CxgxZaCaGlvL
X-Gm-Message-State: AOJu0YwuTXW4NXc7ac3T7lkf4CyuB5obhpPOwbAu+KN74xu8QoW2M1b7
	VD79eEanbITyxlnE/PBFtgEUb32dUWkzIjSmjVDXpXa8KKlV+ziZNkZomJwAAY0BLH6u7/ls105
	jgQjppK7u1VQnZEFaqkCEuPu0q+VmU2voML1en7Yxqdu1DQceRxzKkdIr
X-Received: by 2002:a17:906:f284:b0:a4e:2123:e3c8 with SMTP id gu4-20020a170906f28400b00a4e2123e3c8mr7407269ejb.56.1712061472101;
        Tue, 02 Apr 2024 05:37:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlEz2I255dOogolt0uIznw+lpBOPt+W1j5C0C+337idh8Agza65YdRH9pPiFHshDM6HSGN3Q==
X-Received: by 2002:a17:906:f284:b0:a4e:2123:e3c8 with SMTP id gu4-20020a170906f28400b00a4e2123e3c8mr7407256ejb.56.1712061471443;
        Tue, 02 Apr 2024 05:37:51 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id dl5-20020a170907944500b00a4e28b2639asm6003714ejc.209.2024.04.02.05.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Apr 2024 05:37:51 -0700 (PDT)
Date: Tue, 2 Apr 2024 14:37:50 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: ebiggers@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: [PATCH 12/29] xfs: widen flags argument to the xfs_iflags_*
 helpers
Message-ID: <vhk2g3qvkf224oklr57pmdnrjh6odshv62ciqguxcsgbrbplt5@3msropqnuqfa>
References: <171175868489.1988170.9803938936906955260.stgit@frogsfrogsfrogs>
 <171175868758.1988170.13958676356498248164.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171175868758.1988170.13958676356498248164.stgit@frogsfrogsfrogs>

On 2024-03-29 17:39:11, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> xfs_inode.i_flags is an unsigned long, so make these helpers take that
> as the flags argument instead of unsigned short.  This is needed for the
> next patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_inode.h |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> 

Would it also make sense to flip iflags to unsigned long in
xfs_iget_cache_miss()?

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

