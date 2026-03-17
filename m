Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CC6309DD2
	for <linux-xfs@vger.kernel.org>; Tue, 17 Mar 2026 03:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773719014; cv=none; b=SlMW08K7tegYZJOrnCdY68RCaj0HqgqvKDTQHGXscdsJu7C701RgqbXWBunMo9Q6LYoU2RFzJLHItwF9w4W0Bj4fB3ypSbV/OslUGXamugvSrzPw9fp8akTD4zXO3za8j/oKP7In4cH22t/gMX6WsofOD9toYBFeq8IP17C30/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773719014; c=relaxed/simple;
	bh=Vx2Q3cE2hrN9rjxcQghOvgAp/x/REgJOhJmxH7onb3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQ6qrVJ70VF3DFqwB6B5o6QWh1M/4U5VJSbhQ8evc02xFjAcGInvB/6a0E5Mvf1MLsnmo1JmgqFH8T8fzQkVvC/09k+YPxGzIrt3deBi9Uluntvyv3wU5WGjNpm1AtXXH0xb1UN3PcBFwHF8se5NBfj9X2Z4NL4hAdvMMqtPnLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FQ5MzOqp; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DQDS4l6D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FQ5MzOqp";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DQDS4l6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773719011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4pt5Nu9EhoYKBSrDGYVHAoFMnMCMi4CfpJNnzJddGGA=;
	b=FQ5MzOqpk0jQUGNvI7fGO9FjCoZF7gvnowqBxkJlS+bDtSmo+qf1mEgkUHCscvqbCd7QNA
	+QptVzTZKjZ5D2nL7Kj1Jg1/iYYKNNMsPHtvH8s3PcC8Fxn4DqgHMg9Ufbznj4GXavmy2P
	p+JXlWIVm9CfmIGFiGb9iuHRUgbItVU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-558-LbseZ1IGOo21mxA9O3-Yng-1; Mon, 16 Mar 2026 23:43:29 -0400
X-MC-Unique: LbseZ1IGOo21mxA9O3-Yng-1
X-Mimecast-MFC-AGG-ID: LbseZ1IGOo21mxA9O3-Yng_1773719009
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-829bf6406ecso17967986b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 20:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773719009; x=1774323809; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4pt5Nu9EhoYKBSrDGYVHAoFMnMCMi4CfpJNnzJddGGA=;
        b=DQDS4l6D/1Zdrbc/AzR04c3oRX1MNKm/s+ZQuH/QPIM6onqWul/g5Qz6tMQu73yz42
         y/PV8VHBDp6MJce8zGYF2yJB3bajhr4SolsYnk6qxb7AAqi4znH2b1piqiXgTI/Yi769
         veMJyvCWewL2U6KEeXvAwiKu96zMei7Ivt9QNE89MZydn/gl7mdH9fGAR2pYmB4O/vzK
         Ff6NMFSR9yKIqgv0Pexo94QFxWOSkvvlz0myvc3S0He3x8EC9DB+spb9PEm1YQ1lgdKj
         mHFPd0aa/ktXGHFpiH3ij5JVW2pqw5yxw3iCoRzezgFYMMN+r4qudgPj7Pjl+QBTIhBm
         QzSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773719009; x=1774323809;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4pt5Nu9EhoYKBSrDGYVHAoFMnMCMi4CfpJNnzJddGGA=;
        b=aA/d9chfIhwTycx69FGrZsnMsd9p8/yAlTOEgnDF3C47t+V5tMLma6MtG+k86gL8CN
         m99C6lrvodKup7WUCEN8yFmAAXBO9afUo12/gyUVWYHVHtIlveYLNsAju+Rb8AnIpNBU
         rbLYV9ayDIz/HkZfFe4V5oFQRsR0VT6yQugVNh6juvLpyx0YbW4eQyJDOtN3Ts3datCP
         lRwkpV5vn7w3WenUn+8ZXk/30wVMgs5eA8QnA6ytOeAjCAm5VNbixszq2c//5fUV1Z+v
         Fp0ereY7eSEg0kRk3llgEfsT1nLHqqlYIrOWSG4nlyZFj060JAQeGkzntN8g8SI9KjTS
         FUkA==
X-Forwarded-Encrypted: i=1; AJvYcCXG2WLaFMqb8sRLrfmElEAx226UwRss5MvFQs3EOfhGhJk78BZJ8k/fX57tXBxyFf2m8BO8YvDgkDI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4sLxX3oYj0c65mvWDgv+JOz6UVS7WnZJGHh+ICfzxJAfHKvXY
	HDFkidSI0DcZuBfbt/8b+VGWLMsVUPiklDz60d5Lro1X2sXsZiBcAeQzgAWIBslioZSjPnPoBJi
	NJjU7fi2fDPZm7v/La5M4/lM+QyOuyfJSmNvMQHDVtDWxbphhLL8OD+mqXSbXfg==
X-Gm-Gg: ATEYQzwWDU4+OYgvnRGJtXELH45IzsQenfeYo8yROay1YvCBT72FWRkNkNzBGIi8xbT
	DQFJv/dDMBEYuUUWuOtK7uFvHGNCVPsDX82csmeGiDw+jIowTBaqSgYy8wSJe5wUKnXKLlFWWJr
	NTEH/jFEjb9FF1Qyq97cA/eB/J1Hw4cuDjJBp1/U4Z+Y24g7zNL2wTnJBgHIafDQ5kw1Lr2bUD+
	VXs2LesZlv5qBtZ0IPD3eT0GI0YFi5LXXW1lYxppDvA4w+GjT8uH4AUe0PVH8LJMt0kGIclOCfi
	1wMOHc70eeND6fO7nSb3VmiSMKp/FTZTKbDppinkXFlGtLv7hGqOqpyGOhGli98AUOM0Az1xMVs
	gr1subRsvgAD3UX50mg==
X-Received: by 2002:a05:6a00:988:b0:821:7d7e:41cd with SMTP id d2e1a72fcca58-82a196f533cmr14557395b3a.10.1773719008761;
        Mon, 16 Mar 2026 20:43:28 -0700 (PDT)
X-Received: by 2002:a05:6a00:988:b0:821:7d7e:41cd with SMTP id d2e1a72fcca58-82a196f533cmr14557365b3a.10.1773719008296;
        Mon, 16 Mar 2026 20:43:28 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a072422desm15393628b3a.1.2026.03.16.20.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 20:43:27 -0700 (PDT)
Date: Tue, 17 Mar 2026 11:43:21 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
	fstests@vger.kernel.org, amir73il@gmail.com, gabriel@krisman.be,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
Message-ID: <20260317034321.bk47ojmstastkyne@doltdoltdolt>
References: <177311403420.1186306.10503664469609309721.stgit@frogsfrogsfrogs>
 <177311403440.1186306.11707487947646813883.stgit@frogsfrogsfrogs>
 <abfIexgmKjS1Q7bN@infradead.org>
 <20260316162147.GW1770774@frogsfrogsfrogs>
 <20260316184041.ji5slfx4yvtfwwzq@doltdoltdolt>
 <20260316221658.GO6069@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316221658.GO6069@frogsfrogsfrogs>

On Mon, Mar 16, 2026 at 03:16:58PM -0700, Darrick J. Wong wrote:
> On Tue, Mar 17, 2026 at 02:40:41AM +0800, Zorro Lang wrote:
> > On Mon, Mar 16, 2026 at 09:21:47AM -0700, Darrick J. Wong wrote:
> > > On Mon, Mar 16, 2026 at 02:08:11AM -0700, Christoph Hellwig wrote:
> > > > On Mon, Mar 09, 2026 at 08:50:08PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > Test the fsnotify filesystem error reporting.
> > > > 
> > > > Still would be helpful to explain what is being tested and how and
> > > > the source of the test tool.
> > > 
> > > "Use dmerror to inject a media error for a file's storage, then run some
> > > IO and make sure that fanotify reports the IO errors."
> > > 
> > > (I'm not sure what the process is for updating commit messages once
> > > something's in patches-in-queue...)
> > 
> > patches-in-queue is a scratch branch, I always re-push(-f) to this branch.
> > So please feel free to tell me what do you want to update in this patch
> > (I'm going to make the next fstests release soon:).
> 
> Just the two changes I've mentioned so far in the threads, please.

Sure, I just changed the commit log of this patch to:

  "Use dmerror to inject a media error for a file's storage, then run some
  IO and make sure that fanotify reports the IO errors."

but what's the 2nd change? Did I miss something? ...

> 
> I've more fixes to make to these tests, so I'll send those patches
> shortly.
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > > > +#ifndef FILEID_INO32_GEN
> > > > > +#define FILEID_INO32_GEN	1
> > > > > +#endif
> > > > > +
> > > > > +#ifndef FILEID_INVALID
> > > > > +#define	FILEID_INVALID		0xff
> > > > > +#endif
> > > > > +
> > > > > +static void print_fh(struct file_handle *fh)
> > > > > +{
> > > > > +	int i;
> > > > > +	uint32_t *h = (uint32_t *) fh->f_handle;
> > > > > +
> > > > > +	printf("\tfh: ");
> > > > > +	for (i = 0; i < fh->handle_bytes; i++)
> > > > > +		printf("%hhx", fh->f_handle[i]);
> > > > > +	printf("\n");
> > > > > +
> > > > > +	printf("\tdecoded fh: ");
> > > > > +	if (fh->handle_type == FILEID_INO32_GEN)
> > > > > +		printf("inode=%u gen=%u\n", h[0], h[1]);
> > > > > +	else if (fh->handle_type == FILEID_INVALID && !fh->handle_bytes)
> > > > > +		printf("Type %d (Superblock error)\n", fh->handle_type);
> > > > > +	else
> > > > > +		printf("Type %d (Unknown)\n", fh->handle_type);
> > > > 
> > > > 
> > > > Isn't this always going to print unknown for normal xfs mounts without
> > > > inode32?
> > > 
> > > Yes, though generic/791 filters out the file handle and (TBH) I don't
> > > really want people getting ideas about cracking file handles.  Probably
> > > we should just eliminate this whole part of the function, but that would
> > > make future forklift upgrades from the kernel harder.

... This looks like not a certain decision/change. Is this the 2nd change you want
to do? If so, could you please provide what's the specific changes you want to make :)

Thanks,
Zorro

> > > 
> > > --D
> > > 
> > 
> 

