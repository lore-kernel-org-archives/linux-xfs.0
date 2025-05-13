Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D77323ED56
	for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 10:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130513; cv=none; b=shKUBZC7NEn0RDuaTKo1MtGRfyFWNbwU+FxYPBWdARxw0hVZiOV9zVVct3zeyW1eXBhRILNGLSUqnVjTX7fwdP3AR+j9liA88cy1SsPm0ZzIi2+SkKU3elOJggD6WzndJJEYxv8HWZ8GsjnAmrmLxWDnv8EgVEmlQXl7L0ZH1Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130513; c=relaxed/simple;
	bh=JZoIcT62doqLXb2PbIrJyTn2JAyvj6n6Jgy9Ox38qo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m94lCYi223W1s8wzUhwn8pkqjxKyHua9zXX5oElVDEwXdWzSXKPdAr1A+ST6SspzTU0Lg5NyjHUqTYGyhKJfNZV5ea4vMsnTEll1BHcUImmP8Aex+f78RKIz8Xk0OssO5bsYT66Qsxn3CuZEhGAeHOJYF7uQcuwWwwJIPjd0DrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B3IZnnF3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B3IZnnF3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747130510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UHSwIuerDy4NgDTq3AFLKrqvptjunXpRrgK6X3yUMYQ=;
	b=B3IZnnF3dJ/mVldDNTWWzZnbhkF8DMtxdGAMSfL5wmY3yC5u1GiaLtonL35Xcfr7PeUMQB
	3KU1koH2floU6Ak3iLV1BX7+EBiy6mWNrVYYJODSmch3PJnoxrzitOU8tTBY4pdNN0+3Hq
	NmxoPeNJVzARBq7PK6PbgkFEbx0HYbA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-JL_ITaTnNVuwb7jh3McAfQ-1; Tue, 13 May 2025 06:01:49 -0400
X-MC-Unique: JL_ITaTnNVuwb7jh3McAfQ-1
X-Mimecast-MFC-AGG-ID: JL_ITaTnNVuwb7jh3McAfQ_1747130508
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a0ba24d233so1772437f8f.2
        for <linux-xfs@vger.kernel.org>; Tue, 13 May 2025 03:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130508; x=1747735308;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHSwIuerDy4NgDTq3AFLKrqvptjunXpRrgK6X3yUMYQ=;
        b=DZKJ2qWZKblG9HJyFSP9r16aakqE40eTTUEmF8mJr7Uay3aSykT5ZDtiW2Uu8lQwcO
         75Yx2kjgq9p9rs8lckqEBvDOSiKjzIyKrEM90lFQld5/BoqFxflLEaggm860jgsUxPoW
         QX7ej2QU1oMU8BgjfPA8MxtF+NQvdoMFqhsWksSggEzecg5bte84qUkwXpAR0cy1Od1S
         omBA30Isdy4gtNXR9YZyjJXU3gnquHhbTthlmFOoSOxThJHscMLdSpMrD7O6R4rJ32IM
         4bR0lLVMuy4NDZHyAjG8YzQLuIUhsd5Y/np3bYnlpmC91ukaOERJECi5JibQIh2NmSg2
         bX7A==
X-Forwarded-Encrypted: i=1; AJvYcCVViNH3ABDBfQxQcZYBkIvMKP4Bs7NMx4NDt26/5iw7URtXnF3TRVcJXs9NObUcdrKs7lJdldiNccA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5FR3Lykf68YG+o2oGcbHrJ+HSH8VwOb6vlMzK3jIOXDnRCCdq
	pNaw36SMFfsv14v9gkZ5UlAHG7AxWaUbOsRellt5WxYFJ1ftuTCnlrZuvH3Zk0ecmL+9ZTzMjaC
	R6B2yblvQgGHTwD170o0TGHX/JeR6RG7YPcLcFakXCk1uOTKRT+/chSrn
X-Gm-Gg: ASbGncvV2ny16ImvkmHmeD/dyHeJtqeZfj1yvqMrbLbucy2+plElFPpXt/qYeVwRRa+
	vX4KqmR+YQ4IS72pvkOiyjP34dUnZoO+i8BEhbVhuJralpmYcoiLkmYDIKfmPUCpmHJL4gS1kqZ
	QVOvc/Yijuma3X3U5ONHEoMDaEIx++0oPCIj09TQBI2JJ/0+UXNAlzJ6hqx+Xu0rtx0v2FlMcp+
	AR8S+7b5/Jx6QScwuCmRVb78T3FcAEXOARUgPsxMhZTNqShnrEN6ILCv9jo68qdNsT/WSi810AM
	iuJbr7wISAlve6svs31UTWNFvsylFclxtB4O+CQA
X-Received: by 2002:a5d:64ac:0:b0:3a1:1229:8fe0 with SMTP id ffacd0b85a97d-3a1f6482c15mr14817389f8f.38.1747130508466;
        Tue, 13 May 2025 03:01:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEtsi8k8PnRn4KaCaQ/lnyf+vnxy0UB8M8G4ko57Ut+4WsfGeYt+eu1+MOCG8cFP6S8OFjLeA==
X-Received: by 2002:a5d:64ac:0:b0:3a1:1229:8fe0 with SMTP id ffacd0b85a97d-3a1f6482c15mr14817349f8f.38.1747130508090;
        Tue, 13 May 2025 03:01:48 -0700 (PDT)
Received: from thinky (109-92-26-237.static.isp.telekom.rs. [109.92.26.237])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57de0ddsm15325727f8f.7.2025.05.13.03.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 May 2025 03:01:47 -0700 (PDT)
Date: Tue, 13 May 2025 12:01:45 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org, 
	hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_mdrestore: don't allow restoring onto zoned block
 devices
Message-ID: <77z2ob5xvqytchugnpfeq6rl3uhoa4wu5zsmof6ugoyu4kfs3x@4owfual4zzsu>
References: <20250512131737.629337-1-hch@lst.de>
 <20250512151240.GE2701446@frogsfrogsfrogs>
 <20250512152525.GA9425@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512152525.GA9425@lst.de>

On 2025-05-12 17:25:25, Christoph Hellwig wrote:
> On Mon, May 12, 2025 at 08:12:40AM -0700, Darrick J. Wong wrote:
> > I wonder if there ought to be guards around blkzoned.h, but OTOH that
> > seems to have been introduced in 4.9 around 8 years ago so maybe it's
> > fine?
> 
> I think we're fine.  If not we'll also need to do this for mkfs and
> repair anyway.
> 
> > /me is willing to go along with that if the maintainer is.  Meanwhile

Fine by me, looks reasonable

> > the code changes make sense so as long as there isn't some "set the
> > write pointer to an arbitrary LBA" command that I missed,
> 
> There isn't.  It would have been really useful for testing, though..
> 
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> > 
> > since we wouldn't be mdrestoring user file data to the zoned section,
> > right?
> 
> Well, mdrestore can't even restore user data :)
> 
> 

-- 
- Andrey

