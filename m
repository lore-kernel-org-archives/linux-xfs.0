Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C1733B97B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 18:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771870342; cv=none; b=f2ZgZbZ1txI0VEzUnPhak4HvtUAXt4mWMdCqjDMPKdZEpOr+iYnQDiB881GbX2xR6mTfZSF4nX20hHXoZpt8bgGuqysVdu3I67kuAYTwcA0DTcz/6cBXDYJN59oxSa7a9yWrgrEPvQ6SsYE9UZvEg5eHVH/ktS8yWT5FvbY+WyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771870342; c=relaxed/simple;
	bh=GpcFfjFqktZkq1PJJFTb0XK2gYmrC40W4g+B7g8ZrDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXSHXqGZf8P7wYRTKBjocZ1joJ+18lcwnpXXdgRTQn5nJcAAW618G+ZTnsfldeHyLErxTWLs/WzFx2cfpNwAW1dqvC6IwMcWJH/bBjnPQH5FuWr5s/BzK3yH8oSAuNPdpmzS5pluBBtJR2c/9GvahwvPG7ixhIVlE5nOoh9UQ2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GZ4YcwBb; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P3ONXnQO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GZ4YcwBb";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P3ONXnQO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771870339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=67lPNWHfQZaorsIQ9wDyrI/yXPhj5APVQRxZORYETQg=;
	b=GZ4YcwBbzdepbQ8hmmFDiL4+Adr9q89TB4wQsRkyjFLlSgnrtETKofUcw5ed/jWZv5Vtsy
	eDzvoiy3AYuaQpmKAxMLKzz1RxFgV2k9RfJpERHFg8ZQGpD/rx7T1Euv+xp/5nt/tv68qX
	bD6q/dNgA+GAGTMbFF6qgQZ9oAl/toY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-_6S-wXFFOs-BKRd6XGgTUQ-1; Mon, 23 Feb 2026 13:12:16 -0500
X-MC-Unique: _6S-wXFFOs-BKRd6XGgTUQ-1
X-Mimecast-MFC-AGG-ID: _6S-wXFFOs-BKRd6XGgTUQ_1771870336
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4806b12ad3fso34568435e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 10:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771870335; x=1772475135; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=67lPNWHfQZaorsIQ9wDyrI/yXPhj5APVQRxZORYETQg=;
        b=P3ONXnQO1BwmhffO8Ck+JxqjnFjukn+1FB69pICgreQgw5H7bTHZ5ehMAfw1oO6HFG
         DBdncL0b+FnYrD1XFX6Z3OBtn4EB7wtRhQ1buzkQQkQ/flMLfiYxBb2i+xm6+UzgUKTI
         hRHBsK22v3VoMsWysiF4yillArVezOPkBJkOvbR7+FG3X1HWaeb6prCTJwigLrPNIAq6
         fWzFGCQNOfQaMSs7iN+bxADFb505I3QhrtRbN1WhoRJBCp4jpuomAKoQpcy1ASNqtvBY
         YLa5Dpk+ON+CihiRQnRyuz+dIZ4dVaFfGqB1ouFhVGpKtMQUuKdWiXe9IsFrYMwFhcY/
         FW8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771870335; x=1772475135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=67lPNWHfQZaorsIQ9wDyrI/yXPhj5APVQRxZORYETQg=;
        b=Tdu1giUMSYTFBaGj0bVwTujUpJYmSo0iyCHpG3XabYmL69POmBBu3TvcSc2ykHs0R5
         fVHeYEvArnum3Y9JhFQC6Ij4kPpAIlA49wL5v8MOntzPWFUubZ4zfyiqm6hau2uXxzrM
         uZZZSP0RIR4ThwhUAnBCPhB1sWh2dzu64PwxdfW0tIxghueYrt9v9JDCBWHuSsDVh34+
         +bSYAJBzQfFNI+ZmylL+xJXqLb6OlA+vKAkLCt1OdI1jdsh1Oakg6R7jUN01tDHNG5Z0
         4h9y/AlVx3AesBrAjDR8V/jDLUBGUDvGLaRkB6o80O/Vis+2k+MXbz+Eids+zTykfywn
         I9nQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgFDS5832FidTRYTFpvP8FUsdCtGp4cUbw2KkBV++Sg6CHy5mWLoxdyouVZDNn3NPuH9VZ3F1lb24=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiKJxptq9xmppVFM8m7jFggC/R2rebod3V40WUkqAYeyV9/lWF
	vmD/KvlSMS4QgAXhq7sC3JLkwjaKeE63QI+oo+Mv30W9PdUgKEGm9dBNjBOX99H1An239dC5xCx
	c7O5JSz4AOuKZQ7njOXiiEyoPbyj3eYLr/Sn8zumYRSfAk+tWHUXNVL9Cx6ql
X-Gm-Gg: AZuq6aKcUBV3wLlfUtbNM27tG6r3F1/Hn2EOzKn5MRgkloJficc5YwUX+sTGypPT+ka
	6CmadFk6byomh5iLi1XkAfWGI+m+tLji9+jVhRH4k2K6Ih2+4+L/3GXSS4rHx8d+WdvRFMwjdMu
	8ud+e8ZZpwxwoaPWJqJM0wlAMVtTp+FLJp8ZJQaaIyc3hm/v0OcjvNlt+mt0ZQIBBAtzWGXT4Q2
	tmztMsZgYFX4wsNDVoVfc0yPCer7yT2t4HskQKY6p2sq2f/rMvoJXwSJVWAMs9JtFNsrTRm4gkb
	YAawIcVEC7M6IunwCjUr8N5mKa+O8u6UKYkxnCZHoeGph1LdM/2YcEvuaC7XyhkGvYkK+ZBLdsc
	X7nRxFmVAhK4=
X-Received: by 2002:a05:600d:6445:20b0:483:abeb:7a5c with SMTP id 5b1f17b1804b1-483abeb7b61mr97766905e9.12.1771870335615;
        Mon, 23 Feb 2026 10:12:15 -0800 (PST)
X-Received: by 2002:a05:600d:6445:20b0:483:abeb:7a5c with SMTP id 5b1f17b1804b1-483abeb7b61mr97766435e9.12.1771870335063;
        Mon, 23 Feb 2026 10:12:15 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a430a33esm113087605e9.32.2026.02.23.10.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 10:12:14 -0800 (PST)
Date: Mon, 23 Feb 2026 19:12:13 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 34/35] xfs: add fsverity traces
Message-ID: <ttfypsjh7cjab5o6wjvfjd4oj36wruigwqdttt35kdvnfptmex@2owry54j747a>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-35-aalbersh@kernel.org>
 <20260219173610.GM6490@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219173610.GM6490@frogsfrogsfrogs>

On 2026-02-19 09:36:10, Darrick J. Wong wrote:
> > +TRACE_EVENT(xfs_fsverity_get_descriptor,
> > +	TP_PROTO(struct xfs_inode *ip),
> > +	TP_ARGS(ip),
> > +	TP_STRUCT__entry(
> > +		__field(dev_t, dev)
> > +		__field(xfs_ino_t, ino)
> > +	),
> > +	TP_fast_assign(
> > +		__entry->dev = VFS_I(ip)->i_sb->s_dev;
> > +		__entry->ino = ip->i_ino;
> > +	),
> > +	TP_printk("dev %d:%d ino 0x%llx",
> > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > +		  __entry->ino)
> > +);
> > +
> > +DECLARE_EVENT_CLASS(xfs_fsverity_class,
> > +	TP_PROTO(struct xfs_inode *ip, u64 pos, unsigned int length),
> 
> I wonder if @length ought to be size_t instead of unsigned int?
> Probably doesn't matter at this point, fsverity isn't going to send huge
> multigigabyte IOs.

I will update it

> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Thanks!

-- 
- Andrey

