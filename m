Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608B138AC91
	for <linux-xfs@vger.kernel.org>; Thu,  2 Apr 2026 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775138576; cv=none; b=tVx/MuZoFva4AX+mcnvnhev+1RPFVapIykhiEXFGnjzjLzJ1jDmp2KilEdOrEP17CEbZqugpw1ALtj/byTrgrxyxPW3XrKxDXh+v92Vt8bnmlVDc8RC5zsISvHs6d3JYtpH+IzV7c/quME4IAd2Sh47++WrBa25edyP4V+RdR60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775138576; c=relaxed/simple;
	bh=9Fkhm2ZSRSyJHuWQcaBHkcSrvxp8mNJsd/iY+/b2TWE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o1Iz4kcArHbckFOv5JvvU0xzCcibAV4cLAJG+mMhbuojmS+VuMifAJ80H3RchNNvVIDOUoM0HRVIhw6KeB2Zz5DQqtU6PDCW3fQTRbyYbPXz0orlrWq1QBcDkVvvw7IEURldYNneveL9nvygwMX/NBVNwoVabMkMaoBAWA9dcIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VysHaBO7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=k7IL0NJx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VysHaBO7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="k7IL0NJx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775138574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
	b=VysHaBO7HAjwqFdJ9aJjBRJUHwSd9Ak8hSy+RcJo2xHf5cVJkPhA2MJK4E0pElpO86OEKQ
	2yHF7waxuQraMezfV90yGrIWp/gk/7g4KUOowCgEozS8fLhp5yd+vqOJWLmFtl+iKSHQkj
	jTr/XsqW9XviBLR6pdbUVeKSXusHz/0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-1s2Oj6y5OoyW_cNE-EJUPQ-1; Thu, 02 Apr 2026 10:02:52 -0400
X-MC-Unique: 1s2Oj6y5OoyW_cNE-EJUPQ-1
X-Mimecast-MFC-AGG-ID: 1s2Oj6y5OoyW_cNE-EJUPQ_1775138571
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d00dd913cso1220612f8f.1
        for <linux-xfs@vger.kernel.org>; Thu, 02 Apr 2026 07:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775138571; x=1775743371; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
        b=k7IL0NJx5GiJG7TcS+R7guHCiD12IMVscKOKQbcTDmRkvNQt0oOGgbeshheDGgW4na
         23075yP3zTxm0v1iQLJQs+FhFIQlrNxnSUZ+Ls0Am035O1A06QCvS+5edOet999ovDKS
         ravdSWdGEjUVvan4SqeI3gQAmm9NsDuXvu99Li60xHUnbiv57TrRn8xRZyAEHofV/+No
         iDldBDLQ4LNH3antfoz327iFePCugTHpEv2VAFRhargYVfH4u9sK90oAuoQZgaWyvH4i
         AVHBCEbalvo0p6g5ynD4gykJScLw6gtcs9Kesz1sOCK3CQb6dhM7rC2hf82FAYSokJIx
         03fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775138571; x=1775743371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8VJHK7d7kEAfjuBkOl9dg73X5S+EbES2+s86mo3ZVk=;
        b=F/Ebi3++ugNS6kR0+1zsaANSeHgwbYOVWtBiWTS1yy/YnhRVH+OvTP383RN0mQz5Ev
         uYkrYUJO5XNYFcvwzGN7lvJBrPdYehtAZRKDjpRBZk7tlu6k90sae+Ol+4uAEyub9TL/
         8w5kZHn7iJ0xzlTzIw+cDQX+k516HfldXN72kgrZJHOahd6dFT4MjHun3W562uR/LcxQ
         Y/SSexLG8tm95aTz/p5oBQDhOBr4cVfq1Ub3JYx5egsibAxhcfNbkVHza4Z11Ih4NAgu
         3HOZK8fxxn7oGm5e4mUFeQH9QXdPGhlce/A4WdMiw2KAXpvEDXqflYCsiMeJvmsBLnk1
         uGOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNpaeFIR8s1jHSQmqap6vjUcWDUj0aUUhmfmF7GwWMIT25OKz0nrTgqzBE2aDB7KdvzyFnZawbui0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn28XeXRFm+sytyhC0ucLY0uWY4uhROhl/fwS6U49+/wODJTA4
	ZT4hFy3pWdwrQx8Dh2zkU+pO4sm2A6HUuLtYAePLP9+0wzk1nAEMBNmbOeO1YnWMMBRq9OstjpA
	HK3LcQUU7ZiIXvV0UEY7yOb5czpIthd0LkIMcCOG7HbIMEc4l733AR/IVaPlg
X-Gm-Gg: ATEYQzyiZiAThlxCKuVpWJTBq2jF3jDMyjlvD4kaiodGbt2Tu/tA14tgdnQYIHjEFh9
	pZ+KJZUu2cduDGK9jtPJVks93KYR4dFK+6+Fp45r6LQJ8n0jPyNUAc0ifpEg/B033+D7ktBPR3G
	RbSs03HoRW6zC+IH2dexaCfRiNkBaW7VHEsArE3QEqDnILX+/+TmCAQH/mJSMWBZRYEsQyCtB2P
	BDRC8xHvU5yg/mhtEr4PJ93C7LApEQOwk1FN/cCbjwfPTgIs1MxbU3/8aTOtnEBGAUcVAj6hfv0
	dILw/dwsdzVlrSghCa07u4IPMN7c0cweAR749n3tUoJoy5VMujDgv192pmdy5eON1Xvrhq05QlN
	4oYJ1BREljpyybw==
X-Received: by 2002:a05:600c:310d:b0:487:18c:7acf with SMTP id 5b1f17b1804b1-48883599311mr128837385e9.25.1775138570820;
        Thu, 02 Apr 2026 07:02:50 -0700 (PDT)
X-Received: by 2002:a05:600c:310d:b0:487:18c:7acf with SMTP id 5b1f17b1804b1-48883599311mr128836745e9.25.1775138570201;
        Thu, 02 Apr 2026 07:02:50 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4e6224sm8771795f8f.25.2026.04.02.07.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:02:49 -0700 (PDT)
Date: Thu, 2 Apr 2026 16:02:47 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v6 02/22] fsverity: expose ensure_fsverity_info()
Message-ID: <giol5m6uy5ech26k4cnthqicx7qjzbg6kt6mfg7cyrvbrwwcjd@yi53k4epbu3q>
References: <20260331212827.2631020-1-aalbersh@kernel.org>
 <20260331212827.2631020-3-aalbersh@kernel.org>
 <20260401220241.GG2466@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401220241.GG2466@quark>

On 2026-04-01 15:02:41, Eric Biggers wrote:
> On Tue, Mar 31, 2026 at 11:28:03PM +0200, Andrey Albershteyn wrote:
> > This function will be used by XFS's scrub to force fsverity activation,
> > therefore, to read fsverity context.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> 
> > +/**
> > + * fsverity_ensure_verity_info() - create verity info if it's not in memory yet
> > + * @inode: the inode for which verity info should be created
> > + *
> > + * Ensure this inode has verity info attached to it. Read fsverity descriptor
> > + * and creates verity based on that. Inodes opened outside of
> > + * file_operations->open will not have any verity info attached. This
> > + * info is required for any fsverity related operations.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_ensure_verity_info(struct inode *inode);
> 
> As Christoph mentioned, fs/verity/ uses the convention of the kerneldoc
> for functions being above the function definition.
> 
> I think the comment could also be clearer:
> 
> > create verity info if it's not in memory yet
> 
> Maybe "cache verity info if it's not already cached", to avoid potential
> confusion with enabling fsverity on the file.
> 
> > Ensure this inode has verity info attached to it.
> 
> Maybe add: "It's assumed the inode already has fsverity enabled."
> 
> > Inodes opened outside of file_operations->open will not have any
> > verity info attached. This info is required for any fsverity
> > related operations.
> 
> The first sentence could be misinterpreted as saying that this function
> won't do anything in that case.  The second sentence isn't clear what
> counts as "any fsverity related operation".  Also "opened" doesn't seem
> like the right word to use when talking about a filesystem-internal read
> that occurs without a file descriptor having been opened.
> 
> Maybe replace with:
> 
> * This needs to be called at least once before any of the inode's data
> * can be verified (and thus read at all) or the inode's fsverity digest
> * retrieved.  fsverity_file_open() calls this already, which handles
> * normal file accesses.  If a filesystem does any internal (i.e. not
> * associated with a file descriptor) reads of the file's data or
> * fsverity digest, it must call this explicitly before doing so.
> 
> By the way, should there be a patch that converts
> ovl_ensure_verity_loaded() to use this?

sure, I will add a patch on top replacing ovl's function

-- 
- Andrey

