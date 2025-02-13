Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B91E19DF61
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 22:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739485635; cv=none; b=PNXBYL0NeM9GSSS4rnbPXkTMqwuJoiIfnC28o6WbA4T8pdDcn6QPcikwKG2BJswLWxmjY8eXMv2RqjgHnb518Ki9M7ykDt38/Mlib4eN5VqQOxuWko63ls/6qaMq+FJJkePf0QwwLOmpVQ/RCHc5kvvM2XLOwi6K4Psd2ibEkFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739485635; c=relaxed/simple;
	bh=mPMd4Df4AEqF0bsWWMuX9j7Gu/e4Falf0GXCM60hoSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I0xdxsYOEVkrNkgrx05kynOBLam/sCuHxAykyhHwCv9XbazJ5PpuywXNXz55fgSSZTH2yQrWdhnmjPnkvJ+UVMObBV+p09SrCVgUqIQguvpnE59aV5qcmqgO/oYKtXpuyxzbhlI79BlzpXnaKDInXTj3MoLJD2dN6fuiYOLIJD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AAgtLIbz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AAgtLIbz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739485632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9KSrI6Csl64WLmSHeUMW4B2EeOwa/3+V/peYpzGzslw=;
	b=AAgtLIbzfv9lFzTdbUrvyj05Lfy4aHwp0FfYYAQz2GT/bnP8zP4CEeDryEJwjfPfcdSeqX
	/4uosY9XUb40GySt/GtkvK5AxVxbWX1WADWTRt/MQMIndJWibcs76jJonlIUPxk1w4tA3P
	S5CBeJ6wAru/FxUObZwsRqjWtR3zANs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-hc5OTJQ4P2WJgUSZ4CObsw-1; Thu, 13 Feb 2025 17:27:11 -0500
X-MC-Unique: hc5OTJQ4P2WJgUSZ4CObsw-1
X-Mimecast-MFC-AGG-ID: hc5OTJQ4P2WJgUSZ4CObsw_1739485630
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-5ded3946ff9so1262468a12.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 14:27:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739485630; x=1740090430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KSrI6Csl64WLmSHeUMW4B2EeOwa/3+V/peYpzGzslw=;
        b=UDpkO2F/fM1PPjWsiLwoTT2Ih/jqlukX42uJF/tpJxAwUDY+WU6JlBBq90JRKrf7PC
         OAGYlz3dCSWqOsZLeebv/xdH4CKVeEzwXHtjig86xm/l0wFz1U7+geLcyaFPy6JOR23z
         K6MDl3fIo8PjMeUZdYAA5yC1abVgOb4y1zgYJqn+M2aur7+Wo+k78HjoTktUaeYTnjkf
         05h2LCT91zOH5F5o4bsU2BpKiO5FgIWz+DP7V2Gq4oI3Mrz877FWgUNt8YTpZG6bhdfo
         unqCBc57i8U3+MA48mO2AtB5RXijTdJiJZFvoFqbAvi2GjWlNIgbwLFab/dqsCti/hb7
         +DEg==
X-Gm-Message-State: AOJu0Yw2t4pFqUvhq9sGETFmWmXYFdf3WZ8CZDrxgHRxNG/SZBM3KJ5h
	CMZV8/KJY8Ktz3bbA19Cs98hURvgXnjcq9iG7qViP2+Jhta4/yW1vnAcm9+T7DsirW8QZrG50EZ
	kf+Tzd1jVhuLWaesOZ6la82yxxUVqcFWJMu0xwJDs9bKsGoiIuXRriSuf
X-Gm-Gg: ASbGnct/kwTrTzoh2b/asCieKZ4snf+Ttvmmy6hpQIyixZigayLEon8SFXvRBINKd9y
	94M4rngL1s+hx+fVLetfkZJ3BCHJq33m+UPVuqBir689YY7Arlz/bRkBwOU9+xgbcEoqfKtUxSz
	ECN/EZ1KCMKM/L2f6r9Obe87wVruGMsrUDzQsXtFAFWhNC0qqXyXvxLzPu67/WMg15kJvKWYZBB
	X/xar55uFMBjhs5Abx09nggkshKngFhnapWkIE6ayxeiOgOV20fK1wT05QoUNvIvWPraQ3ImFEL
	yG9hEYJsIf8LURAk5l+4Go5g
X-Received: by 2002:a17:906:d542:b0:ab7:85a4:fb01 with SMTP id a640c23a62f3a-ab7f3391afemr954832566b.16.1739485629765;
        Thu, 13 Feb 2025 14:27:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCQcl2dcOQV15Y/pvWNErjC+1zbQ6U1eJjbVWl/svaK4Id6VkROsHjXJD//7+inuBTMZs29w==
X-Received: by 2002:a17:906:d542:b0:ab7:85a4:fb01 with SMTP id a640c23a62f3a-ab7f3391afemr954831566b.16.1739485629368;
        Thu, 13 Feb 2025 14:27:09 -0800 (PST)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba53398364sm211585466b.128.2025.02.13.14.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 14:27:08 -0800 (PST)
Date: Thu, 13 Feb 2025 23:27:06 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 09/10] libxfs-apply: drop Cc: to stable release list
Message-ID: <2yzj7wrqodq7d5tt6mcj2yrplgf3kwt34ewl2y3rpcizan4gzb@rj6b2agkbhre>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-9-c06883a8bbd6@kernel.org>
 <20250213214541.GQ21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213214541.GQ21808@frogsfrogsfrogs>

On 2025-02-13 13:45:41, Darrick J. Wong wrote:
> On Thu, Feb 13, 2025 at 09:14:31PM +0100, Andrey Albershteyn wrote:
> > These Cc: tags are intended for kernel commits which need to be
> > backported to stable kernels. Maintainers of stable kernel aren't
> > interested in xfsprogs syncs.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  tools/libxfs-apply | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/tools/libxfs-apply b/tools/libxfs-apply
> > index 097a695f942bb832c2fb1456a0fd8c28c025d1a6..e9672e572d23af296dccfe6499eda9b909f44afd 100755
> > --- a/tools/libxfs-apply
> > +++ b/tools/libxfs-apply
> > @@ -254,6 +254,7 @@ fixup_header_format()
> >  		}
> >  		/^Date:/ { date_seen=1; next }
> >  		/^difflib/ { next }
> > +		/[Cc]{2}: <?stable@vger.kernel.org>?.*/ { next }
> 
> You might want to ignore the angle brackets, because some people do:

The ? does that :) One or zero of <>

> 
> Cc: stable@vger.kernel.org
> 
> which is valid rfc822 even if SubmittingPatches says not to do that.
> Annoyingly, other parts of the documentation lay that out as an example.
> 
> 		/[Cc]{2}:.*stable@vger.kernel.org/ { next }
> 
> <shrug>
> 
> --D
> 
> >  
> >  		// {
> >  			if (date_seen == 0)
> > 
> > -- 
> > 2.47.2
> > 
> > 
> 

-- 
- Andrey

