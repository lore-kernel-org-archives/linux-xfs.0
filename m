Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2971FF5E8
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 23:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729207642; cv=none; b=tWFP2tJ3mGx2WH9wqlIXfjQjiDjeQ/aTSGl5jbBJuSi8NKxQWpaCy56fuwrSWjnndP1LYysctCWLDoeiH56e9x6TAxIcR5GxwsT0CnZ2WJ8L8ozDUMgydntSuDQLK5+1+cW/uOJNSGWyUyyYac4NI6oLolBTLQACD3DPUa/JdwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729207642; c=relaxed/simple;
	bh=VUmD56CRgv94KIZTidY5c+wDBoW9wxtveE3P7Pv6ukM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKxw0Xd5Lk3d8y/SFjb2Ym+fmprlchyaT7gkNTaRvN5hEg6Kcgqt29FNwaBCMzB0AlxrsU9jLZ5nJN3tKXlP9eE7LB0zb8ckxkbWrIzWlMW955weLrAVlbg0hmU9ogLbIe5lIgXpFgvUlAMi+TWozZtRmSVHJMl8DBNVDN6T2gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LDsqeCVk; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LDsqeCVk"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-71e49ef3b2bso1118489b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 16:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729207640; x=1729812440; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r46enQFGl+wIaKd5dnjWHHbxQMYIwA5Q5bAisSSXPNw=;
        b=LDsqeCVkGX0CoU9y2KKDmmyTau8uCk1IRw+p8F6/zGE+oIx80Pwbj9wji2Oeln4tT/
         63zTfc7L26H8QJMyLDI1T/5t5Kvxfsa9FN05g8fKKF/WCAgPtMU5i1h63jAglqyRJcCe
         0vukRvRZ2O9h/AijciRRBaIzioX7fqx9FpJziDVnYNK/lqXu42N+JfbXgXq/XPHoU63j
         1FOq73Sckvtx7RE4wUiQlRgeVK5UxH8deelLv0O6oGdjf6gIlxNMrnrcuhzjcIdRRsoy
         isIK+FJib4o1QShMAcusF/yVC+DhJDS5Ut6hDATFZHjXk1YbpvU2FuXiTh2QE1ysbmIx
         DIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729207640; x=1729812440;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r46enQFGl+wIaKd5dnjWHHbxQMYIwA5Q5bAisSSXPNw=;
        b=KDTVsvnLVAo3j34sZQknSWkzwZ/tU0LNHeShobzsBRCDFi1RZQl/Ayw7+ffJStIWdX
         Z9A5sAXULzZCrL8OEILUxyOWw8ffLCvMr56c0wjbt7T/HcW+ne3gh1nMILXZCS1Gj0ym
         jXo8lK+hsoSdPG65M9nDlqJk4JUSrKPqa15FnW2t3Oz45XeplW1Oi9L00z61uOy8a0Fy
         cc3js5C/6UfxNH0Tk1Rwnb47WgO/BBWcbRX0rB9mhCye7r+w7BTPQ6EUcBrDBf8D4yp0
         9BEe5m5szV7sRoR/aDX94ItuxL/VT4KlniBetc74tSNBu2V82HMRK+IrvOSbxE+0n/Q/
         6nuw==
X-Forwarded-Encrypted: i=1; AJvYcCVOpg6eYOp+uxg8p2ioiPQQczSoGcvLCdPze90dNNjbxoj2jwDAUz4a63q9T+g36iT4YaKHwgVguVM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yze27YfCa6sV/Fb1weoYi1D9awzXTtetA0cE+lGhgpGWqcP6QEw
	9InL7EWalHYRhelPXNbQahQ/Gd4Cq/8/uJpeLC5GlanG9Yt038sgq50bIGdOsTeqKBzxi4nX0vC
	A
X-Google-Smtp-Source: AGHT+IEpP4XA3IZ0/4YLItd69xvGn0Ola/qAc4zC+rZst/ZRgea56OgWhFpPox/WZJeKPLfyLh78Iw==
X-Received: by 2002:a05:6a00:3917:b0:71e:55e2:2c58 with SMTP id d2e1a72fcca58-71ea325b53emr852664b3a.15.1729207637383;
        Thu, 17 Oct 2024 16:27:17 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ea34094b8sm210336b3a.134.2024.10.17.16.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 16:27:17 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t1Zth-002E4m-0W;
	Fri, 18 Oct 2024 10:27:13 +1100
Date: Fri, 18 Oct 2024 10:27:13 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHBOMB 6.13 v5.1] xfs: metadata directories and realtime
 groups
Message-ID: <ZxGdUfNuCD+/qMcw@dread.disaster.area>
References: <20241017184009.GV21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241017184009.GV21853@frogsfrogsfrogs>

On Thu, Oct 17, 2024 at 11:40:09AM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> Christoph and I have been working on getting the long-delayed metadata
> directory tree patchset into mergeable shape, and I think we're now
> satisfied that we've gotten the code to where we want it for 6.13.
> This time around we've included a ton of cleanups and refactorings that
> Dave requested during the 6.12 cycle, as well as review suggestions from
> the v5.0 series last week.  I'm jumping on a train in a couple of hours,
> so I'm sending this out again.

What changed from the v5.0 posting of this patchset?

A change log would be really nice, because it's kinda hard to know
what needs to be looked at when there's no indication of what has
changed between postings of a patchset with over 130 patches in
it.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
