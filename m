Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E0222D790
	for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 12:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745496073; cv=none; b=UtrXX51hlL/hXp1o4vdztvkBYIuZGkvYTqMshURegW4z660Xfpf+PZoNp9WW9XRQL9US4snwR1Ea/SC3mYlSe9baqLk9S6jUXGlQolRiBgHh3SuDyPYgQ2Fk9+OWUQEeWZcgWaqYAYlyq8QinVIBLZf09KwPloKzbiiFp+knuzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745496073; c=relaxed/simple;
	bh=zHBNLeWHxH4uRghVIDcJGB1pA5KmRlsOoweWHwi1x2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gVa5IfTLoGl6fNmKxk4EWbczMBTwqXEkxZmuxA8/3rSBQ1OhGx715u/2bQHMFG5tyfrBMWdu4aMohx2HHfXUzEMIjekHOZl+leeo60CYkJZaNmbm9OCr/oPszfGbQgsNuvxz9szM6XKEd002U+KjYeK5gPGsnP2u4SVzo4SKHkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CrqWPCHs; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CrqWPCHs"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so152805966b.1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Apr 2025 05:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745496069; x=1746100869; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bMwfHG9xzA15pccf4ogfuhy5PgXFYvPdPYe3VlnTEBw=;
        b=CrqWPCHsagQt8AfYF1k2srrs5WCNcKC5ByQs/3JYwj6blZmoAIFrnyMxnNLjqXEyYj
         PZwRZGybbAvfPbksV38q0etxKL6QnZlgbBdKAbwJ6N7pE2UXm3KtLXADQyIvtkHujvID
         xTq/ndtYMA+aWF7uwJOgdxM6xKP6dz+AaY3iIQFk3LoqInaH2Knh+JE220CMb96+bQIW
         R9o9ZejeIVDppxcoU2Cljv3rlHJlgscMwJiUqcu50syPVhIWgUnz1Exi5QpRnx8Igl/B
         fMB9R+JQUSHIJ3VZ4PKJOOBgFbyx9+3LsQ7jjJQWeQ+Y9Z+nq5WJXZ+iOc/sA4xk5Zxj
         F/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745496069; x=1746100869;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bMwfHG9xzA15pccf4ogfuhy5PgXFYvPdPYe3VlnTEBw=;
        b=JkmY0N3dD/sTotJHuPAPYIPa2xO7q97PAp2qxbyWoLQD8uxZu43BLKKnJED1zyHKEO
         OyHv2zOqNVxfpz88y0xGxRBsGxArIfiDH4Kq9sSNEJIOJyrIer0dFlqpsaxpvdwxw8Ls
         S4ND+TbqBiD9GcgQRUX2LzMWPtcQxIjbvYGyKUdr40a7WP2Sw4o+Hu7qT4IaU9JXQy+l
         8aisR4IyKNa9kV8iEM0o7Xt/GqIOdSUXZb053Rwq9mffIyk70FoXQO/lFslk1jpuInVZ
         6ob8i0htHlokDYhMfTr4/QA17McRIVba3MWYjSr6Zdv++YGRxVLlnET7zZz3u20+6EyG
         E0+A==
X-Gm-Message-State: AOJu0Yyi/y17/1NZQ2tzLkhgkv8KnDPjoYihoswXRuBuOYSDRA5yX0Ni
	ivjQB2fSTuvx87WhDSrGWffqqSPw2CK+vsGztAG9rKlfA38yjMB5
X-Gm-Gg: ASbGnctyjLg2/2PKFzT8mJegoO9HGq6uyv6X2NjqpdXXytM2ysLU0X8rQyLloGaujxN
	zeuDzRK8p0f9H1jiBzBpZgW2G/Qtup/LqhEcAw7FE4HhLqpB5BQtDTdhVNaBI4HVnRMwvP/V6I9
	iH3ZD+gZDHmD3txHBmYkGR22mxxPj0VgbeYRdnNyEj0zoroTQaG/QGNECcVGJUarsjjtFdwFXOy
	eRud2WHLHA/zYlBbm2YTjPckohfETNCS+ObySclsW5gfsn085HQQ+QpXavT20VWs6e7zlHJo3Gd
	aK7yp1M=
X-Google-Smtp-Source: AGHT+IHrb9kno+Rq6a7xJUMKbJdPb+het5vGopZuCHh/aTGBEvPtlZj6D4RvyiwV9Skd1+up6ynjVw==
X-Received: by 2002:a17:907:a088:b0:acb:63a4:e8e9 with SMTP id a640c23a62f3a-ace570e7c36mr233501366b.5.1745496069121;
        Thu, 24 Apr 2025 05:01:09 -0700 (PDT)
Received: from framework13 ([151.57.44.129])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59bba677sm97050666b.99.2025.04.24.05.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 05:01:08 -0700 (PDT)
Date: Thu, 24 Apr 2025 14:01:06 +0200
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, dimitri.ledkov@chainguard.dev, 
	smoser@chainguard.dev, hch@infradead.org
Subject: Re: [PATCH v6 3/4] mkfs: add -P flag to populate a filesystem from a
 directory
Message-ID: <rb5jppjdx4c5b4qxqmlxinheztreysqts5o6fx575zvceszart@mtpo6ngxms5m>
References: <20250423160319.810025-1-luca.dimaio1@gmail.com>
 <20250423160319.810025-4-luca.dimaio1@gmail.com>
 <20250423200914.GH25675@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250423200914.GH25675@frogsfrogsfrogs>

On Wed, Apr 23, 2025 at 01:09:14PM -0700, Darrick J. Wong wrote:
> On Wed, Apr 23, 2025 at 06:03:18PM +0200, Luca Di Maio wrote:
> > -	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
> > +	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:P:m:n:KNp:qr:s:CfV",
> >  					long_options, &option_index)) != EOF) {
> >  		switch (c) {
> >  		case 0:
> > @@ -5280,6 +5283,9 @@ main(
> >  				illegal(optarg, "L");
> >  			cfg.label = optarg;
> >  			break;
> > +		case 'P':
> > +			cli.directory = optarg;
> > +			break;
>
> Uh... why not modify setup_proto to check the mode of the opened fd, and
> call populate_from_dir if it's a directory?  Then you don't need all the
> extra option parsing code.  It's not as if -p <path> has ever worked on
> a directory.
>
> --D
>

Alright, that makes things easier yes, I'll just make sure to clearly
explain the difference in the man page and help so it's clearer,
something like:

```
-p prototype_options
Section Name: [proto]
	These options specify the prototype parameters for populating the
	filesystem.  The  valid  prototype_options are:

		[file=]

		The  file= prefix is not required for this CLI argument for
		legacy reasons.  If specified as a config file directive,
		the prefix is required.

		[file=]directory

		If the optional prototype argument is given,
		and it's a directory, mkfs.xfs will copy the contents
		of the given directory or tarball into the root
		directory of the file system.

		[file=]protofile

		If  the  optional prototype argument is given,
		and it's a file, [ ... continue with existing man ... ]
```

So it's clear from the docs that the option is there and it's the same
flag.

L.
