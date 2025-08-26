Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA3239573
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 11:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207425; cv=none; b=jrNkZxMVwlGzx4K8sscoWHQW5KiZ9qznsV15u4vIztjSFz3UtKiZ31aBjp/JjbbALSzHtpD2L4ed/kTG3o/y1HbPUwcWJPnjQIv5l2TrCZmmFWAZO2usY6fYfuaXG8u5TfPIKAz8w7PqDEoFqUSW82xMbJpqdcs+sq+sY68cqE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207425; c=relaxed/simple;
	bh=oPb769DMR6Gdpu06rp1sqS3Bvmgst7y0I87FQEBgMHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sd62AH+9DBcukFo5DgRUlW2mId05XcWx1RArgNVfKdbt0ZJEnJEizhW+WLP6ThC/hCqCAS7/AKJWrd3W6azMP3uw7H8nZoUJXk0d4ZzNdl3BKxs/PjLsA63OGt6vmkw6j5oz0AnW/Wf2eTM9c55QNwVNl2c/R8UAkOOTg/tJA98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gpLrTNVa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gpLrTNVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756207423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bnbduMHAbkm/gOQS6pM4pXFiw9E4hBVUffnsKhNAj8I=;
	b=gpLrTNVa8p+3T1oPoGCXgwwWuIWMBE2OZHYyEninRWXm58miF5oTk0DqOaM+o05bTgAjeR
	sdHQOTGrK4EENNIhLD22HtrP1jwo6pDVAqNtjUqp7np606ygLX1GMhm7nnrGkd4+TAd8au
	s5FOAUrC6XMlEAhdkP5jBwRMXyErq10=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-t4FsFajiOZCq0i_fvaY6pg-1; Tue, 26 Aug 2025 07:23:41 -0400
X-MC-Unique: t4FsFajiOZCq0i_fvaY6pg-1
X-Mimecast-MFC-AGG-ID: t4FsFajiOZCq0i_fvaY6pg_1756207420
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b0d0feaso39465405e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 04:23:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756207420; x=1756812220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnbduMHAbkm/gOQS6pM4pXFiw9E4hBVUffnsKhNAj8I=;
        b=OuawdGZN0QZhwoK/7IPglNdtA0qCzjEfC0yxvzHnMn3ADXlgswDvDd/QbTm+nJEoyR
         pBPrZILtrHPIw37rrPzqa9XNP0Xw7pSMyn7vuXh5sJPMaZet6kYiFetWJ/qa5mxQc3C3
         rL1vTeuVser7chX2/fn9WA/GlvuQIBMVt/J5W1DOeWgXFkfNzU0FcgG6BmKlpDfOz1Rv
         EfjQMeSoi5eNbEAr0V1HZDleLbAbLL34Pv4WrdtShnxZAn6IjYQbrwc4akDuNPSLY6Mc
         R9XzciVWaT9kun/T0hIXVHwvguePTlJn0GnCQzU8PlVtbOHNSBi0K8PEDRwPYaVKdjmy
         kv7A==
X-Forwarded-Encrypted: i=1; AJvYcCWcZCgHjZk1Jtg/t0/h5rHrXZttRQKCJeg9VD9wdPUwnBrskW6zNrxWCUMYmGA3CetlXwwgeSzbvTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDYwCcXsLm2eiZRO87msj84CEtx5lCW8oSYEmH97oEkxkJO9PL
	plVfMmVGDbjcF5qYl+s1Dca3ILKdhjItUhtq+P+cgOBviFbro8iageswJvrCYxWfCIPvggY1IrT
	HFKgKDBWl+KMoDL9DNGfLfLQpzDhYS6iUSct30joCphpmnAVBBrkjPUpJ3DXc
X-Gm-Gg: ASbGncuM/XS0PWPXbVXLQNF2AiK5uJw3AR8KSP6Sr+F8qTjC8FIKi65j12pzOJJxOoi
	aGzmeWswkROwlesfV5/dRQ5JQSScCbc6WFhXD8SBgT92ZBjFK5YgFgNHQXrTKxGqYW16I5E+I6W
	JQkbWPAYPPZ9pNqzuKjqap3Tdt+oZ3IJz2yEbNjK4xUqPbYedcSzkS+4t5SFxfTdgIiOEb13Wxu
	c4qdDez/ZggTE4XEXkFHD92rNunXZKOE9utDts3x0OCO3bMo1WfAgSZRgsCVsZnyYhaDaMdhR8U
	0Oosqdcz+WvJ8Jc3DTaIWCOh7nu/xTc=
X-Received: by 2002:a05:6000:22c4:b0:3b8:d2d1:5bfc with SMTP id ffacd0b85a97d-3c5dcdfed86mr10020115f8f.37.1756207419896;
        Tue, 26 Aug 2025 04:23:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGMPod6H6RlNtm/0B+ZVEkXQ6cPqMAmzET9SiUA/vD4cdgPNkd2LLrJ5my2cSfrSrHaJkcK/Q==
X-Received: by 2002:a05:6000:22c4:b0:3b8:d2d1:5bfc with SMTP id ffacd0b85a97d-3c5dcdfed86mr10020090f8f.37.1756207419442;
        Tue, 26 Aug 2025 04:23:39 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ea81d38sm16316374f8f.17.2025.08.26.04.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 04:23:39 -0700 (PDT)
Date: Tue, 26 Aug 2025 13:23:37 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, 
	Chandan Babu R <chandanbabu@kernel.org>, Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Yearly maintainership rotation?
Message-ID: <zlstwhiavf25jsmzlcutrbredgsplfbtqoihomljukqlelkwk2@ibrgmljxocwy>
References: <Pd4KqICHYbjm5ZYOHBmgSRgs-uKNopGdeI4ARGEXr12t8ZnKctQMdfVRNceZbMeFFKncvIv9_fKyKoMCmCiLfg==@protonmail.internalid>
 <20250819225400.GB7965@frogsfrogsfrogs>
 <7svscwa3oy5oxavscjgapcvr7lbumsntu32fq7uhmrfqr6pino@7awm4hxzzqzb>
 <20250820152552.GD7965@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820152552.GD7965@frogsfrogsfrogs>

On 2025-08-20 08:25:52, Darrick J. Wong wrote:
> On Wed, Aug 20, 2025 at 10:07:02AM +0200, Carlos Maiolino wrote:
> > On Tue, Aug 19, 2025 at 03:54:00PM -0700, Darrick J. Wong wrote:
> > > Hi everyone,
> > > 
> > > Now that it's nearly September again, what do you all think about
> > > rotating release managers?  Chandan has told me that he'd be willing to
> > > step into maintaining upstream xfsprogs; what do the rest of you think
> > > about that?
> > > 
> > > Also, does anyone want to tackle fstests? :D
> > 
> > Considering you were specific about xfxsprogs and fstests, I believe
> > you excluded kernel on purpose, but anyway, from my side I'm pretty ok
> > with how things are now, and I'd rather keep it as-is, specially because
> > I'm enjoying the role :-)
> 
> I specifically mentioned xfsprogs because Chandan volunteered, and
> fstests because Zorro has been maintaining that for a very long time.
> 
> It's fine if everyone wants to keep going as they are now, but positive
> re-affirmation once a year feels (to a longtime maintainer like me,
> anyway) like a face-saving way to give people an offramp if they decide
> to take it.  IOWs, I think it best to help the maintainers avoid
> burnout.

Thanks!

So far, I'm also good with continuing to maintain xfsprogs :)

> 
> > Of course I'm talking about my side and my workload only, I don't speak
> > for Andrey or Zorro.
> 
> <nod> No rush, you all have plenty of time to give things a good
> thinking through. :)
> 
> --D
> 
> > Carlos
> > 
> > > 
> > > --D
> > > 
> > 
> 

-- 
- Andrey

