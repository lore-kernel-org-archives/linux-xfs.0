Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D22338936
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 09:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771492859; cv=none; b=qweTz/cmtaueCnRr1+eDqYv5//B1Xz5WgoEfwPqa5HCzS5IkGXhUS1ITN0b0Me5yXNmz+6qPBVkU2ndd4Y7HELeKIBhPybGfHSrDP1RHq7gYjlya1yJ5I88xKFSrQOCmVwyRnYAcBys1FPDrHh5Gh+XSXY61WfVHWFOxIaTWYTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771492859; c=relaxed/simple;
	bh=xKXts/skz0JyIelk8FhsIJVjS5AJwJaHz2pl7SfkktE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ufwn/p3hQKIuIn0UB/9PlEf5ECqeOWehJv8HlX7uTiTocNxKF+6fo/0CsIIdx2sNgoYsNTggiRhBH9vp2OArHpRP8G3QUo98nxucFQgIBWQOcWlMDJgcYSwW1aZu4cKEhrEzAhO80bKF/3dAsKPt1mkwndjyYyHNU/N/nHmgd44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HhSlNfq1; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HhSlNfq1"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4362d4050c1so714731f8f.2
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 01:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771492856; x=1772097656; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FlmjqWniPC3jVFM4ecKSA8vcZ4REL4AR5R1sKakC6E=;
        b=HhSlNfq1aK66riOhvJRGmKVmwUE9x101pY3piUYViH0cXEwhc5pbTnZh89v7RoVCQm
         Ro10cpiJoLdVuA2TyGpc/DdErnJY4Eh5IJap8jQs6bkwlAj4rq4UYjuDQwGRii1NE8Z3
         MYVIZwI0OgLdJbP4KhLNIFrU/UEXH4J0q1uahFzC6qTHCrXobXMUY78hLK9V6DquDnM5
         zCiJu++S9g5GRkCCq6rCdHTzxkvr6SbklmqxQo8WUbt6dnzNUrK2nh+UYvD5W0OZgO/p
         0pdun0Vw9ULnbRav3lMAh38AkvXxHqaKWdNCkyIPl9n6uwY9e+bk7LPV5x5NaqUakA99
         25bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771492856; x=1772097656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+FlmjqWniPC3jVFM4ecKSA8vcZ4REL4AR5R1sKakC6E=;
        b=CNJsrYbIBTkZ6tIDHZdPACJQiTZzeQFWCUaZdaa7yjvcagDKGckvcTU4MDBPMe56Tk
         5yYVzJJ/VsPMeWwBDdPvxEVnVjN4ykplzvWE1DPIW3h1IoVislVbXALGXoS/WFaofKbd
         l5BGOYHOh3v9coTrO2UdobqQvTHqWVML2SXfvrfjrUG3PRhogJVjdDMaN+6UMUqoW5E/
         ij+lUgREREyr/9lQfYjLI88/dGz1tU4ip3llL1zvx3masE47nwcWSoFYlnviaOhdp+wZ
         2V9D8BgDPI9NJVpUa2mZq2ABl6u2LhHWN2sskHDSPj14AXn44o490FB+rHppRLNyiROm
         vU7w==
X-Forwarded-Encrypted: i=1; AJvYcCUgpKp/5qgAU4Zlf4Whow/SptYkLSj+D+gvXBAET2zTCcWH9ZDCzLbgmF3Ughy3pOyOWhh+9IIE1Go=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJ2Sd4Q5GQKkLBrORWm9iEp5vPUtw44z3QJavm7hYDIHZTI6jf
	coIDHG0WSyhUu2da78aVwDaUs0HK7n+2z2sucbCiln5FYt6cq1apo5m3FOQzlLueW9w=
X-Gm-Gg: AZuq6aJ9Q1hxmsrIFPH4nmD0HSILtOyLK5jSwwbTI6yldLkd4KPzynzPjtGPosm0pSH
	nCS6Jsl2bPwEQKcPIwzzNjd9wyUkF6E9wa7NdugZlRVK4TyMNknusq1sZhESFQBPURMd5Hvrkxo
	52gZRKevo0WaK0nVwpKJ+TObrzLnLDeu8X2bl8gX4Y+HfM/LNq8nEItMP2hj5C34naJGKPy0y7p
	U1N6a8kKuPwrOLT69DEohr0pvdVhH633cVUzeXFimBN+5RdB3vg0w5rO2RHpKxr+yj82+X/OWTe
	+8M+my3EinbPlObdNSveNGB/Hmt5eorzjU7guvfeeDUraLFqJwMKXIdLHEK5AkaVlPkIjOc4iAd
	cWE01mx9YS67hFVi00x9SVR8GWpH6lk9r8q234iSDGz9o4Dl8nyWUAfO3ZNPpDRu14AlaVqrtGm
	tA1zTNNmDjnLThlqx1XusDP0db88o3UlQ=
X-Received: by 2002:a5d:5917:0:b0:437:99d2:c115 with SMTP id ffacd0b85a97d-43799d2c495mr28106790f8f.26.1771492856402;
        Thu, 19 Feb 2026 01:20:56 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac8d82sm48035914f8f.31.2026.02.19.01.20.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:20:56 -0800 (PST)
Date: Thu, 19 Feb 2026 10:20:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: Dave Chinner <dgc@kernel.org>
Cc: Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Anthony Iliopoulos <ailiopoulos@suse.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH] xfs: convert alloc_workqueue users to WQ_UNBOUND
Message-ID: <aZbV9tqatNGbKRqF@tiehlicka>
References: <20260218165609.378983-1-marco.crivellari@suse.com>
 <aZZmVuY6C8PJMh_F@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZZmVuY6C8PJMh_F@dread>

On Thu 19-02-26 12:24:38, Dave Chinner wrote:
> On Wed, Feb 18, 2026 at 05:56:09PM +0100, Marco Crivellari wrote:
> > Recently, as part of a workqueue refactor, WQ_PERCPU has been added to
> > alloc_workqueue() users that didn't specify WQ_UNBOUND.
> > The change has been introduced by:
> > 
> >   69635d7f4b344 ("fs: WQ_PERCPU added to alloc_workqueue users")
> > 
> > These specific workqueues don't use per-cpu data, so change the behavior
> > removing WQ_PERCPU and adding WQ_UNBOUND.
> 
> Your definition for "doesn't need per-cpu workqueues" is sadly
> deficient.

I believe Marco wanted to say they do not require strict per-cpu
guarantee of WQ_PERCPU for correctness. I.e. those workers do not
operate on per-cpu data.

> > Even if these workqueue are
> > marked unbound, the workqueue subsystem maintains cache locality by
> > default via affinity scopes.
> > 
> > The changes from per-cpu to unbound will help to improve situations where
> > CPU isolation is used, because unbound work can be moved away from
> > isolated CPUs.
> 
> If you are running operations through the XFS filesystem on isolated
> CPUs, then you absolutely need some of these the per-cpu workqueues
> running on those isolated CPUs too.

The usecase is that isolated workload needs to perform fs operations at
certain stages of the operation. Then it moves over to "do not disturb"
mode when it operates in the userspace and shouldn't be disrupted by the
kernel. We do observe that those workers trigger at later time and
disturb the workload when not appropriate.
 
> Also, these workqueues are typically implemented these ways to meet
> performancei targets, concurrency constraints or algorithm
> requirements. Changes like this need a bunch of XFS metadata
> scalability benchmarks on high end server systems under a variety of
> conditions to at least show there aren't any obvious any behavioural
> or performance regressions that result from the change.

This is a fair ask. We do not want to regress non-isolated workloads by
any means and if there is a risk of regression for those, and from your
more detailed explanation it seems so, then we might need to search for
a different approach. Would be an opt in - i.e. tolerate performance
loss by loosing the locality via a kernel cmd line an option?

I am cutting your specific feedback on those WQs. Thanks for that! This
is a very valuable feedback.

Thanks!
-- 
Michal Hocko
SUSE Labs
