Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE83E0220
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 18:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773686456; cv=none; b=ofOCrnNnQQ4LLN6FCXapyf/ZCapZ+5DOXv+hw+8WJ42CO2FF0e/3uRYvxwNV2iiZR5slvRPGZKuDZv1wItPiz70WXRfmzmkjKehrKLElfBJ5esLibmc/zJKyUXWFub5HxSZZ4a9VOA6styFog+aASAyeHEaprOW2GSpppqCWwNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773686456; c=relaxed/simple;
	bh=QidtBix1KZQxoTs2FPcZqmT6gEHQJGYZjnLMkHeIxbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qTmE0wlV1IPEACAGHFx5nuWOiX8pLXCJuViLQF2uN4qipqcrIf5AQv6xtEA5ixm6GkbrZzJ7Xj7J6J4QOHghY5fABWTnhg4RXl0vZNS+9brlTV7MwDHVT2QVgH1/lUKJDo4u88L5yU9XQIhugawF6jzNqMjF9QGIk7YtV8nI7RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d2xpHAyV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ltoKmtNx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d2xpHAyV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ltoKmtNx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773686450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zg8GjY3hLi9qO5yTJ9QjTKSpRjIDRv4OW1ON0/sXxR4=;
	b=d2xpHAyVUsby87Aojz1iZS+fGVWDUcv4XGPM2Dr+igd1d9xUfvYGihdWVBaZq+fbrCBIXC
	syiPj6ZgU2x9BYY7iHNThKN/oiDIy4PRKvVklfBlNnfdHlWZusepIycDIgmdC168BrEet5
	/CeJlk84qxRiiBz5WHUsv+a7s6JcTgY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-LJROpjfVMSGz3i0ZN1rcbw-1; Mon, 16 Mar 2026 14:40:49 -0400
X-MC-Unique: LJROpjfVMSGz3i0ZN1rcbw-1
X-Mimecast-MFC-AGG-ID: LJROpjfVMSGz3i0ZN1rcbw_1773686448
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35ba4bf54beso1075893a91.1
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 11:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773686448; x=1774291248; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg8GjY3hLi9qO5yTJ9QjTKSpRjIDRv4OW1ON0/sXxR4=;
        b=ltoKmtNxV9EH7Haj1s2C2U37IlsiDPgpRmtZtM8fDAKOLvD+VfkTwtW4cphR6M1I1H
         IMOTNcKP4kesXOcgYi7JiH0IIeYxshktUkfZBetZZSO7s37bUwNBs0Pb/0Z66URUMEZt
         O992Zxxgr6tM/IhEOVZhuayDrhjZk2RhfKWO6zDd88K2Mh85Z/QoxKTzgsWwalv60ecQ
         53Xb5NRZ0HQLwUFRXC2D063+e7GIpOp2PVat5m5dNkjx5oX5pgFoIHduA3GbqS3nGKo6
         uQxbAZ5i93ksb10N+hyTvRIueRk9/em/hkQLmn3hAo27geHRYBB+YjxeRZTP6HMy/8Jm
         6YSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773686448; x=1774291248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zg8GjY3hLi9qO5yTJ9QjTKSpRjIDRv4OW1ON0/sXxR4=;
        b=TBynoSFcy1PCUZvN8WaJOMJLTdGhGUWAdSTjFgxDQeJilQW+sU4N8xuThYdgRAxtlf
         54vA1bOW9K+58b3WWmex0WrCiVbNL0zgenAKa9AFyC9MH1xvT/mcEJc/z1pOtrx4j2Z7
         ZhlLjcTmuFn9Sr+8xn1Ix7fSbo+hFXF/tK8nirnTlTfm81d/1Oz/b+jAFYUe2Qq2UuRV
         ctFJj+Y672qKxlVqq3+Tdw9Wq6XPacksDvYJ0W2otPfyR02VdEXoVsrs9UWtu0K2W/F7
         Hn8flro1zD/T+S1eFZvb42trmFJXYtAyU+vi3VzkLOabib0ZaZ1C3U6pTh1K7m5JCQki
         vnCw==
X-Forwarded-Encrypted: i=1; AJvYcCU/LjV082HveHY8Wd3cFnQ5CpfMQGvgzZbW+m+3lN/h5YoCCQIWsqIwr+2Ve0IQ5OTX5in6HYmaD8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMDGLMCy4xPL7GyfvNvvnLpRW5VkVUUxNxDKbneoTN2HVkeZvv
	K/I/lSZLkmkzlw74rNZ6pECd9GT6UGWnJ8D3Psb7cQGP+PoOCmwwd3NW9ww0Gzd6QW1uWj0y5x6
	NrvsTiEBkThVXmbkqkbJhMQpuodvmoLC+pSUhlUNYg98d31Oe98UEx69LU2ZGEA==
X-Gm-Gg: ATEYQzxSOfVWlh7hwzp8JJXPRIPgT6544CuNJ2/PgPH6hGyhLcLC1+yvsd6E5zu2Ktx
	nibkh8GTPjhtESUDQHcvJCtzSWStjrIlch9yiL/CO9JlCsMiZTsaEUltQoJy140viqWrgODNXAp
	/D8kDT2XQwQxCSPPUN9H3UevTBpU+efrY8VWLv0h+vhs4flr02c9ma0JZic+q6rDxG5qYBXeQVa
	l0B/b5fjet5SP0f6VDJTIJDiMD952aj/Qm87y8XRcz2Gf5HPpihOL/HNsZ59txtDH7hfYoaCuCY
	Ma2kAFokBE/pcFe5Znn+eX1xAnOJ/c3bUankvhmOrzj4GXmM3Ij/tr1P+ykIGlYe0NHb5CHUQAr
	SPiZIFqen4fFzvTQz1w==
X-Received: by 2002:a17:90b:4b05:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-35a21efd272mr11767653a91.1.1773686447988;
        Mon, 16 Mar 2026 11:40:47 -0700 (PDT)
X-Received: by 2002:a17:90b:4b05:b0:34a:b8e0:dd64 with SMTP id 98e67ed59e1d1-35a21efd272mr11767629a91.1.1773686447508;
        Mon, 16 Mar 2026 11:40:47 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bada2bfdbsm363654a91.3.2026.03.16.11.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 11:40:47 -0700 (PDT)
Date: Tue, 17 Mar 2026 02:40:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	fstests@vger.kernel.org, amir73il@gmail.com, gabriel@krisman.be,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260316184041.ji5slfx4yvtfwwzq@doltdoltdolt>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
 <abfIexgmKjS1Q7bN@infradead.org>
 <20260316162147.GW1770774@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316162147.GW1770774@frogsfrogsfrogs>

On Mon, Mar 16, 2026 at 09:21:47AM -0700, Darrick J. Wong wrote:
> On Mon, Mar 16, 2026 at 02:08:11AM -0700, Christoph Hellwig wrote:
> > On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Test the fsnotify filesystem error reporting.
> > 
> > Still would be helpful to explain what is being tested and how and
> > the source of the test tool.
> 
> "Use dmerror to inject a media error for a file's storage, then run some
> IO and make sure that fanotify reports the IO errors."
> 
> (I'm not sure what the process is for updating commit messages once
> something's in patches-in-queue...)

patches-in-queue is a scratch branch, I always re-push(-f) to this branch.
So please feel free to tell me what do you want to update in this patch
(I'm going to make the next fstests release soon:).

Thanks,
Zorro

> 
> > > +#ifndef FILEID_INO32_GEN
> > > +#define FILEID_INO32_GEN	1
> > > +#endif
> > > +
> > > +#ifndef FILEID_INVALID
> > > +#define	FILEID_INVALID		0xff
> > > +#endif
> > > +
> > > +static void print_fh(struct file_handle *fh)
> > > +{
> > > +	int i;
> > > +	uint32_t *h = (uint32_t *) fh->f_handle;
> > > +
> > > +	printf("\tfh: ");
> > > +	for (i = 0; i < fh->handle_bytes; i++)
> > > +		printf("%hhx", fh->f_handle[i]);
> > > +	printf("\n");
> > > +
> > > +	printf("\tdecoded fh: ");
> > > +	if (fh->handle_type == FILEID_INO32_GEN)
> > > +		printf("inode=%u gen=%u\n", h[0], h[1]);
> > > +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> > > +		printf("Type %d (Superblock error)\n", fh->handle_type);
> > > +	else
> > > +		printf("Type %d (Unknown)\n", fh->handle_type);
> > 
> > 
> > Isn't this always going to print unknown for normal xfs mounts without
> > inode32?
> 
> Yes, though generic/791 filters out the file handle and (TBH) I don't
> really want people getting ideas about cracking file handles.  Probably
> we should just eliminate this whole part of the function, but that would
> make future forklift upgrades from the kernel harder.
> 
> --D
> 

