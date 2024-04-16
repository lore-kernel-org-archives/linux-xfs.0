Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57CAF9F0
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713285126; cv=none; b=Ond6aJxRcd6cPaAOJ7HV6rKoilg655otir6gbERjcfi0gdBWLjCoreyzxek+heGulgpsKcg3/LhPZbTVYZAi0gHmOVCYDvbN6D2DxqZN/jr53pkyskaJV6Qo9/iQJVWM6A4cLIGzxYJLDAlFewcloz2kPX5Pmakk8+3V3ZNBHJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713285126; c=relaxed/simple;
	bh=yzS1DmbgjX6Nq+ZWRrXOT9Dvn9edaLyDkAzMevHpqVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HL2KKM1A506oOyGXyBptGH4NelpuprSxR7m+OXtFcLi+xkyIb2VxVMNofIFT+ydXm039ISpdXOIkifT5s1ijDCoKzYtBIOrPuy+2ENeSlcg10w5MyXkGPEY0YXmoLqLSQLxMXCTFsOmSwxZI0L57zg94AvfCM2qTZsBRCvUQaoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIqLKlKT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIqLKlKT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713285123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ayJnstHtlrEuw9CXW6uPHWwd68S0wbunQ90Gf9INOsE=;
	b=OIqLKlKTh/y/n1Dl/rIwpSdCVbREY0USZRoMfi3My1WDppn3q2wRptj9OA88f+A9IRVVTU
	3INOngon++xCUemixwu3Ht+l1XQHYZdfAIpmMSiMjkslidOiUZBl2rbICqc/3XAkhP6zKO
	MMdm+bUAhgrtc7baWiPg0ccr88LWPo4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-500-z6okxQulPK6cxluqBwCKOg-1; Tue, 16 Apr 2024 12:32:01 -0400
X-MC-Unique: z6okxQulPK6cxluqBwCKOg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a51aec8eb93so334696466b.0
        for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 09:32:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713285120; x=1713889920;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayJnstHtlrEuw9CXW6uPHWwd68S0wbunQ90Gf9INOsE=;
        b=m6Y0CJJBsfPnIlD3dkf1Rcbr4l6Z2+4IWm7l/LG/+hT66OZ7vrfNzm238ke/SziDBU
         xMrnuPs8+I75gx0JgyaG1mAoxC5i47UvKlm3QEDTyGmesaYs/9tQ9Y1MK/MxnsUznGJD
         boeGClQ3TW6tamxExb32cqrNL4mO9ry/tT9wtMjoNzXdVX0/NyJ5dlbZZcfN/tre0J86
         8Hsg8ZxRNY1KlbQZecBrvs0Tg5D1VeEYID/cOr3ctDmxBBLLY59dVju2Pc4wozdou4nn
         v/LGJfkcoFbXSCCPifvwl1jIJkpVwQoDxCyzGzTx7qJq2RilgJ0JqVWhlkHqZFAKEj/m
         8KVw==
X-Forwarded-Encrypted: i=1; AJvYcCVpbDGb3mDFw/ddYEMFkQDVvhtF4SGv2ygJ5I1IyXWd4eOrIBO0tvZOKSbyVR5YJ5LUX4G/x+tIqh+SA/ftrW4+iAAD0lKVfcvf
X-Gm-Message-State: AOJu0Yy8qzf1QMiWXrJdbhc3+ognd+7y5gNVwHI2C66ou+oJnG7RMUOX
	xAcRsJCbo/o2f6qmkiaGKSafk3hBeflIl7bEsXXxqxaPpbj3o6LBWUEaL9YVGpnsfWZ/vmprPQ3
	4UX37myImOTpg2VNRvG6d+NIoAHORBoOeGCsqVbsjbTZcXi8c3oGYqr1BDn15iwxA
X-Received: by 2002:a17:906:795:b0:a52:58d9:4379 with SMTP id l21-20020a170906079500b00a5258d94379mr4604866ejc.16.1713285119564;
        Tue, 16 Apr 2024 09:31:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHx+HU5wb+07u+5Y0kg8ajhMY2p5xb7m3SfY00wxPlVcBJCcecTo/QRDChwwzyWmPlPXSFbtg==
X-Received: by 2002:a17:906:795:b0:a52:58d9:4379 with SMTP id l21-20020a170906079500b00a5258d94379mr4604842ejc.16.1713285119009;
        Tue, 16 Apr 2024 09:31:59 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id w6-20020a1709064a0600b00a5209dc79c1sm7126838eju.146.2024.04.16.09.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 09:31:58 -0700 (PDT)
Date: Tue, 16 Apr 2024 18:31:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs_fsr: convert fsrallfs to use time_t instead of
 int
Message-ID: <ay75niholqd2z7tlcgygzoyzc7qyt2zgkh76utoyvk3vayytq4@57qbfxilszhk>
References: <20240416123427.614899-1-aalbersh@redhat.com>
 <20240416123427.614899-6-aalbersh@redhat.com>
 <20240416162125.GN11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416162125.GN11948@frogsfrogsfrogs>

On 2024-04-16 09:21:25, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 02:34:27PM +0200, Andrey Albershteyn wrote:
> > Convert howlong argument to a time_t as it's truncated to int, but in
> > practice this is not an issue as duration will never be this big.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  fsr/xfs_fsr.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
> > index 3077d8f4ef46..07f3c8e23deb 100644
> > --- a/fsr/xfs_fsr.c
> > +++ b/fsr/xfs_fsr.c
> > @@ -72,7 +72,7 @@ static int  packfile(char *fname, char *tname, int fd,
> >  static void fsrdir(char *dirname);
> >  static int  fsrfs(char *mntdir, xfs_ino_t ino, int targetrange);
> >  static void initallfs(char *mtab);
> > -static void fsrallfs(char *mtab, int howlong, char *leftofffile);
> > +static void fsrallfs(char *mtab, time_t howlong, char *leftofffile);
> >  static void fsrall_cleanup(int timeout);
> >  static int  getnextents(int);
> >  int xfsrtextsize(int fd);
> > @@ -387,7 +387,7 @@ initallfs(char *mtab)
> >  }
> >  
> >  static void
> > -fsrallfs(char *mtab, int howlong, char *leftofffile)
> > +fsrallfs(char *mtab, time_t howlong, char *leftofffile)
> 
> Do you have to convert the printf format specifier too?

is time_t always long?

> 
> Also what happens if there's a parsing error and atoi() fails?  Right
> now it looks like -t garbage gets you a zero run-time instead of a cli
> parsing complaint?

I suppose it the same as atoi() returns 0 on garbage

> 
> --D
> 
> >  {
> >  	int fd;
> >  	int error;
> > -- 
> > 2.42.0
> > 
> > 
> 

-- 
- Andrey

