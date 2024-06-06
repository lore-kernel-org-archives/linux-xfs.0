Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B30113B28A
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 12:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717676262; cv=none; b=SecS2P6TT0q6uzL5HV8D6ozjRx3cfUm6zusrigZ5N64jEb0w02EhznhMVD3Q6ivMuQkjpc5QAHSewxw/xKttMuW/ObIgBKUk/oXSlUuQUQG7z2ye/kYmMvelKco2efLJhaNqXb6Ksp8bP1jbd80xd/fclwDo12YNvJ2GmTKBe/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717676262; c=relaxed/simple;
	bh=mfzNpWljTGWF5x0QoPC8XCUMC2PiQkHKzBSVEDCqb7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f9ozwoRRjQzcZonGgXOViaANkTquhRIn/q/w1Q0nWkIqypei4Wt6fKyBVYSXMr/OtjmaF9jSOhqIMXtD5C1YMhnc+46g5SElsRmBAgAw8KKQ2bUfvAkeB52h3bPDAGrPY+JoK3QBCvgpp8HYw5bN8DaRQT/FE4YeD1HH7PmU4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AqLEhZLl; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AqLEhZLl"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7eb3a45674cso37164939f.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Jun 2024 05:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717676260; x=1718281060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aWxxnlQwc9HtbCioAV6KSLO5jhCVBZVFta1hIKWFNQY=;
        b=AqLEhZLlKEVpK1eJs/kImoLvG0INCZl09tylYE8eiE1Hdw9aIi8uBacAyg2RW116oV
         fQQW4UwwNEGtWM/X5kSSrw6dgM6zndzWqA3pJSztnMeDhXmVwpOqHC2ywz/eHQzhkGZv
         m6++YjrPPQ9p1vBpoHHU4A18/g60JxuaDEvAJqORxYrxm5bJiN65Uq7j9Sd1D0zRl4uK
         rES0394uLbln+jKeeP8ImpY364Q++iuzq1BYxS1EOfdRxw1u5avNiQ+nsFw4qwxx/ttV
         JI25tocF5Ext6OvcQJFVr7nbppO0sQAU8A820vSMUfUJDdwUbK50TzX2kkHzcC1SDwtU
         9jOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717676260; x=1718281060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aWxxnlQwc9HtbCioAV6KSLO5jhCVBZVFta1hIKWFNQY=;
        b=l6LtSqSvanIMT0152+gjBtIhydECOrRP0WOvsVAE/GjkvfrOc54v0Mop2+CfWYbgZe
         I1xh8V62WpwvDYQFTNoj2fdDeAhMp6bbpFGn38gp1AEamjZXuDG0zsfuoFavzeP1juna
         Tzi5grVycg8RCCwZfdtWvekydP443fW/MDQpJpxKKUr+fWUvA8QxcJWks3fxnlplBqTp
         srRzmNGqDZazlGhn/Quvdl1EDyzcT6juSodL1ce0jAn3IWouihWb9/YUFn9VyuU94VJT
         n0uRrnhNxW4cac3zlb1Vz9KocMmJmKt/4JJF3zbKuKd+9YQt3d7JNK+hrAcGIUT2Zn7j
         I+1g==
X-Forwarded-Encrypted: i=1; AJvYcCUL6/ACAUrPqrCVpp0SjoopUQV5PpndRtb16e0KdfMtgJzQuzpgyn5JEqiOMutYp8xKbzHXKYTYSo7pn7MkBkL3Xfk2jJXCb6Wm
X-Gm-Message-State: AOJu0YzZNbA3qBTA1gR8m0rtPhTzbKW6sx2WgtKQS9+CscOqRjnVUQBG
	zVIsMOV8uNYo607jt11zhywsgAvQcaNXqT/0NEo8lVW315dvgHv7VBkxaxr859ldX2wt7A92yLx
	J+sFGVyAgpz8BFVpA/EdxF4beRJNxYq0N
X-Google-Smtp-Source: AGHT+IFfgYHxk8XwWVrUEbkzOZ8PAr7c8Uc5oXZuiCK7AgJBzpXFvjaWOlGgGo0sxCJuBfmzVXJ+TVRAmVxzZ0U56AI=
X-Received: by 2002:a5d:9a94:0:b0:7ea:f9e9:14ed with SMTP id
 ca18e2360f4ac-7eb3cad3d41mr515910539f.19.1717676260361; Thu, 06 Jun 2024
 05:17:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>
In-Reply-To: <1eb0ef1c-9703-43fd-9a51-bda24b9d2f1b@app.fastmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Thu, 6 Jun 2024 07:17:27 -0500
Message-ID: <CAAMCDedh6j0jt8f1aWEpV_UX3-8FRNLBHEsOUcuvACSB-YDQ_g@mail.gmail.com>
Subject: Re: Reproducible system lockup, extracting files into XFS on dm-raid5
 on dm-integrity on HDD
To: Zack Weinberg <zack@owlfolio.org>
Cc: dm-devel@lists.linux.dev, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

grep -E 'Dirty|Write' /proc/meminfo

The above are the amount of outstanding writes that need to be
processed, I would expect it to be significant.
sysctl -a 2>/dev/null | grep -iE 'dirty_ratio|dirty_bytes|dirty_background'
vm.dirty_background_bytes =3D 3000000
vm.dirty_background_ratio =3D 0
vm.dirty_bytes =3D 5000000
vm.dirty_ratio =3D 0

Default you will be using ratio and ratio is a % of ram.
dirty_(ratio|bytes) is the high water mark  (background is the low
water mark) and the OS will stop writes when the high water mark is
hit until you reach the low water mark.  With spinning disks and a tar
file and the default setting that will be GB's of data requiring a
significant number of seeks and the high water to lower water mark
could be a really long time (many minutes or even hours if you have
enough ram).

In my experience about all these settings do is make it appear IO
finished when it really did not (I believe the original intent of
these changes may have been to improve benchmark results when the
benchmark did not force sync).

The downsides are that at any given time a much higher amount of
IO/data could be in ram only and not on disk and if a crash
(hardware/software/power) were to happen a lot of data could get lost.

Because of that I set these values much lower (see above).  It appears
that you need a write IO cache, but really it does not need to be
huge.

The settings above will stop writes when 5MB is hit and restart at 3MB
(likely a pause of well under a second, rather than locking up the
machine for a really long time).


On Wed, Jun 5, 2024 at 1:41=E2=80=AFPM Zack Weinberg <zack@owlfolio.org> wr=
ote:
>
> I am experimenting with the use of dm-integrity underneath dm-raid,
> to get around the problem where, if a RAID 1 or RAID 5 array is
> inconsistent, you may not know which copy is the good one.  I have found
> a reproducible hard lockup involving XFS, RAID 5 and dm-integrity.
>
> My test array consists of three spinning HDDs (each 2 decimal
> terabytes), each with dm-integrity laid directly onto the disk
> (no partition table), using SHA-256 checksums.  On top of this is
> an MD-RAID array (raid5), and on top of *that* is an ordinary XFS
> filesystem.
>
> Extracting a large tar archive (970 G) into the filesystem causes a hard
> lockup -- the entire system becomes unresponsive -- after some tens of
> gigabytes have been extracted.  I have reproduced the lockup using
> kernel versions 6.6.21 and 6.9.3.  No error messages make it to the
> console, but with 6.9.3 I was able to extract almost all of a lockdep
> report from pstore.  I don't fully understand lockdep reports, but it
> *looks* like it might be a livelock rather than a deadlock, with all
> available kworker threads so bogged down with dm-integrity chores that
> an XFS log flush is blocked long enough to hit the hung task timeout.
>
> Attached are:
>
> - what I have of the lockdep report (kernel 6.9.3) (only a couple
>   of lines at the very top are missing)
> - kernel .config (6.9.3, lockdep enabled)
> - dmesg up till userspace starts (6.6.21, lockdep not enabled)
> - details of the test array configuration
>
> Please advise if there is any more information you need.  I am happy to
> test patches.  I'm not subscribed to either dm-devel or linux-xfs.
>
> zw
>
> p.s. Incidentally, why doesn't the dm-integrity superblock record the
> checksum algorithm in use?
