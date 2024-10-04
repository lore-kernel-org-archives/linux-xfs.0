Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F3114B94C
	for <linux-xfs@vger.kernel.org>; Fri,  4 Oct 2024 11:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728040147; cv=none; b=lpGcsCPyMCN6kWHmBGYjoELXL9CcWaAV0cfR3rmJo2eq/w4AvbL2mh6I439bYZT4Q6g/PxqqgGXrv1nYFz+Vs1ogGopbUCBOD6CWmsgqrm2iHrskgA+jV4bN4iSlp2AS6If6K+Jtkya8sHhYYk9YDtaRAGjuzXszOV+kcYAJcSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728040147; c=relaxed/simple;
	bh=Im7hS+a9bmuFmPguwuWcWz+SVH+S8ioqsknSf6atxqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fuxvzjn7PBhsZ8QBNkaQ+RmFpMIM63Qtd9dbZ+OjJEEp557/SxnV2+znYH/NMzu1cut1et4C8IW7puQI5KRpNhFtlClrs2v8QryEkqofdSDx9L2fmFaG7+hqpD/58T9Y50JOZEag+huWu98yVn4ANmtBuFFN/0u9BczZo+ThdzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hf+CVNhA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hf+CVNhA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728040144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aHSfT+tHPOx8LCBAypdcHTzDtgrD2sNHRZ9LLPt/lJ8=;
	b=hf+CVNhAuFwmtELOPq4vt+HH5Ux89/M8bA/+gx1UCxnSr1FBNfgiDXsPMQv5Bn2dz3kuIa
	JDzBf75aibYzX8sA+UFR4r7mc72j/Sxymm4JYqqWgLlvPvxh8gzh+3LdFBH1bz9+SIosfF
	mAgsa121q8NO5tDjf4g3EXzDWXXPY7s=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-o9gUOUV5MG6Wt0msT5UB5g-1; Fri, 04 Oct 2024 07:09:01 -0400
X-MC-Unique: o9gUOUV5MG6Wt0msT5UB5g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a8a8d9a2a12so158222866b.3
        for <linux-xfs@vger.kernel.org>; Fri, 04 Oct 2024 04:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728040140; x=1728644940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHSfT+tHPOx8LCBAypdcHTzDtgrD2sNHRZ9LLPt/lJ8=;
        b=fKgfn9jDRqmypyI1dgUntvzApUwJpeJQBJGZePzrpD1PqxMYNtpr5F3NKVx/lC0/94
         bLw8F5sYcnw4BGEj/GX8JOLYH94fDEK9B71TMGxLj5E81ZJYNbg3ldwdTwwg2NlMw5C+
         0Hl29Us6wTQCKaaQH1LzltLiEQTshVQ4T5zoUgOskorQHDmr25n94UiunkJrpIhCZBEU
         s0koYeqFYfXLYjU8oz252jlminRUd2p1geEvHKCDqy5W+0lbhOmMWlfJIvjS7ubnFjof
         /Mo8NFtuwHo/ZDJT2I6nYOJ+ThoK8oDvkfw1PpmCVXW97/n/oLVFtp3ADME8DWEGFRFe
         IjnA==
X-Forwarded-Encrypted: i=1; AJvYcCW9V4vIpaUNv3cu7s9wIMT9fgdzyaQFTuBekMIknOigNIuaCzbxHppnHFgZtNCQrMolrYlgYJ4l9bI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSXOUjJS0IoiaumrEoviha8Td89MMM7D8M6LarS/3DV5MlNXH9
	w1aJje0erS8xHp6+hc9zhTPsYKK/JoSMbtzsdHEhnL/euj0kTO5IReSQRgGr/L8UbO40wYF3UV8
	cOCbG76LnkbY/0jUkW2ulCaRMMhKKW772VT/thNowNuDaZMxV03q4sUNa
X-Received: by 2002:a17:907:d3cf:b0:a86:96ca:7f54 with SMTP id a640c23a62f3a-a991bd4998emr223701866b.21.1728040140020;
        Fri, 04 Oct 2024 04:09:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX01dgDDgI0w+zpeV6fR+5oAiOZ2rA5Lbh7TQBEZXR7Gno2SDfrT8+OJw1FBE8V6aCYB9keg==
X-Received: by 2002:a17:907:d3cf:b0:a86:96ca:7f54 with SMTP id a640c23a62f3a-a991bd4998emr223699666b.21.1728040139636;
        Fri, 04 Oct 2024 04:08:59 -0700 (PDT)
Received: from thinky (ip-217-030-065-002.aim-net.cz. [217.30.65.2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99104c4f17sm210167966b.199.2024.10.04.04.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 04:08:59 -0700 (PDT)
Date: Fri, 4 Oct 2024 13:08:58 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, aalbersh@kernel.org, 
	cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: Re: [PATCH 2/4] xfs_db/mkfs/xfs_repair: port to use
 XFS_ICREATE_UNLINKABLE
Message-ID: <3tpg7lruq7mjnujagq5oujnicqhlgbgtoi257e7l5b5s6w6iyy@n26xmg24z2jq>
References: <172783103027.4038482.10618338363884807798.stgit@frogsfrogsfrogs>
 <172783103061.4038482.13766864255481933120.stgit@frogsfrogsfrogs>
 <ZvzfytE-q1WwJULo@infradead.org>
 <20241002225029.GH21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002225029.GH21853@frogsfrogsfrogs>

On 2024-10-02 15:50:29, Darrick J. Wong wrote:
> On Tue, Oct 01, 2024 at 10:53:14PM -0700, Christoph Hellwig wrote:
> > On Tue, Oct 01, 2024 at 06:25:00PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Source kernel commit: b11b11e3b7a72606cfef527255a9467537bcaaa5
> > 
> > How is this a source kernel commit when it purely touched non-libxfs
> > code?
> 
> scripts gone wild :(

I will drop it then when merging

-- 
- Andrey
> 
> Turns out that editing these free-form commit messages with computer
> programs is a bit fraught.
> 
> > The code changes themselves look good, though:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> --D
> 

