Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09AA286D64
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769533190; cv=none; b=CKnLzI2HeyUGVWTileX7I/gSdEl58wZmL4atazko4SjTlSwNzd1isZ+Kb8/c4wwtzLoGKt8Di1tJbOTANydPA/r8tVtZqIxy4Yr/5JPHvpM5brp07xbB/I70bMGlGATvU9TYsfLxWQWaLD4O/JeC/tCV9jka1poV+jv+JXjGVAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769533190; c=relaxed/simple;
	bh=tRjxCix2MiY/QNZqxfT7bftqGwkDjbhnjEivCo29l3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJa9ZRwMoVe39s1Foy1oWLkAjd/0pWQzDO/fhJTvBT80XnZjeYcoXE0dmtPbJxP8soXdEk1z8DaK2w9Nrlr8dt7T6NfAEiOoVpenPZx/wpnbmYVZH6NHgAZ8u9fgWlUbcKFVumufQ06Z58x4qcOxwxz9R6pxA7Q53AQHbD9PuAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M/1HiAOI; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=q6vAp+RS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/1HiAOI";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="q6vAp+RS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769533188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ9nTEpRSEuoeHEuCVCPIQ0a89tYgEGP7rGR/WMmz6U=;
	b=M/1HiAOIA6AuTTK0z+UaP2YGKOZejbb0P2TfIK1Jwy+QE3PKMpD7rtlrX3XlVsSCjFIzfm
	7qHef7PyvWZhPupDySwMo18hQuLrYKPSHOywIbiudWd1EXalI4pSc//d+SVr356MjCCGBu
	vBEMLd1WSTXOeS6+8aIZiIt+MrNIZxs=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-pKFJCXjGN8Gp4LdcvENqhg-1; Tue, 27 Jan 2026 11:59:47 -0500
X-MC-Unique: pKFJCXjGN8Gp4LdcvENqhg-1
X-Mimecast-MFC-AGG-ID: pKFJCXjGN8Gp4LdcvENqhg_1769533186
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4806a27aa31so7024035e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 08:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769533186; x=1770137986; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ9nTEpRSEuoeHEuCVCPIQ0a89tYgEGP7rGR/WMmz6U=;
        b=q6vAp+RSybUWI5r4c/E4/1JYW3YCr0ANlM24Q0dMV1bSuNTO2P6HGZeV0rsolkd89I
         9f5/cTNdLF9wm8YooS7BQD5yDhl7QPQ42lzAosDOfC47YUo1LPlDOZOUd8NvL8eblTd6
         x3EHabX3lu3m67y2eIJmDuRS/DGsf5WgUZyHQT7LzivkAj/IFSAlZM3JJzDxIu2w7dFu
         fX8v6leOR6YsEcekep4Xfj+A1x5vect36mrRUuEC05PUQwI7w1+IMNTO4kh4ocJGMpGw
         gS5GXBxCq0eMfNTwsi9g1BcgQD5tRs7ehzz/EPAwfhjrwROaUdwwOIvnTItCExTahDd8
         TCpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769533186; x=1770137986;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pZ9nTEpRSEuoeHEuCVCPIQ0a89tYgEGP7rGR/WMmz6U=;
        b=wXu4jFiCtwfzePjxmDcuWw4lBNZ7XNp7Py0O9EVWqUAR6ALCc2X2/rCIncjh9wm+u5
         up5PnY/mtYoHiL0PKQWpsdyv1PyvlQlEIRoBspU741hcxb/dK/3CNyyUFpc6lO75lE47
         SF80oOAaaslXQH/Zifpdd+MpWPKgEQPqLCfZ2ktjNKo1x6QdTpQc4Ucp9nMPQnji8Efs
         dG2BLVSpyFWVNJpDaeZ3jk/pGHewTjGIA9IqQliromBP2Yf3Ae/grO5Z/FuU6tDQnfXB
         MVsKu4/U8jI1fJSSngEvXVxiYg5JUEDqhwcunNX6GHs6B7YExW8TEEfLIL7ozybx0f1v
         IYnA==
X-Forwarded-Encrypted: i=1; AJvYcCWG7pnnkPWxpreA1n8Y0kiRJtPfb1K2zOqGJ1HhTgFm6rM2UroIIvKxiMiN2A2QaYMzBQAHO8Vfpjg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9cRjZCu625efAsAOVrCqc18yzYScmglwDyz/RuPM9H8Am6cwi
	tOpZOvT13195Aw/hQiqJFA/8aTT/8ni68s+RGpCaJkFikYBsX/L7zvpOYjV9zE+Fu9XIvBH7/OR
	H3YAjjsSNfkQupcmd8KlnGfaTPpP/47wLYh1eoAwW/isxIAL4smtzmosfepPn
X-Gm-Gg: AZuq6aIUElD73k5akrrU6eJA/F4RPFY544xAFbdO6Cs6Y4+w+w3yOhEdg6V0jbLSlbR
	oN6U5UXVdIOkRryzdjBCa4G4zJN75upFz5L3XXLcajel16egbbqrYPbxqzh8g5CdTelIz3CddC1
	55fSTIcbrv6EDu7B3wkJn3Jbfk+9mA9Xoa6wYiXy1ehkyr7uqM4AT1UeNyA5eGivFAGELaaFwVr
	5rSeX/txzXya4mEVd7Bfl7UYfCQdI+4Ti9kB2h6eqbTf+nF00aOrtD6rely5e/5gyrbUDXW5tFs
	UDF+rPqPjleudyO54BGXwBCbgwE6iqqkCt5L7V58Ba1JnNyCxlVGarbyA13OLv9ojhNZjlO6xOg
	=
X-Received: by 2002:a05:600c:3e16:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-48069c6012bmr30026525e9.29.1769533185991;
        Tue, 27 Jan 2026 08:59:45 -0800 (PST)
X-Received: by 2002:a05:600c:3e16:b0:47e:e87f:4bba with SMTP id 5b1f17b1804b1-48069c6012bmr30026165e9.29.1769533185437;
        Tue, 27 Jan 2026 08:59:45 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e4757sm147576f8f.5.2026.01.27.08.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 08:59:45 -0800 (PST)
Date: Tue, 27 Jan 2026 17:59:14 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	dlemoal@kernel.org
Subject: Re: [PATCH] libfrog: adjust header order for BLK_ZONE_COND_ACTIVE
 #ifndef check
Message-ID: <5oruatch45s6qsurqnzaxhn37ycnunmhj5w5fswgohujzd42ve@ls4bk3fadtub>
References: <20260121064924.GA11068@lst.de>
 <20260127163934.871422-1-aalbersh@kernel.org>
 <20260127164309.GB8761@lst.de>
 <h65l5eiu73bnc5odsswjmay5vyhn4mjvetinpxxtiw4nykvocg@3eiiix3pb66c>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h65l5eiu73bnc5odsswjmay5vyhn4mjvetinpxxtiw4nykvocg@3eiiix3pb66c>

On 2026-01-27 17:55:32, Andrey Albershteyn wrote:
> On 2026-01-27 17:43:09, Christoph Hellwig wrote:
> > On Tue, Jan 27, 2026 at 05:39:29PM +0100, Andrey Albershteyn wrote:
> > > This is because of the order of #ifndef (in platform_defs.h) and #define
> > > (in blkzoned.h). The platform_defs.h defines BLK_ZONE_COND_ACTIVE first
> > > and this causes enum to fail and macro being redefined. Fix this by
> > > including libfrog/zones.h first, which includes blkzoned.h. Add stdint.h for
> > > uint64_t in xfrog_report_zones().
> > 
> > Thanks, this looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> > 
> > please order this before the cached zone reporting series, or fold it in
> 
> I will apply it first

hmm, actually there's no this header to apply fix to, can you resend
it with this fix applied?

-- 
- Andrey

