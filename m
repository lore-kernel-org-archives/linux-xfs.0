Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9107A2236F3
	for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 22:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761084166; cv=none; b=UnVxIZ76D7GhidVPuPbdhxlq7WKpDJ5+DMkI705g8qHQmv3syCTlbldYmLfmOw/rsg/UdXZuXP9Lxoe+UxyDEc8WdEiUwpAxWWP2c/19R7qbBF6oAiT9O6kTdvuhPQGzxxwskkXkzsrUn2Z9nn9+M1nGZGG6mJsb7q5wljgODJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761084166; c=relaxed/simple;
	bh=p942vWPpfBl3DJpABsNfoFO+q136DGFSv6Cp/lPpgI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/NM/+YcMyAnR+cUbjnJsXZHPec21oDIr1TT7VoDSKccyOvGJwL/uSAIKgmEv0XlBu5BRrrGTpmL9Gtd+ktfETdLTOFhmFW9PTKTK0kTJYyh9CyAz8M4hg0Gs/QpG40019fuDdF2lsnn/txRTFtee67fB+fYLPwknSUzkoIh88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=e4cHxZ1s; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="e4cHxZ1s"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-782e93932ffso5330227b3a.3
        for <linux-xfs@vger.kernel.org>; Tue, 21 Oct 2025 15:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761084164; x=1761688964; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASJLNBoOS06Ub5wIm728qf+h8+QWWhWXhhzlSoFpsBA=;
        b=e4cHxZ1srNkXPmDG9tMIz64N9oSh4rgwvVMxPy5bGMVmYJ4b8eNFneFY4Wh8Ha9ZJO
         pb4jETIQiN7r4uYyqXwSOlKEmMWXHfLg/AyfqOqv/lbZMw5Y/6OyRCm1aCl+FHNMC01L
         tcsntwMMFxs0k/glUPQdlMaF2tGg9kUPRGWaW0adC93pzwZzgGLeie0I02SyAnPKnv3X
         WuWFP4UbUleNiBj/0GCpjjLxvlyVSP1GYUvBx0A0gdXEhflPy06n/frbkFHlVytksHk2
         PVtN7tnHR2K/8FTTCMUdkEcY9m402xF/GU+m33mg9ghkEV5cXmoCpij1YfcB6vjAN0k9
         oUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761084164; x=1761688964;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASJLNBoOS06Ub5wIm728qf+h8+QWWhWXhhzlSoFpsBA=;
        b=hhbsevjo7c7KiGldjMhw/sxbWKKzbhKkCSh3AyA1+PwNTuKIBxEGoaPvOhFJ4BZ8cs
         NLTJ0wH8IqxNzVaFu+DthdOgpBvAP/i/YN3NdrJOISJjUcGZYcxHYWF0oywhsRXqnpsk
         zG1S4gtAaee/LC3jOKDWEuWrAuMMjxgTtKJLvUAkEzH0/scfZNvF1PWB8m5CbvLBGWGo
         dKrfzI2QF5sl5d+KBVCqKkNbas9NWCVPs//LEEiZqCsgnqrCcjdnmrcsonVU16cCQeTk
         DR0+StRS7g2V6cnbzh6cCwX8X3otO2xn6WiwrEg3f6ly/ddGFlta52rPuGqNQTRwqro1
         US3A==
X-Forwarded-Encrypted: i=1; AJvYcCX8JsRxljqgiqGhEF9+nbT49f05RKQrLroM+Fe6WmppP97wAbpF5/0p6nqIufKu0k2/ngkDb7YMee4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7pjBnHtP5KXY72Dqp3rWpX50S2s5DsuwOk2w+KgXnmG1ia4KP
	TzoS5JJ/1pKiyi28VDF8wQlaMPjumpfbMA6gTM0ApWhITpINWYOpELolpW8sMDD3paM=
X-Gm-Gg: ASbGncvf1x2l3gEI6hXMlKMLFAadGZhcbkwGdlbj7gIRKPn+2+W2/66lihsxYtbp3CQ
	hICfuwgS9uSYj5QmBEmuzjRTyFvWbIaNLrXoWxdHmtdn03ntYEIIZBlyH9Zp8eRfjRaMfLHzaHP
	xLXKxK57l0sXnbAyj7aRQJpCEWGUcKJGDbO74oFltNKapdaK7GuAWe02DICUBR6YhRSBK+G6KFv
	NDVOdr+nnOZ6eVFNX8bEMeJLfWK6Ud8Y0fi0OVX3+QoIYolJ35hNjaKmsd8O5j4guvFzHfv3YLx
	3he2HXJGDAbu720+rAiT5n6e+KhtVnyETLuo35UEO82VMI3FFLdJ4l1ySdCheKMs98VJ/QboFnZ
	ReYSlpt/ltdHJJ+p7b+Yhsfe29QKltqktq3uHx2uYVDo+yq283gDBXQxQq4885VGon2+sNEWjhf
	Vm1q2NJbOaQ+FICFm4UX4wGSohR+WSVmAPKsaEDkaSCCioXYLFW1obR81B7iP1RA==
X-Google-Smtp-Source: AGHT+IGrL+0c3D4fw/cdjBnkXbD3svMlqXdnwByfryx++c5r+2d9dBoP+6lRVpqobGEEsJE1U/NYmA==
X-Received: by 2002:a05:6a00:13a0:b0:792:574d:b20 with SMTP id d2e1a72fcca58-7a220aff329mr20982783b3a.25.1761084163598;
        Tue, 21 Oct 2025 15:02:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a23010e265sm12259539b3a.52.2025.10.21.15.02.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 15:02:42 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vBKRE-00000000LQ4-0YFO;
	Wed, 22 Oct 2025 09:02:40 +1100
Date: Wed, 22 Oct 2025 09:02:40 +1100
From: Dave Chinner <david@fromorbit.com>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: djwong@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Remove WARN_ONCE if xfs_uuid_table grows over
 2x PAGE_SIZE.
Message-ID: <aPgDAAfq8opIeSWp@dread.disaster.area>
References: <20251021141744.1375627-1-lukas@herbolt.com>
 <20251021141744.1375627-4-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021141744.1375627-4-lukas@herbolt.com>

On Tue, Oct 21, 2025 at 04:17:45PM +0200, Lukas Herbolt wrote:
> The krealloc prints out warning if allocation is bigger than 2x PAGE_SIZE,
> lets use kvrealloc for the memory allocation.

What warning is that?  i.e. it helps to quote the error in the
commit message so that, in future, we know exactly what the warning
we fixed here.

If the warning is from the  __GFP_NOFAIL directive for this
allocation, then shouldn't we convert this code not to rely on
__GFP_NOFAIL?  xfs_uuid_mount() can already return an error, so if
we get an -ENOMEM for this allocation the error should already be
handled correctly and the -ENOMEM get propagated back out to
userspace correctly....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
