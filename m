Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9192A4F4D1D
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 08:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065956; cv=none; b=dhAfw4ytDp5h4UZshpXKGcwWqbZ9lrv6eVdKtNETC6diKvKAnE5fYolbbUdGp05h56aFhYoyhiRL9kQz8rP4oLu6W350NKKznAFzIyr95CSmoC//QUbxrz6FyN+nMLrMKCua5c47Wx0Du2EW/b2Ydxrf7sBnDrJpjvkG0McP3Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065956; c=relaxed/simple;
	bh=bxOLRyx+TtzIaCObuWShkyjhDbes/LDLjKEl4CexuEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z2KbaP1DHBLk10ECYlbgkkA1uUP8EEA/4r8pA96Hcahws/p15Zduqe9TYsznN/sL7sG4Fo4v4Rrdl0nNf7IIuYI8EgOYTrRNjd8hIw4tpbMaGSHT7/2RZJgW/n5nkBSzicHZ3uJmmgeDkcLRLPzTDua9YWdrcB9HYmpn/Oh+etI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=darM+GM1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qz4gOev9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="darM+GM1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qz4gOev9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790065953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
	b=darM+GM1S7h7AqXoz/p1A47ibc7IZrqENT4BH8E54RGqEj00qmVsyh74xlHz83XqRwPI1l
	mWpILjxgHKkufVL50NYBw2sk2uvFyOspjI9cKL3UE6v+UF6kUItDb/GlLszzLlDpri2Z4T
	Gqo7vH9PvWasCr2KMUQ6+eH7JYvzC8o=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-T1sIkCc9NvGCAfjlRg6ojA-1; Tue, 22 Sep 2026 04:32:29 -0400
X-MC-Unique: T1sIkCc9NvGCAfjlRg6ojA-1
X-Mimecast-MFC-AGG-ID: T1sIkCc9NvGCAfjlRg6ojA_1790065948
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49fcd86b8d3so26823385e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 01:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790065948; x=1790670748; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
        b=Qz4gOev9TgVra5iOJWfTnbYEokCVKsZZUgM98FD6WKxETb+2CICQBG8jcqxWFdPrbv
         cf6wdt+ujB5YeEcHJYuRkn8CK4IsSIsaeQgLb1AOid1GU2VkOBDgM6zaLxKBN4kVfebZ
         amF/j7UhBtdBBIGHGO2yMskam0cpjPpF4kbhtgkJXJ5mXjX44+faUpCgF3EYfu/VgdIH
         7WG8dtTdaLbsPxPTWd5NZW52Xep/pfo/msijT/oEnpLZZZ6uLBvrDMpJ+X/+BYLPMFb7
         CjYY2bCexHm1KLIM93NpZ9JciGGb0Ay6sFee16y+WNwGJLKVcjV63Q1i25pBPCXdMsLf
         L68g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065948; x=1790670748;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v6HyFSOK4HYSfvcwVKnaiUCa+pWXMNUUzDe6nYFstxk=;
        b=aMZErdbP0FJZVQKAIiQWpmUQkpdZIl//9N8tDvBaX83bOniIiQq7MvSGB3FNQYszkS
         NUchssuLJU6j7R1PNASaMc5bIUTO0dimsXqbjOO2VHN9GH8dyr0SpBIQT3c4b82CwUEI
         Oy+xrn3c7DF2P5ZAdGf4mLL7uEIyzPQZy5Mv+nTSGPRHrMu9em7Q1avTQRSrZ+a2H4J8
         BWZH7GCA7yVadcw0tMBbHeiEILTD6b334q+WweOftKnhem4a0acfsnCuhxj4e2xNCu92
         c4axydXiw5UtlwGN5zdRuQjXwohdl7dtyzPS3zaaWEaGnqdI1BdlKASnnXVKI6vrKZkk
         AgWw==
X-Forwarded-Encrypted: i=1; AKwUvByg1FyMrUs2ZjfLMLSOzPnIUTQirPwFtZ9TWF282h6saKYaLgB8Wm9+ghPs1KdyKHhQr6sBMgDrvbE=@vger.kernel.org
X-Gm-Message-State: AFuF++mYV+H0pfPqXgMK8Oa2Nv+j9tYKbGqQBPu/jwn+jq6tpAVyvETo
	aQuPRfmL4BgrKWLYLqq2Uo9tcdV2/lzd9B6IHKvwCBRwn7ym2wApkZLk9pYvhjdJQllmiyxZJv/
	Z196QJ5sA2zCyGT7d6TvrbU/JFU9btJv0Tett56iSQBJUffNmxmKAjEUO27EK
X-Gm-Gg: AYBFou3/7jJvCXzO3jxz+Dw3Srw0379WHnecI6tHftmB67O3XbMyjjEfMYNoujkLN2t
	dbULO068/83ioxZHmKht8O6vlzHD/3XlnpkoiFIG3pbcmTjRS7BpUBDTyD0PbhFm1wXs8SyLq4B
	QlWDo/vV8tJfDh/wYP43/6qk5kE+WIcvLvs7WCrLQZRzEbFNDfrg4/jbgOaPYqG0ZMOdEI+pYPa
	/d4Q2Gy1to1QQ88bbgLJQNHXueFgSZZeVIVqevp0qvmv6ofWgc2l3jtcEnRgtUP/AKArkmhOvER
	19M6XE3OmBlfp4y1fpdHgR0tylZmsRMjOL5q91IrBBOoLZNE6t50glQVUHTg8ShG2XPA+2V4bDu
	HAjUz+ev95IROTtapR8tJE6LY37EBrV6f1A==
X-Received: by 2002:a05:600c:3f0b:b0:49d:1df6:2592 with SMTP id 5b1f17b1804b1-49fc5750c61mr161766925e9.21.1790065948503;
        Tue, 22 Sep 2026 01:32:28 -0700 (PDT)
X-Received: by 2002:a05:600c:3f0b:b0:49d:1df6:2592 with SMTP id 5b1f17b1804b1-49fc5750c61mr161766615e9.21.1790065948022;
        Tue, 22 Sep 2026 01:32:28 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fdabe8a2asm32746655e9.4.2026.09.22.01.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:32:27 -0700 (PDT)
Date: Tue, 22 Sep 2026 10:32:24 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Andrey Albershteyn <aalbersh@kernel.org>, ebiggers@kernel.org, hch@lst.de, 
	Carlos Maiolino <cem@kernel.org>, fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH v16 13/21] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <arI8cvh8rgIwmv9V@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260918111539.1003439-1-aalbersh@kernel.org>
 <20260918111539.1003439-14-aalbersh@kernel.org>
 <20260922043402.GM2705364@frogsfrogsfrogs>
 <arIsIhrWltHi9Aej@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIsIhrWltHi9Aej@infradead.org>

On 2026-09-22 00:20:02, Christoph Hellwig wrote:
> On Mon, Sep 21, 2026 at 09:34:02PM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > index cc48f6e20e80..7ba76017ae56 100644
> > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > @@ -5280,6 +5280,10 @@ __xfs_bunmapi(
> > >  		if (del.br_startoff + del.br_blockcount > end + 1)
> > >  			del.br_blockcount = end + 1 - del.br_startoff;
> > >  
> > > +		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > > +				del.br_state != XFS_EXT_UNWRITTEN)
> > 
> > Odd indentation?
> > 
> > 		if ((flags & XFS_BMAPI_UNWRITTEN) &&
> > 		    del.br_state != XFS_EXT_UNWRITTEN)
> 
> Yeah.
> 
> > /me again wonders if bunmapi ought to have its own flags instaed of
> > reusing *some* of bmapi.  But I concede that ought to be a different
> > cleanup, because figuring out which flags are for bunmapi.  I think it's
> > REMAP, ATTR_FORK, NODISCARD, and UNWRITTEN?
> 
> I think that would create more confusion than it helps.  OTOH asserting
> the valid flag would be helful.
> 
> Sashiko complains about interactions with the weird rtextent bunmap
> behavior.  Should we disallow fsverity with a larger than fsb
> rtextensive to not bother with this?  Btw, did you test this series
> with RT classic and or zoned?

yeah, I will disallow it

I did many revisions back, but haven't tested recent versions, I
will test with rt for the next version

-- 
- Andrey

