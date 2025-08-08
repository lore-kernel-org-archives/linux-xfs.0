Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9359C275860
	for <linux-xfs@vger.kernel.org>; Fri,  8 Aug 2025 11:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754654121; cv=none; b=I8hSRUGQ2sOSOlXgefTQMgbF0qSxbeuP2zq+9QnjH2ckBhdPX4LzsL4g/S7IHCbhyQUG0bD290t2LIkCtPWuhdnb3rfDxjsSy5dNRS9bxVlC7Krg250RRXCyy1XPoBxEk7K4LupzhqraZSAyKwoYf6HEe6Y2PxaCjoOyntAGM1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754654121; c=relaxed/simple;
	bh=n/MT8OcvUtJE77NwdPgoyqv8kDlu3SUcOsbhWi6ziaA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbgKo2T4GHyakHC6x/pkRczwdLjeaoqh/Ck44ArM46DxR7dqcoN+AUTCwrPlilYV7vR0b+QwE4+BDycsR3cJLFXG2f3gDnBEEJjnhC0JNBhvl5HNP1CBjspMZSe5PD4kGXE/g7V3jqCGtbtJUEjwiIYdAta3j27hHEHB9DZyIV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WXj1HUbo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WXj1HUbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754654117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F4drwZZ+3blUpWpdIVuLJqp2lsrdhuI1Hihod0Asm0I=;
	b=WXj1HUbo/xBK20Y2HLX/K0YfToGKI24/eil3bAJkuJy2mvMqDRenOTQmi5xDbzd4JKYGOL
	pQGx+lbBlNPI8kKnkwECVBZMnrMlf8Vza1YN97ZV+pXZyYRFocUXrXbH+miPqcgWSYzrMG
	s8WyOI9Y0JkgTMXZljSV6xuvs0S7OcU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-5vxSpfIMN4qXpFQlO26sTg-1; Fri, 08 Aug 2025 07:55:16 -0400
X-MC-Unique: 5vxSpfIMN4qXpFQlO26sTg-1
X-Mimecast-MFC-AGG-ID: 5vxSpfIMN4qXpFQlO26sTg_1754654115
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459e30e4477so15867805e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 08 Aug 2025 04:55:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754654115; x=1755258915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4drwZZ+3blUpWpdIVuLJqp2lsrdhuI1Hihod0Asm0I=;
        b=peDlsILlOiOt+L0lDbXstIhcrLVWZegOBd05PBcMnq8CNz8NF3cYwD22C9Lm8npBHP
         2OrdOc1Hunt9OB3cUUAjpbiLCpDIIw6yDT23e3no+kvLfgE50HC9LB/IqfJWrViLIdzz
         Ga07gZafvk9RdAuPgjbri4nD7MJu11x4PJ8Lwc+a6MOEQJQGA49cb8nYjwizkevhwAQP
         Z2Yl6we8Qjw26TuDe4Nn0walonKp45xCr7CxNi+nW2iMCZiMG+kZV7dqtIkDG6ONXEeG
         qwowSOvu1GfbBTxHNhbJX71jYpfc/txNW62zn6pBFvyoa1NG/O+pGW+tHdsAuEqO+rxv
         G3EQ==
X-Forwarded-Encrypted: i=1; AJvYcCVBFJ+37RMq2+9SmCRVDus4zbi+jLvgKCNGFsraCRwoFXqjpziCpcGf/Cu+kkI/tF5HUIWTBvYtCF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFruy0jBuoVSrX+UWXrXwzroMcSA3ZYAMdQlFDxvOFT2tfVTVY
	Ae3AjSULjIvvzE9ZE5LRPepY3v0Cu5yXSxIJWAsySPOh3f5Yl9AY+YBAjn2QDKte02cWwZGQMGp
	9sqKTH2hRvBcXXU9XFDK7mdWg6cXtyfMvl4j8D8k2iOZT/Y/4w+y4GTkqMo2y
X-Gm-Gg: ASbGncsJ2L++bnofR7xzkBgLgmzUDVblF0Vy1DmKy2Ze6ySJz18MHxhgS0aHTJw80LN
	t5eVJILtfR2bvqB3fHLZRXlTy7EkQJDw9DNnjvSjKCpOx0V7N826VxY5JYea2kUBqSPu5yNpb3b
	rWSfSlF6100T09VK9MPbwwrEXzi9SpHKzORJos1fwJyCaT5yZfUmuDXBVO9gyeeX/Isima+xKpK
	jHf0H6+E/AvwdWA3xs95AaFQhMySXCv/tnweK8SBx7IlbuFXGLkGyFEu0vnRHZ/I2p/wVIMBtHZ
	aMfwNxr3zwc2Y1C/BMRU/aYs4UtNywWS+TvtHSv24F7LJ93QpKzKOWB8zkE=
X-Received: by 2002:a05:600c:8b34:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-459f7bd8e86mr16344375e9.0.1754654115067;
        Fri, 08 Aug 2025 04:55:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4+aMcjlEP5J/AzYjLRkq61JDLOWunE5ZS/woGTffAQ6Un3vNvFjKJc3ctRGXecGruX8IrPw==
X-Received: by 2002:a05:600c:8b34:b0:439:643a:c8d5 with SMTP id 5b1f17b1804b1-459f7bd8e86mr16344155e9.0.1754654114681;
        Fri, 08 Aug 2025 04:55:14 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dc900606sm196993005e9.15.2025.08.08.04.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 04:55:14 -0700 (PDT)
Date: Fri, 8 Aug 2025 13:55:13 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Luca Di Maio <luca.dimaio1@gmail.com>, linux-xfs@vger.kernel.org, 
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v11 1/1] proto: add ability to populate a filesystem from
 a directory
Message-ID: <jjpiu6ot5kndjcggvoochddt7qq6vxmijdlog2vcp7y6pldhy3@wmbpth6y5af4>
References: <20250728152919.654513-2-luca.dimaio1@gmail.com>
 <20250728152919.654513-4-luca.dimaio1@gmail.com>
 <20250729214322.GH2672049@frogsfrogsfrogs>
 <bowzj7lobz6tv73swiauishctrryozcwqmqyeqck65o2qjyt5v@vufmu67nwlkc>
 <20250730150409.GG2672070@frogsfrogsfrogs>
 <an4uufrp4vk4bqs4zpvver7sodqn3i2gtx5rjp5336jlylmmhk@bchzcckwdlfr>
 <20250730152652.GS2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730152652.GS2672049@frogsfrogsfrogs>

On 2025-07-30 08:26:52, Darrick J. Wong wrote:
> On Wed, Jul 30, 2025 at 05:20:42PM +0200, Luca Di Maio wrote:
> > On Wed, Jul 30, 2025 at 08:04:09AM -0700, Darrick J. Wong wrote:
> > > On Wed, Jul 30, 2025 at 04:40:39PM +0200, Luca Di Maio wrote:
> > > > Thanks Darrick for the review!
> > > > Sorry again for this indentation mess, I'm going to basically align all
> > > > function arguments and all the top-function declarations
> > > > I was a bit confused because elsewhere in the code is not like that so
> > > > it's a bit difficult to infere
> > > >
> > > > Offtopic: maybe we could also introduce an editorconfig setup? so that
> > > > all various editors will be correctly set to see the tabs/spaces as
> > > > needed (https://editorconfig.org/)
> > >
> > > Hrmm, that /would/ be useful.
> > >
> > 
> > Nice, will try to put something together for a future patch
> 
> Either that or a indent/clang-format wrapper?

editorconfig and clang-format would be great, as far as I know
clang-format is pretty flexible in its style configuration

> 
> The kernel has scripts/Lindent, maybe someone should try to write one
> for xfs style if I don't get to it first.
> 
> <sigh>rustfmt<duck>

:(

-- 
- Andrey

