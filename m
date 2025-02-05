Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6860134AC;
	Wed,  5 Feb 2025 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738759580; cv=none; b=YV0gJ44iPUQ2QqFAflXmC33ZitpdMlp9q6iieENPCMEz0U2Zq96UiiKBtVu31QwYIlXGA/8YHfzUfLYjVHvO2TTTjCKrKALVjQCj63kfqCQdFJ0fPBVyV5b7oNhYNz1YA5rMCFR7HVm+TZXhK9VGyX95JCQ7JjLEVDHo0lCwQbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738759580; c=relaxed/simple;
	bh=NONtCIzOsZibfn4obslt99o703S+2fn0pEmYJ2C2XuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uSHhz8Am4NqlscmOUcELC0C19FuUATSU3E8xLWKNz9gJlujqJMbzTFzBwKQxPXwARrjTGDwpU5sAS6Rzf+iqrID+8B7gnrDe9Uk08Zj8zJwm/e+j0psAU3Y1ay4i9/qYC+k3qhyKiJvst30XTKP8aVzhVywzvUaqfApwesL7RFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=huTUuWR2; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="huTUuWR2"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab7515df1faso301257866b.2;
        Wed, 05 Feb 2025 04:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738759576; x=1739364376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7S5DjpvLROuAlYE9IrzCBPIi5ghuA3vjGjETG9ZuKU=;
        b=huTUuWR2HUKS0q+eAPi7hrcsl8cu0ME1HW5YcSbCbmI1vTUlS01Ny6FIP1NcUic281
         T3uD0yG4fqQACu7W47MIO9KZia5rj9UzFQz8LTPbST8IGtXQj5LVfJiaBuRuNMsJwb2u
         lXDWKLmLBpBMvUrLPbCr8TUbBGwMiBmY7iJW4TxTI/l0AesPYBFOrkfG0joPHBw7wwpH
         PnfzSv8O15R+Wvgn0VvLWXifIjhEzZAgDHqwNo29NDswal+vA+96JKo7wlrKZ7u9NZvG
         wFbgaWi1T/KBSfHHs+NzJ7uNeXuXdWfyf2YoHS6POwPosra29u0fUZAyrj9CX/v9AMDm
         QqnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738759576; x=1739364376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7S5DjpvLROuAlYE9IrzCBPIi5ghuA3vjGjETG9ZuKU=;
        b=M6q2+Lt5bnofIjYWXMcaHWEKEpCDX615ylehcicSlWUTTnH3NIOmSZLT/yEs9YA237
         1rePxaEp+EYshWFMpY5Y/aKaQ/109CM/eRtotzI/XapbIIGbdXlrOX8mmamHd5sxEVSl
         e4FGT2wpsH6ysk1g09kYA7piNH+DVh0N4IsXUxiEQ9L4VHlCvWm98Vp12vaGiYnXHiCw
         q76NivNwQcwRbpy5yjLqED94z9R8657+UV6dH2qRKEKsVT4K5f3qi7Z419gHMQfQd4UU
         e7+8K1SK9spZymztX7s+lXesUNvtEo5O/xwTRCoTtqeoxPLLu/LfY7EddP7srR40IxU0
         WLLw==
X-Forwarded-Encrypted: i=1; AJvYcCV/KDtdvQcxurKBJ1Ni+qNpbZn3koaIeJ6F32GM2pwSAZSq2Nd+5Yl2XfNrUw34wBWZap67hDbfX9t1@vger.kernel.org, AJvYcCWRcgf6AHHi/CTfIMh7v+dSlMNnOMVIhFzcqF8urkvDeZoEmER2xh2gwUBT0mx8IK2mSWo+YUoE@vger.kernel.org
X-Gm-Message-State: AOJu0YzgCR/z2ZWwAzutoCjl08sfnRLU1kiBH9T62xgN/eydSWhIKsy8
	U7ZeWg+kzmFb/+v5X4FaEhwLBrflSu5pJCBp7WLpecxl5OsbUlNqggk72pGSW4r+Stg+vzezW0E
	DEAejrlChC3menB11wH17u0kjI5jW/Z3l
X-Gm-Gg: ASbGncshrlaIXS3snFATOQMsvHeNop4rO8LKcKhK8V1syP3QW9m6ueIZdmZuWDVi3In
	BmfRCcoZjT+HK3Q0y0F/AvkaCV+LDs6yDnBYauwvqW5FyR/7+vBWqy4WYsa8VCaEVWNhGFYqe
X-Google-Smtp-Source: AGHT+IFlrBQPzyiMqCa9XCUu9R6B1iVTQeXQwgO7Vkss7TKYigz3mjyzX+JtmaiuvQazoZy0qEL3kEO4ZWYL8M/wiSo=
X-Received: by 2002:a17:907:971c:b0:aa6:7091:1e91 with SMTP id
 a640c23a62f3a-ab75e24bf1emr264410866b.11.1738759575517; Wed, 05 Feb 2025
 04:46:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
In-Reply-To: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 5 Feb 2025 13:46:04 +0100
X-Gm-Features: AWEUYZnm8JyU7ZiVa2U-nlQwwRrJcXkaUxWIGO3Gc-6flJXl7EWbzkhstcJaDtM
Message-ID: <CAOQ4uxhuBzcdccttNfHWPGPe-17nHWmEXgE00=THO8_gbMbHJg@mail.gmail.com>
Subject: Re: [PATCHSET v2] fstests: random fixes for v2025.02.02
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, dchinner@redhat.com, joannelkoong@gmail.com, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 10:22=E2=80=AFPM Darrick J. Wong <djwong@kernel.org>=
 wrote:
>
> Hi all,
>
> This is an unusually large set of bug fixes for fstests.  The first 20
> patches in this patchset are corrections for that RFC series.
>
> The most significant change is that I made ./check run each test with
> its own Unix process session id.  This means that a test can use pkill
> to kill all of its own subprocesses, without killing anyone else's
> subprocesses.  I wasn't completely sold on that approach, but it works
> for me.  A better approach is to run each test in a separate pid and
> mount namespace, but then kernel support for that becomes a hard
> requirement.  Both approaches seems to work for check and
> check-parallel, though I've not tested that all that much.
>
> Note: I am /not/ happy about Dave's RFC going straight to for-next
> without even a complete review right before everyone went on PTO for
> several weeks for xmas/solar new year.  But in the interests of getting
> QA back on line for myself and everyone else who's having problems, here
> it is.

Thank you!!!

Amir.
