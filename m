Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485FA1D88D0
	for <linux-xfs@vger.kernel.org>; Fri,  3 Oct 2025 10:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759486090; cv=none; b=T7seOWM6SJCu+Z5zf0mL0k48wngH21zjoglgMcF+/gCRD0H2GH3ETADMXAYaXn+aSQ+XTW755q8nyTv7tJYob9o3QWtJdbkL3iTST0oL4U1NaLV31F0IGP00KXLwVfLGA16x2JuosKyRtOl3m8NJuZfQJroqEhO+uLr5Wf1/fBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759486090; c=relaxed/simple;
	bh=fW4xmtKcBROwCIBZD+ijOZoyWcAF9M7mbDEeOC2ZbDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZnIFG6/K+GrwYCrpgykpcLCO+Yvw963xCicmDA6zmxUVGOvpeyVd5WWFdiQzl4t+NJCsTLUb8Eud6zWXySHtgNCuDRj1kr7wIckt7wr0VZsAVN5qsG8pWU1qkNSH1zXKft2aUTe99VD2/Lno23JMIsDFw42y3F4h2plqIZankbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRHE1uh3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRHE1uh3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759486085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=55IKadln8Y89bcBnLvj/eyiJwDebS8D/FqvT5rTSHsA=;
	b=IRHE1uh3wOb8MG0TPJA+gF0AFi5mJPIeBezeJ7j30BEFEhbyxSaww38YrD/hJCuqJL6kQP
	pNbRz6OhnhmTfYn8JxlA9MTLPgBbSNnrv0p5B8KQ18Yfk9btI3t2LmPp4sNloq4DiWKndN
	4AS9urfUuh3AyR2+nEgMCkDcDUSJwqk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-4r5I2HeZN0G1fF2CKJDUxQ-1; Fri, 03 Oct 2025 06:08:03 -0400
X-MC-Unique: 4r5I2HeZN0G1fF2CKJDUxQ-1
X-Mimecast-MFC-AGG-ID: 4r5I2HeZN0G1fF2CKJDUxQ_1759486083
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6232f49fc79so1944441a12.2
        for <linux-xfs@vger.kernel.org>; Fri, 03 Oct 2025 03:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759486082; x=1760090882;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55IKadln8Y89bcBnLvj/eyiJwDebS8D/FqvT5rTSHsA=;
        b=ICXMQ4not31A4bJIQ+eeE6la2mpm9lsfp22M+8DENTE21ywK6ldBnxxd5c9oz6dQhl
         b+itlUleCx8ksODBqL34o+0TiAOYky8qDZCGZCQRmBIyfebBCIBDjrHf5Sk1dh+n31SQ
         nQtoKfgSv4Kvjy92AaB2N21IPJ2lND6EDOqgfL6CTmYVi1Vb1pD+vbKvHZzF5DB01otc
         bzuaYDvvnP1CAUuAy1PCnCtuRiz7OaD2TitnZHc2pQyZhy5kbDzsy7rAynBYAtkgWHKs
         hGWqImsEqDsTGnwkn8ooMYBsoke2Jl/WW1UZEEA/Ue3UcDenr5LykC7rDFGPplGbDkb+
         i5kQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3jdFtHFSr7GssvBiBPyI2x+GB5wdPg9G2yWaAFmMlJOORjBrRO838hcmSYvMUlczVzf8CiRsQUeA=@vger.kernel.org
X-Gm-Message-State: AOJu0YznV2aGzbbhurFK6cJCRJYe9RxdcqQiC6vYD/i4L3cVUw8oAE1i
	9vWYHNlID+IYaJmWHe9woApemvpTgC5aicZMND0C4HUQuIQxeG8qPShU2hpO67j9f3/BxjYIz71
	25VYuZFzfAxThlzy/i2YEfBS10eHE70Q8sburF7WuBHlYrf496TkKqGupoVfG
X-Gm-Gg: ASbGnctHD1Z2GRfMJL6c+6pvIMjE6eb4ZYBY+3OIwHturqzJpW+6FBSLFJxMoh5PCOo
	Vzzv6cOSD3U0iDyRqVQtDuiwrGY+xqtFvSgKe516CEJYg6SYAAoJqX7vQJfZDQQbm/x4I9wasAb
	SkEX+QeQ3ZpT2MHT+aByJWmvgMVOTnJn7nsCgyNG3ubNGiVz4K3N/lcAmHJ+L2CqwCkRuKfsPfX
	jkj9K2uZlsofKRpvwbed6GXckW+h3KIg6hXoGiSdGAP061+N0xxSnOllVAzF+riPH39SJNgDJlr
	wsCTJCfoE9UCZislXoiXLwXLVI8tzKRmKxNWgF1oV6jDCf45CwwF0rfXCND5KLXMbA==
X-Received: by 2002:a05:6402:42c9:b0:637:e94a:fb56 with SMTP id 4fb4d7f45d1cf-63939c2e125mr2529345a12.35.1759486081758;
        Fri, 03 Oct 2025 03:08:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWl1Nkkc9kEKFIF5ZTQH0P343iPe2N2Q70EEckGGReFge+M6LphuueS56E8MKyPRcltokhkA==
X-Received: by 2002:a05:6402:42c9:b0:637:e94a:fb56 with SMTP id 4fb4d7f45d1cf-63939c2e125mr2529314a12.35.1759486081273;
        Fri, 03 Oct 2025 03:08:01 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-637ef848199sm2215829a12.21.2025.10.03.03.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 03:08:00 -0700 (PDT)
Date: Fri, 3 Oct 2025 12:07:29 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>, 
	Christoph Hellwig <hch@infradead.org>, "A. Wilcox" <AWilcox@wilcox-tech.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs_scrub: fix strerror_r usage yet again
Message-ID: <hk4clpry32jwyn5hit73oltflfqxe6jkwfilshf4mj6656siy2@3n6quhcp7iib>
References: <20250919161400.GO8096@frogsfrogsfrogs>
 <aNGA3WV3vO5PXhOH@infradead.org>
 <20250924005353.GW8096@frogsfrogsfrogs>
 <aNTuBDBU4q42J03E@infradead.org>
 <20250925200406.GZ8096@frogsfrogsfrogs>
 <64881075-46f0-ec0a-f747-dbea46fc5caf@applied-asynchrony.com>
 <20250926162716.GA8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250926162716.GA8096@frogsfrogsfrogs>

On 2025-09-26 09:27:16, Darrick J. Wong wrote:
> On Thu, Sep 25, 2025 at 10:58:38PM +0200, Holger Hoffstätte wrote:
> > On 2025-09-25 22:04, Darrick J. Wong wrote:
> > > Has strerror() been designated as thread-safe at a POSIX level, or is
> > > this just an implementation quirk of these two C libraries?  strerror
> > > definitely wasn't thread-safe on glibc when I wrote this program.
> > 
> > It still is not:
> > https://pubs.opengroup.org/onlinepubs/9799919799/functions/strerror.html
> > 
> > Pretty safe to say that this particular train has sailed.
> 
> Sailed off the end of the pier, yeah. ;)
> 
> Andrey: could you pick this one up, please?

I will include this one in next for-next

-- 
- Andrey

