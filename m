Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5ED57FB
	for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 07:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711782891; cv=none; b=VBnhNT8Nd2AdPdbObAvbuRZLFdLVq8IfzWFM6UT+b5d1ttNy4iawR06eXT/ODaO3f4MLnbwltb+ruHzWwy3oEDkWw9M6UlYRQGqLgxPd49jssl0aA4JonNXKe8xzWr2+YMlWZMQYqBq4GVqiPv+N2px+chD4PmUUbMAhoz30K60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711782891; c=relaxed/simple;
	bh=ZmWo2v84hYikRBD3+pSn+JrndFit6bSsR7aygt7Z8jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwbmdBtrDNEjOkEjRUq+IC0UWo6K1DhC2bLj+eYvyCOQzl75cl383WhBEMwLGTsehRuhmk8Jfdi5QOFWIQyfsRgm5eDGJmyINVmkbD0azy/F5wZa6uwRxHFA6DyDst9FNYUf2ZABT1K94gnPW32ZIEUgpkIxKzN7AqvuwGzLfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T7Q/wgll; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T7Q/wgll"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711782888;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QzsptU+EGHYhDonyeBcGz/NxoCBKxQxpTopvgEZSOqA=;
	b=T7Q/wgllspinBwbl9sIyQgdcXmyhxFiN7xI0DD7qwicmReYIQXDsov7Y2wjnE77n4BLfiE
	lIxjRPPgIZ0TlT/1aDdSu0gQYtgq2V2LRJ/vYevYXih2LUihay7UxSR6DyoYavFIMwXQjL
	9DxtS5w3zJuKrcEdS+i3z0mII7ewr+Y=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-e3lKL2Q-NYOW5Tvl-NNpJQ-1; Sat, 30 Mar 2024 03:14:46 -0400
X-MC-Unique: e3lKL2Q-NYOW5Tvl-NNpJQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-220ac2258bbso4098163fac.0
        for <linux-xfs@vger.kernel.org>; Sat, 30 Mar 2024 00:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711782885; x=1712387685;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QzsptU+EGHYhDonyeBcGz/NxoCBKxQxpTopvgEZSOqA=;
        b=HmGqa+4goiHOqJsQdFelKefyGQwy6+oRNPNxi3+fDUHRlj+ktqY+bYRMF+XqB2HsGV
         mAA5s7/1+C5DvBjX+okdh9hvPuoGIA8fm4Ly9C2dGqrQ/zidfIc+0YE8EkKiJsT3GZWm
         Lhqx+BX8UyZp5LfXcMZ+kBV7gWkM1D/hInIbCRkbgNZXQW38TQVF3ye67iQH22LeTLWH
         GtoxWMdmhsmcoyTP2Rp3y3uIbHW6MqplEAujeOJ6DnG0lCI9lhCtdPeRWXvjEgjZ7Mhb
         +j+hLMjx3Beq2RfCaFblx0FBbUK5BoPyuVbvE+wvQ+cv7RFvJ37HjYb8c3x+qf/fPTxK
         VZNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyX/hifAh7BovGlBf1iGAKu1a4tNvkTdWNYX5vjc9p4WyTTzVp++q4l+xfajH1UsiCGK6r/GVnil6qnmwalFBfY8JTI2yrp91E
X-Gm-Message-State: AOJu0YwySjns1Jefcb0e7akWozPEXr5PHaTEtNFfty0q3li2Nb4n1Bri
	qRyIudp3geEvJEnIpJ/mhgm2+emV6kOur/MqDgLq8F1Nr5QHtaewflgBfh+sH0jdJtalwDREC2l
	kfR6QI6yPe5/Rahzbaz+DS3YwwPCZzJWhQBOUcvcZOAEGVTpMI8sy2XBJve6TMz81OYZg
X-Received: by 2002:a05:6870:1611:b0:22e:5cf:9d09 with SMTP id b17-20020a056870161100b0022e05cf9d09mr3457751oae.2.1711782885341;
        Sat, 30 Mar 2024 00:14:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1aFuBLvMGt5Jeo3xVON6btWh7XOPv3Vofy3PalaV7o6NbAvYzXf/FqfHFQkJjfuLP48wM/g==
X-Received: by 2002:a05:6870:1611:b0:22e:5cf:9d09 with SMTP id b17-20020a056870161100b0022e05cf9d09mr3457734oae.2.1711782884966;
        Sat, 30 Mar 2024 00:14:44 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d21-20020aa78155000000b006e6b959b636sm4019538pfn.53.2024.03.30.00.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Mar 2024 00:14:44 -0700 (PDT)
Date: Sat, 30 Mar 2024 15:14:40 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] generic/{166,167,333,334,671}: actually fill the
 filesystem with snapshots
Message-ID: <20240330071440.4xz7ldmqd5jjuwmj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <171150739778.3286541.16038231600708193472.stgit@frogsfrogsfrogs>
 <171150741593.3286541.18115194618541313905.stgit@frogsfrogsfrogs>
 <ZgRQYV_uc94IImTk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgRQYV_uc94IImTk@infradead.org>

On Wed, Mar 27, 2024 at 09:59:13AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 26, 2024 at 07:43:35PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > XFS has this behavior in its reflink implementation where it returns
> > ENOSPC if one of the AGs that would be involved in the sharing operation
> > becomes more than 90% full.  As Kent Overstreet points out, that means
> > the snapshot creator shuts down when the filesystem is only about a
> > third full.  We could exercise the system harder by not *forcing*
> > reflink, which will actually fill the filesystem full.
> 
> All these tests are supposed to test the reflink code, how does
> using cp --reflink=auto make sense for that?

/me feel confusion too:)

I'll merge other 3 patches of this patchset at first. Feel free to re-send
this patch in another PATCHSET later.

Thanks,
Zorro

> 

