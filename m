Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA278202C29
	for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 11:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229672; cv=none; b=XYbEMIC94mpGHvE0CUOEHpoS/kGNQIG575kidvz6lFO2M1KNbLjA3ltnSoRLrbvCFEY5HWjAbvC40X233+kvWUBiPC1h9RadW0J+0jTaofio6WzoHA+RLo+4gioXZdnq60KvSrIorK/l6g/0UJWSHVgribc6U/LHOr00MyFZye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229672; c=relaxed/simple;
	bh=Hot8zhdh4os52H/bQtBLbPFsGFzTkd5c7ypRjZf9624=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qDgEQ1DUUleweIOWUsDIqfJHBeIp44VE2HsXrmIg6Bh7krUR5pz6TI82qUdeMKe2Prqk2ZSz7zhvkPpmWeb9jrSkccsHqOfK304HKS27xpbuek2636QnfFhjV0uNfR+DrMDOFhwCZVv8LcqEZs83uhkGTUn/GATAgC4QiD5AKN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bpDtRo8R; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nlrWJJDN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bpDtRo8R";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nlrWJJDN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773229669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
	b=bpDtRo8RGzTpUVtHbeV1Dfx0edUf99zv/AurKK0p6Dim+ZIAMOCXO7FMDOlawS4Rb8c/WA
	kDxSil3Q8EuN3ShfFOJ7Fgm/6/dGhp4m6qbLKVuxnItza5G0IH65V+pKHgmfh4icuuFJ0x
	ZNn6YPCSolzS/a0CWqsPLlfvyWO+pHk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-DySO84WmN0Od1HJd0tp0AA-1; Wed, 11 Mar 2026 07:47:48 -0400
X-MC-Unique: DySO84WmN0Od1HJd0tp0AA-1
X-Mimecast-MFC-AGG-ID: DySO84WmN0Od1HJd0tp0AA_1773229667
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48539bda3dcso31037845e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2026 04:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773229667; x=1773834467; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
        b=nlrWJJDNrqzuaLdO7weVeErzoXcRpDb+mroRiA4Ojlp6ftlQckim8mzmsdEK6w/MRL
         tTEdLEjKzJFNg1nRQA8NPfBusIK0FQTzZUZBuOrUZ/xCKnETTZB53aG7ubUnFEW/TKqu
         hU9Je59avigpmas8q0upYaifR9Q/Qx6aWKZ9YX+s9pspxSpYMBE910DXGQn/Nviwe2c2
         ORKDLw2T+YerhCFi+urov5IPaKvNyyvL04z7IJrWgpmICgVLS3x8LHPPibepVEiRAySz
         tXLfdVEoSrrxTrowIUGkVCDwn4ATTNlUHlM6+QHEpuPsVfQIUDBCcID9anBQPvntf71I
         HB5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773229667; x=1773834467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asRPjwI5YmOjCP6UVRlsstGP3cgkUliMF2dXi85Qbqg=;
        b=xMvT6oU5OsUmTeDlfGQxJdTq4sMWTD8w5vWWA8oXxnf/mxirVdBwUVkkCXLMJp5DGd
         gJbYHYP0Td8DaaOcRqv5msnrhq05Ok0NDkaJ44aModzfXyb/YdT5I7B5CCPe7ib3SISF
         NRqRn+4aJPbi4JQ/07Y9ffyv7oNOvwELqv6I+GvdBtiIPBKh8W5HXFO9BEPAZ1tCjffR
         A6goZNhE5PqrsuTo22yGHxOB+bcuGKxR+LTdAz4JQxw6tLf84Gb1WlVF4J/oLbdYea2b
         T20cFLCZDAlmjHHdcd83KKNbDgdGIu5CQ3Hs5/nSQ8kZY6x/z8a1I8ITC2z4jEq80mxf
         XU8w==
X-Forwarded-Encrypted: i=1; AJvYcCV3NEnqhxu0EVGckHTyvrx2STLdZeooy+oS8/xqjzK52NnvljEV/Ks1MdUo/TqV1OkHdI7GYzUEzQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxRXk+EjAgrck0SkcH9Ehia4wlL63RXqlac9EV/3OtiKWCGTgZX
	3ciSSLEkubmivCOOF8Afu8Uy45ZBhvIIctNi8SP+Pwo8+QG8c4oeqT8VzmdgomMhoRBaSPn2UZW
	Hl8g8UkA5vPl3gbMWqtOyWzMz03VLpXDBwXwQGvl1j8bEgun8m11Nqe5Gem3y
X-Gm-Gg: ATEYQzzHae9s+fnC3vTHNcxUeSfSTskUMJYLZuC/w8ZVJOe/Hi5DWH883Gj+O08ohFN
	9lPznoCevgf2FMQPN6SZRt7f2NTr/f73vsghorXJEDFtnpvaM066Gwu58TlYIMv4MMDDwgZ7+0H
	RSn5i01+qzwkfK1EpJstso0GeTY3i4ikHyyJrUbJ+msfpPa5bI0nWwQ0lTJ3kXjhSmdq/eOy1on
	XnxuI5mdWVjERZHRBV2K46LpJdA8/zJAnO28mxW8so/0/xhIyq25hOi5bIUGAh/2ra43qM+HGE2
	M8PqG0x4lblzktSeP5IUNLd8rpBhGPCu/A+X+f9MwukZHvfaeOhKRmvSh9+u2FUrzNRv1AuPA6/
	oFTxSMR+l27Y=
X-Received: by 2002:a05:600c:6818:b0:485:3ca4:4eee with SMTP id 5b1f17b1804b1-4854b144e6dmr35215685e9.34.1773229667270;
        Wed, 11 Mar 2026 04:47:47 -0700 (PDT)
X-Received: by 2002:a05:600c:6818:b0:485:3ca4:4eee with SMTP id 5b1f17b1804b1-4854b144e6dmr35215345e9.34.1773229666807;
        Wed, 11 Mar 2026 04:47:46 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854ad5ee37sm37540885e9.2.2026.03.11.04.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 04:47:46 -0700 (PDT)
Date: Wed, 11 Mar 2026 12:47:45 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 01/25] fsverity: report validation errors through
 fserror to fsnotify
Message-ID: <jezqpw7mjdren3gzvmkxv7dzviisf7mx2n6dwtq3iwgypghvne@z76sdkkk2x7n>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-2-aalbersh@kernel.org>
 <20260310004627.GV6033@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310004627.GV6033@frogsfrogsfrogs>

On 2026-03-09 17:46:27, Darrick J. Wong wrote:
> On Mon, Mar 09, 2026 at 08:23:16PM +0100, Andrey Albershteyn wrote:
> > Reported verification errors to fsnotify through recently added fserror
> > interface.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/verity/verify.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/fs/verity/verify.c b/fs/verity/verify.c
> > index 4004a1d42875..99276053d3bb 100644
> > --- a/fs/verity/verify.c
> > +++ b/fs/verity/verify.c
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/bio.h>
> >  #include <linux/export.h>
> > +#include <linux/fserror.h>
> >  
> >  #define FS_VERITY_MAX_PENDING_BLOCKS 2
> >  
> > @@ -312,6 +313,7 @@ static bool verify_data_block(struct fsverity_info *vi,
> >  		data_pos, level - 1, params->hash_alg->name, hsize, want_hash,
> >  		params->hash_alg->name, hsize,
> >  		level == 0 ? dblock->real_hash : real_hash);
> > +	fserror_report_data_lost(inode, data_pos, params->block_size, GFP_NOFS);
> 
> Don't we also need to cover the "if (unlikely(data_pos >= inode->i_size))"
> around line 199 in verify_data_block?

make sense, will add it there too

-- 
- Andrey

