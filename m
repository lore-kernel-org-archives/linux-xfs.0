Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F4421E08D
	for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744743396; cv=none; b=kvOI1f6edGlfWARUwnImwydyitQxavvHNf5qA+trYk1jZWYeyLs42/wgoWRxX/3QMCVFDIoaOuh8OzoZSwjfZKjx3JkGeMWLNz0+sanjf9EoWF97xJZAhxHEcvRmvnpiIrbeJVyjnKFOXwWTf5LV5f/g5WAKCBxMYk7WIRUyEr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744743396; c=relaxed/simple;
	bh=tNaMBb4xJiUf2l4ogX/SyLcXUDrHLvagFj+AB3544Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVwC2OyOgQrkbk+6HFzKWJVwmsAadxjAX2MUf51iTXimeLgHrfJb3mFPyrJAV493WajRpXBugyYgyLJSrnorvBqthG3XPjzddGypqJHlWUYB2x1ciyg3CrHGJm377oiJdtIBjYdUXAnpyGFqHRtWZ4LfSkn0ajHuluzuPwmoIE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kl/w7rhr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kl/w7rhr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744743393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q6HYmxddXOb2OtpGfSLiP1eqhFWxU464sJHZtyN3seg=;
	b=Kl/w7rhr6HbxQr7aAcunx/+Wp+xHkmhZ/KlxFZ5cBimR+yg40NFSTt5B149V17Q7QHYi6g
	wvIWurnK8WNwIUSuVvJ6a0zWoOenH5FXNqbZ/gPPh+eVWFHOTVLXZUU67QwzXZnoa2cFmi
	UQ9vhQIWuIyvSr2HLmth7GrHXSs8GVg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-lTlCarqIPwC6bjoggd4yUg-1; Tue, 15 Apr 2025 14:56:32 -0400
X-MC-Unique: lTlCarqIPwC6bjoggd4yUg-1
X-Mimecast-MFC-AGG-ID: lTlCarqIPwC6bjoggd4yUg_1744743392
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4767e6b4596so107295641cf.2
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 11:56:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744743391; x=1745348191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6HYmxddXOb2OtpGfSLiP1eqhFWxU464sJHZtyN3seg=;
        b=UpG5UHlyeRmU8MZEBsv5tC9zZqtH7/t2v7+7amH4yy55s761MY5htH3DlZB8l2JxSm
         RW9NAov1lEyiJioIhN9zYP8HISY+dLv8aoO6R5r9LGg6Ts4czv44kuohvBOKJVlgXYaJ
         7Oe8/kI1IH0g0sL/BahzX3O1tJaFueZl2dim7VDhPODSbiVv2K0cJ6PIPSg0YVNAThOn
         GFpg54SmnAwg4pMeBoEB5NU3yFrsAAbp5ghIFt5Ufvz0tcho+gWdwtVpBJhKa16eyKyY
         DX5KgjCLI0xg6VVUi2dM8Pasesz3i7miIx8OYyqY7r0KazOLVNCGN/ogrc1cmpMvRwpy
         /0RA==
X-Forwarded-Encrypted: i=1; AJvYcCXmYHx47Ll7HXMvYuSniEXeMxzPA4uGbHAMng2fCOAb8Hg4CAuRHNJK1S3Z/hbny/wuml/VE1bWiEI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+QHp64mjJLnCTw56KSwPUWMh3TcocL2ToM/oucYbYxqOxjEfe
	hl2FRhRLrY7Sf85jXIPFKvep+mM5eRSkCG9n/z5QGbyBqCzEq2PBCJ2V54NLWOFLj3TPGF72GpZ
	3iHTWf5A7FB93SS4+kGLQpK0RoM5lpmQ57B+6GZtapILblnSJSk1Ry2US16Cs5Aff8w==
X-Gm-Gg: ASbGncsqcG1krQDbVNW2kmQmPMPdlPGFqneHHkNxWKY/bDvdLIT/T1FQP0df6brrYk1
	baMBcc2xX3YhR5EJxPT1ddldwBNZAmXcMT4dYV0vNXa+TaRzashMHa/BW7EJxbCLxP14LttSHve
	sf7sj2wKYohcYHJVKLIB0NqM3SfAkHa1IiAeoCs47a5QppUuykTiCJfMecuSpiHOX8O6AV6S2I7
	51Itr+L2g9V4XLbS/lTry6LZdS/3Y+ULHG6PQ5fL8IfEbmp9gCrFh1SDmVDQ6yNdrI8V5nm5DQA
	vDMv2PykqQfzjdzuswPb54FHJ2GY/ndTCtsaBMY/QL21
X-Received: by 2002:a05:622a:1820:b0:476:add4:d2c9 with SMTP id d75a77b69052e-47ad39fe7aamr7326311cf.8.1744743391226;
        Tue, 15 Apr 2025 11:56:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEe8pFdzPxZvwsovZlJSk0yokoNctRuRKIHX0ik2MpH4ieYkz0l9uCCtY+XCZDDL1BC4z4oGw==
X-Received: by 2002:a05:622a:1820:b0:476:add4:d2c9 with SMTP id d75a77b69052e-47ad39fe7aamr7326091cf.8.1744743390870;
        Tue, 15 Apr 2025 11:56:30 -0700 (PDT)
Received: from redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4796eb2bb15sm98549851cf.40.2025.04.15.11.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 11:56:30 -0700 (PDT)
Date: Tue, 15 Apr 2025 13:56:28 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "user.mail" <sandeen@redhat.com>, linux-xfs@vger.kernel.org,
	aalbersh@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfs_repair: Bump link count if longform_dir2_rebuild
 yields shortform dir
Message-ID: <Z_6r3B0gZQw3NUw8@redhat.com>
References: <20250415180923.264941-1-sandeen@redhat.com>
 <Z_6kCAHGNoSnPc27@redhat.com>
 <b894a2f0-db12-4eef-aa6a-c14756fe812b@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b894a2f0-db12-4eef-aa6a-c14756fe812b@sandeen.net>

On Tue, Apr 15, 2025 at 01:44:25PM -0500, Eric Sandeen wrote:
> On 4/15/25 1:23 PM, Bill O'Donnell wrote:
> > On Tue, Apr 15, 2025 at 01:09:23PM -0500, user.mail wrote:
> >> From: Eric Sandeen <sandeen@redhat.com>
> >>
> >> If longform_dir2_rebuild() has so few entries in *hashtab that it results
> >> in a short form directory, bump the link count manually as shortform
> >> directories have no explicit "." entry.
> >>
> >> Without this, repair will end with i.e.:
> >>
> >> resetting inode 131 nlinks from 2 to 1
> >>
> >> in this case, because it thinks this directory inode only has 1 link
> >> discovered, and then a 2nd repair will fix it:
> >>
> >> resetting inode 131 nlinks from 1 to 2
> >>
> >> because shortform_dir2_entry_check() explicitly adds the extra ref when
> >> the (newly-created)shortform directory is checked:
> >>
> >>         /*
> >>          * no '.' entry in shortform dirs, just bump up ref count by 1
> >>          * '..' was already (or will be) accounted for and checked when
> >>          * the directory is reached or will be taken care of when the
> >>          * directory is moved to orphanage.
> >>          */
> >>         add_inode_ref(current_irec, current_ino_offset);
> >>
> >> Avoid this by adding the extra ref if we convert from longform to
> >> shortform.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> Signed-off-by: user.mail <sandeen@redhat.com>
> >> ---
> > 
> > I was about to send a v3 of my patch to handle this (fix link counts
> > update...) based on djwong's review. This looks cleaner. Thanks!
> 
> This is related to, but independent of, your patch (see my self-reply).
> Please continue to fix your case, so that all entries do not end up in
> lost+found when the header is bad.

Ah, right. Looks good still ;)

Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> 
> Thanks,
> -Eric
> 
> > Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > 
> >>  repair/phase6.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/repair/phase6.c b/repair/phase6.c
> >> index dbc090a5..8804278a 100644
> >> --- a/repair/phase6.c
> >> +++ b/repair/phase6.c
> >> @@ -1392,6 +1392,13 @@ _("name create failed in ino %" PRIu64 " (%d)\n"), ino, error);
> >>  _("name create failed (%d) during rebuild\n"), error);
> >>  	}
> >>  
> >> +	/*
> >> +	 * If we added too few entries to retain longform, add the extra
> >> +	 * ref for . as this is now a shortform directory.
> >> +	 */
> >> +	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
> >> +		add_inode_ref(irec, ino_offset);
> >> +
> >>  	return;
> >>  
> >>  out_bmap_cancel:
> >> -- 
> >> 2.49.0
> >>
> > 
> > 
> 

