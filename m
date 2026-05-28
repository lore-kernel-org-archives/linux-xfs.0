Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com [209.85.208.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469A3CE0B8
	for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 13:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.193
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779974902; cv=pass; b=T9nYjUMD/yf6r8Siin5DMYGHCGAWV2FlSfXD7Bs/7wKxryV05yBtRg0d5mgRPsCdPHoQ+9ftADMH06k/hGDX4o5eCMGZwkoMbc9hqRhiX0Zy3xa5dvv0sORZBAUniP3kRMHHi2UwbuLXDPMrqfBarwbXxqA4qYLdxcetGnFXWTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779974902; c=relaxed/simple;
	bh=1K03bwNnLHw7jR337a49x/Vg8qaIFDb6ZduxLGRdKI4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDZg+fSfIUaVgHB3r4qUWG1RFlp73h+adwLo8ZC+owHpW+3iUoXEf761SmZHwmyrBA0phkuafoNqiKV1xpQemWHHyGOtUsYiFL3jWzuTFwPOgSxMFMymCr6pZ3OwDlBKQ2ysgqaC+qvMvNeSBXw6xb6TpD2zpuampFp8AiU4rkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMK1TDje; arc=pass smtp.client-ip=209.85.208.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMK1TDje"
Received: by mail-lj1-f193.google.com with SMTP id 38308e7fff4ca-395317d8852so107626651fa.2
        for <linux-xfs@vger.kernel.org>; Thu, 28 May 2026 06:28:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779974898; cv=none;
        d=google.com; s=arc-20240605;
        b=GNMIgShkCYVOtXojWw2n8XpRLbluAyHp03gytT/EKnwZnOipntTc7z3k0OwLNVvy3p
         +77t+YYRc63Sm0aAbz2eHULxKtUeOayRSWNvAldZi6wQevHYYACijtdTUp5y447jgnK5
         w72Bk1grnOYyWEowcQ5g2WohRnwiy7QotozWFgNKce6FKH7y5gh6Zdvg4BxBDVykTknU
         tZEjXUD3R8J3qe9ZjAGOYJjtY/KWRBZco6UN0IQ7O8XtIURuiTioIG4E5rCztMSpn8rY
         4bd6nAG38WoYfYctbY6cAuSlEc7998bYBT96QGmTT6dmOFX4SUCSc9ekBx6k0owIWnOf
         yEVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=S7Tip4eBDHh1hevbh6CfT3LqPSbBqal5X6vGTdeJrq4=;
        fh=lQMMZGUQgaNuR99qfEdQrJrKtgPslza57k1Zum9utMA=;
        b=Tpu+4YI7mT7XaJphLWPGcKtcdl97OaTwkUZsgwPT/HBYeemJ+ufB3jIN0MamOOZY0P
         SaR74JEigNkllMgApDVuQL50zNUgKeA4ephM0Lpwwl6qahpt/jF9iF13cM3y7Nzkavb2
         LDOR9iTD+Zbc/oefDk839jjSZrGmM3NAzZxt9DkOkQ/aPJ/CLcYIgAkhCSR54xJI4duy
         1JMJnOmuO4JIZIItWF3H0MH79nuoJijt2mEGaWWE3DAgP/UrcVS8ymNU+NCUWLIz7ejc
         ok2Y7L57qgFrwPane1BCkUw0ZLsLuu5Z1Ej8PE0mPDOdR7XpkqxjlI1yfMxM4XRLLDQM
         NXAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779974898; x=1780579698; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S7Tip4eBDHh1hevbh6CfT3LqPSbBqal5X6vGTdeJrq4=;
        b=iMK1TDjejrZZiMi7zxoMob3DwArJr1UIj5wZF6Aba4lh0DDSdovy/lLHhGz3/jiKTr
         w41dS4OtJKTakeXU6n7Vi/OLRC8VDi9pOKCIt6g9P6Oy9A0mE+0YG4/I1inybLCl4p9o
         9k7tX8RBqdN4SnENN+x1/IqvdDXJonDvH9g6PNkt8APSqP3ReBNYO8x3hA2q7dHDWX6V
         DE2NMhgTrgz3qVlfGhZbrjzKv4eJoUVzIMzpO5VpqKdfuTNgd/+Fs+iRtuYiq5Aef4Oi
         pVZDHkvjdNpuimbjnRp5GjBe5j09lTmcw2Erk1YCyJUzeMyAlik9YWWamv1bHsXr6FWX
         e1lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779974898; x=1780579698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7Tip4eBDHh1hevbh6CfT3LqPSbBqal5X6vGTdeJrq4=;
        b=ZirFrZktXeChIwVPKvedWiUe71qHr8w2qrQhBY19BY/WNIgMBZ6CqCIo1T0ypvrw1h
         rFvzSBE039CSHiGQG8+jxDGJ4vN+moae/yo4ZPW7PNC3WMsRpE65n63usUQze6Px+dc8
         DPc1i9c6lVZsm11miv9k873kiNX+Q0Kmba9CYjsqVAUp8ikY63nX1wNPWYZreAngkSmx
         psrbQ63T5iv3PwjvSkWgeJPFtacAFSdiU76hPUKpypst0z1IbdpBKlxLyx7tY3ga/EwE
         glTQDpAkzYHuiVKhyeQyZuu9OEiJd8H+J86YEzkeNcpZuKxiDgctzz9I2rgCsa0VVrtT
         0rBw==
X-Forwarded-Encrypted: i=1; AFNElJ9OPc5jC5GYUZNxt5dOuOEhSKqQud7OC7VgSvE9sic7whr0Z2pTl00AJ83vDCVnYixkkFQYbijgaOY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx76PtXzjtSo8z5RAUd1liw62rGlmJ7ClpWkDFaqi1DtATVB1eM
	WCAx5Hagr+8HTlKfMPiSPOj66xiYyS+EfJfV3uAsPzuRhAjUP6GbHZsfPU7OalvYWdL2AXyAr6s
	SFuwi6yGvgzGX3G17yrQOzf1ycwNCNIA=
X-Gm-Gg: Acq92OFmjOrqZZ0BC2iJUDcXye+4UrUw9jIX1WyI6MD+b2/FUW14z3XvsVWogkSKXJa
	iDH1I9GLbeuNweVBdGvmTQueH4KWXe3KZvTg9LlEBvOXg59817QbxuWm/5FdtHDAcqpLki/cA1o
	bq9xHLdbu33akReJsVrOmBZbadI73MdTwBleWr73ohoEaMVHskkbpCMQnQ9CVJ0B7IuOYoExb2X
	5gv4zFlJVY2C5NcJDvyprNSQ0DKG4VCPokf67oIUm0U9PGbsO17+FbV2FBehWOuTlVowkblhZ2S
	V84oHeWsEWZLaH4N+aOYE/zmWoleZo05iZvq/5aZ0Q==
X-Received: by 2002:a2e:bc03:0:b0:395:940a:d84b with SMTP id
 38308e7fff4ca-395d8bd3820mr98904661fa.3.1779974897335; Thu, 28 May 2026
 06:28:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <agwh6darf9q52za7@infradead.org> <20260528053128.3036120-1-rollkingzzc@gmail.com>
 <ahf9j4G0sdSx0Ti5@infradead.org>
In-Reply-To: <ahf9j4G0sdSx0Ti5@infradead.org>
From: Cen Zhang <rollkingzzc@gmail.com>
Date: Thu, 28 May 2026 21:28:02 +0800
X-Gm-Features: AVHnY4LNaRyd4HI6Ch-B2c-SXEwD5WMYQCwAHpJaNzfJOctyw5q6F0iHTtDx0lo
Message-ID: <CAB7XQsFyZgJqraMaDbpR-nPpZNkvbAscjp6qGjSPOAtUPBET1Q@mail.gmail.com>
Subject: Re: [PATCH] xfs: drain inodegc before quota teardown on mount failure
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zerocling0077@gmail.com, 2045gemini@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

> Can you come up with an xfstest for this?  I guess you'd need a new
> error injection point, but that should not be horrible.

I tried to turn this into an xfstest.

In my local attempts, a mount-failure errortag after
xfs_qm_mount_quotas() was not enough by itself, because ordinary test
setup did not reliably leave an inodegc item that would enter the
dqattach/eofblocks path during the mount-failure unwind.

The draft I have locally uses two DEBUG-only errortags:

  - mount_fail_after_qm_mount_quotas

    This injects -EIO immediately after xfs_qm_mount_quotas().

  - force_inodegc_eofblocks

    This makes a regular inode released after quotacheck scanning go
    through inodegc/eofblocks cleanup, and delays that inodegc work so
    the mount-failure unwind can reach quota teardown first.

The xfstest creates one regular scratch file without quotas enabled,
unmounts, and then remounts with:

  -o uquota,errortag=force_inodegc_eofblocks,errortag=mount_fail_after_qm_mount_quotas

On a kernel with the errortags but without the inodegc drain fix, this
reproduces the same teardown ordering problem:

  KASAN: null-ptr-deref
  Workqueue: xfs-inodegc/vdc xfs_inodegc_worker
  xfs_qm_dqget_cache_lookup()
  xfs_qm_dqget_inode()
  xfs_qm_dqattach_locked()
  xfs_qm_dqattach()
  xfs_free_eofblocks()
  xfs_inactive()
  xfs_inodegc_worker()

With the drain fix applied, the same xfstest passes and the filesystem
can be mounted again cleanly afterwards.

I do not have much experience with XFS-specific fstests, so I wanted to
check whether this is the right shape before posting it formally.  If
this approach looks acceptable, I can send a small kernel series adding
the DEBUG errortags and the mount-failure fix, followed by a separate
xfstests patch.

Thanks,
Zhang Cen
