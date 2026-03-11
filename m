Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BC43B9D8A
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 11:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229252; cv=none; b=VdzIfjAtfMs6VjAqlJbwRM2sxndbjo2R8dkOcfokPPuXfxmdKz2cRTKoVICHz53yd/DcdAIos/hkIZa7vvovBiTouZCdv8bkUauGkZNywthh/gbRXDTz8tTrEJnTCJA469TT7og347uz7i39EFdOwocODIOxY4pbVLL5ZEaqEL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229252; c=relaxed/simple;
	bh=20znycAiWYwgVpDq1AEoFnk1IQDyUcy9AAi5peaAKMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULGt/kjIGH19QHtJkXeEajiySY2M3kq3elOpvEkinuL5dDFJjBqu7ylCHnVL37Y9Bygauul3RLq1Pa+YhLpUwBYJ5o32aXwp86tcETz9oWqh4lSzL23A5CVm9INOvahm6VMHQYHADszSnFBen8HzQMqtVIzkzu528b6ZSfPN+RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a1Qwob/6; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fut8wmbN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a1Qwob/6";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fut8wmbN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773229250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hghvzVba1q/xAQn2tH8MfPNoAAIYmfTOne/cK1QhKyo=;
	b=a1Qwob/6/8qKrB5AGwPUrCU0xyEa19bb+znPpQ2ef7lqYuy9ACv23wdTc52XgaVyeSQDcW
	TGcj0xApLufGVnQso9YFYXVkmhfR3EBVhZtE47cF0zIkT3Jl5sAeCQXvckP0nu2Lbk0yw3
	J6E7bv6jG34hvkNoOPnnY/QAAqvwu54=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-D6Au8kelNRud0qwvzz_XrA-1; Wed, 11 Mar 2026 07:40:47 -0400
X-MC-Unique: D6Au8kelNRud0qwvzz_XrA-1
X-Mimecast-MFC-AGG-ID: D6Au8kelNRud0qwvzz_XrA_1773229246
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4853b0af42aso38077755e9.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 04:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773229246; x=1773834046; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hghvzVba1q/xAQn2tH8MfPNoAAIYmfTOne/cK1QhKyo=;
        b=fut8wmbNXv0G1xxo5yznVsFqUOntF5SqY3o/FFahGl+gHps5y/4bo2Kd9wOjuSGVPg
         kpwLWnpKs+V8aBUxY/UebM76Qir6WONjHkyQAzKTPWIFZo+7B7s7D99KS7gpOIlCZKnq
         4L4BHsImAk/+zpk/n1ddP2vRtPDO1J+mAWcLoK3V3tuww730CGKeElg3COvKy+vZ7bHb
         MnrS+L1FjYt0pBp9nqR+8heWifHfpATMskDp4s55A6HdmQTSktmen4TlafeAmfOEXYFl
         dUuHLUqeKX6QR/G4eSoDQNPRUX0oUglegzBwf1jUITwT9JfHeCjMv28lOl2xuE7Lr721
         edFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773229246; x=1773834046;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hghvzVba1q/xAQn2tH8MfPNoAAIYmfTOne/cK1QhKyo=;
        b=XEmNuprByeqkPJnRjnpqh+4D9PG0wv3ut4NosP/rmPuD6xQKRREIdNIdzb8w+5t7MY
         FUhtZgTMvQmZ4kpT8TJu3B2M/A/KMztaBzB8hBnvTrYVjL8Mka2m5fRTaZ70MCmONsYP
         eRepFg+7UDE1/K8tzzg06upKci4lQW/8CYKoWVzQ0i5fihMDqcJo5M1Zqp8bppME1Ku7
         nfq//2d/M3qupFfAT+1tGD3VsiuCbSvKjtjzhZidHJoa4knaquCu8Y94mLwugikxENvg
         KGZiCz/ratPzVaoIURfJRJ1TGbcG6wMFHeAsvW6hich37CsHCvcr7txzWKhMFrPXD10/
         8ghw==
X-Forwarded-Encrypted: i=1; AJvYcCU1NcI+K/M6Kt0al27BdVeowfOV/HasF/XMMVLn/xaaqtpHTaJ/KO1ZzME3Tp8Ld+GpkaRVPyBrjBk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxTqIiNXo0TV5L4sdw8u2npIhGYZDvgWVN+ZJqO8Vd+u95rRPK
	pwtnUT819NijBfG/DDXI7usP7M0EvuN6RHaDMwooP1oDc8E6nkXlFRASTV0GbjBVqYtGKgpcZQE
	3abG9IbPGhQAXsaXV4dSZIh1udKKh/mJN/+MRtl3G1ZXqz5i3t+4qK3zJstCR
X-Gm-Gg: ATEYQzxk6uf57MO8xllBNsajKnt2aOzhW+BNNtc1X+CLfT4sV6BaeN2DRshgK0au9xF
	sJKPlPdqrWgaBOu/HMChqj2UoLD/ZTdGKDv0GG/ObuSDilGswu6OUgB9D5Rb2WN7HvcLNt0Ntct
	gGPLX87fvlIu96lgVjG8Un3/sysBPdsdd3ExBU0Y0frCEKJVGiGREIHMq25GUjCXT8I9tJIRv/k
	YiRB9sqqMr/+Ag1vtbIqxVyY0p5+TCcM4XTxwbZ1NfHSlJvPfswa7b+PtdOTvyvUH1+iualKB7R
	1CgIu37HZaaCZM6wM8/9KWAevE4PmcQRJkFd7SJ8yaylG0bkUj8NZ4OEdTu4LRRi8NbHovqBaHF
	NXVE8dqAOmDM=
X-Received: by 2002:a05:600c:a08:b0:485:4388:3492 with SMTP id 5b1f17b1804b1-4854b0b2979mr36839615e9.11.1773229246040;
        Wed, 11 Mar 2026 04:40:46 -0700 (PDT)
X-Received: by 2002:a05:600c:a08:b0:485:4388:3492 with SMTP id 5b1f17b1804b1-4854b0b2979mr36839045e9.11.1773229245499;
        Wed, 11 Mar 2026 04:40:45 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439f818d61esm6551972f8f.8.2026.03.11.04.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 04:40:45 -0700 (PDT)
Date: Wed, 11 Mar 2026 12:40:44 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 17/25] xfs: use read ioend for fsverity data
 verification
Message-ID: <bjvosviztvgxswil77pbhw6227y3qss7govt74iyduhfoo7biu@uifmquvn67vj>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-18-aalbersh@kernel.org>
 <20260310012105.GE1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310012105.GE1105363@frogsfrogsfrogs>

On 2026-03-09 18:21:05, Darrick J. Wong wrote:
> >  
> >  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
> > -	if (list_empty(&ip->i_ioend_list))
> > -		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
> > +	if (list_empty(&ip->i_ioend_list)) {
> > +		if (IS_ENABLED(CONFIG_FS_VERITY) && ioend->io_vi &&
> > +		    ioend->io_offset < xfs_fsverity_metadata_offset(ip))
> > +			fsverity_enqueue_verify_work(&ip->i_ioend_work);
> 
> I think the fsverity metadata (merkle tree & descriptor) don't need any
> (read) ioend completion work since all we're doing is reading that into
> the pagecache and eventually fsverity will go look at those contents
> when it wants to verify some actual file data, right?

Yes, metadata don't need any verification. We skip it here and
enqueue only data (this check):

+		    ioend->io_offset < xfs_fsverity_metadata_offset(ip))

The metadata goes through normal read path ioend completion.

-- 
- Andrey

