Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358C935B63C
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769532969; cv=none; b=jSi1iRYP8979JwRH3gjxEDzk4a91zlW4OvKKuCMAXra074glOscnzoIJxnrH0q0vVophV+0lc01issZo3walFeSrBjY+BrGQggY5EhtIuoCuZri2hLLva+Ef6dnEIO/B99E69jwpbzPBTZ2Qdlm3/cFQ3/55LfaFGtVR4Q1Ogu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769532969; c=relaxed/simple;
	bh=DO+kbJEKo0y1jgVDMsgQcZqLLbE7EgF2TGpCgb36DTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lpID861FdJAfY7hYw384SztvLcGTGb4BR1Pv1Lb2IuyDGig4wFC/EGvx/ZHIi3yiuON/ri+EKA/tNV41J/BqAHEzmNMNlZu5BVkuPP5zLhAp9BnoghhWVN9bYC6FhusQ3FiyuvW3ZDyfZ6hidl9fZaD6OrdIWcBhS6NyI1HCTnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dpzRIc+B; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6ApWIsm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dpzRIc+B";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6ApWIsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769532967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MNA73357dJddsb5Npx49+uuyQeAyauu+Oh40Xg3wLqU=;
	b=dpzRIc+B7orCoxV30OwJ8qBMMrmC1pLdAIC1vt99celqNwiwqcIXzXMHs6TE8dd/8wjWbU
	pRoRjTCH68AhhcL4166RDa96XbIoqY1lUrzVXC+QP9MfttuMHz/sEY0b1OWhcAGn3ihAK9
	ZP2EFnFzIRSGD8JXGWmRaYYfGhV5zpY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-0KvPvVkqMy65yvswkWIjng-1; Tue, 27 Jan 2026 11:56:05 -0500
X-MC-Unique: 0KvPvVkqMy65yvswkWIjng-1
X-Mimecast-MFC-AGG-ID: 0KvPvVkqMy65yvswkWIjng_1769532965
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-435ab907109so2766764f8f.3
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 08:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769532964; x=1770137764; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MNA73357dJddsb5Npx49+uuyQeAyauu+Oh40Xg3wLqU=;
        b=L6ApWIsmHG9YSAsUpdxwAqHURVZhk0Efg+g777+PVNcwJuK19C2CdD5cn7rgj1YT/Z
         8+SUsDrKX2Idp8t3ACgnL9tA6yn64sbE+FwcqoPE4nbx+aUsgBWZAjljUT5sokEIutR0
         HTlpha5XG9m+5ZTFdYBm2XZN5KDy3ok1ntLVAmzOeaXYJ4jONRhWx9Ai6PJ4jGz9X1ZH
         ikEslITnWF3Q09P6prOWKp5ztiTFRPvgr6SAxhvvkxSBAyoSRwkH5et0rR2RWLcsdKRO
         3Wa6izaOm7rblMw9RdoL0NEZxZhdmHm8b+y72ZGrigkbHQOUsD6nGnHc4my2HL5ptOpb
         wQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769532964; x=1770137764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNA73357dJddsb5Npx49+uuyQeAyauu+Oh40Xg3wLqU=;
        b=F34WWHFfpXXt9dgebTALI6bByZbjYajWtkVwhADS96ySwwtPD9UcncQSUCSPMJsgEv
         O5n/vw3brKIwQt33y12++H8sv/jZQC2971YvwMlkf160w3d6xFH3YBTpllfHuyeA3POg
         xpodf2PAKpw5K8+BgtY9RQD2nDpsmodAROwqB7LE8zHF2okzvctiCvE9KMkI13z0UVKZ
         1FZgKitsrVgnHa6LY0YcsG1LS4ZY+0ZCnPEuZC32Oun5GEW+cD4f/cUFOsxDaQ88E/Sq
         9OeisTtazgg3kHxgRvVFVEZmZwG37Fijo2QlsNOyueQ0IiAJenp1Jq8SKbhl8EffauvQ
         dsGg==
X-Forwarded-Encrypted: i=1; AJvYcCUWOtzc5R9kRLqPde3IS3jK6gdAAaZKCFa7FjMKnQlOO1qrWOs8RRf5x+FU5dFJUYfY2FG7OcED310=@vger.kernel.org
X-Gm-Message-State: AOJu0YwrGRWYPyQ4G4MZn4rodwnFcdRPsvSNrEsvwiwhYMFhgB3Q7ge+
	874ypRFGqywAuDXrVM7bGrtY2F/9qXKbn61I2kuH9eaXgIfjrh3jHsljLkygyJ6Cwcome3CkhgP
	jnf6pZ2koweWdp5GFmzy/j2Dda6eu9bu/IW6UR+Jv1UClGNC9H5Q6i6XDSBoybloPDt2F
X-Gm-Gg: AZuq6aKoGyD2ows3OEyp4bc/PJZYLxSJt9MHh6rjAmkhWkbI8tRE1vI52NoboSePL/q
	yjI7auFvUkLknHzg3LRAow5nqnRvfjcgg4Ogd+FG19LLMiiVpbXcw6kL+OWpW//Fz1U4FwkwLEq
	TGFz5wbPQeExB9XsaEpyBR8WHurbKPFwg18RnDuUjyv4Wba8lbJuq1b6doxGjnmBExkX0H1Aoxc
	J192NNc94bpoHD0O9Y9uA5SMY5O237INQepkv3DECymZ3EpF6zzEMATD+HL1oXhlLYMKOmcPWbV
	3CJ2DIjuWy0ZuYv+FuKDJ2+tAouQ8faLJgBbRHWJI1oLnuN5jGSS1QO8iid8OGfCL5eNJl+o2Pw
	=
X-Received: by 2002:a05:6000:2481:b0:435:aecf:9674 with SMTP id ffacd0b85a97d-435dd1bcdd2mr3050046f8f.55.1769532964407;
        Tue, 27 Jan 2026 08:56:04 -0800 (PST)
X-Received: by 2002:a05:6000:2481:b0:435:aecf:9674 with SMTP id ffacd0b85a97d-435dd1bcdd2mr3050010f8f.55.1769532963879;
        Tue, 27 Jan 2026 08:56:03 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10ee057sm89608f8f.15.2026.01.27.08.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 08:56:03 -0800 (PST)
Date: Tue, 27 Jan 2026 17:55:32 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	dlemoal@kernel.org
Subject: Re: [PATCH] libfrog: adjust header order for BLK_ZONE_COND_ACTIVE
 #ifndef check
Message-ID: <h65l5eiu73bnc5odsswjmay5vyhn4mjvetinpxxtiw4nykvocg@3eiiix3pb66c>
References: <20260121064924.GA11068@lst.de>
 <20260127163934.871422-1-aalbersh@kernel.org>
 <20260127164309.GB8761@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127164309.GB8761@lst.de>

On 2026-01-27 17:43:09, Christoph Hellwig wrote:
> On Tue, Jan 27, 2026 at 05:39:29PM +0100, Andrey Albershteyn wrote:
> > This is because of the order of #ifndef (in platform_defs.h) and #define
> > (in blkzoned.h). The platform_defs.h defines BLK_ZONE_COND_ACTIVE first
> > and this causes enum to fail and macro being redefined. Fix this by
> > including libfrog/zones.h first, which includes blkzoned.h. Add stdint.h for
> > uint64_t in xfrog_report_zones().
> 
> Thanks, this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

> 
> please order this before the cached zone reporting series, or fold it in

I will apply it first

-- 
- Andrey

