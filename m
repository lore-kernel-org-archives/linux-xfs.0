Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C161C1751
	for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727453654; cv=none; b=eSVJqsgVNqlw0cMacGW961VBzNGvgL20cwO8H5GGVq4TNa1WA4qjDS+9Q7J3RD34sS4GOhQ93u+rzN0FDh2ntZOcKcqJUBWzyYfOGVIn0+kDELLyaHlM/gAtAXAdfvUD0hVvymnNcd1dj6asrDUKZT12edAEIsEGphmLM/R11/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727453654; c=relaxed/simple;
	bh=s9n6u44xh/Fpg1SEjrv5YE1qXpF3+UEbFf6WxKkzOXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LTZmhou3ZOJuwEDh5qHcCpQx0TfkRNdvCvS14PKFio77K1NRiTiTGnQLvu2QEWYCgNHhHcLRSuY8yYuppKFhceIxaDMs6Zb60Jln4cH1nA7/Mid6QYSPD7BCb/BZn/T09Jwjmscgdm2ZEWoQl2x4zENHlnZFDzGD09wSzJ6WuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=itNWA/Uw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="itNWA/Uw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727453651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZTAhWdJWdTyMW375G+ds66cbfpJ3BDKI7V2tKVC7tnc=;
	b=itNWA/UwmJyZ+15Yao/z6lWVBKuF5bi1m7SIJGB6DsIDPnCLnV0W8ciOmsV0RmGHsrLxSK
	msiJkzMQl46jYUVC6C0EFGDzXgN9p+TOlPMVCSp1R322N8oJpS6Ywdhh9ptwXXylcYXk03
	mQLtq4V5KCkp5L9ql6/fCiDkybJLkw4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-bgsW9qptPNW9A0FL7FsjPg-1; Fri, 27 Sep 2024 12:14:10 -0400
X-MC-Unique: bgsW9qptPNW9A0FL7FsjPg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-37cccd94a69so1124674f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 27 Sep 2024 09:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727453649; x=1728058449;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZTAhWdJWdTyMW375G+ds66cbfpJ3BDKI7V2tKVC7tnc=;
        b=s/Gn5wyuMe3cao/zdIkeRW5VvFHPcW4JhkGAuZ4p5OoTXwy/9dsJnL0RfkLZQLKzpe
         LdaY25mzH+LvT2XNq3/x65/+VQbBLT94HCVJWrdK54RLLI/7RXjD4LwDXQ9sN9dggUYu
         cq0/IS1sgfeNu7QvyJlLcuvdpQYB4qKfA1DNrwQ4DksyNx30dtHXC82ozktw7YQxacVy
         ZDwhhTl+GdnO5qrLcrC4F8Ep54YS8Rv003+cxC+nDZN5ukYtkBIP6O2nWghsCiK/zc7D
         Pt4IQ9TfmsRPvMGGB7uACSezH0/uQiX5XiTgYRJ1bWY/cfrbM7Unx6bQ1VNot+QCZCHi
         0RuA==
X-Gm-Message-State: AOJu0YxICSgpSgLv4r1IUSOWzXroYTMbhrY4xFy7gpsrnBHTWfgM9M9K
	Jymgr7b7+4PxlAVE5u3PQfbRKZaVRqjveW2aQAKYwWejKvQn4lQuWTL1avyQ/6FYAuDI5Pqyzai
	OIlOIGJitma2er5t5KTrkstKi+X7avsHjsqYRxPmMqGiiRPsmoiVgPvTg
X-Received: by 2002:a05:6000:1201:b0:37c:d4f8:3f2e with SMTP id ffacd0b85a97d-37cd5b1dda4mr2581644f8f.55.1727453648970;
        Fri, 27 Sep 2024 09:14:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF6XuEoiUUgGgQm6V9iumJEeC+vVLa7TT3YZgm5YG5j8jUO1fjvI0BZcdrs3v/zHZGbNex2Ew==
X-Received: by 2002:a05:6000:1201:b0:37c:d4f8:3f2e with SMTP id ffacd0b85a97d-37cd5b1dda4mr2581620f8f.55.1727453648525;
        Fri, 27 Sep 2024 09:14:08 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd564d33dsm2944845f8f.19.2024.09.27.09.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2024 09:14:08 -0700 (PDT)
Date: Fri, 27 Sep 2024 18:14:07 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, aalbersh@kernel.org
Subject: Re: Re: [PATCH 2/2] xfsprogs: update gitignore
Message-ID: <p4gdx35xc2sgq3tr6nactej4z7wzvjqvuugk4enmliv3ahzjkm@ainycq2bavht>
References: <20240927134142.200642-2-aalbersh@redhat.com>
 <20240927134142.200642-4-aalbersh@redhat.com>
 <20240927152035.GL21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927152035.GL21853@frogsfrogsfrogs>

On 2024-09-27 08:20:35, Darrick J. Wong wrote:
> On Fri, Sep 27, 2024 at 03:41:43PM +0200, Andrey Albershteyn wrote:
> > Building xfsprogs seems to produce many build artifacts which are
> > not tracked by git. Ignore them.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > ---
> >  .gitignore | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index fd131b6fde52..26a7339add42 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -33,6 +33,7 @@
> >  /config.status
> >  /config.sub
> >  /configure
> > +/configure~
> >  
> >  # libtool
> >  /libtool
> > @@ -73,9 +74,20 @@ cscope.*
> >  /scrub/xfs_scrub_all
> >  /scrub/xfs_scrub_all.cron
> >  /scrub/xfs_scrub_all.service
> > +/scrub/xfs_scrub_all_fail.service
> > +/scrub/xfs_scrub_fail
> >  /scrub/xfs_scrub_fail@.service
> > +/scrub/xfs_scrub_media@.service
> > +/scrub/xfs_scrub_media_fail@.service
> 
> /me wonders if *.service/*.cron should be a wildcard to match
> scrub/Makefile's LDIRT definition.

yeah, can be a wildcard

> 
> >  # generated crc files
> > +/libxfs/crc32selftest
> > +/libxfs/crc32table.h
> > +/libxfs/gen_crc32table
> 
> This all moved to libfrog in 2018, how is it still building in libxfs?

hah yup, that was there from building a n years old master, dropping
this

> 
> >  /libfrog/crc32selftest
> >  /libfrog/crc32table.h
> >  /libfrog/gen_crc32table
> > +
> > +# docs
> > +/man/man8/mkfs.xfs.8
> > +/man/man8/xfs_scrub_all.8
> 
> Looks good.
> 
> --D
> 
> > -- 
> > 2.44.1
> > 
> > 
> 

-- 
- Andrey

