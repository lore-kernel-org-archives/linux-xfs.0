Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611A9192B90
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 12:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757421021; cv=none; b=RsOzGQPxTOq8M2LaQ1jk+yD5z2QclvNGl4iqqD9kixlm97jYSauriMG0YVvf0Wj9m4Z4tKQeAs9apHQQ/2XazzYDHe6aeEtpV3gK2jIUjAXyzOVa1Cu4Bwy3dP8U17WJKjR4JVMPIpZdQAKRo22+9nb8P0Q1JN736dRt1pTsT7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757421021; c=relaxed/simple;
	bh=s92S74rkTQygVdBylBjRnsGIqHJ3GyRJ+UufBEDW444=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V/jtdAE6tzo+fMWkkCBuWIREWHfcxApwbKESGjqnxXA3XXGxk8Ox/cK+OheaKeesxFeKw8A1RpBfD6SGZret8w8rjzR7lTFtFRFY28AfiKYqNCv1A6WP/9GE2JezEJo7UM+FKL3QghqsZE72OoTcLRb2R0ztUOxp9UiT2LaxORI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fiyvUshB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiyvUshB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757421019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=00MIITktQKpeu4Npo919IC2v222FV9c+T1/KFxmzFFk=;
	b=fiyvUshB0JcQR+p1qPkPxPeizdn57DBVB4Wuj5sxiJIQZjfZa6UUGQ3R0mf82SwSoBaLya
	yXm+rfqItF7VH7cPox5hWVtF1y7gsg2qu8Weqe9xgZSul0RmVqv/C998NszodShc+oOhhQ
	xcxLmv0mVH8sg1rWYT47Qa4k1lY+MmU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-CThBksapOjaQeMuNvrybfA-1; Tue, 09 Sep 2025 08:30:18 -0400
X-MC-Unique: CThBksapOjaQeMuNvrybfA-1
X-Mimecast-MFC-AGG-ID: CThBksapOjaQeMuNvrybfA_1757421017
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso33083975e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 05:30:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757421016; x=1758025816;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00MIITktQKpeu4Npo919IC2v222FV9c+T1/KFxmzFFk=;
        b=ic5ZZoYw18UgLAsd5ooGFCnx2tpAeHRqT4bJ9D83+kgloqshdaxcSzU0ZnlXm3xcKq
         B3OJGQ6CURIJFGFzvtthl4H3cmWzxTBA+PsVR80KBKhK5YwmUNtsUWzcOGVEri87GTk+
         NRk1UjYDuVK681gh2kOZlrvhOr6afMyWFur967DzduS7NyE3osOrWt2r5qk0eSfu2rKU
         EXgXk7EjzI2HyXaJTe/C6c68i5wVZo9zKFhVwTJyOmHdU0XeAu1BbAWYrF0/5B7O1Lj8
         PJm6QaJ66oA+1wlyjb9jKUZAG47edi3DM8c3Hfhp/VZhUDieCEIyO2SDDQcbbZrZMPEf
         UqwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVVgPF9gBrpQuuryINb43+KKBsXHGnLI7hSHg/tkP5AQjM0rPYVzOiTwQ4Z17rYbdt9gMZlsSmRT48=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaHC43fodf4Gr/pNCKFAwSYo8iiM/roGZAHnRzBc6kfKkPvsCL
	BISa8PSrOUhn9neFIoQ3dOHW5ivMEm1JjwpjG/3f28Nu/F6wD1cXpSvjM1jubzLkPzv4hvKPmdY
	hBQjQycMs5WIjlEjEMkb60Or7xfK5qFE/rYarqk/IVbLXl7zvIp3F57muZWXiCieRL5GU
X-Gm-Gg: ASbGncsaF0P+SuTkTDyEkt8N/dXRPhVfLWVK1nD8nLCJ3jyZtSVB8aQ8dwt3dO1JyLR
	h8SpT+sId8Doz+91wji/UMaAADLIUIL+wYXHfQygoVfENESzoxh6nGbBXzoa4PxMmfznml35lbd
	NqxQ1XjIvlIu/+YR/gx8cczCpb3wdqYwkagg9uRu6ZDtRny2BGBEZNn9HuulyPi6wqiM9CTwbcp
	xDgy8bFCojEQE6Cp59uKFYTKHuSOs6+e6UB1HZk4FiT2Brce4v87QQ194LZc5mXxfDZVa5aiqff
	chTRd9W6m6AuydxXAOd6hO4PHX0QuMg0
X-Received: by 2002:a05:600c:1c1b:b0:45b:7185:9e5 with SMTP id 5b1f17b1804b1-45df6334418mr607555e9.5.1757421016412;
        Tue, 09 Sep 2025 05:30:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF90lk9hKimn7/9fXuczdVmK4Oq8YW/IoH85cs4kzzTgo9MhmHaqu+WdCnHoNhq9HRvmfB8fQ==
X-Received: by 2002:a05:600c:1c1b:b0:45b:7185:9e5 with SMTP id 5b1f17b1804b1-45df6334418mr607245e9.5.1757421015994;
        Tue, 09 Sep 2025 05:30:15 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfd8csm2646333f8f.11.2025.09.09.05.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 05:30:15 -0700 (PDT)
Date: Tue, 9 Sep 2025 14:30:14 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	ebiggers@kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 02/29] iomap: introduce iomap_read/write_region
 interface
Message-ID: <pz7g2o6lo6ef5onkgrn7zsdyo2o3ir5lpvo6d6p2ao5egq33tw@dg7vjdsyu5mh>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-2-9e5443af0e34@kernel.org>
 <20250729222252.GJ2672049@frogsfrogsfrogs>
 <20250811114337.GA8850@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811114337.GA8850@lst.de>

On 2025-08-11 13:43:37, Christoph Hellwig wrote:
> On Tue, Jul 29, 2025 at 03:22:52PM -0700, Darrick J. Wong wrote:
> > ...and these sound a lot like filemap_read and iomap_write_iter.
> > Why not use those?  You'd get readahead for free.  Though I guess
> > filemap_read cuts off at i_size so maybe that's why this is necessary?
> > 
> > (and by extension, is this why the existing fsverity implementations
> > seem to do their own readahead and reading?)
> > 
> > ((and now I guess I see why this isn't done through the regular kiocb
> > interface, because then we'd be exposing post-EOF data hiding to
> > everyone in the system))
> 
> Same thoughts here.  It seems like we should just have a beyond-EOF or
> fsverity flag for ->read_iter / ->write_iter and consolidate all this
> code.  That'll also go along nicely with the flag in the writepage_ctx
> suggested by Joanne.
> 

In addition to being bound by the isize the fiemap_read() copies
data to the iov_iter, which is not really needed for fsverity. Also,
even on fsverity systems this function will not be called on the
fsverity metadata, not sure how much overhead these checks would add
but this is probably not desired anyway.

Is adding something like fiemap_fetch or fiemap_read_unbound to just
call filemap_get_pages() would be better? A filemap_read() without
isize check and copying basically

The write path seems to be fine, adding kiocb->ki_flags and
iomap_iter->flags flag to work beyond EOF to skip inode size updates
in iomap_write_iter() seems to be enough.

-- 
- Andrey

