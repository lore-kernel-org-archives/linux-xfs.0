Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C152517AC
	for <linux-xfs@vger.kernel.org>; Thu, 11 Sep 2025 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757570087; cv=none; b=vAH0kU5nzhUjfZFnIH4nsaXR9X6xCXuzPHnn2B+pSO4qvX+jWYr6/RsVqGNgcX0DTJvsMHbPQsuZh6A7tnkoj7hAHO5sDFIKdgcfZOKmpivGV+Pd85hb7SCzeAhskYk4pgfi1ABuXMaByKXSVOT1hYRW+yuFXNmNhV+Qq5H31zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757570087; c=relaxed/simple;
	bh=JLVGfMwisW3Y4JGot2IV80m6V+FOPM2PsbTbCgXGcNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJZzSwURgiD6Dqol1uUC61WtJv4bzr03vN4S3hT5aDzhBzT7B1+IEu1dTqqr1S46VAsBe+ALzJdVYfKpklEKBBjcxOgdWM0hRUncju0aZ+/kLy6bXQKxysQM4Yvb2X6uZPmnaCiqwQcMizMMD+I2PfNEaXL+4cMpzQ3GmbXBz8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=U7lkqRrV; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="U7lkqRrV"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24b13313b1bso2212295ad.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Sep 2025 22:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1757570085; x=1758174885; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7U/qSpu3brb3YBeOIJTTylaUCIcvX4SeZCWNyYbixqI=;
        b=U7lkqRrVbCuJAFHEae+IPf77lWdCcl9IPLjkxHPq1hDp6w/xxREPaRlIYLQqdQqPjf
         eqmGbQRw/LOz+9HugJNnu9uwdm0d9qdNlAoB/mONG6pFTLG4T6iV+t8YM07yPAKcvDjy
         kJlLiEAVfTIYJE7Unm+MX8kaEz8b9CHfJwPQsVymf94xxwz/ftSwODDzotlgD7nN+lk5
         TvRaCZ/7RKt7JLWuQsi9OC+RMhL6mAG0CfbhYlXWTwnOeVJERmAeGLHu8HO10Tv/DTAU
         ZUrvqrWCDllvAoQY8ZI3TuI7XbsHmZKPTpDuA7OrZqIsGHI6itChFo5s8yeJHYrWqfYt
         wYwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757570085; x=1758174885;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7U/qSpu3brb3YBeOIJTTylaUCIcvX4SeZCWNyYbixqI=;
        b=pPmr5HR0QcJrkMwkVnqf8M4POQwJwFOMoiE+FZJbnLijyKgPfBOr4o8l6mdQ33hWht
         L0DHN6R3IwGz0CeK0b4X9dUG/m3oO5t1kHyMMeQ71Bh+JiCpRgH2z59HRD95csPVIbTZ
         X1HtcTrmERgBs4UpIWBth+AobmO1z/o5TscW+NlVRNq+j5GtS+wdpNVgjH1xvrEcIBae
         sG1/9AxP4ineMmkhLnowf1hnXeNS/gC5m3N74R6TRrFjM0t2XwEO4run0DX7G/hGYH1X
         WSjnuJCKDY+lfpDs59f9IgSbMqAvDYdrtonFpXDjmSGrJm53vvM6vfeDtDqSi8gUAxS2
         WFtw==
X-Forwarded-Encrypted: i=1; AJvYcCXICNXVYJuQEUQtxv7OFNZ6mPQR+jH7epWaEDmA7hTG5qq20OISVaFfgoUZyLePVnAEc64zcz//2JY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDcZtadp87+Tk09eCKzNg56pcoFxVlIZ3YR0qqZUCX6moaGD15
	y30HyBGrXJYCOwiptn/2JyUeQG98b6z99RhmLsjuMKiahotPsw3TRMfByjgIGfdkIaWBgKu2wyb
	PiLSd
X-Gm-Gg: ASbGncs1RoD6LosDW8R0+0EWA0q7z9bPl1eTbZ/+0eZTUbYfLcF4Yt+ADRo577nwprp
	9sKHbXUypPVNukWLq00tFTRIuuNOuJRaHBGI+aAuJ3xEelrRSv5NB0Keh3p7b/JKBIxnBWTAfKM
	oKaR14kg+ihhENJEsVJxAmgVItOO45/UK6P+cKNu6XCMqD3hsZ0Hc+WOL85YUsRNKleAx3tVf0M
	gH8k9N0fBPgsrWs3Wb4TftnsvYch57i3qUtoThJ/71sUsg0oWZAVbiJ6b0qiX+I5lYCvDm72DDp
	cjDcgBsLw+lJHr0pN11s4I8Kp9A4OFYOHJN2npffXZ9muIvA70xEl+ZbaJ1xFg54PMNPQXie+QM
	vgQEDuj/XZgOQ8ISSuGBmj+EElyAyXfutUbw2Q11jOAu4ynYxQsdrkJhBGVgIpVMU19/GhPy+rF
	7AnMWlIUpJ
X-Google-Smtp-Source: AGHT+IEJ8EWH4EX2E0dT8s/g+9UDN2nb1wl7crNvle8QYhSW73RtvbWKXJWPfnOBHU1es1wXSTrLow==
X-Received: by 2002:a17:902:c946:b0:25c:5a14:5012 with SMTP id d9443c01a7336-25c5a1457bemr5452105ad.1.1757570084813;
        Wed, 10 Sep 2025 22:54:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c36cc6c59sm6905715ad.12.2025.09.10.22.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 22:54:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1uwaGX-00000000QEt-1mcY;
	Thu, 11 Sep 2025 15:54:41 +1000
Date: Thu, 11 Sep 2025 15:54:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, ocfs2-devel@lists.linux.dev
Subject: Re: [PATCH v3 1/4] fs: expand dump_inode()
Message-ID: <aMJkIbDwuzJkH53b@dread.disaster.area>
References: <20250911045557.1552002-1-mjguzik@gmail.com>
 <20250911045557.1552002-2-mjguzik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911045557.1552002-2-mjguzik@gmail.com>

On Thu, Sep 11, 2025 at 06:55:54AM +0200, Mateusz Guzik wrote:
> This adds fs name and few fields from struct inode: i_mode, i_opflags,
> i_flags and i_state.
> 
> All values printed raw, no attempt to pretty-print anything.

Please use '0x' prefixes for hexadecimal output.....

> 
> Compile tested on for i386 and runtime tested on amd64.
> 
> Sample output:
> [   31.450263] VFS_WARN_ON_INODE("crap") encountered for inode ffff9b10837a3240
>                fs sockfs mode 140777 opflags c flags 0 state 100

.... because reading this I have no idea if "state 100" means a
value of one hundred, 0x100 (i.e. 256 decimal), or something else
entirely. I have to go look at the code to work it out, then I have
to remember that every time I look at one of these lines of output.

When I'm looking through gigabytes of debug output, it's little
things like this make a big difference to how quickly I can read the
important information in the output...

Otherwise it's ok, though I would have added the reference count
for the inode as well...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
