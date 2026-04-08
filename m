Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180503644C3
	for <linux-xfs@vger.kernel.org>; Wed,  8 Apr 2026 22:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775687318; cv=none; b=pnkc4BO4zz4hKC2LRAqgcL3+dZ+KiueFjyBHsg9XIbI0Ab1JogDL/0ndkPiFuGjPJPHKePCGyOzQZQCsDi8KH0RrJFAgDr8wZz/Z+1t7EUWMtLWDC5uAetLMeiS7MJwHk8AW+qlBhHguN2zwllk8+e7P9TD43fhocVb9IoBGLyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775687318; c=relaxed/simple;
	bh=jN9TowKLjFv38RGaJ6rU8PAaYZyNiikLlBl9yPGFIk8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=joF0OrM4fEKcHNDx6pnIU+OaeFiDxin9Py+JpDZWjtdVrCnNJ/jOPpILPugNqEFbKkSR/FiyUotZyBfIZV7seoJHiVdSfHVJ1SpmptdK1/DBSdrBi6W54Fb4xRHsNK5x/dXu2sEkkDGdqGn0MBsWdIJnRr3gAz6lcNym2944C1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BYSkTsnE; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BYSkTsnE"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82ce0a9b3f7so171811b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2026 15:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775687316; x=1776292116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=25ks4QK4ZQUZfiV19ZOQ+c2gbv37WllzG79mQvvjDJk=;
        b=BYSkTsnEdyBUsZ04oOmfSQEddqIQSm3qSBuXphMfoNVhZTwHINDHCNmwXXFzqZHEkd
         eNl1QMuNyKK0CO1Fo3tPNZT0yYGHyqDiq0SjGcW6lOdGKZ8zLy1k2fLpYaIxB4VZVANN
         GWmY2wFy8g7T+z+167R3ZIFkeR3FO3zovwS/S3mEvsFy0DNZh7rmEGphdwBRdVrfHR6x
         1jY7PSroST+o7UvPwwkPjzdLbJ52kHIbNCSJuV4ku3l27VhtsJrEg5q2OLAc+g2MKo9u
         EqvDutOIdLORZyOC6eT7/4b+uPRmtQ0Dq7JDT6Blqw1AujGmnxamGY57iBGj0rZM2WiI
         W7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775687316; x=1776292116;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=25ks4QK4ZQUZfiV19ZOQ+c2gbv37WllzG79mQvvjDJk=;
        b=L4AUmQFw7SB9P7DVCkw5ZQ3+K627Vj/WZ2eISsY+jmDa+DXWjm6Akpo9VzI/K1mgsC
         LTsoqW6pg+KErKktbkbg/oyRWW95v2i/HiiQooKfBByfgf7YOjFsXVOcxBUVSyUkH3cg
         +uO3CtU40sEN3QtgzRwEx1lNU/D11r9FMM88qrJyp6EUmu167w9tlAx3IHYYhPyGbtcY
         XrAllU9zaWoGvWjgGsmKvZlj2K9FkcW74kRWT11bmNk3ZVPJwklw3aWn4SUROXkjIFza
         Dh17z2HIu5mHNnuGF37uP7kKyXcoB5LncF+T0vJM0J1Oxxrs//IkhmEqmm84zq9a6f0Z
         3AFw==
X-Forwarded-Encrypted: i=1; AJvYcCWBpiN0QTb4kb2fYI+MXlEDkPl2RIwd6YRlRtWL1KqRS62lTyi0817xcv0bFyQl0tuN+FW+lh5qeuc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Vgkm/z2UaTPNERG3d7TJqK4ol+/L9Av1IZ3iAyBxjtT/AWNk
	I8Nmv/9CqcOM3H9XD1ZF8uCk/eIaeWgEcig4pZqqYVKQtIbYdVAgqO0c
X-Gm-Gg: AeBDiesS3YyUafkflZ4FrEckLYS3CQ3lgYnUq10ZeewmMyON1dxwuJc1rckIxqLZJy+
	FNeyz5meI1FnBuS2h2jO/aGR8mft7T3tXud/E5tqTue1rO8vlfrYDhmrTD74kkjN0Ee6J28xVdA
	Rh0+aOafhX3t80AZO6+FVu2JsWy99XYqVb1MTWQdA2vj2tFdGTn3QZTA0PtYTU9DJ8ujp3Ydomg
	Lesf7Yf4ACh10ZJxLsBoc4Nsax1GDd+/E0SY/XtULgks0d1fTM3qKu4tzz6J+NdVi+owjHKDSHo
	ChMS35CV7E0wcMmavuopAQfXPpjK2xgdOOciixlp0NYygQ7NyTbg6/qh0wW1EG7A2u+BxxuAXUV
	s3EglM0AkjhmVOlux5zDPa8svSfciLd3cp9X3OmLSG36YFSkWYprCwqYatArwW54p5D6XZcEBmk
	hQOvWo81bGuRd3A8c6DiI9AeoabfQ=
X-Received: by 2002:a05:6a00:6c9d:b0:824:188b:c173 with SMTP id d2e1a72fcca58-82dd894e0b3mr1189959b3a.5.1775687316458;
        Wed, 08 Apr 2026 15:28:36 -0700 (PDT)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9b3dcb3sm21403770b3a.16.2026.04.08.15.28.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2026 15:28:35 -0700 (PDT)
Message-ID: <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
Date: Thu, 9 Apr 2026 06:28:32 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Jain <anajain.sg@gmail.com>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 Anand Jain <asj@kernel.org>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org> <20260407144709.GA81690@macsyma-wired.lan>
Content-Language: en-US
In-Reply-To: <20260407144709.GA81690@macsyma-wired.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 7/4/26 22:47, Theodore Tso wrote:
> On Mon, Apr 06, 2026 at 10:22:16PM -0700, Christoph Hellwig wrote:
>>> Dilemma:
>>> While statfs(2) [1] suggests f_fsid is "some random stuff," we know
>>> userspace (NFS, systemd) often treats it as a persistent handle.
>>>
>>> Do you prefer one of the names above, or is there a more idiomatic ext4
>>> naming convention I should follow?
>>>
>>
>> My take is that anything that should persist should be an on-disk
>> feature flag, not a mount option.  But I'm not in charge for ext4
> 
> My take is that f_fsid is random stuff, as documented by the
> specification, so anyone who tries to depend on it needs to be kept in
> a padding room where they can't hurt themselves or their users.
> 
> And as far as NFS is concerned, file handles should be based on
> the super block UUID, not statfs's f_fsid, and anyone who wants to
> mount a snapshot as an NFS exported file system at the same time that
> the original file system is mounted is _also_ should be gently coaxed
> into a padding room where they can't hurt themselves or their users.


> The solution that we've used for people who are cloning block devices
> for things like cloud images has been for *years* has been to use
> "tune2fs -U random /dev/sda1".  And this works on mounted file system,
> and (for example) built into various cloud images for Google Cloud
> Engine.

Ted,

Thanks for the feedback.
Some A/B testing use cases require the filesystem to remain
byte-for-byte identical. In those scenarios, changing the UUID
isn't an option. This was discussed on the mailing list a year
or two ago (I don't have the link handy), and is similar to [1].

  [1] https://source.android.com/docs/core/ota/ab/ab_implement.

> If we want to change statfs's f_fsid, from one set of "Random stuff"
> to another set of "Random stuff", I don't really mind, but I don't
> think it's worth *either* a mount option, *or* a feature flag, as
> either would be confusing for system adminsitrators when some file
> systems behave one way, and other file systems behave another.

I agree that a new mount option or flag is too heavy, and I wasn't
a fan of that approach either. Let's drop the ext4 patch for now.
The `f_fsid` collision in cloned ext4 filesystems is currently
only theoretical; we can revisit this if it becomes necessary.

Thanks, Anand
