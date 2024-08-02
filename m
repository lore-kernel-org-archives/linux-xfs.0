Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46887483
	for <linux-xfs@vger.kernel.org>; Fri,  2 Aug 2024 00:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722558552; cv=none; b=QcHmeiZsptkt+QjSHqGH5VFk8Vzz11cv16TPWts0o2GPXmCpamwxRcD8cH9dYKK0oWA1hPF4hr43yDIcjQQ4NRNBNm3NKWLRGzg3e3PNW1sOkJB/vHVhxfWCeL814BUicqbDDjbEGoDV3EXDuk0Y9iQNesy1koi8MgocEV42OuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722558552; c=relaxed/simple;
	bh=f7C3xur2576KgD8plY+LuzrZPRQ6hgZGdeLJ07BtpAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NZsR5e4h1eQbD7gbHlEaQF/Vg3tcHseX6FebPFMzzI03uN8chb3ehx2mpS3gVySW3ORPeu56ZwSg5qIJn+RC1BE71MiVg8Nl/UtpFnfiU6niyvAFRaZl2+XpLgfguL4ye6xvuqbZ6rYE7SdKJD9TOHhWJya5cz0lS7KFNfgx7WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=kArIS1aa; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="kArIS1aa"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fc566ac769so55409655ad.1
        for <linux-xfs@vger.kernel.org>; Thu, 01 Aug 2024 17:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722558549; x=1723163349; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=04k9qg4IdytrkzyB2D0iIks360T3O1nYFYbwjnX4QyE=;
        b=kArIS1aaHzVGI6BN29hlCDHYKWR8A8y//l6neS6IYqtePSRnWOJnu/oE80uwzWP6eC
         712hvV+JAle9Yg77Zkl9QXPzVH2KAGYwZCjtG0fn4kZfeRfVfhFvOzyo7uGy6xyhCG5L
         YCKZN3iT4Ae7tx4InGi/kHQxVWyJyStntqxDjCW4HLMtfC3XdmBdJX0gd6LPbCyAZZqm
         gyIT5AW+qX0ulirAp6FvL22tMpTg9NyP7FOk1hm0/IdlupUOF/jsr/GwkC3o65r0Vs0u
         sVPLLf5mPdnFUpj+UCy2wZTk6BcIwEtdFAvOsCFuvKPZ8VEaKQOiTTv343ptHdWooa5o
         YesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722558549; x=1723163349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=04k9qg4IdytrkzyB2D0iIks360T3O1nYFYbwjnX4QyE=;
        b=xISsEVYTgQQQp68iI4PwP8bXuCRBCtr0huS2ONtkCEfdFeYZjn2bExfdyxkTjPqYip
         Jt70Ic6xz1pSHHBpYT1gkp5bgM0dYH9ja3oWuoyh8/MJop6gAuYDUM3/SLiy3fPs4ge0
         78ZPzpWvheiVuQJPr+EcGkZ2xF6KXFglAek8pBwujr3kZtZMEVoiqEJ6O3/NXN7hmhCg
         J4N62jgSy1XqDnkLfyzNsMLPUr/hWYqbX7IHQJOqxKO2O+/gWyGYV0VwUydYT5Tf0zqG
         oJxfRzjNSltp0Lg9KnXffeijAzpzCOCGbHp60AI1fDrXOQ00uP3vC4hJ88LjQyRhTAg9
         OynQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzsl5wUVvU3exyB6/P5c3pF/rP+6JzdRA/bSRXoDblgtKdwJgsYXPwSY9YtSNQnKg6JjuN0nIlQYqv4ybddx/2njEExHYGrrs+
X-Gm-Message-State: AOJu0Yw7gtUIkNzUhfEeCXkbjEdVnE8m1Jo3XMFptaewn9qIYYI9YFrN
	rBGuRd0UQcTWinKiIJ18I5Q+ul6zMS7pGYgGcTWiLJfNf9AjbO2szbS/YL4Dkbg=
X-Google-Smtp-Source: AGHT+IHwB3NGPRBQpByLo0gCulb92xiWRMQMM6pQpUJuAYVfXcpyF05TKEa8fbev3hkI6xD3C1lKnQ==
X-Received: by 2002:a17:902:c951:b0:1fc:86cc:4254 with SMTP id d9443c01a7336-1ff572e0a49mr24585635ad.33.1722558548895;
        Thu, 01 Aug 2024 17:29:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff58f5a473sm5075795ad.106.2024.08.01.17.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 17:29:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sZgAM-0024Pq-0Z;
	Fri, 02 Aug 2024 10:29:06 +1000
Date: Fri, 2 Aug 2024 10:29:06 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCHSET] xfsprogs: filesystem properties
Message-ID: <ZqwoUhCL42aBg16o@dread.disaster.area>
References: <20240730031030.GA6333@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730031030.GA6333@frogsfrogsfrogs>

On Mon, Jul 29, 2024 at 08:10:30PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> After last week's discussion about how to allow sysadmins to opt in or
> out of autonomous self healing XFS[1], I now have an RFC patchset that
> implements the filesystem properties that we talked about.
> 
> As a refresher, the design I settled on is to add ATTR_ROOT (aka
> "trusted") xattrs to the root directory.  ATTR_ROOT xattrs can only be
> accessed by processes with CAP_SYS_ADMIN, so unprivileged userspace
> can't mess with the sysadmin's configured preferences.
> 
> I decided that all fs properties should have "xfs:" in the name to make
> them look distinct, and defined "trusted.xfs:self_healing" as the
> property that controls the amount of autonomous self healing.  There's a
> new wrapper program "xfs_property" that one can use to administer the
> properties.  xfs_scrub{,bed} uses the property; and mkfs.xfs can set it
> for you at format time.

Overall this approach looks fine to me.

Acked-by: Dave Chinner <dchinner@redhat.com>

-Dave.

-- 
Dave Chinner
david@fromorbit.com
