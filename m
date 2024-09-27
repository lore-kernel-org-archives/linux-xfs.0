Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20971C1AA0
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 16:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727453867; cv=none; b=m1iqWVi75yTlHdXhQaznUTRRqXUm1dQfA8R0NHV0oZlRP0LLkU2ewK4vuD4d67L9g9ChXsKzCBWyQO6Cq/JUw7Yg2QK309T+ccDLkjn+m6c1V+tSSVBZwrWv9+UHCs40V6QmAdvvLBW2GG6pYxiPvBIAQPM+bXoRvoA0unOc+f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727453867; c=relaxed/simple;
	bh=KUrjWTd52AS6Ehp8haJMBpijrCVcqc3S5JOoJ+9UQjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W3rAuurtWf5l1+iWwTf0e++5kswd7UI1UMiPuUhrsnyi3Cg5b+5M4cGXuz1HLZyiMoWvzXGmuBjXQTO/y19TB/NTHx4JJwdB06JF6ARp2C6GdnGsKFBy65Sv06Ihlou4cc5BtT8qcn160K7ts8V1ualHXM/sK/ABIDv93LQSA70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C4MWQxeg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C4MWQxeg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727453865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WkPAf5pPZT9IvBMgja+3V6pnvlbstTPttELU5RYX4Lw=;
	b=C4MWQxegod/2u/nitiDZQrUjFGUC/HpRCk2cPPeiPNO6Au832NFTVZaO9v14FLknp2xyGJ
	TFxq7sEXeeYPcTB6zYd8KTfj1fOs2r5Y905umNcakDzE4XiMVuXaZxe7e27bO7d5xvh2/8
	eph+Jcc8xRya/e78RBtl5XcKSTPbExI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-HkOSRg95N9C_L4Ko1bnJlw-1; Fri, 27 Sep 2024 12:17:43 -0400
X-MC-Unique: HkOSRg95N9C_L4Ko1bnJlw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb479fab2so16238385e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 09:17:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727453862; x=1728058662;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkPAf5pPZT9IvBMgja+3V6pnvlbstTPttELU5RYX4Lw=;
        b=RI/+TcJhh+ryziFsXc8RNhKCc13/PpuCrFfeBaz22vhy7NLFGJDsshHZimMOFiPGx2
         4/M7hzJi/4Z/CJjBf5lkjS7H5AzOE+10XhQlJ60JOz3fxhvWOP6LQUVEtw4b8MbmC0w0
         oxbfVVJvAZ1EA9ke05l1FLmn1Gyi1Haj3ydG93fPgQvS5yPBEZ0rpMze+GlIKZl/gyIu
         E5lxGiAMfc7UEyeP5MKkukHnGEbR68DARbWb4czqWPkkJfCW6LRPutK29Bn1jhn71d+Z
         44A3d56cg4d62FDVGnvqgbld6yCnEGd3dWvaq1lSFORDHGklVltXdp23iJ7Lcc82RLc9
         FZDw==
X-Gm-Message-State: AOJu0YxlvD1j4xtRj6SNU3kBe4PTBDD3olCrAlP0BL5C07+H6oGVYuAu
	aPVlH6B/tGnxD6K1zZzyIdN7feUTTwZLGV/oGXS4W3PI6S77HeorM8kLTC3ybHlRxscSv6BZ7SR
	sPNLEhqoJjcUx8irmGbg1NKqZBIdj96p4+J8J8/4NjdQMLTGEkFPn2WoQEPgnbt+5
X-Received: by 2002:a05:600c:1f91:b0:426:63bc:f031 with SMTP id 5b1f17b1804b1-42f57f5d893mr27001645e9.1.1727453862253;
        Fri, 27 Sep 2024 09:17:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH26VO3tVia0puYx+UpIF6pqx9jC2BT4ogvqoSZeyLWq+p6DMLZuk/WBmsF8uwTPgGcXXSMBw==
X-Received: by 2002:a05:600c:1f91:b0:426:63bc:f031 with SMTP id 5b1f17b1804b1-42f57f5d893mr27001525e9.1.1727453861813;
        Fri, 27 Sep 2024 09:17:41 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e969f2434sm78897175e9.16.2024.09.27.09.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:17:41 -0700 (PDT)
Date: Fri, 27 Sep 2024 18:17:40 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: Re: Re: [PATCH 2/2] xfsprogs: update gitignore
Message-ID: <kytibzjbd6c7mjx4tndppujofz7mhqfiowqahemk42oyelp26e@a4auqdutyy7x>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-4-aalbersh@redhat.com>
 <65wlm36uziggutarpnmmy3uxbnrwdrv6bf3co54gjipbwxp2ej@r2sbabrc5m23>
 <xsfgvilxt524gct2jrjplcbu2irjjoapwmmy4qj6bnzwyq3lys@hfp5d3hkkou7>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xsfgvilxt524gct2jrjplcbu2irjjoapwmmy4qj6bnzwyq3lys@hfp5d3hkkou7>

On 2024-09-27 16:17:56, Andrey Albershteyn wrote:
> On 2024-09-27 16:09:20, Carlos Maiolino wrote:
> > On Fri, Sep 27, 2024 at 03:41:43PM GMT, Andrey Albershteyn wrote:
> > > Building xfsprogs seems to produce many build artifacts which are
> > > not tracked by git. Ignore them.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > > ---
> > >  .gitignore | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/.gitignore b/.gitignore
> > > index fd131b6fde52..26a7339add42 100644
> > > --- a/.gitignore
> > > +++ b/.gitignore
> > > @@ -33,6 +33,7 @@
> > >  /config.status
> > >  /config.sub
> > >  /configure
> > > +/configure~
> > 
> > This smells like your vim configuration, not the make system.
> 
> opsie, you're right
> 
> Andrey

no, my vim was creating backup files but this is actually created
by autoconf.

this is doc for autoupdate, but autoconf does the same if
./configure already exists
https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.72/autoconf.html#autoupdate-Invocation

so will add it gitignore

Andrey

> 
> > 
> > Carlos
> > 
> > >  
> > >  # libtool
> > >  /libtool
> > > @@ -73,9 +74,20 @@ cscope.*
> > >  /scrub/xfs_scrub_all
> > >  /scrub/xfs_scrub_all.cron
> > >  /scrub/xfs_scrub_all.service
> > > +/scrub/xfs_scrub_all_fail.service
> > > +/scrub/xfs_scrub_fail
> > >  /scrub/xfs_scrub_fail@.service
> > > +/scrub/xfs_scrub_media@.service
> > > +/scrub/xfs_scrub_media_fail@.service
> > >  
> > >  # generated crc files
> > > +/libxfs/crc32selftest
> > > +/libxfs/crc32table.h
> > > +/libxfs/gen_crc32table
> > >  /libfrog/crc32selftest
> > >  /libfrog/crc32table.h
> > >  /libfrog/gen_crc32table
> > > +
> > > +# docs
> > > +/man/man8/mkfs.xfs.8
> > > +/man/man8/xfs_scrub_all.8
> > > -- 
> > > 2.44.1
> > > 
> > > 
> > 
> 
> -- 
> - Andrey

-- 
- Andrey

