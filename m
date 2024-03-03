Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D744667A01
	for <linux-xfs@vger.kernel.org>; Sun,  3 Mar 2024 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709476917; cv=none; b=paQ3XOdME3sLTJAFuuB9fKe2Z1X/3itK3IyCiEWz34jwkgV2WQ+k/fvs6rq5UekiNDD/okLdZA4EK3/Q4ECsoj4l5pCAJbEtzsiV7ifoK0y44/AoUwZSQg2YYdCIe6vgbe+ntnyDNrvlCqL3+kSmlXi/EeioZFa5c/lkmj3P/+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709476917; c=relaxed/simple;
	bh=SThudsZwnWnGyI6jp7a10bTtZojDmLcZXDe6STXoIc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AidCx8gJTgV4l+IIGoBGiXVka8o2aTnVMpaIxInIamT/2tgE0RJYhChQm2+xlx6GHO+n8fbqbhFEcDMmi4v/52jMYYJfG2qpUaDpAoKBn1E0buSQl9zL1BVhgL8uf8Yo0hTaaR+zMoAVMjwDtqrUY95PgfDZYb6l1iUBXsCDnYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z0jdUhNC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z0jdUhNC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709476914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rl2ByWGTuIoJFZHZspKAH0Wx8/n3SIks5Pk2qLRqUHw=;
	b=Z0jdUhNCycE8BF30Jl/yHRUSn4YeoqzcnYxSArmG0OhSsnEf0KnspfHFoHdEtIiosUSwsb
	xJ8VG6l/eOq16mA2rc9JNtJn3ZUN8FTiBMO9TV7pGWPt1pxDwwjjt3E1vzKjMcz3qWG4Om
	5MHAL6fBnbaHkh6mJUcra0lc6r4T7z0=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-p7Kw86KYPjefSv3EMnkgwQ-1; Sun, 03 Mar 2024 09:41:52 -0500
X-MC-Unique: p7Kw86KYPjefSv3EMnkgwQ-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1dc4f385c16so36870595ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 03 Mar 2024 06:41:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709476911; x=1710081711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rl2ByWGTuIoJFZHZspKAH0Wx8/n3SIks5Pk2qLRqUHw=;
        b=H26AlH9bbOvtjYWvZkBoTmPnfq83IVThSj2AjLRqab3uhrpKo1NRFUlxgsy18U8PC/
         qQQ2ZBR7DTrQB+j3KHbh0vNUDjpXerSEvvvLHxgCQkb5tKrHdL2mxqj6tnRtHTg5E2rV
         mlAfalOqox/xjKkiEZzturiCmcsIy/DB8PQIGwO1zMHY61d8HS17or8xR1iunNJsmC5U
         yLKtoii1zQXnsno11WjC3w91KS2/z+Qghrw0Sfp6rCcMv9HArTD9zU/pE4FheUfzbd6H
         SttQj9KQE97iOjPBdFq5pLfEnWSsnNjOBVjVAaY+5ksWfRWz8DpFldw6InIY1cfks5sx
         IziA==
X-Forwarded-Encrypted: i=1; AJvYcCXectSctd/+St4ee6GPcgfu8HlzsU/m0zQMK290XHurvpVF8nhCl2TXZJOgTSUHkTS/UEPiOuSQAL05m+TXZMSvsIVi4X+29J7y
X-Gm-Message-State: AOJu0Yx3q2oxVAs9eCQB1ezPJFs67PhDp8MWxSEtLk7knlIVetUt6Phu
	eRfCqjKWGggRvwM+9g0RFu6E52ib6mavvAPZAdU8FS0cRPFy8QBJtH2oanjlYwLT42e6dIzwJ2z
	lJn8Jrc9aHbZ1xAX+A7foWK3rjwUMrMqYvig4C1d5vx9XS+dAUmF5VLhZCPqb381lCx60
X-Received: by 2002:a17:903:2a84:b0:1dc:ccd3:29e5 with SMTP id lv4-20020a1709032a8400b001dcccd329e5mr9452886plb.2.1709476911629;
        Sun, 03 Mar 2024 06:41:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFQI2RXeoq7rInr+07aWOpZQfLoydz35OH36u6e//8L01dmgE0Wq9V8fvL2bPwlGoO13RUxxA==
X-Received: by 2002:a17:903:2a84:b0:1dc:ccd3:29e5 with SMTP id lv4-20020a1709032a8400b001dcccd329e5mr9452876plb.2.1709476911339;
        Sun, 03 Mar 2024 06:41:51 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902dacc00b001dce6c481c1sm5122843plx.301.2024.03.03.06.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Mar 2024 06:41:51 -0800 (PST)
Date: Sun, 3 Mar 2024 22:41:47 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240303144147.rjdc3sbx7wdtghzj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240301152820.1149483-1-hch@lst.de>
 <20240303131048.kx4a4b2463deud7t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240303141526.GA26420@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240303141526.GA26420@lst.de>

On Sun, Mar 03, 2024 at 03:15:26PM +0100, Christoph Hellwig wrote:
> On Sun, Mar 03, 2024 at 09:10:48PM +0800, Zorro Lang wrote:
> > >  	# Convert free space (agno, block, length) to (start sector, end sector)
> > >  	_umount $loop_mnt
> >         ^^^^^^^
> > Above line causes a conflict, due to it doesn't match the current shared/298 code. It's
> > "$UMOUNT_PROG $loop_mnt" in current fstests. So you might have another patch to do this
> > change.
> 
> That line actually is from a patch in Darrick's patch queue that I'm
> working ontop of right now for some feture development.  Sorry for not
> remembering to rebase against current for-next first.

Never mind:) As that "_umount $loop_mnt" isn't needed, I'll change the
single line only. This patch and the other patch "[PATCH] common:
dm-error now supports zoned devices" are in fstests' "patches-in-queue"
branch, they'll be in next release.

Thanks,
Zorro

> 
> 

