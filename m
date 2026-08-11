Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15FB3A0B3B
	for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 08:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786436298; cv=none; b=s32lrLeWpjGJ+vXMB21RsXQEDka0vuoz0ywKL6BGrWnOqE7g4dfqDN4nugnA213aU4G4I6/ftsGIJm7yC8/Gd7xknHKBAjcK9pQ5c3QaB/yiPQbmcdbVhp+0UXUjdHn9mx/HpEVunHJsm1e2bdefFSjQAnrjf2HjNmdyHstVIUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786436298; c=relaxed/simple;
	bh=0m0VCrVFS50IL0+ZPUc8eV8aQ+yXJjlZWMeXsIJ1aBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPzqgSc6QDtboq2SyJv0swUZvrgXDhx7PUFhEYJ6Hsq4pUlutZ2nsdhRzDnPqb0qJebwgo5hywdcua0tz2GP+Xh0GX68f7rUnM1qKSZlHdzVghS/pbOF9+8DLrcnQu3Be88xfCbGan3QtL6QIlHHQoQQpoqHsXIMnCIZDTYsCK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WVCboBiv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QmpED+JA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WVCboBiv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QmpED+JA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786436295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rQoYgawLl/uFdgKGximNInLlgWg1ECp2Ql+MmIdl1KM=;
	b=WVCboBivTiubRo1WNpL6u6DYD/OQWnjxQ5FFCQWfNGpKqdLXfrsIvyhMFTBBywKfJGk0kC
	TQ+d2IxSc+GY6vUXqzALbmOmsKAAkmvURSTDDWSIuP7UtQZ0OZZmxQ5jqcESVgwLMZjtez
	DxsLsQm4AucY5qMmZ4cQ4Ra7jOS0knw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-qkbPQLdMMZGUsx6NN6tXBg-1; Tue, 11 Aug 2026 04:18:09 -0400
X-MC-Unique: qkbPQLdMMZGUsx6NN6tXBg-1
X-Mimecast-MFC-AGG-ID: qkbPQLdMMZGUsx6NN6tXBg_1786436288
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4957287363bso16397735e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Aug 2026 01:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786436288; x=1787041088; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rQoYgawLl/uFdgKGximNInLlgWg1ECp2Ql+MmIdl1KM=;
        b=QmpED+JAJESU5FyhCyTatmFHkwiMWEcr86kck2O1E19QIoD8iACqFSniC+z71Bpfq4
         lHB1cC5988ZWcEpXS2jBbpl+8bXcTaLF8Ptn6iuAQctnkw0EAWlxJH5T4lbUGq24RFMp
         GJqAElN8kpyPqFyZbfxEMzC7fY4Adwq29Anc1K6TT3RoJ8W6Cepb59LpBtoTldmd57sv
         +RK+pY23KXHX7vOSXvBWA/75gbtexXvCU7XavuoLarCi2r+Po0wiHkarYvRaQnDOgE96
         T/kbvYnmh4mQ1APbZLZmE5zJErEFlCpDXIta8RUNNQp2k8wDRzLHurpwSIdNXVBl5PSW
         UJ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786436288; x=1787041088;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rQoYgawLl/uFdgKGximNInLlgWg1ECp2Ql+MmIdl1KM=;
        b=G6mc9lJVMz6HWUu2iU2TBYnce9yzCdrKIixxGx9Ki2XRqn9/Sc+j683EhSvzB48Eai
         ZR1wx1obtgfnY5+gLb79zOOJKsJFr7NnYs1dbFrK4Xrgs522XbA4AOYF8n69O4H8hLvy
         wDEeQDtMiHXa/gd1bAAJ3BKqszs7L+uxsJkKOTI5zxwxgoO0cRnyjahOY/kXc1lYHT67
         p6brGKFhPG1SuSzMl88kBW8sLxqB2rpqFE0nWEfddwJp4wGmeTo4scZMHHS6Hqp+jm/C
         iLqIknO5sym8gqHEKJBxuWf0SjtjnykrBf522mI4cWaus/NPHjkEIuvh5c5rMY5wO7Da
         d2LA==
X-Forwarded-Encrypted: i=1; AHgh+Rpf/2cupxQL1QxUOORBaHdeluE9zxsZ9vZdq/MXx6FOZhnz3kKT0FGYzBQgycGWTo1clEHcLDwZ7tM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHNwQRDy7v9H7fJxqjDo8rZOG0iIPhhzFh+4aAcOIyP2G5+coj
	BdaXsUH/FwvloyYnQG9H53eClp2O1RsCnBu6+kbkg0vtbb7smYjTYKGElbQrpYVxXuGkXEs5X9K
	kp2CNt65ODggO0OMyDYa5O9i7tyuokKLGVtgea5vcwWYEBcByttuED80X5J/k
X-Gm-Gg: AR+sD123rBaiuBi8JJ9r1vvgS1taEyOihOkKrL8OVJ1w6a8LDIl/JIR63iKWSnb8a9E
	SkYnSER1RXuT6QBDIMP+iCaogQ4ttJal+q54Xdxou+jpMyiIDyaJbOUkacwYESrAoXHutxHrN1+
	hCCf1eQRdl4AaA/HkOIlTtZ9hguLTbdmbIW8zrPPNYEOVZK8T7pBphpkfq+JJPhZaCkjmm/mQAb
	8V9kPG9Wur6jEJUWvw1K665tCtcK9a3UTECVjaLNQOlRfFrdN/0tImTZncQVqlL56JPX6d7f9LY
	ACXBZvHTNImuOTDRaKYWOCuE4ZyRDo4eFKd2tmTLFJ6UcSy2hFkweLjLH4bb77syN/qvnnbNCpg
	T80i1b8umZu2Yi+YycIHZSzw6sZTTeA6+tr5/lQ==
X-Received: by 2002:a05:600c:4683:b0:499:5210:c537 with SMTP id 5b1f17b1804b1-4997842c1efmr23685975e9.1.1786436287867;
        Tue, 11 Aug 2026 01:18:07 -0700 (PDT)
X-Received: by 2002:a05:600c:4683:b0:499:5210:c537 with SMTP id 5b1f17b1804b1-4997842c1efmr23685055e9.1.1786436287342;
        Tue, 11 Aug 2026 01:18:07 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499788f11b8sm26013505e9.10.2026.08.11.01.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 01:18:07 -0700 (PDT)
Date: Tue, 11 Aug 2026 10:18:05 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v14 13/21] xfs: use read ioend for fsverity data
 verification
Message-ID: <anrZR9SarXJMBLgI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260803200820.393203-1-aalbersh@kernel.org>
 <20260803200820.393203-14-aalbersh@kernel.org>
 <20260804183632.GO3556460@frogsfrogsfrogs>
 <anmNNNNy4YsV_KLB@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
 <20260810183102.GY3556460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810183102.GY3556460@frogsfrogsfrogs>

> > > "If we have fsverity and block device integrity attached to this bio,
> > > we need to run both validations from the separate fsverity workqueue
> > > to avoid deadlocking due to fsverity issuing its own reads."
> > > 
> > > (Assuming I understand the fsverity && pi case correctly.)
> > > 
> > > One thing I'm not clear about -- why is it safe to do the fsverity
> > > validation here if PI isn't enabled?  Can't that also issue IO to pull
> > > in merkle tree blocks?
> > 
> > Without PI, fsverity metadata is read without XFS bio completion
> > path, we don't get here for the descriptor/metadata reads
> > (see xfs_get_iomap_read_ops()). So, we won't block the queue, as
> > data ioends won't be mixed with metadata ioends.
> > 
> > With PI, all fsverity reads goes through this path. We could get a
> > case that data ioend is waiting for metadata IO to be completed which
> > in turn is pending for data ioend to be finished (due to batch
> > processing of multiple BIOs in the bio_complete wq).
> > 
> > So, this will issue more IO, but this IO will not get onto this
> > queue (it will go through iomap_bio_submit_read()).
> 
> Ah, ok.  Maybe add to that comment:
> 
> "If we have fsverity enabled but block device integrity is not enabled,
> completion of the fsverity metadata reads does not require a workqueue
> so there is no deadlock potential."
> 
> then?
> 
> (Just echoing you to make sure I understand completely.)
> 

yes,

I've changed it to:

+       /*
+        * If we have fsverity and block device integrity attached to this bio,
+        * we need to run fsverity verification of data folios from a separate
+        * fsverity workqueue. This is necessary to avoid deadlocking due to
+        * fsverity issuing more reads of fsverity metadata which would be
+        * processed by the same worker in the BIO completion workqueue.
+        *
+        * Without device integrity, fsverity metadata IO will not use ioends for
+        * completion.
+        */


-- 
- Andrey

