Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3221C167
	for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755873641; cv=none; b=gKlwHFVp8zGw//9+n+vyOMCUJpIa3zlOUUS5HEBauZ16tCXHMSSSfphJz/ieH+qt6h5/PDDz1OCQiBGXDNxWP3jp7z6/HIce1Y6y+Uqb0Sn2D9xM2zjENDB4PLGBA4LWGeU+teGJO89SPtiDNX9m6h4yNpPh1tfqU4+mD3TuC/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755873641; c=relaxed/simple;
	bh=fEOMn/md0OE1QvUICBnX8O+3a7PgQ6vANjZfZQ8gxr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiiiCf9ZTE7ZBnPqdJEV0NzSXXPT1NQ4ClriuhjlmmM9P5gsJxJFVorGXKR43iAMYGANM/PvE6mlH7Ui29zI11VAQkA5bL2LMX6D6jUQxdEBfcZwiUE1SZ2Zuq3N/yzWyXFlwgI49f/15uQgWsOYRGZIxAp+5Yq0FspCSPasAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=none smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b=lZQvjLYh; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="lZQvjLYh"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d5fb5e34cso21094837b3.0
        for <linux-xfs@vger.kernel.org>; Fri, 22 Aug 2025 07:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1755873638; x=1756478438; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v3OogfFXdkMqRNtpkZ1fUtnIz6uf3uzEeX+PeKEs10Q=;
        b=lZQvjLYheqIp9V2Ez+RTb2JAres8DKTut5o8p2IJo57s0eCDZm9/podHwP91jEwTQv
         p9qJJ3sDzFkUDpL1Z1ai1PRQeVKLy32Z1zJxWbfeTKAvzfENO3UUc72tdg+C5A2L9G+4
         w6YFH9XDGVNJguysAG/VCQ7iWmZ0GkmFHI2uoX+SzK50/hxA0DZpBCcg4xnTJsUZCokR
         9PQ6+V8d60M46pMHmBPcH8xzmcnpLNGPkuAPlgiCpgEX/EJzBSv94g4AdX4DRymLbFhc
         cx08V5P4Nc2DsD774SFP96FPUus8q24pA77zbLJlAppusUSHqxzzQ2vh3WX3qSoYuCkO
         1iTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755873638; x=1756478438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3OogfFXdkMqRNtpkZ1fUtnIz6uf3uzEeX+PeKEs10Q=;
        b=Ek8oH8IyQejcRAe4BWS6St1ybm69WclRyHqv/YXIK4GuAW6ClzE2RXbBikvdpy2Wda
         dB4NikwDmF3NLDW0KRj45yUvCnGIPiDpFGB8hLMy7NyfiHLZ0YtEG/jeIqDakM18KHK7
         Me8cpM2tWEedvnkMIm5ZUJ4Kyds1J+bPtXl+wShMlCix9kniiUCSj+56aSX3qlrH90Ub
         YWB/C/3cbORNxqUX/6i6A12kq5Lo8xR3XDc7lB3DBnfNS4xbVlR6we8fVzJ64XCCiHaf
         gNKcnyGqHxbvUkbWR51OLsCclPbF7A73FrqZO9yv2+HObawwOZ3vHqRNqIscspqDaWtJ
         R4Pw==
X-Forwarded-Encrypted: i=1; AJvYcCXat6zaI2W8DtQPmLtCMFvc9hOHPiW539fgfkuarucCeGODkG0rQefCtK447EvL3Fn9KcSnkI1PoJA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEWq9anYuPyv0wXTcLSRCt97ixH9gmtqgoQ0sbSUX95muqS+Hn
	k2W6Dg/aPOWdIwunpPcau+59EeBn03JwzOIQYZXO8H2msfqgeZHIA9eJ1tytxJOVzP8=
X-Gm-Gg: ASbGncvb/0oEhJIwc2q3FO1cO0JMbGI1zqdXv2EKcn7jvHvR8vwmPj7HFiGBLJSdzvu
	brfB8vHlbINPXs685/PcS6zGykyevhaQwOdntrDbbvSzfLuPgtf01pYWJCZ+o73B33rE8LyJLBk
	wMLBF/QbfwfI+OthdJKkKyn1JCUccQAkF8T1pOTpyKYp1YfM6m783GzUBDpc9w38/7yv/FFb3eh
	pQCrvPeAtIRzltoKueF/tzJhlDvl43g/5ufFEzD/ZbC79X6HVoPki+GE3VXgg/rkm7wWlwfrxZY
	Ns2z8nuU5ZzZ2bZ5/LabUNjfwG8oskGpIjItgst9M7xHyJkRTMomQoqcAehUAj3E39byzVYIGGH
	4MGQqfdB3/HMMDOJk5py86HhKahWvV6C38t1yqdNqWZNxXhWj0MUq+vqgOPA=
X-Google-Smtp-Source: AGHT+IHOy5Mb0Jt/cJA6ywQp6sLORvyAzia/tx+cqSm3UKE5FfWzv+W3sub+zG2wAFxqmQLGUh57tw==
X-Received: by 2002:a05:690c:6bc6:b0:71c:1754:26d0 with SMTP id 00721157ae682-71fc9c664f6mr55261597b3.6.1755873638329;
        Fri, 22 Aug 2025 07:40:38 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fd92b885fsm6937457b3.10.2025.08.22.07.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 07:40:37 -0700 (PDT)
Date: Fri, 22 Aug 2025 10:40:36 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Sun YangKai <sunk67188@gmail.com>
Cc: brauner@kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 02/50] fs: make the i_state flags an enum
Message-ID: <20250822144036.GC927384@perftesting>
References: <02211105388c53dc68b7f4332f9b5649d5b66b71.1755806649.git.josef@toxicpanda.com>
 <3307530.5fSG56mABF@saltykitkat>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3307530.5fSG56mABF@saltykitkat>

On Fri, Aug 22, 2025 at 07:18:26PM +0800, Sun YangKai wrote:
> Hi Josef,
> 
> Sorry for the bothering, and I hope this isn't too far off-topic for the 
> current patch series discussion.
> 
> I recently learned about the x-macro trick and was wondering if it might be 
> suitable for use in this context since we are rewriting this. I'd appreciate 
> any thoughts or feedback on whether this approach could be applied here.
> 
> Thanks in advance for your insights!

That's super useful, thanks for that! Christian wants me to do it a different
way so I'm going to do that. But I'll definitely keep this in mind for code he
can't see ;).  Thanks,

Josef
