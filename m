Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAE39DBF8
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 19:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791834812; cv=pass; b=DbokYwDNTahBVJZ1LR4jjwdwnBCdQPh0BZyelYV/vSIiCnyfLMA7CkmAF5pcFsE67//bVQ3NFQifcdbscYxqxg0mQJnugHoRsMBDKIMXsc0Ogg6hzn4Pxsww/j49aWHqWrxDRvtQJqYcNuhoJsiQvEq5cGquft5IMcYrbRgTIoY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791834812; c=relaxed/simple;
	bh=IlwmU8OCAbEoQDIu68cpmuFtFikNmqlb+jBjHGPeKOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BQ1+cHN4yODlA/9c/9iTzTxKPhluo8ru1/69irCobKEj3CnTYeRI0ouwoYEBqGOMciDkWeFPvAmfvL3PTP684TIQWiDBwKgcAPZUdd9pSLFEwEMTnZ/SgKl73kRg0HF4BnHgfvXExFZeNYEzcV6Nm0Z5SJaWXfmPhigpYy0OdCM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oO26jEWH; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oO26jEWH"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88834d30002so936490b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 12:53:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791834811; cv=none;
        d=google.com; s=arc-20260327;
        b=tASKpVPAjRdpaHdN9Paye4BhT52zOehZtGqcpxRuxuEjn4y1JHEupKKZDdjFAOzDJE
         SAnf3NYkEi1ahEKWXacoCEWURfscgGm6VVOEEiC/YEefdO16ALahm0glF9dgtTVc4s0S
         UU6YeKTAq/Rc8DWu+5+KJ7K6MWqw95SWLjKjWywpl7L4Uiv8Z3G2Cz/HHxvUkzw7n+sE
         Ucdv25U8JlcaRniXnPhZfyaDv2Heg7GdDv6klITIsMfvk2YjWaFsEjI1vJSIJswGQSkn
         2BVFu4NMmZIC5Sx8mAjYnBsFPB5sNvF6rzG0lLdj/YyhqnqO8eQjOkA/rVvp0lgDMYqf
         Ss/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GPdu8JhStDNx7MAPYui0esETTQ5pHIDAqmp9pknf43c=;
        fh=Cgo4Aa0WRIx40WHR4JRIfXmcZZOygwliEermdhZyvqg=;
        b=ayRbcMIrFlOh7MQJh1c1iY9z1zv4lpP2I3faw4dJFg6vqTffKox5/xnd2PK7nDpDu/
         Cl++170/beajitJPwXC2B0iWezhaH92Hcfrhg8Bl1SfGGMYXLFFd4+NhQ6aYwgajnGK2
         /XMfo1cHbfPVv69KevStgrfxYkM7ILEUAZFDXbvI2p6tIdPbEMuMHUMnYaDdCyeIikxo
         TCfUQs1VALyp4sfCMsdUdvUvXCHaDKS6Ynznkn6Rhq80P6zsUlQQ9B+2LXnl/r48K68R
         7hBTmxQ9nGzb3DzWuaYJTjQR6yGVsSZv/WjR3+DfkDtTrEcFbjebttqF8KZHFOLj/D99
         9ySA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791834811; x=1792439611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GPdu8JhStDNx7MAPYui0esETTQ5pHIDAqmp9pknf43c=;
        b=oO26jEWH4VmBjoVa8BmLzgQzgzo1aOI2SflpjK3Np6qwdYkujD94vsy07IvhNFHbXx
         lQ+OlglGrJJuRq2M+VBVDZncksB4oYy075FpGXC7zyamWvHmdhymN6VHbRxC+OdRxJKc
         q/xudBPufQ1TxLnLS4zaaHBfvQci2UFY8DoGrV74SSp9DWWVhzxm3t+HibyUXsDoj3SE
         pvdY0Kqvjn0XBO0B+9YNiqOadJntoBtkhEPXMR1DrMEgQuZSzLc8swHFjPKaTu4Ef9uF
         TvY055gc4BpZm76k6Ht5oRPuzuYSHvgkKwVVXEzABSW51R2yeiK4mbtteawELrHQ85xE
         O9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791834811; x=1792439611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GPdu8JhStDNx7MAPYui0esETTQ5pHIDAqmp9pknf43c=;
        b=2j2nlBWeyBtX0BLkIwKPlZpS/g1Pq9MYyU8tdYLFuLlg49nZQt0PiwWz9yS0U70/cC
         RdTN5QhJG5XAIRgIESYvP77AkskXcG2aGZaL4TmRC5nbAzqBLogkU+8bHWvgskSO1qLv
         hS5IdwxHU+frseO8VBNRGRlJnpcR2JeHw4OLKb6LxFM2uG/72D3gS3PpZmXgZ2XB08dy
         W9J2yCxF4JYbnT9wMp5YX0UJf2I7ZVGsqU6nkGQd7Ci0E3yZeEoERa5ozZ8soz0BdcAj
         fymLXUwFM5iDd5u4bTGSDAb6a0J6ibrGZhi/ZiEdC32kxwzXQtkVcOVudAw1Tv93XJo6
         /b3g==
X-Gm-Message-State: AFq9FYJWwADHYaj2rlWTo/ESpTPALUKgUEsqAgAGYgbsSOdTcivUujZI
	FduMbY6A1aRnow9eQpYR0v/KF0U3J98idTC5Pk46X8sAX7lFcGiwpeAV5Lw+K98z8DVN/tgvwEA
	GfYUSdUr3HJxrMlmvu3gubMLxKLm8pDbnxg==
X-Gm-Gg: AYBFou0E9MudV4cF7wJk2KXzYmrxNThpz2XLbQbngcvJeTL9yxSeBacJmq8Pw1xJoVi
	LtjbVlvcMpvFWxlOb0e3E7qxyDW9u+EXdi51YA3OdkE9DOPmCgrLqew+JnsmZgp5maTYlf9fsm8
	LgykNOy1BmA3u44ogaKDnnaLUotRX5SjhbWtY6Spdh5KBEBOqfHusePCFQXD9SDZytf0B492UOC
	E0l6wDSyBWFm+Fn9kvYCFzgGKfwatY6iii8YNoM2o6isVGPhkWCVa3YAk/As6cJnTEM6UoCD68O
	el+FuZtzp+98eSRetMxMhoSROGpCg4BeaooEpJMZ6SEci6t2OGjlXb9FcsMtK2h5mEOTbGeAlpe
	WPFie/OALcGtb
X-Received: by 2002:a05:6a20:3d1a:b0:3df:c9eb:127d with SMTP id
 adf61e73a8af0-3e16bb0b01emr9937056637.11.1791834810857; Mon, 12 Oct 2026
 12:53:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAF8PYMjkpEkoop-Wbk=2oBMdqer-pWh1osPvhSv90D2fwLSv0w@mail.gmail.com>
 <5985D8D0-2411-40E0-B20B-8622F156AF90@gmail.com>
In-Reply-To: <5985D8D0-2411-40E0-B20B-8622F156AF90@gmail.com>
From: Vitali Lovich <vlovich@gmail.com>
Date: Mon, 12 Oct 2026 12:53:18 -0700
X-Gm-Features: AclHuK8S5mUhzC6sFa4jk3SKJJtpQ1ThUTeOcarzhe3g03WaOQMz7e2F3SHDdFk
Message-ID: <CAF8PYMjKrRH-kYJkHcqXx0O1AjOgPH6PGi3R007G-qVZoXA_Pg@mail.gmail.com>
Subject: Re: Really bad I/O lock contention between non-overlapping reader and writer
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 12, 2026 at 12:38=E2=80=AFPM Alan Huang <mmpgouride@gmail.com> =
wrote:
>
> On Oct 13, 2026, at 01:47, Vitali Lovich <vlovich@gmail.com> wrote:
> >
> > I think I encountered suboptimal locking behavior with concurrent
> > readers and writers on a file, which resulted in huge latency spikes
> > for the reader even though the writers and readers are touching
> > unrelated ranges within the file. The writer/hole puncher hold an
> > exclusive lock on the inode while forcing a flush of outstanding
> > writes to disk which creates huge latency spikes for reads.
>
> IIRC, there is no fine-grained concurrency control on the same inode.
Correct. However, I think there's a middle ground without rewriting
the VFS layer too intrusively. The rough idea is to have a new
mechanism for filesystems (that opt-in) to track range operations. The
inode lock would then only be needed to protect the range tree. It
still has lock contention on the lock obviously, but the problematic
operation - needing to do I/O (or even worse waiting for it to flush)
while holding an exclusive lock - is relaxed when the ranges are
non-overlapping.

Thoughts?

>
> >
> > I've observed read's taking >> 500ms even though none of the writes
> > could be overlapping and traces seem to indicate it's the shared inode
> > lock contending with the exclusive inode lock that writes / hole
> > punching is holding. In my real-world test case traces indicated that
> > the cause might be inode_dio_wait while holding the exclusive inode
> > lock.
> >
> > I've observed this behavior on XFS, EXT4 and BTRFS so it seems like a
> > general VFS challenge. Generally, Btrfs seems to have less read
> > latencies created than Ext4 (~2.5x more at the 0-1ms read than EXT4),
> > which in turn has smaller and fewer tail latencies than XFS  (~2x more
> > at 0-1ms and extreme is smaller) although all filesystems exhibit the
> > issue. Starting with the XFS list in case I'm way off base that this
> > is a problem.
> >
> > Attaching a simplified reproduction of what I'm doing with one writer
> > appending data to the file, a separate writer punching holes in
> > unrelated ranges, and an O_DIRECT reader that's reading data. Reads
> > are doing random 4kib I/O in [0, 64MiB), hole punching is punching
> > 4kib holes in [64MiB, 576Mib] and writing is always appending after
> > 577MiB of the file. The directory the anonymous file is created in is
> > CWD by default unless you pass a different path. I'd expect read
> > latencies to not be impacted by waiting for writes to flush yet it
> > seems like clearly there is such a serialization.
> >
> > cc -O2 -g -std=3Dgnu11 -Wall -Wextra -Werror repro-syscall.c -pthread -=
o
> > syscall-repro
> > <pessimistic_locking_between_readers_and_writers.c>
>
