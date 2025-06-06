Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6722D288CBA
	for <linux-xfs@vger.kernel.org>; Fri,  6 Jun 2025 13:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218117; cv=none; b=IOZtqd02oS+KzNbxo0PrFTBuucQ3Inj62O7xXV9ErWbklldzE1dKVr4BSDUIJosjxJIhf9imnGa+7Hjd0dZ3TI6iIGLc/lRCLVcD3vlUQUX89wnECNNqnQ6+DC+M2xAJvIXXO7NjxYNaZuVexRDt0zxcH1fmtQ5M12zNGC/dLms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218117; c=relaxed/simple;
	bh=BiBKkugoiM16l4QTDZj/vftTkuVh94Dm/j4qISoefgk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GqY0FJOMPwvL6PA4W16pENNtF1DA+7Apb8d2P33S54y+F5f+i4ix9NYJHhXt4oasTR577o9FpLVCpvz8bdhvUHyi5zb0yUIv653RhDy44n3UwDtCanIYXIk3LKdybvzJYv6pt2vnyVoI0jOXZ2vbcXA6ZiEEk9mmTbFUuR3wc2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=dbsd8LJU; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="dbsd8LJU"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7d20f79a00dso282091285a.0
        for <linux-xfs@vger.kernel.org>; Fri, 06 Jun 2025 06:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1749218114; x=1749822914; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E7/mZixpkg0lei16mzPlvTFGBUK0AxMB+9TgdpByP7g=;
        b=dbsd8LJURMowwmzicbKk5vnrTCyYpJpiLiOoDz7sBfbdgd/zpu6B3eLQBzs7kc+Lju
         NT2AMqbudG6osFLzY+jsFRrfxwORAVw6RW7BPlWT6EKs5Ch74tAgh+u3xBgXQV8kZpQR
         FUw0c93Q3C451+dSAF95dZJrUDVN8Z4IoVFgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218114; x=1749822914;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E7/mZixpkg0lei16mzPlvTFGBUK0AxMB+9TgdpByP7g=;
        b=QSCSQPKohMveU2GonbT9iuzv2OfKTsNGxY6n1dAm89K3uHvSaTLdHCLf76frcpgjdI
         cbultWsStMuuchZac5CpI3LlzLSWdwFH4QP9Jkhr0SRudpF/sdTwMUmSrFdR+EA0MqBv
         oa6iedAIMIWjME2F6NPU3+T9XGde0wGrE105l98A5n/+UuDkuWklZQmIKEsiM4VBaMrb
         oTTy22/48aFQpy3rMa9PYFDx2unZnzT62uzgCLX6vUomCoc6ninJAYQMfJNPwxxY857m
         iLyOyCAE8vrhbFCgMTHHqQijXnPd8coWIyvy0s+bVluKFlQAGmrMnqSo6DLYJ32aC5Zs
         iA4w==
X-Forwarded-Encrypted: i=1; AJvYcCXjlJoJf+/ELu3zlPvhy2BtNaEAhfWfAYy3vj4NZA4IGJT7QUIVsWi+svKe+T57qlyaZJIAJJz/040=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzuo1FJxtOdhZEiHsrViCgikupXxQZemmHzjSG2L0MB/GHxKAQ/
	82IKmPddZVLvSmmNvMwI+NxnpIC36Vxc1MSo4Hbu1TIFWfiSIr5RXYe5wwgJ4509rB4qR8dv4Sh
	oE5NZ2jeuVFa8ObkR4n20Yjk0260Ubaz2rEcEDgMePC3QBL5mkRff
X-Gm-Gg: ASbGncuM3eL89HB9PIIlvC3vyQG2v0uMdBW0i/JH5SnjBcZuiwWMY5Fa4NVKeyVzYrv
	ooJVi08euYFEeOOnrTqysElZ570WHfibySC56qhtsKCYAQRE3gWBlUPrZEq/5ldWmo0CkpSQDrb
	NjapULrPjTdfzgBmVzqrauWUOxVZ7lhcQ=
X-Google-Smtp-Source: AGHT+IHQlrI/OtlIWS2a2vIz47wRFPm1D8aQZ4bBhcElMWjypsbw77Uu87VP2HAYTCSIjvehXsNall5j9ttNQcsenUM=
X-Received: by 2002:a05:622a:4c10:b0:476:91f1:9e5 with SMTP id
 d75a77b69052e-4a5b9dbb8f0mr63968261cf.50.1749218101624; Fri, 06 Jun 2025
 06:55:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <174787195502.1483178.17485675069927796174.stgit@frogsfrogsfrogs>
 <174787195588.1483178.6811285839793085547.stgit@frogsfrogsfrogs>
 <CAJfpegsn2eBjy27rncxYBQ1heoiA1tme8oExF-d_C9DoFq34ow@mail.gmail.com> <20250531010844.GF8328@frogsfrogsfrogs>
In-Reply-To: <20250531010844.GF8328@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 6 Jun 2025 15:54:50 +0200
X-Gm-Features: AX0GCFt8wqjlMocidJZkmGlImqJ8eqE9iJOCP1TCcDw9PeehwnM-2y0bS2wSaQc
Message-ID: <CAJfpegvwXqL_N0POa95KgPJT5mMXS2xxCojbGWABhFCZy8An+g@mail.gmail.com>
Subject: Re: [PATCH 01/11] fuse: fix livelock in synchronous file put from
 fuseblk workers
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, joannelkoong@gmail.com, 
	linux-xfs@vger.kernel.org, bernd@bsbernd.com, John@groves.net
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 May 2025 at 03:08, Darrick J. Wong <djwong@kernel.org> wrote:

> The best reason that I can think of is that normally the process that
> owns the fd (and hence is releasing it) should be made to wait for
> the release, because normally we want processes that generate file
> activity to pay those costs.

That argument seems to apply to all fuse variants.  But fuse does get
away with async release and I don't see why fuseblk would be different
in this respect.

Trying to hack around the problems of sync release with a task flag
that servers might or might not have set does not feel a very robust
solution.

> Also: is it a bug that the kernel only sends FUSE_DESTROY on umount for
> fuseblk filesystems?  I'd have thought that you'd want to make umount
> block until the fuse server is totally done.  OTOH I guess I could see
> an argument for not waiting for potentially hung servers, etc.

It's a potential DoS.  With allow_root we could arguably enable
FUSE_DESTROY, since the mounter is explicitly acknowledging this DoS
possibilty.

Thanks,
Miklos
