Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A762FE585
	for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757678213; cv=none; b=TABHBBfLjZsRqELqllKG09xTYdm5eN+hDwjOqg+hqz7Jty7rFyMgSydIQjYSdIACMdyx4dz5U31NjjIpe1mctDSVyV8GSKy5TebMVtgGz9JCKvBc22a/Qc7xuc6Cf1JDXZpNJ58/G220MyGr+/bYzjj9rBbYdAfGGdMA62/MOCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757678213; c=relaxed/simple;
	bh=+mNtg5JQLMkrEOEyHPRCbKpHStXXOyD5XtUgf68Si4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZFkI6CvICbFlq2taSnX++uGm4VDBbyz8yuJ7GyOo2UGnT9suoFd497LfAThSKB7L9ukZdT5sol5T+UwvorinDPHI587D7CIfRTEWwJIwPFZ0bkiEbABuFJcC21jd1nppweF+bFPZG/Mm65ikK/5Wt93hGwS8cCnTy5dpd/7zNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLcNqfnZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLcNqfnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757678210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z+6E05kBbROZjYHlECJ6pM3n90elFfaGg1KIjniWKd0=;
	b=HLcNqfnZtQIRRIrw/Pu50WCO0gl5DJMDQ27rYBob+wMyoWgD/2WNaS0RObKULVNJQJr0ds
	7XK5SzLjCVhN+LbZWspqnXGxVS0xhD98R66+G9UQrI//V99BoztWBPTu/A0L7hH64Jy0pe
	tQUH7lWkcT39ALBrE144BQFvWom8Myg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-VQduj30-PXKdn0MR13HK-Q-1; Fri, 12 Sep 2025 07:56:49 -0400
X-MC-Unique: VQduj30-PXKdn0MR13HK-Q-1
X-Mimecast-MFC-AGG-ID: VQduj30-PXKdn0MR13HK-Q_1757678208
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dcfc6558cso13785425e9.1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Sep 2025 04:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757678208; x=1758283008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z+6E05kBbROZjYHlECJ6pM3n90elFfaGg1KIjniWKd0=;
        b=IWK+UOMnywFjEcKJmw0SdD2VqgGPGX4cpskObAfsjsZhKncZdXfOnJAKDsG/P3YO3l
         JA1f0rv93HKAA3SLrJ+Y1Y+rgDSBPjSTbHc3EUVmCbHmzqccLksOUh3YVKhB61FhDUop
         emKZQ98tijCwVSHjPtvJIWrE/KchB8ID+uURoz7BVS3g2PJU1k0qQURAcNGHCqyZZhV8
         n4b+so+OId/80ZklhdWWVmGU3BsBt6vbg+wOjt86MS6EdATEHXhf5lwxu3PzoTOC8ZVc
         2eXhF3Uo9AohaGvQEawR/Sxog2kjTBP9rHFoQPITP4fberDo9k6iloVwJuFZcdD83Ee3
         tmcA==
X-Forwarded-Encrypted: i=1; AJvYcCUb9RgSEtIV7Ul4Ur5XHfUDSxOH05ZdTyOyAznDE9V5iNvsLJGaGQ1GLICycHUnrqenZlJshwqpln4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxwUHm943AtO730OH+GCX2km0EE9Nia2YfQ6BpRFz16/wNJqhWM
	TRb9TyzEJ50MCBSxARRjThBPCSDOTofSzU3ZsZO2u53CkKFkjS1GXstTFCu+XqS9qeScYxu1+d9
	SYZ6xZ4aAWcYtfeB8iDw0Kojn3za1+64Qzg7Zt7YKNI/8Qm2kGskBM0ysYLSJ
X-Gm-Gg: ASbGncskBf5K5mcsu+s3GtIgU23YrKRu5cGzblcZl8B4B7FYEI8sttMgSuVcANU+PwW
	FhdeDHAd7110ea9HqyZjQkdFywsisWcevrMShXw+wpV3ZEL5wMDfP291X6kwoJKJ0X9jwIRqdu+
	IMRZZ+5282DZ9EoGqNfS7DiQgjTcVu3zuIp3bylO/UJJoEtXpgQid+1nbTpxsl+u+GcZTjxSWIP
	lG4O9zt1wh5XwhnotI43404EQ+LhmfWBA0SwV3TSWp2ulegE/AI9OjDUM/YUD1CEd+O1vJ/Hb/E
	sGgKM38rCKKpiG/0oSEr6EQRBICV13i5
X-Received: by 2002:a05:600c:46d3:b0:45e:598:90b0 with SMTP id 5b1f17b1804b1-45f211d4640mr28993435e9.9.1757678207817;
        Fri, 12 Sep 2025 04:56:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa3w2WIx7VIKrKrQtNbmGIs6VxkTekeX4oKYegwFajbDtX1Br0uRbrYVR+ymTQ7e9/hErz+g==
X-Received: by 2002:a05:600c:46d3:b0:45e:598:90b0 with SMTP id 5b1f17b1804b1-45f211d4640mr28993125e9.9.1757678207364;
        Fri, 12 Sep 2025 04:56:47 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037d741asm58941035e9.23.2025.09.12.04.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 04:56:47 -0700 (PDT)
Date: Fri, 12 Sep 2025 13:56:45 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com, 
	ebiggers@kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH RFC 02/29] iomap: introduce iomap_read/write_region
 interface
Message-ID: <khoyx76se2x2z2ktzelsklcqnbjl4budasczm2mjknkgvlsbph@gckk675qmqkj>
References: <20250728-fsverity-v1-0-9e5443af0e34@kernel.org>
 <20250728-fsverity-v1-2-9e5443af0e34@kernel.org>
 <20250729222252.GJ2672049@frogsfrogsfrogs>
 <20250811114337.GA8850@lst.de>
 <pz7g2o6lo6ef5onkgrn7zsdyo2o3ir5lpvo6d6p2ao5egq33tw@dg7vjdsyu5mh>
 <20250912071859.GB13505@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912071859.GB13505@lst.de>

On 2025-09-12 09:18:59, Christoph Hellwig wrote:
> On Tue, Sep 09, 2025 at 02:30:14PM +0200, Andrey Albershteyn wrote:
> > > Same thoughts here.  It seems like we should just have a beyond-EOF or
> > > fsverity flag for ->read_iter / ->write_iter and consolidate all this
> > > code.  That'll also go along nicely with the flag in the writepage_ctx
> > > suggested by Joanne.
> > > 
> > 
> > In addition to being bound by the isize the fiemap_read() copies
> > data to the iov_iter, which is not really needed for fsverity.
> 
> Aka, you want an O_DIRECT read into a ITER_BVEC buffer for the data?
> 

hmm, but we want fsverity merkle tree to be in page cache to use the
"verified page" flag. As far as I understand iter_bvec will need a
page attached anyway, so this is the same. Or am I missing
something?

And with direct io there's no readahead then, and we don't get any
benefit going through vfs instead of directly calling to iomap.

-- 
- Andrey

