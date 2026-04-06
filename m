Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D5D3328E6
	for <linux-xfs@vger.kernel.org>; Mon,  6 Apr 2026 17:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775495139; cv=none; b=RSu8ZNnsdNVYf54jSY5NtQLvnvJ1Zd5/1uP9/VbdEX/Vh+XCsD02eVqP1T8lYGzTuqoYKicUhnUgrcjes9pYBz7ykIXMmzLF42I45ktmHnNzPmUsCU4RYFXoO2IR3mgrdxHIm9/5A2MXInbqiwZ7IRATfON/U0mWDIvNrnhs9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775495139; c=relaxed/simple;
	bh=i1FBzzgd6g25OyRIBCssNPzR0Gi9AaTz7cseTNTRLdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A80ymExqZjR56M82hhQ/Z/KIK0IBNdLo390fBdT06HuIRJaWJhUVnCJDFKfr9cCqmsVUMe4LE6nzJj/M/s4/ZDXLJ4a9Ce+Kjk6atQvJnC18Sci0ZxCVXQIHUz6styFUcLrvQTdG0mSY29WBNc02Jy4lAGjwid9p3bUBexNtWt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OizCd4ph; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MvUXOR1A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OizCd4ph";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MvUXOR1A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775495137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qTwXZ6MKD56LdsiHGj4K7RlXwiXwOsYAGKNXyywo88=;
	b=OizCd4phDmWtyvS8zyq5FA3JD3LNH5GO7xh2A/NNsEldiKnsIar9IjPQF+t85EQWFAx4us
	HFl24X7tNAiBYaP3Ve+ouhpMoHPbc7cfRh+Ng6CQ1Xk7McoGcXSoA7FQdOwruBSCoaez+0
	UaZWeNCURhLVtSNOSd7E/8ow/udUpUA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-7nA3MPojMc6N9bpo7QxZeA-1; Mon, 06 Apr 2026 13:05:36 -0400
X-MC-Unique: 7nA3MPojMc6N9bpo7QxZeA-1
X-Mimecast-MFC-AGG-ID: 7nA3MPojMc6N9bpo7QxZeA_1775495135
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c76c60c74f3so2003536a12.2
        for <linux-xfs@vger.kernel.org>; Mon, 06 Apr 2026 10:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775495135; x=1776099935; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+qTwXZ6MKD56LdsiHGj4K7RlXwiXwOsYAGKNXyywo88=;
        b=MvUXOR1AyB7bmTLpeI01yeJB04RzWrqt2LTf2MQAzNHArMI0xaZF5U0JeO0y/j2Lcm
         1zfpYHFSWLk87ViON1BvykL4fe1L2gvdtxnw8gmJYkBc5zKIF4G6VMC1gkWTuXsqiqBv
         dD40wSqoKGQRE/Mu9Cj54DEdKc8Dhp53OpRC0fjPMMEwRLJ88rFZMk6Am2tVFO+LkYTQ
         Jq9J8sAvmdLXHdBOYevsF7NphLH0vn87M0sGau5pKFtyPy+Nr0Szs3RVGmqVI1WScYRG
         FpPKrNuq2VOjcN5kcLB7j4zgAI6Qwqy9tkxpueA9xvjfWgyu7vYVJMbdtoK8nJSBMDOq
         q2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775495135; x=1776099935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+qTwXZ6MKD56LdsiHGj4K7RlXwiXwOsYAGKNXyywo88=;
        b=XxXZH6+ptsr5Twf3/UKS1x/xcHbQcqAdhtK5C6adLZnKNzRxB3wj2xro06wY5T/jSv
         FQptWisp1qfV4uSAEE7uVPjwKjMAvY/RnMis2+7wlmvufesxS5pg26GCIDKNelT4lcbJ
         jJ174255CLXzOBGTc+dGmIqFSYenlKDspcMq0NhFMAWJt/istYsAkfrnfNUOANvTnCm3
         pgnlWA96qALAd/iMfzFJY2vV3DUgZaOC7ieUCvOZLUGHvHo8KWJVLzZm8NyIU7c8pdir
         +Bj6SWfo/koW17u+Wq/GtWO8qV9LLhiB4S046XePM0rqlX6bTCN/WLCzAHZcSig1lsyq
         zaBA==
X-Forwarded-Encrypted: i=1; AJvYcCX3STRHL6TSoM4RRZL0lxFgblDNo8KwTYx7mf7PQ4xcB+QiZ2VAuF7P1V3J5yON8I73vtAgLYGJFdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN5x0P/RICcZEtHPscs0704oqda/sOgXD1Fe8w+7LGw4liCUtl
	XVMXQpQgdWkrfRepvZtDbp/H10L4CHpJFPPFtiivw1Ga39gHaEC3adChc5u7Ab+KschjlkKUMKV
	e3IWq4inOazX0j0JbweEnj1Vurux2fM9MWP+120GbxItDx8Hw4JHxg2hO9sXjvQ==
X-Gm-Gg: AeBDiev0uK9cUTq+DLUttEX+YbYmAWLVXcJuMM4XAGfr4f90AkT8IQwEnQmudpYpEY/
	zEfbvUo7T5pdQW18pDn5DBM/XaWFlFGnfXwfQ+l70p4QUn12+BI5crjpw29p+NZGNF5ASY/XW4d
	kImaLrDuqCtOj0gmqbZG46wBy1of5qHqypaDBIphzit+SZPlf/ibleqJNLE/mrIe2nbpwaPNnii
	KsVhLE9DYiRzlrIMy7TbJtb2yMpZHWDQUtNuwkUlX1eXTcCz3CW1a5A4RYohlIBRKp820fA5SpV
	GgBYiHxZJE5VaBU8JqZ4oKH+Q9lZ9wDpPQHy9qVgWqOZlBINYG59liICUPh/5WMH/UcQOYY7w75
	bmkrmCf1Y5svg5wE7Ng==
X-Received: by 2002:a05:6a21:a395:b0:39f:64d7:9372 with SMTP id adf61e73a8af0-39f64d798d7mr6631825637.41.1775495135328;
        Mon, 06 Apr 2026 10:05:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:a395:b0:39f:64d7:9372 with SMTP id adf61e73a8af0-39f64d798d7mr6631783637.41.1775495134739;
        Mon, 06 Apr 2026 10:05:34 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6492097sm12917602a12.10.2026.04.06.10.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 10:05:34 -0700 (PDT)
Date: Tue, 7 Apr 2026 01:05:28 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, djwong@kernel.org, dlemoal@kernel.org,
	hans.holmberg@wdc.com, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: add a test for number of open zones on
 conventional devices
Message-ID: <20260406170528.sxcm3qcndjhwm7pp@doltdoltdolt>
References: <20260331152341.4047725-1-hch@lst.de>
 <20260331211807.gofhlabxlr3mdxnr@doltdoltdolt>
 <20260401061828.GA24293@lst.de>
 <20260401075952.ifuz3kqfq3g7c4gf@doltdoltdolt>
 <20260401140646.GA21703@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401140646.GA21703@lst.de>

On Wed, Apr 01, 2026 at 04:06:46PM +0200, Christoph Hellwig wrote:
> On Wed, Apr 01, 2026 at 03:59:52PM +0800, Zorro Lang wrote:
> > > > > +_scratch_mkfs -b size=${bsize} -r zoned=1,rgsize=${blocks}b \
> > > > > +	> "$seqres.full" 2>&1
> > > > 
> > > > I usually tack on "|| _fail 'mkfs failed'" after _scratch_mount if it's
> > > > using extra options. That way, we'll know for sure if the mkfs actually
> > > > failed.
> > > 
> > > Yes, that is useful here, especially if we want to support older kernels
> > > before the zoned device support or !CONFIG_XFS_RT kernels.
> > 
> > Oh, if so, we might need _require_realtime. But that's still not enough to
> > check mkfs.xfs and mount.xfs on old system (then notrun), we might need
> > more _require_* helpers for this test. What do you think?
> 
> 
> I think _notrun if mkfs or the initial mount fails might be easier and
> better here.

How about a _require_xfs_mkfs_zoned ?

And about `_scratch_mount -o max_open_zones=${open_zones}`, if max_open_zones
mount option isn't supported, _scratch_mount will fail directly. So how about

  _try_scratch_mount -o max_open_zones=${open_zones} || \
          _notrun "max_open_zones option is not supported"

Or we can have a helper for that, as xfs/642~644 and xfs/668 also need that.

Thanks,
Zorro

> 

