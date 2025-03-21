Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22ECC1EE019
	for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 20:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742589408; cv=none; b=hwdbeh/i6P0hH1uxEC0qlRAyKYXMD9gLCSv4o/Wbz7+frilnzPzFxR4DyNR31/RkA2zXy7kSngO2ZP8mux9U83awI47F3ppDSnS/UV7+ELNvQ5g2MUWWgwzqqUxxs/FM44LaBlaczlEfx1xS8Cno7aqCnLIJC76WTyyKf6PI1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742589408; c=relaxed/simple;
	bh=ZG2NhjyO1Ygi6DkqYp8GAFMYlFWqoOjwFp+0BkUTX2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahtWTcFmE8+R6j746zzmqzHom4gCVdbmWB10S3liSuzF9pfDK0+/wzwfd1y5Cam4LptRCE33LjhD+DC8kNvvLiwTmhI/4smLMOghOfAqsp0MrEId+tvW13bXnIJsBKJ4jcuu4QJ3WQdOjvskSaI2gyDkUQkL5BIHFPsyrt+x6+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IYIsRtfW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IYIsRtfW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742589404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U8qGjZBLPjbcw53PJ9JKOoB9RfUmy0Urp4DXOVE2wbw=;
	b=IYIsRtfWKgPnIZwPGivDL8LlANM0/Vq/QAgNRAEi7VBDXyBvy0ZFMIijeRtE8a7jKfjCdl
	YcmojWAqSDpLlFnTjqe0OIbVCU9XtwJtJxEv7bMq45+1d/8UXWuO5TZFtb47XDNMENaPhf
	nS1JVkcOBLLUb2whNLhuk90BOfBDeNk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-4lsMx5pOMfKejyq8P4XFaQ-1; Fri, 21 Mar 2025 16:36:43 -0400
X-MC-Unique: 4lsMx5pOMfKejyq8P4XFaQ-1
X-Mimecast-MFC-AGG-ID: 4lsMx5pOMfKejyq8P4XFaQ_1742589403
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4769a1db721so55270301cf.3
        for <linux-xfs@vger.kernel.org>; Fri, 21 Mar 2025 13:36:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742589403; x=1743194203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U8qGjZBLPjbcw53PJ9JKOoB9RfUmy0Urp4DXOVE2wbw=;
        b=ERMV0H19pFDVyzUDyNmobdnmHzlfYDnu/22khA3zk69HzoJ8oOdrFIfNP97DQBKBNA
         213Z84JaAC7nMl53sGDqfe1pvmYL8vl0XxdPhwl11kEv9g8tJUN0Mg67sY5/Xu/oZehF
         c2QUHX94w4/cSaRZk1KmMtxWLiZ2jurq2IOlVRnqFedjI1NxEf9Hm6F70rotuEslJu3W
         WmXmbHioSrwlxBDydpt6y1BxLq0JD2/0YdsVn75/uEnhu9KHBbMTmh8C1xGF71CGvnyr
         kSq9+j+vEoiRCCSPsc3TwQfYI5EIo/bZuoofa9ZVazmAm/t1YIjVFWEFpOvtig0efYIh
         kCtw==
X-Gm-Message-State: AOJu0YyATn4HK9U2eoVeBAMQJIn91hwP1/CUpKBn7wpIpjIeD18g2EFi
	hBuUIzNO7LsJ/b9qLkspL7bOAFIJP6qDu0dAJ9vfw/xy63FGNsYSl/Jg0JscTWoxpY11h1nNuGA
	mtf+g8jRCshsBHzHjPQChRu7K7v8URjFPUOKJpBM1CUEeQAx9qd/pW1E2qw==
X-Gm-Gg: ASbGncs8SfGxNbDrb3YzY1WXpbfmMD0gEiyYQIehdqSX9rTTDxfrWCZMGcWSVzbWhKj
	aHT4WwoBknMbzOPs+hHWiRhiGGhxnYfwc/WgNpzYcrdEMjcrbKu13CkfulnThiNto0P0bHI8ef9
	8heNtJeENUQLVl8XYEItK5LWvyQPq7e24C1+AaNBI5cwdaZxvbsP51DhDfiC5ohS7iJ7pNbLr6y
	mrXMW2eAPh3mAbh/U2JvhU4CXCz0++XAJTAn9d/uYIZm65mdEUdVHFVJPXz1oc8B3CyFNGZp7pL
	2vptZ+axNuAUyVFIea+II345UbTlDaFDQHhxVz0es0QTfTRz
X-Received: by 2002:a05:622a:1148:b0:476:b783:aae8 with SMTP id d75a77b69052e-4771ddc9124mr67078851cf.26.1742589402651;
        Fri, 21 Mar 2025 13:36:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGLAfqdDexqh8NHyfJdHVPDhdeB8VZQ2Exn60bZLAs5h/nou8Y6PifTv78VRQudZ/OglzyuNQ==
X-Received: by 2002:a05:622a:1148:b0:476:b783:aae8 with SMTP id d75a77b69052e-4771ddc9124mr67078421cf.26.1742589402118;
        Fri, 21 Mar 2025 13:36:42 -0700 (PDT)
Received: from redhat.com (72-50-215-160.fttp.usinternet.com. [72.50.215.160])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4771d18fe25sm16307811cf.42.2025.03.21.13.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 13:36:41 -0700 (PDT)
Date: Fri, 21 Mar 2025 15:36:39 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net, hch@infradead.org
Subject: Re: [PATCH v2] xfs_repair: handling a block with bad crc, bad uuid,
 and bad magic number needs fixing
Message-ID: <Z93N12zwQeg6Fuot@redhat.com>
References: <20250321142848.676719-2-bodonnel@redhat.com>
 <20250321152725.GL2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321152725.GL2803749@frogsfrogsfrogs>

On Fri, Mar 21, 2025 at 08:27:25AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 21, 2025 at 09:28:49AM -0500, bodonnel@redhat.com wrote:
> > From: Bill O'Donnell <bodonnel@redhat.com>
> > 
> > In certain cases, if a block is so messed up that crc, uuid and magic
> > number are all bad, we need to not only detect in phase3 but fix it
> > properly in phase6. In the current code, the mechanism doesn't work
> > in that it only pays attention to one of the parameters.
> > 
> > Note: in this case, the nlink inode link count drops to 1, but
> > re-running xfs_repair fixes it back to 2. This is a side effect that
> > should probably be handled in update_inode_nlinks() with separate patch.
> > Regardless, running xfs_repair twice fixes the issue. Also, this patch
> > fixes the issue with v5, but not v4 xfs.
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> 
> That makes sense.
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Bonus question: does longform_dir2_check_leaf need a similar correction
> for:
> 
> 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
> 		error = check_da3_header(mp, bp, ip->i_ino);
> 		if (error) {
> 			libxfs_buf_relse(bp);
> 			return error;
> 		}
> 	}
> --D
> 

I believe so, yes. Basing the v4/v5 decisions on an assumed correct
magic number is not so good. I'll fix it in a new version or separate
patch if preferred.

Thanks-
Bill


> > 
> > v2: remove superfluous wantmagic logic
> > 
> > ---
> >  repair/phase6.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/repair/phase6.c b/repair/phase6.c
> > index 4064a84b2450..9cffbb1f4510 100644
> > --- a/repair/phase6.c
> > +++ b/repair/phase6.c
> > @@ -2364,7 +2364,6 @@ longform_dir2_entry_check(
> >  	     da_bno = (xfs_dablk_t)next_da_bno) {
> >  		const struct xfs_buf_ops *ops;
> >  		int			 error;
> > -		struct xfs_dir2_data_hdr *d;
> >  
> >  		next_da_bno = da_bno + mp->m_dir_geo->fsbcount - 1;
> >  		if (bmap_next_offset(ip, &next_da_bno)) {
> > @@ -2404,9 +2403,7 @@ longform_dir2_entry_check(
> >  		}
> >  
> >  		/* check v5 metadata */
> > -		d = bp->b_addr;
> > -		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
> > -		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
> > +		if (xfs_has_crc(mp)) {
> >  			error = check_dir3_header(mp, bp, ino);
> >  			if (error) {
> >  				fixit++;
> > -- 
> > 2.48.1
> > 
> > 
> 

