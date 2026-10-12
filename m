Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC14449A3CA
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 18:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791829405; cv=pass; b=BaEqB4w10/oJMLtttD8vqk8tORwVXW/vL0tiy6I5+1Yy8u8f0vRYGzd8dHrDh3eVJBrd4UiL1IRelsK8LnAE31pjIhV4sYm5WO+bIN2La6flyqj3gqyQjpkJP9KpOcbPrVW+lUTqECoff8SluiWsyzs8yoo+f+cALdE3MzyrquI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791829405; c=relaxed/simple;
	bh=y/zWXXhZ9pvHjmmlxT6KbE58T8p7AJ66Qh1lNWZd0+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ZJtSyNn+0GQE6zYvaCWK2r253UMYVDQscapJRMZodABLGxZcf7MOQCpprD2g4uJUvq2pTs1qlyG8CF4ThSugI8UamRwEPGLpek/gpgiBiDR6a8Vy4QVzko+TZ19BTMbtpJLw/WtFfnxxxTbo3eHtP3IuIJBVrT2AmRE7fj0tjus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gJhnuWpz; arc=pass smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gJhnuWpz"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e61ac64ec3so19002525ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 11:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791829404; cv=none;
        d=google.com; s=arc-20260327;
        b=WnTMV6t+uS6NOQfZxDV571Zz1Smyghyus23JF5elGSwS50YwiHmS9HWafC18XnZkVx
         IHC7lS+/zZ/2CBYH/Zv323AQF8ChH3YiiSr538h7TpOwj+uDZkN1f6gyZp2nObopKvjW
         ZbifTI+OICxkh4GXl47JUWc52fL62EsmdzeEor8cPoy56yweNQhKaVPNtgZZBTQaVLQc
         FuSYZltTDfEZW/OyQjyLrTraMBW4G8p+1fR1+OKp+Y2dMPAB7/1IJQv25tnYKDxuDThT
         GozVAhrO4qDGJ4FqaMUE5M8C5HHqFr0lEwZf2gxxEmVHXu0VBT/tdMIk1ZvfVowBCUxD
         8Fhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M1rxkFNi1AOE/jGjjeQU891V/0iQvpA0lCPAciHdvwU=;
        fh=717UJfa65qmxQPHgXYe7gUuNhUmUVEsh3JzHptCWmjI=;
        b=BsOJvRjuETWrecdJqMKCNqRdUku0f6uQQmcF3EvzRuH+C3sO5q+oerfADKYVYylvI7
         mGEvj/WY950wCwW1OKPFNj10oaLI8umtch2h0gwhnHwCmzhTcJn1SrZDwj7LR959MWCM
         DsQ+DxMdrjCMFn0RDciFs2ZsgEn6KqdgwQb4Zvnp09duPQYs8fDbR/XEh/l/IapfHrtW
         ARYqI+7x5b6NIkS+yg6g0L4MuLrfI1QwRe0wFHkCfCTukF98luoKiccBKdkA1mY5qTFq
         V/em9O5zjzftSxkGuZFx5JllV4iXF+IV4ZixRhYc5gb/x9rGdvXQCCwrhSpvDUKQ15j0
         ooRQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791829404; x=1792434204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M1rxkFNi1AOE/jGjjeQU891V/0iQvpA0lCPAciHdvwU=;
        b=gJhnuWpzq+y0eJ7n8WROnSBW6AtI6yTK2VC+bTFxe1I81dpxWkv958s9iol7Cpgy6p
         KC9g+OaVzwjrR/IGDAxikbZPGLCAHdOqLExzCn1K29AlHkZw7ie1goLsACteVmNo0yRY
         SStmeR0WfJ6gjCP7eCnzb8T2xn+NoDGiky7yChe7jGIT4sfS8OwtXtBqivhE2pF9G2KZ
         pKb1hPkcsCKq2MSlS6FxD9UiFgT56mfMOpkiswtbl7kNQztDrK/1LXhupr+rm9zP1ceC
         IGV3LGDhY2sksZZ28nSI+UodiHbKxz/PiKnnwj8FrOrsU4BmyTMQSVuvy/GuoJWKcrFb
         UupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791829404; x=1792434204;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=M1rxkFNi1AOE/jGjjeQU891V/0iQvpA0lCPAciHdvwU=;
        b=OGF6TUkmMOJTaYHoa+WKn9LR2eufCktFVV+OeEpBIBzJ1Qb9dfH1xhRtzXBBIVElcu
         VyYrog77rXA0Rau8AkwxXyATDpJR5PHL1uG0WrU0LLGDx6KEW4Wp4FBC3AeHHmnwhBWE
         csx5wYBTxxiGcGwXA1dQQN64ULfaUHoQ2ANLLyC3Ros1CZUrYLK6vsblZRWpYvndXkWe
         lgNuwI7CD+hxoOYNGbfcOUrRY56c3ivg0WF3e5ZtdUzNyKyrgkqlubk1M2htfOIezeyz
         /XgWhZq5sZUW0HBiJZCKbBw7zbRNKJEFCpwPKpkGyKdTcz0nMh8RYFkx+XIIWCQM1ws8
         gsXQ==
X-Gm-Message-State: AFq9FYLL4BqIzy+DybhQMz/scuPkb+TsxTAlPBAU7DnE/VJJ00oxMu2k
	fWCLFUvsEtSteOS/C6fuIzmQO8SuROWjlIgGE3thoiqLnKv0kZYqreHIJ7hHxLOh4qTT9KJSu8K
	/yIFjbKNdWKcEXUFsyuJ56XYVfXPvhqw4QXH9
X-Gm-Gg: AYBFou2bpQ9Sr6hWVUD3LOQ4rCHc1g40+0Dx9vKXRkGdrilBfzUm9JWOq2NSUeURN5b
	1rLyAb72rEuHfxD/7hrIzdxN/9bYHsR/Vh/nEbWCL8LAKOpIgQyDfG8FJsW6vKJQUKINyeZ94ot
	A81eYUFUa/O1pYKtJkKMhZOpjMkiz9yisGIt4vR9C7cdcxVABkNKK5yDv8bkHJywXj3+ryyOnVn
	GYN/sG6+AI1V3MWljhLT/08Zvx1iuyzlByPQSTSCfBhTYxHWO/T/UHAOD5ww3q0y+BoiHuPAxUo
	z9rHOE4ZkUZuwVuE2q31o3XjacTnd4GGVCBuw7J4+XQEeh1to3JkgqtRrTOSWu7ZINputop13W9
	0GeRAT6h2ID1Q
X-Received: by 2002:a17:903:b87:b0:2e4:cbb3:2376 with SMTP id
 d9443c01a7336-2e842cef372mr87899775ad.52.1791829404118; Mon, 12 Oct 2026
 11:23:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
In-Reply-To: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
From: Vitali Lovich <vlovich@gmail.com>
Date: Mon, 12 Oct 2026 11:23:13 -0700
X-Gm-Features: AclHuK_jojEt-ZSIHtMe_lHs1aLA5UWMSCWiqUF7cTRcnk3XyzKuiHQIBaYSeB0
Message-ID: <CAF8PYMj=RDL8tMzFO4pCrJQUoG4_G5VbaFUmJofDdiPgHRrh1Q@mail.gmail.com>
Subject: Re: Really bad I/O lock contention between non-overlapping reader and writer
To: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I also forgot to mention I'm on 7.2.8-arch1 and am happy to try
developing a fix. Not sure who to coordinate / collaborate with.

On Mon, Oct 12, 2026 at 10:47=E2=80=AFAM Vitali Lovich <vlovich@gmail.com> =
wrote:
>
> I think I encountered suboptimal locking behavior with concurrent
> readers and writers on a file, which resulted in huge latency spikes
> for the reader even though the writers and readers are touching
> unrelated ranges within the file. The writer/hole puncher hold an
> exclusive lock on the inode while forcing a flush of outstanding
> writes to disk which creates huge latency spikes for reads.
>
> I've observed read's taking >> 500ms even though none of the writes
> could be overlapping and traces seem to indicate it's the shared inode
> lock contending with the exclusive inode lock that writes / hole
> punching is holding. In my real-world test case traces indicated that
> the cause might be inode_dio_wait while holding the exclusive inode
> lock.
>
> I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> general VFS challenge. Generally, Btrfs seems to have less read
> latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> which in turn has smaller and fewer tail latencies than XFS  (~2x more
> at 0-1ms and extreme is smaller) although all filesystems exhibit the
> issue. Starting with the XFS list in case I'm way off base that this
> is a problem.
>
> Attaching a simplified reproduction of what I'm doing with one writer
> appending data to the file, a separate writer punching holes in
> unrelated ranges, and an O_DIRECT reader that's reading data. Reads
> are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> 4kib holes in [64MiB, 576Mib] and writing is always appending after
> 577MiB of the file. The directory the anonymous file is created in is
> CWD by default unless you pass a different path. I'd expect read
> latencies to not be impacted by waiting for writes to flush yet it
> seems like clearly there is such a serialization.
>
> cc -O2 -g -std=3Dgnu11 -Wall -Wextra -Werror repro-syscall.c -pthread -o
> syscall-repro
