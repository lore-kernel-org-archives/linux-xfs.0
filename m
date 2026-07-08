Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821FF403123
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783499989; cv=none; b=U5Z7BGREICxTsOk3P2laRxzbtGJypy6dNiuC/iCtPp4LXR6FuWyXP7+QIvwW1UQJeeO1foEZt0D1gvJYyQgpNRKBhQpwThuXVukmtgAafvNrhkt2NIpUgp5B4nPfi0AIMu1OkuaQdeN+aoP/6piptV4HBGipfjf0DJM4ioKXDks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783499989; c=relaxed/simple;
	bh=Ob8GScNZGznU5ShQThV1mxj68oqOeGtITVzi2m4X3ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=es2ygx/+yDYCevxgoU4vkdrYiroCxiAONPmxQfoze76EQcXvIeU8pKY5dHsQ9nMMii4dm2mCcwi3ikPwWWGdE3kcl8iTAmQsr/vgNRajD1MGNI5Ym4q2Hykn2kZSYOxpLzge5i2INsEjUHx6lHNV9131LNKKYtsfgKzLixy1wJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ah9FRcy9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oc1k9ybJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah9FRcy9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oc1k9ybJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783499984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dezo2x+q0iTGKqBlE9igj9Nqmyhsk4+11KZAs0z1C8U=;
	b=Ah9FRcy9EUWnUbthbCYcSYcapRjs71Y1FgxyTwHRybcFLAm7rJ1xPWCsS6uJNBd3D64hgv
	R8A5uXoWl2B2Qgew0QHlOKES4+wEl+elVtpTVLx0/NyONZLxzhMggbqx1TobuTWjZfTYXm
	etYmICwmd7Ab6pSzkb90iAcEBNH/e9E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-x5LrpeKnPwerhVvRi4e0WQ-1; Wed, 08 Jul 2026 04:39:41 -0400
X-MC-Unique: x5LrpeKnPwerhVvRi4e0WQ-1
X-Mimecast-MFC-AGG-ID: x5LrpeKnPwerhVvRi4e0WQ_1783499981
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493d742c668so4560625e9.2
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jul 2026 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783499980; x=1784104780; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dezo2x+q0iTGKqBlE9igj9Nqmyhsk4+11KZAs0z1C8U=;
        b=Oc1k9ybJa7GgWQBh+/yXxGqOkvZGYjNmVqrQvj+t8e56ejE/GbUu33FHJXIr5tMw8t
         6PDvOT7IHR+MD22tFbttsTU3AcQrgEbQPsNQKpRYHkw20xCa5bBACi7DOYm1yI4NKzL/
         yarnRvruNY8ELCMInZEqTz6vbhBm6uWicOB59RK2Jl0Mct8Yn9IR4+Rb4/V+ghn5uas1
         lnyoltCZI2dFzLq4LhjhrJngk/j2Awt3XVNqcJvUrBNsqURA58zqP6AG1yB+oQ/+TjC9
         AGo5P5mYSwHug73vhznh9hz5Qpry+Opy87gbij3bWrs4BDPhcaYgB6+YwYdPt0SYV3jj
         Q4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783499980; x=1784104780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dezo2x+q0iTGKqBlE9igj9Nqmyhsk4+11KZAs0z1C8U=;
        b=CKwdnUOuoW1Geq5RcNUUSxg+kUAFijJU+UMMak/JVMDtBB6wET/JiqnipzHMoMlnkF
         N8uCl2AOgqrrqLAgN48PSTo/DAsY2IRrMYHvCr2O6HwC7Wjf1f1471wFq2ByzuZab9+j
         yJDyjufovrPqbfVNFv7ivu6Xj4rpgP49jMImSgN8wyhzQt1IKajcZAFtVdk4x5jXmbyb
         nco30hWoq+8yxb2oAvb3xJ6JQzzjFRrTbVEvHKt69kjeVQT7MiPpDtNkYX/TVZtfH/Of
         4tFMdzN3fMbcHrWS+r6tZYfSf10qtgdQhU/yP3LT9Rs/YPKRy0XIeQRVYZc5OmtiyIwF
         74lg==
X-Forwarded-Encrypted: i=1; AHgh+RoYOzgpPXcUaN1Gh2Pck9JtJ92dmJHJurpBlzOP0nHhiKLK8xAhFW4TYbBLcdFboTAKoRfllT7oSQY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI15qPv3GtV1riWMi7CjSKQRN5cDZRW3MdvcUUr6bxu89ioBqn
	MB+VA0W8BsNvCcdu8GNV1y6B5W8BdsEQaP3AO0Seqx/7ka8J+eYiI2pppvnz+kS6/0SlOhygXt+
	fqOYXxffHlLdY6S/KA/U9ZNqiOOTvDXpZ2tfFzbuVMCPErBjAHsarg/QYqjvi
X-Gm-Gg: AfdE7cm9mPL7jbr4oe0SawkGRVR+ROcK6yCNQrqF8kr5H4iNru9AN5MXe37dvJj2Qkp
	z3q+OepUegojipbitjkTIogzTmgcp8fe1D5p/PNFBzRSpbnT772eQVfPbrMaLi3VrXv81S5wX8W
	k/5ntLu8G/oChKGuNhY05A4BCHfHCLbBpSkH21IUfXSsUOSFi5eh7Z37lUyPunG8pCAumx9NLFC
	QNDTE83ig+klwchYpts8+CyN9YlVdl3JUDDl2Yi0Xy3tBk3/2FXUrI5nUGhoYw2V0WPosXibsEp
	9T6C3x3qM8UmpQ9P5kMWsSnAFXk+GxE7M1xV2Q6ggWHTZdbGdJptOI4Ya3mW0e7kKpZrkmHS56p
	iBcPJ97RsJEAmtkJf+sops8izRbInOb6y/Z46yAywILLPiw==
X-Received: by 2002:a05:600c:a55:b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-493e68635e5mr14596315e9.22.1783499980533;
        Wed, 08 Jul 2026 01:39:40 -0700 (PDT)
X-Received: by 2002:a05:600c:a55:b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-493e68635e5mr14595815e9.22.1783499980037;
        Wed, 08 Jul 2026 01:39:40 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e10af550sm122137705e9.1.2026.07.08.01.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:39:39 -0700 (PDT)
Date: Wed, 8 Jul 2026 10:39:38 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <ak4MI5zbSaQj91-2@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260701145124.GE6526@frogsfrogsfrogs>
 <20260706065035.GA25419@lst.de>
 <20260707164202.GD9392@frogsfrogsfrogs>
 <20260708081334.GB1198@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708081334.GB1198@lst.de>

On 2026-07-08 10:13:34, Christoph Hellwig wrote:
> On Tue, Jul 07, 2026 at 09:42:02AM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 06, 2026 at 08:50:35AM +0200, Christoph Hellwig wrote:
> > > Btw, the current xfsprogs for-next fails a lot of xfstests without
> > > this.  So it would be great to get it in ASAP.
> > 
> > I'm assuming Andrey saw my most recent PRs:
> 
> Note that the failures are without any of the series, and none of
> the series seems to include this patch.
> 
> 

I will squash it with the one from the branch (they're the same
except added to different places). I was waiting for my testing
to finish overnight, will send for-next update with this patch
today.

-- 
- Andrey

