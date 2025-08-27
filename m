Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E51430C374
	for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 21:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756331223; cv=none; b=K4RrrXezmU5ifwshodpPpmwlYUAfAOLbTf/J07R/ai7oupIkRgc4lgFKzpCmSyGCML+I8Fzsjhl4bgUAeEa466oj4QVUW6as6mk1KyqACGDzM4Bzx9TkboX1PQVvgD7XKyYaaMJZqMPb3uai4YmHc9InY/w7x/J69r0B24TEKx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756331223; c=relaxed/simple;
	bh=p7brPDy2olHFfAC7S4q3Vp+PKM6Nm9aH82XdvCJ8awI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cp8crw7wPkwfpNiPgPfFK/pXx65ch+hxHFa5ZdmbUJfoqYKEtOMG19WRI3rnFOkSJvOFUo+UHeBJSc6n4cBCEZoDesHCfNPcT7H/oKATu67n71kdKAQ1ARzGS5wYOFMcbMY+ZTBi05G1D3Hp1pfzp0k1qdvkyCSCie7g+VzxSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=oTmL/8S2; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="oTmL/8S2"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-771f69fd6feso435129b3a.1
        for <linux-xfs@vger.kernel.org>; Wed, 27 Aug 2025 14:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1756331221; x=1756936021; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1brA+k4hD/Yqcu3E+OzWK4Zw3vVchK7SPI3ZmUa+ClY=;
        b=oTmL/8S2U0QYx+4QQGCxzpTYxxbY2M847yIFjACe3uxKSxUtpm9qlqz7Ets000hEGT
         eIlJIh/5HkEN4W8yhMs7iQIcBBI8FCGR6qgATvk8QiXPmAACVNI2FuqOYKsPDLtIC01u
         W5n9bD10pqz1hqvN39di9RF5l7AwgDEZevx+3g0lZpbypK6Mg9oIF2eJWXPanYxofjOF
         sfFkKPdVPpnOU8VyGa/MjGDpJYfJSq4ccjwXjn9iBdSNAR9wIaImSVISg9EHkTjc4TcF
         aqb2Aygkz2vYxwm5obVtQ60Ayx/IneMQkZDZKAS6Fg/q94wLCXZAqV1rvfPcFRjB/hBz
         ADRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331221; x=1756936021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1brA+k4hD/Yqcu3E+OzWK4Zw3vVchK7SPI3ZmUa+ClY=;
        b=B8qRwi2idVnsMfdZsQbDD5pROV1P/8v1ANTcnd3FJPNMArs7h0bIi8KcYaySqZUbLL
         bZmNqXtPqmXHQcWIsZorhOPzAmeaKKU7kHg91AFY0MEUOvSqU1URDgDSmtTl7n1VjwVk
         8+mGHmHIoz/K54cElHgQjF/ZJZr3j04fW36hsC24kvcMtcOmy/QbCqzt2I4+xDXpQAJU
         r4Y72YBdzTGx/C5b5rcJiLd/jSbpzplKZWbHjO/gRS8+5a+Im0GrlvmKhdHFJ4QEPp+F
         z0qtvHS7s8o0t47ehVGiXKuNfEftIJ04PWPvGJ0u212E3Ire8NeQbcPUev2DqjE10wc8
         O/uw==
X-Forwarded-Encrypted: i=1; AJvYcCXBe89kTTM/jNEN72Hzg91n3NPeifmsS73sLgQqRf49EGNS1QfNwQI/+KJr5o93zAfLYezR90yrG3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqUwAFhv9HdRG+mAy8eOhlieIC4E/5SAbRZCzJvnkYKfVZ2gZ6
	mnGpCXUQRvZ0qqnEPDeECpHny1keNhDR8EkVOvCDBm+8PwCudg6A25vujI0UKj8KYu3T+ciuwjK
	+4M8A
X-Gm-Gg: ASbGncsy/LZv3bp0OcGaeQHldbjEkhudJdiGI+ITsEidfV8qvx9v1M1JUdCTv1fQlaw
	RDUpTV7nyEBxoxY2vOhR8Hl4eSlKkX1uFLxCLQx1/xzrT3wJEQT7VR8wI7MGDoWh8ODS8LwqWA7
	1rsGRGOZiQnVo//w7YEhvu3zxxEvXxF0aWzScXOcGYrB6C9G4Mpg46+9eVDFaA0N5oSVYCTN/X2
	DlZUZCtyogZxq32/dznHG5QwGkO0+ItG66vmyPFxdAP7hZiTRhbQEUr4bpJAx0eVuFjCt1h9Vr4
	UWn+3+CZbrL/vM39Af2bFpzUdbqA8F1UAqkGiXkjUpimL2G7XqV84kd0gPhS1YenZbZhkdtL4c1
	vPLruOQbG55sq6pnty6mpVJKoRMrBTsUPWHXbWUTMTpy8I1eZSI7JZ+KoamQ4jqwQ7AGGceRroR
	Doc2Dr1qdi
X-Google-Smtp-Source: AGHT+IGwubMhrkeveyZScO9SyGs6JfX0VeRusyOBY+29aVn++TMuUkFVK5pCfTn+imoo/NPkWa8qcg==
X-Received: by 2002:a05:6a00:14ca:b0:771:ea86:3f73 with SMTP id d2e1a72fcca58-771ea864584mr15877772b3a.32.1756331221445;
        Wed, 27 Aug 2025 14:47:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771f34ecccesm6566839b3a.61.2025.08.27.14.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 14:47:00 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1urNyr-0000000BvQF-035E;
	Thu, 28 Aug 2025 07:46:57 +1000
Date: Thu, 28 Aug 2025 07:46:56 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, brauner@kernel.org,
	viro@zeniv.linux.org.uk, amir73il@gmail.com
Subject: Re: [PATCH v2 16/54] fs: delete the inode from the LRU list on lookup
Message-ID: <aK980KTSlSViOWXW@dread.disaster.area>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <646d132baae6e5633064645e677dada101681850.1756222465.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <646d132baae6e5633064645e677dada101681850.1756222465.git.josef@toxicpanda.com>

On Tue, Aug 26, 2025 at 11:39:16AM -0400, Josef Bacik wrote:
> When we move to holding a full reference on the inode when it is on an
> LRU list we need to have a mechanism to re-run the LRU add logic. The
> use case for this is btrfs's snapshot delete, we will lookup all the
> inodes and try to drop them, but if they're on the LRU we will not call
> ->drop_inode() because their refcount will be elevated, so we won't know
> that we need to drop the inode.
> 
> Fix this by simply removing the inode from it's respective LRU list when
> we grab a reference to it in a way that we have active users.  This will
> ensure that the logic to add the inode to the LRU or drop the inode will
> be run on the final iput from the user.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Have you benchmarked this for scalability?

The whole point of lazy LRU removal was to remove LRU lock
contention from the hot lookup path. I suspect that putting the LRU
locks back inside the lookup path is going to cause performance
regressions...

FWIW, why do we even need the inode LRU anymore?

We certainly don't need it anymore to keep the working set in memory
because that's what the dentry cache LRU does (i.e. by pinning a
reference to the inode whilst the dentry is active).

And with the introduction of the cached inode list, we don't need
the inode LRU to track  unreferenced dirty inodes around whilst
they hang out on writeback lists. The inodes on the writeback lists
are now referenced and tracked on the cached inode list, so they
don't need special hooks in the mm/ code to handle the special
transition from "unreferenced writeback" to "unreferenced LRU"
anymore, they can just be dropped from the cached inode list....

So rather than jumping through hoops to maintain an LRU we likely
don't actually need and is likely to re-introduce old scalability
issues, why not remove it completely?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
