Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA936F8F1
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 11:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785152408; cv=none; b=K37uo1PLpluGkhNvj7WWuX76DUEBDwDQPGej1kxtQ2oHC1eOk6jdynpKOx+CWiSxapdiKghOmlp+MBIA4PNGWKl2YiKXs+lzNdVogAiJBOzBnhH6dsmqD4eF4A2T8wlRLeedL68vEiSsZ+gy5lKzmU4whSCnBkZaLvl7snUhAQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785152408; c=relaxed/simple;
	bh=bi8BA5oS5R3RGDXFaAMjH9VjI7t5/jzE6E9xn3TWcOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iawMaitU3EhETIkNTb3hwihgX8wFdEJChtDSxDybJHvf36e426yp/XhW4ORhZCXiJENKJAYM1MNfP0NOs1F+QO3m03Cc0uQredFta0D+5f4Pm5JwCWbThYWDc9ZbRJjQNLnYPerPQIsQibfoFdLi3NFF6MjYl4JjU1N1Ch4QpuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fl/eAaJb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sCH0xysY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fl/eAaJb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sCH0xysY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785152405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XjT/PIWbG/51hlsr95HE/1iGTwI0BlJqCQFAOLtkIYs=;
	b=Fl/eAaJbLNmn6K3f9B5SxPuJAICi/lgV+d7k+IV9asTpWoFDWA2LPJXvH3LE4CunB22ssP
	mDQerjG6OfvMipxfa1L1hh9jtKo+z+pg+38ynG7x6x00OvyWS+D7AQZlpgPETU5zOIpDZg
	trA+/S9jP9rh6ik7YrCngBdz2D3vR6o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-rxdpx40KMJqpfzjOhDH-bg-1; Mon, 27 Jul 2026 07:40:04 -0400
X-MC-Unique: rxdpx40KMJqpfzjOhDH-bg-1
X-Mimecast-MFC-AGG-ID: rxdpx40KMJqpfzjOhDH-bg_1785152403
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso23004625e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 04:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785152403; x=1785757203; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XjT/PIWbG/51hlsr95HE/1iGTwI0BlJqCQFAOLtkIYs=;
        b=sCH0xysYgEIstUl7aHJV13gWXGcHqK3vteCbmXo+v/y8na5SUTj32Ol4E7VRzya6wD
         6L5WAmI4EVYmHDJFp39XC5FEDKqbLdGtaS1VDaBpGkmSS7O9F4eHITqr4umPc/0ZsH3k
         H7ng5WvdoFhw4U4MEznbW8TzKVCwHKXhH2zjlAC3atFWv9vW4xUA3onvXzckYE7T6kEq
         qSBbvz7GEyCbvm0Mxi9Ut6KNIPQh/l55QvuQlc/rVw2uhg6prR/OIdr9tM9LPlrYOfkW
         a7IH9P5KqayRyS4iw2b0kX6T5a6c3+SmQbtsjvy+KmjzBu377fHj+2GP185CWbJZq56u
         zY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785152403; x=1785757203;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XjT/PIWbG/51hlsr95HE/1iGTwI0BlJqCQFAOLtkIYs=;
        b=Cp6AJOjsN88hfcIrNs0+ad3XiQLd2oH6XuREVvCun5M7Dl4cmSsUn6inv+uVqtPcqT
         rrdZXL+vicUjqliJf9ulYMObpPotzGsyNlS/34Rk1QcclIAQgYHkZbSWwA6P1TsUvQaI
         1kgDdMvATzb39rOOqtNsGNrpJxQ/gIWNL9XN8sAqwTg0sd44fRDTmy9dTHzMeOOTG010
         wwFvoxCviz+7pn0VeHLWeWycSpEpDe1wKjLSrJyID5r21Uv1+FZwBC2eE1nkVXFtUywY
         mrQqyp3T3/rTpZPoPkY82DxvUkUDHIsZU7FiaYkXpbwPFA33h3/tMCA/dO0zJGxq2QlS
         DxLA==
X-Forwarded-Encrypted: i=1; AHgh+RrmzEWiL2+R6ofHBYInhU4UlI1kFyl0C4lWCnakREvPvPunZ8e66pwXFppKU7kik5rIeJ4Kbbb7wDQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRrdrRsYGoQpcxUqAHZAKyxIyDE6TEqBNwidSAPfip/8GU3QpH
	R1G/HziRvIWLb+0g7rXpgPq1WHmL7uIOpyzREDHFzrz9m0dmrZf1vREr3ob0G76iSslvhMfyv8l
	ypDAKHpISccp9EpbI0YEI6bUubFWAFvUIO8Yife7RaycverEZII8iidDkywPk
X-Gm-Gg: AR+sD13dEagspEbue8lhe7tGWzeKy5k/N5Vpi3DwVndorI3P5mfRBNgHWi/xp9oCHkf
	o+Kd6xTvYcGr95Ieen4zTVcpu39XjWZhSCJ2TvncvwGak01PxRUfwOUpAKbYZUzCM6ioVdYonXI
	Ul/fhynoxygK2OPXeA0MJTrZLDAx76emBBQ+yKTfTBKj5UI7GZDO+wTx9i369fbS3adkTanDDcl
	NmWCgnF8Z0ciIHR+pLwpqTc9ooH+EiRNMOU0xNoaM1jjTJisyrcoEm5Y/dYuj7oHb4QgbNfQ9J/
	ftMnQ6hYfXnETtLYfFRDG4dFUTs01dejcjGG25v9XxpfTxz0h7GsYPC15KpprcWHtbAM/zIPa5G
	ELBbMNg+lI9xe04GidQltylWTIrBekF84jCI=
X-Received: by 2002:a05:600c:c87:b0:493:fa66:4861 with SMTP id 5b1f17b1804b1-496b5747df9mr103190395e9.25.1785152402897;
        Mon, 27 Jul 2026 04:40:02 -0700 (PDT)
X-Received: by 2002:a05:600c:c87:b0:493:fa66:4861 with SMTP id 5b1f17b1804b1-496b5747df9mr103189935e9.25.1785152402345;
        Mon, 27 Jul 2026 04:40:02 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b499ccb4sm225617015e9.10.2026.07.27.04.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 04:40:02 -0700 (PDT)
Date: Mon, 27 Jul 2026 13:40:01 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 02/23] fsverity: expose ensure_fsverity_info()
Message-ID: <amcy2KC3veaniXof@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-3-aalbersh@kernel.org>
 <20260724233744.GB1901@sol>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724233744.GB1901@sol>

On 2026-07-24 16:37:44, Eric Biggers wrote:
> On Tue, Jul 21, 2026 at 08:40:39PM +0200, Andrey Albershteyn wrote:
> > +/**
> > + * fsverity_ensure_verity_info() - cache verity info if it's not already cached
> > + * @inode: the inode for which verity info should be cached
> > + *
> > + * Ensure this inode has verity info attached to it, it's assumed the inode
> > + * already has fsverity enabled. Read fsverity descriptor and creates verity
> > + * based on that.
> > + *
> > + * This needs to be called at least once before any of the inode's data
> > + * can be verified (and thus read at all) or the inode's fsverity digest
> > + * retrieved.  fsverity_file_open() calls this already, which handles
> > + * normal file accesses.  If a filesystem does any internal (i.e. not
> > + * associated with a file descriptor) reads of the file's data or
> > + * fsverity digest, it must call this explicitly before doing so.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_ensure_verity_info(struct inode *inode)
> 
> There really should be a note here that if the file is also encrypted,
> then the encryption key has to have been set up first.  This was already
> gotten wrong when it was proposed for overlayfs to call this.

Sure I will add a note.

> Do we also need a more specific contract than "-errno on failure"?  The
> caller in xchk_inode_setup_verity() tries to distinguish between
> "metadata validation errors" and "runtime errors" by checking for a
> bunch of different error codes, and I'm not sure what that means
> exactly.

The scrub checks that if incore fsverity flag is set on the inode
we should be able to read verity info. If metadata is invalid,
"metadata validation error" happens, then scrub will clear fsverity
flag on incore and on-disk inode.

Not sure if this can be improved much, any new error codes won't
trigger scrub. Passing int *corrupted everywhere also doesn't seem
to help and changing everything to EFSCORRUPTED will change
file_open return code.

-- 
- Andrey

