Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195A91AA1E0
	for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 17:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745862937; cv=none; b=ug4Lo7d/jwcWCFNqxCpdJqrhrhm14nbcZ+TNdvBcI9uvOKveojWcSHliEkoI9icDG6erPJuJrcNQ0Fz1vP980FwovGnEz9P8J+cBd0+jUzLTjR4JVFyXH/o6i4W28tMfoRpLNGZ3naj1DqBAL9okZwlcA2FFOwpaqhQIxeZkMVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745862937; c=relaxed/simple;
	bh=/5uAWoUmx+9IvlwwzxgOvLU4mVF1VLWY10xsIe7l2cQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pYx3c+o5RaamPXPntPBjP/CMyKeIQPjamAFq5mnfGJLnl6hldy8dENDZtoymiaudrrMMpZYVbEtWUeQEwOUbliJfj+OYj2Rhb/qiJWVxLiCZ8glhblrO8jfXYbMpweDem9aWueBYIFWFZQYt38W4g/5vVT1WSgsni0RjWbx2GMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gS3YdwO6; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gS3YdwO6"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5f728aeedacso5164335a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 28 Apr 2025 10:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745862933; x=1746467733; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YT0ay/ycaDONYdeQV1UNLLylJNxyrxyp54Y+yjn33c=;
        b=gS3YdwO69rUFX6QOUomqpXV1ge/dB5K1jZAvCsDGPsYA6t44Re2nNSexPPQkPlAfeP
         EHiwYTG/vHVPqA/xnPgms9LUFqLzwvpfCDZQ50kjKicbxLjYGbeyblpr0wa2QdaxBGtM
         FqtkHUvVuTaJ1Wx8AxaKFimUtb2YtNE/r0pNf8tHnA1FxwrePXi22jHQgYX7HPxDe/Nd
         1xB4LtvbSEO0JZ61j59sGQaqwdCq8IkFnXlQJ0D7OKiy6ll7DQPgJwOf4pp2+t1aofFQ
         kCxR5yRAt38f1LC2sfqLXAvQAnhFS9eNR4Ot0n8ZOVGuqB75SgguYC3/ddq74bmMated
         M/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745862933; x=1746467733;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YT0ay/ycaDONYdeQV1UNLLylJNxyrxyp54Y+yjn33c=;
        b=IGsvYzwtySu8FoT6D5jPXQ+fhxsv2iRqmsCFD8qJ863WHOhF9WYde3XZm3gD1NvU5U
         Sy884mQjay8kA98DXqn2iOJjCx9bTQWNLKPlW8w0H0Owi5zmvQzRD0rhbECnY95k7O9x
         p/8Tu5LfU2Z6GkRO13WGCFn8cwBo0rhUMD9NeKCt7Fj1QuTq3tiZBPkM0eZMXiIFOI7S
         3eYDeZkwp9xUTHCXFIZT/uXjM7wpZGCOGGonk4UyrfYeXPgYmo6MNU84RF5nbqi4K3cJ
         wAQU61p1pX5ajRn7gk76kqvFfW/3Dv4urDHAuIWta+Ck11LhkJj08lLwMNTCZr2walke
         kE4A==
X-Gm-Message-State: AOJu0Yx+PRlJ/fmcJ/WnY9HgjzKxh5RLj31ZCunxZOTTZWPWbNevT38p
	JbrolwNYq5weL6uQRzkKMso0829wcdima6rH1eh86ZeITGcgeDmCWh3GXjXx
X-Gm-Gg: ASbGncuK55wkf3rbflzfby0r6va79M/chAqZIvLl+pbSJHWI3Xq0MOE5n0buhmKe5m9
	XH+twH4Sl5KB90dWe4URLO5DerYPEVrbDzPSTU7ASPv84fFUfSHKHuhBCiNNLvPxpq5eL5brbgD
	0Kz6DWcMPT4UEEcC0oUAKoHYQfgK0WsRRe/8aIUpFp9itzxcOdB526+4+UIyEpZUCOuJWBjIBMC
	4wk/otCLYY/qn0j3S6qD7vqKM0az5In2YMKn69TNY1prbcQ9C6C2dWBMt2aV1h0188NRQQdLao1
	9p1nfJE5eh++TdyLkURTc1Q6cXiXS6vWXA==
X-Google-Smtp-Source: AGHT+IFRNiPXMSH4ZblkCk7gf7iG7f8f7UE7F9OhThAsDK/4pGYQSSl/xKeAF4glueyOg3pn1+1zbg==
X-Received: by 2002:a17:907:6e86:b0:ac2:cf0b:b809 with SMTP id a640c23a62f3a-acec4ce1422mr67977966b.31.1745862933035;
        Mon, 28 Apr 2025 10:55:33 -0700 (PDT)
Received: from framework13 ([2a01:e11:3:1ff0:b731:1460:9d65:f626])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ecf9a0csm671705066b.94.2025.04.28.10.55.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 10:55:32 -0700 (PDT)
Date: Mon, 28 Apr 2025 19:55:30 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v7 2/2] mkfs: modify -p flag to populate a filesystem
 from a directory
Message-ID: <vfgqen7xdgdt3fljw37lxgafyifdfaikbgobhbxyfrjogyuc6q@p45gi2bi6aq2>
References: <20250426135535.1904972-1-luca.dimaio1@gmail.com>
 <20250426135535.1904972-3-luca.dimaio1@gmail.com>
 <20250428172355.GT25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428172355.GT25675@frogsfrogsfrogs>

Thanks Darrick for the review

On Mon, Apr 28, 2025 at 10:23:55AM -0700, Darrick J. Wong wrote:
> On Sat, Apr 26, 2025 at 03:55:35PM +0200, Luca Di Maio wrote:
> > +Content, timestamps, attributes and extended attributes are preserved
>
> I thought this only preserved the atime and mtime timestamps?

Right, I'll be more specific

> > +for all file types.
> > +.TP
> > +.BI [file=] protofile
> > +If the optional
> > +.PD
> > +.I prototype
> > +argument is given, and it's a file,
>
> "If the optional prototype argument is given and points to a regular
> file..."
>
> (I think, technically speaking, you store a protofile on a block device
> and pass that in, but let's not encourage that kind of absurdity)

Will modify, thanks

> > +.B mkfs.xfs
> > +uses it as a prototype file and takes its directions from that file.
> >  The blocks and inodes specifiers in the
> >  .I protofile
> >  are provided for backwards compatibility, but are otherwise unused.
> > @@ -1136,8 +1145,16 @@ always terminated with the dollar (
> >  .B $
> >  ) token.
> >  .TP
> > +.BI noatime= value
> > +If set to 1, when we're populating the root filesystem from a directory (
> > +.B file=directory
> > +option)
> > +access times are NOT preserved and are set to the current time instead.
> > +Set to 0 to preserve access times from source files.
>
> I would say "Set to 0 to copy access timestamps from source files".
>
> Though if the default is going to be "do not copy atime from sourcev
> file" then the option to enable copying of atime ought to be named
> "atime".

I was also thinking `atime=1` would be better to not invert the logic, I
was going with the `noatime` option for consistency with mount options,
but I assume this has nothing to do with that, so we can use atime

Will modify to be atime

> > -
>
> Extraneous change?

Yep sorry

> > +/* populate from directory */	[-p dirname]\n\
>
> /* populate from directory */		[-p dirname,noatime=0|1]
>
> --D

Ack thanks
