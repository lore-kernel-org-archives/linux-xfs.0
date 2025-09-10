Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB323054E4
	for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 06:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757484447; cv=none; b=Ly/3TEL5ZHA26dbwsmfxxAzl9iGOGDeC06iMHYqUh9PMB+vRtm96sQ+xiVB4ix1KstDEdON6nb0EkMtQx6Ek/nPxUlKD/CmQ5I43Z3P7H+0WDYTMEWGyffFK/IzfTSRXDTMx1PBjwlQCKzbg2Qi1WpCADj6gN1JEbh8zcTwiG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757484447; c=relaxed/simple;
	bh=gbYCNoVCr2sz/dvmF3FJfLnJEFurD2LkE3QO/MJ+M9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YgyYwD4rSIHXbzYf9Z0zyX9f5umFng+9XbAUaFMzPht9it+NV6C2djM5b8BXjRLUChMyOifwQt7dkP7L5JeNIhpDS5IKL1vsqehNkFSohSYJl+D2q2AE+tXq//rbvup6C6dZkjdlZMkkw7RR5SDA/XI+O+8MX1H+pg5MCexag6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OjHxuDyr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OjHxuDyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757484444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mWiGzTdHTTRflbkk77kHOQXZWch1zMY1MtxXB+Kyuw=;
	b=OjHxuDyrG5eZrTFYx+Cpk2FXyK7s2kn8rXF/uS+X6EHhgNzGQCS79kpFZRKZEtmLufXQYK
	UyvSSLNK4doYs9L0+8M8M2Ndd2EARNKZrlUCvOaAJzEXCYj0Og4q8TvcfhZP67kZ9V0KCs
	/CMemZ/6KhIiT7Ih/AU0daagSMikyD4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-qdyZKAc4O-mGGvAu3Kt6Gw-1; Wed, 10 Sep 2025 02:07:22 -0400
X-MC-Unique: qdyZKAc4O-mGGvAu3Kt6Gw-1
X-Mimecast-MFC-AGG-ID: qdyZKAc4O-mGGvAu3Kt6Gw_1757484442
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-24458345f5dso90311955ad.3
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 23:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757484441; x=1758089241;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+mWiGzTdHTTRflbkk77kHOQXZWch1zMY1MtxXB+Kyuw=;
        b=QK/xJr4KcjMuglSWt9EUK3LLAup3H3lQvpuppbrG95MsxHM0MYaLdySBMpDpLYXUDh
         0LY/Hd0KVXRK+H6cAKhXkiSy3htbBCfRFhh2ljYomfq+JJvhCX7muo5G3/oJJUEuFShN
         ofokLQz11LNEPcZMjKZeGGOUZU21dqR8uhwDCRcLJ66v6aPnTVbVP3uVwxl9KRjnY3l5
         G5r5tc0V2TnaFCKaqNf49BiSfDAo4MRTx3rdct8/CaMgjIUKbgLRTgcH6zmxpgNrmQn9
         x9xxnrY39ZxuYlnqrgdFfsB4U7qvGR/OFcBNU5/t7SDbA3bSarzoAv7PHaKAe3S6baDT
         fZJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpcNK2vrvpRUg4CtuQltjpyaoe8PEhvlA5Xg19kiVTh67517E/kaYS7Zp0usRN3D/nOX5XYGZH0j4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa2FavDO+KYabjdj7KzYAWbnnwBhqFPQJYch3pT8q4HSxIEAPV
	lGjQK2USng16T9XAZwDEhe7yOK1VTGYdvHVAcNkC8pKoY+MeCjYv4ICj0C0W3+6lrvtoi2Ak+mU
	VsRfE3qCxPZzt2ZJT9uFPVbwbvcC6L6IC7WsoJmOQQ/kiThTDhLZ6b3AhJ8OeGw==
X-Gm-Gg: ASbGncv9/JLQzhTVu6CvCONAczDvxkR6wDaTLBo9CLUu12+vg91qOzcxCKsE7cNOLHE
	Iw2QItI21JOOVR9mDboyehBwHQxU8iSIn0goy0uC4sDU8rtIy8nxB3CE6uMwBQiscQwm8niapRV
	jKMm17r5pA0ZVen+fdDKsov2BbHS2Kuf62aAoNRoviePzKLlP9JYq0JftJPC8XzpH4EyOW6+Zjc
	DpNxLsBIZiPhFBd5KkhdrrAOAOziITMnP3LdAXRYGuFqPRXIk5/TPvhK2VsJVPRlSEoFFhqgkK8
	Bx3/rSqYOht4lPC4w66frAs9wPmzCACLOni/1rgWYPD7Nvx/jbnJqMtXQx0SQIUfguHRHHIPyJz
	fY0xx
X-Received: by 2002:a17:902:d4cc:b0:24e:af92:70c2 with SMTP id d9443c01a7336-2516f240f23mr198910925ad.24.1757484441650;
        Tue, 09 Sep 2025 23:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1bGkKYcod7Z34ZVF7GZWSfh7v+1OYk2L6fq8uiER3IOseuf+HFEJpoxMGlGVvkQFgYlzxIA==
X-Received: by 2002:a17:902:d4cc:b0:24e:af92:70c2 with SMTP id d9443c01a7336-2516f240f23mr198910585ad.24.1757484441124;
        Tue, 09 Sep 2025 23:07:21 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25a2742590csm16198215ad.8.2025.09.09.23.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 23:07:20 -0700 (PDT)
Date: Wed, 10 Sep 2025 14:07:15 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: John Garry <john.g.garry@oracle.com>, fstests@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>, djwong@kernel.org,
	tytso@mit.edu, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 02/12] common/rc: Add _require_fio_version helper
Message-ID: <20250910060715.gc2thcbklvhzaxz2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1755849134.git.ojaswin@linux.ibm.com>
 <955d47b2534d9236adbd2bbd13598bbd1da8fc04.1755849134.git.ojaswin@linux.ibm.com>
 <1b12c0d9-b564-4e57-b1a5-359e2e538e9c@oracle.com>
 <20250907052943.4r3eod6bdb2up63p@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <aL_US3g7BFpRccQE@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <08438a13-6be7-4be3-a102-35a1f6fec9a5@oracle.com>
 <aL_tLHcWyFPShrUc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aL_tLHcWyFPShrUc@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>

On Tue, Sep 09, 2025 at 02:32:36PM +0530, Ojaswin Mujoo wrote:
> On Tue, Sep 09, 2025 at 08:26:52AM +0100, John Garry wrote:
> > On 09/09/2025 08:16, Ojaswin Mujoo wrote:
> > > > > This requires the user to know the version which corresponds to the feature.
> > > > > Is that how things are done for other such utilities and their versions vs
> > > > > features?
> > > > > 
> > > > > I was going to suggest exporting something like
> > > > > _require_fio_atomic_writes(), and _require_fio_atomic_writes() calls
> > > > > _require_fio_version() to check the version.
> > > > (Sorry, I made a half reply in my last email)
> > > > 
> > > > This looks better than only using _require_fio_version. But the nature is still
> > > > checking fio version. If we don't have a better idea to check if fio really
> > > > support atomic writes, the _require_fio_version is still needed.
> > > > Or we rename it to "__require_fio_version" (one more "_"), to mark it's
> > > > not recommended using directly. But that looks a bit like a trick 😂
> > > > 
> > > > Thanks,
> > > > Zorro
> > > Hey Zorro, I agree with your points that version might not be the best
> > > indicator esp for downstream software, but at this point I'm unsure
> > > what's the workaround.

Hi Ojaswin, I don't have better workaround than require_fio_version for now. I mean:
1) name _require_fio_version as __require_fio_version, to mark it's an internal function
   of another common function.
2) only call __require_fio_version in _require_fio_atomic_writes for now, don't use it
   in any test cases directly.

> > > 
> > > One thing that comes to mind is to let fio do the atomic write and use
> > > the tracepoints to confirm if RWF_ATOMIC was passed, but that adds a lot
> > > of dependency on tracing framework being present (im unsure if something
> > > like this is used somewhere in xfstests before). Further it's messy to
> > > figure out that out of all the IO fio command will do, which one to
> > > check for RWF_ATOMIC.
> > > 
> > > It can be done I suppose but is this sort of complexity something we
> > > want to add is the question. Or do we just go ahead with the version
> > > check.
> > 
> > I think that just checking the version is fine for this specific feature.
> > But I still also think that versioning should be hidden from the end user,
> > i.e. we should provide a helper like _require_fio_atomic_writes
> 
> Sure, I'm okay. @Zorro, does that sound okay to you?

Sure, that's what I tried to say as above, sorry if I made you misunderstand :)

Thanks,
Zorro

> > 
> > thanks,
> > John
> 

