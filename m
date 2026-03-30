Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8761036C9D0
	for <linux-xfs@vger.kernel.org>; Mon, 30 Mar 2026 02:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774839077; cv=pass; b=oF6hBDnCQrjIqTOHWrpyX/IKQ3z6xJU+Al2Kl3rXK1jJ5/8zkSzGrSqbRQ/hVjeL7M0SF5DnE/mWCO4UiXTh2w41l0hP4YeZn1ehbMNSGCpYE5e0f5yEx0gL+u5v6Ac1mMwfsikwVU7j+M3HL3c76FHJEYnqyCKfCAJ7dyXjnjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774839077; c=relaxed/simple;
	bh=RNK/vnKu/pgZEBtVMkMLbuqixs2u1SksMaUAltp2QDM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=auUKxnVQ4F/h62OFQZREfnnZui/JzQX86sxaQT15FJDoTzqts9QjftSvkyy1qRhPHDIRUOCa8NS/uyVM3Vz25CrYBRU5UcsjmQrrI6pBerac9PBLhbrMnxP86ryrRS5TGgwURTJqxKYAFe/cJsQA92OVUKYQe0Hh5XEaDjq4CCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qwTzhzBI; arc=pass smtp.client-ip=74.125.224.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qwTzhzBI"
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6500040ef85so3218384d50.1
        for <linux-xfs@vger.kernel.org>; Sun, 29 Mar 2026 19:51:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774839075; cv=none;
        d=google.com; s=arc-20240605;
        b=CS8RA6pwYzMC2yGJa53/f+391fPgoKWdt7H/g9y1yGEtxowmPaRPRitOjpSFtgfSJd
         KPKxhaXY/6z/NMxBwt/LLNGbGbPpF5xlxoLSjth0Tvl/g4mQTmkdydKoTwJwOPacpBPz
         VDDuvmREEoLhDKLfYHxa+pMRuF7Vq6f3wCZOmXgxYgwpsHsxf+YEmqeUiCAuapsCOUVC
         rypVMIZRemqnGEeCPkVyx/UwehGbedXVJUUDJ8w1CdmXLCqE0ILfulnP+jSfCJHCeK5a
         IJJ49jl9zp1e5rUUfgNM1sF5BYQ24xR4gM8zIXjX+hVwODaU/ezuk/mh1NOtHjplI8mF
         FEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L/pm9TpXLcvckJFncspSQ2WQQxlL1sYTEpU9KK49x3w=;
        fh=7aFvoLPrUUcjBxkHjLNpLqt7jOQSg1OgWzqhKPnX1d0=;
        b=LC1hqNrJpoiKO+CM6FaagV0mRcJ0rtvaZ6xdtGsZYXRBUl9onvRMzJJHPHQJVqNBA8
         ajeH1Tu+0osexJRXlWkXC3svCG60bdXGSXny0E/5yn+pT8VxgZvEkW8OVhbFfyWgx2vV
         JlcT7x4hVpOO2/fbMYxDDR2ozvAyB0TbudUZDC186+e+sNzzPDI1R+ksKXSjJI+luDkQ
         Xm4qRZQ+iHhJQTPMV1EE3zn8hh7bbX6rLyNw2rHa6l9277tZOWlcXlL/6bytTVnJLq2o
         +lP+QuVCwVtSzgSIFud0+yP35Efbd7YcgFVVC8BowlgFnNa2391ZXb8bLMSBW++Kl4Zj
         v8pw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774839075; x=1775443875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/pm9TpXLcvckJFncspSQ2WQQxlL1sYTEpU9KK49x3w=;
        b=qwTzhzBICL0Muxb/f1s6PRi1tTWLc3aZ2kDwQR96UeR06WONd8UCSLo7j6+a6IggnC
         VveKGUipDYbN+Iel1SatJAHd3Fr3XoconQc15au0LIvyCrva6qHx5XX2pr9QRvDTndck
         qn1A7x47xNce7tibKXM3SkKl3QSZoO8TulrVrVICBCdFPdSU5s75r4VwBD/iFw8ZK/55
         DuCZPJ+gJ0svbAwQlclejOYX5NInUOADxbMZsp92yjnaGr1Bbw9iAZnoV34jKS0JDDFz
         6iaGc7aC7PwYfEtCPxP/XWfcVUl6YKrfp/QxXgUkg4m0G3SmOx1qrhE7DYBhWADg2400
         4xQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774839075; x=1775443875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/pm9TpXLcvckJFncspSQ2WQQxlL1sYTEpU9KK49x3w=;
        b=n4qVpyUA5jCJasTl6IPa3OM9gvVRQ8rA/yccXj0uCfJhosJ2Re9gffM6tLaCEOFxTX
         XZ3h+9M/+bwEvX5Uf240TCnLw4EZBOdZmnfQF7YgsfauQQ9Wrc7U5PUURhAp/814SWmh
         dpUGwtzor85qFMjk89Y9o0bpsfpAXHEYTdRhiQf0lV7ffVGUAC7+gS9d6i80N8q+zez3
         JZpPxXTSg5jRx7b97cEKk9yDFUlOZYygs0m6bZnHr6wyfPhOyvf32/zxwS2vdsxGUZze
         wNZQo/wEbYXOqYDjRQNai+KtM5wo6qZltHo0xcvv5+nEqOorhAKjMMUjBR1PWqf75zAE
         Oe2A==
X-Forwarded-Encrypted: i=1; AJvYcCVJNqRx4Vrvjy0H9bGrlzejJB5DIC9F8/la8cv/ylQ0WLknwcsHmm/OfUUScLWJGnFF3uUf/An517U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+b4lY9WBXushsi4S2Jr1RO5E0n4NLeMEN4YGPRsyl6SW2kDmC
	YzDPX7lLIsASuZ2MuDkAzaZRQmwTm65Q73nnHNjOvBGCp8kqjxJW6wFajFkntCpcmu85SBPnfqG
	LpKItZIJGyHY3K5atNT9Z+S2TrUIBPRw=
X-Gm-Gg: ATEYQzx+tFVGywstheLZI5Z1C/3cC3keb7h+bWRPnv2bxB6sSmSyIWHeo7/DPEqvAmH
	pSOaoHtB5lcwdT2srnOuIue9c7QiIxnZGIm9fYvsLhEmB7+DHXqk/dUXNH+9D8yXA01KIPo2wba
	r7xgB8hIB7YGidtV20LAJaQ0HrzNAx50uskvfBpwUSp0A0p/gyg5A2mQxzVfKZkyZw92kBHxPhw
	4obVKZawIQBE2IAqowlozAf43n4janDEaUCJZ7hsX9K0knkZd22ao7x/x8kl6QGMYEXCzXM4lZU
	YnencYvbFAzFGg+VzGwp
X-Received: by 2002:a05:690c:e092:b0:79b:d56a:a7c2 with SMTP id
 00721157ae682-79bde06b035mr114098427b3.48.1774839075368; Sun, 29 Mar 2026
 19:51:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260327131448.156177-1-zzzccc427@gmail.com> <acnS4iOihfWL4ay5@dread>
In-Reply-To: <acnS4iOihfWL4ay5@dread>
From: Cen Zhang <zzzccc427@gmail.com>
Date: Mon, 30 Mar 2026 10:51:03 +0800
X-Gm-Features: AQROBzD8lyNwGbcqekKHhTmk0Q4gpgVmHnWhnWcQE3GVt6kS1rEIV4i0Mce3u4g
Message-ID: <CAFRLqsXeK6Y_C8=afkxJoMmxtGn8p5HaSy5g5VYpa+gcA3RKiQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: annotate lockless bli_flags access in buf item paths
To: Dave Chinner <dgc@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	baijiaju1990@gmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dave,

> When XFS_BLI_STALE is set in unpin, then by definition the buffer
> must be locked and the BLI referenced. [...]
> Hence we only care about the bli_flags when unpin has the only
> remaining reference to the bli, and in that case the read cannot be
> racing with anything else changing it's state.

Thank you for the detailed walkthrough.  You're right about several
things: READ_ONCE()/WRITE_ONCE() was the wrong tool here, the
WRITE_ONCE in xfs_buf_item_release() is useless since it's under
the buffer lock, and the tracepoint change doesn't matter.  I'm
dropping those.

However, I want to share the actual concurrent access evidence
before we decide on the remaining two reads:

  (1) xfs_buf_item_unpin:510 reads bli_flags
  (2) xfs_buf_item_committed:803 reads bli_flags

Both race with two different write paths:

  Write A: xfs_trans_dirty_buf:532  (bli_flags |=3D DIRTY|LOGGED)
           via new transaction on the same buffer
  Write B: xfs_buf_item_release:713 (bli_flags &=3D ~LOGGED|HOLD|ORDERED)
           via iop_committing on xlog_cil_commit path

The concurrent paths are:
  CPU 0: old checkpoint completing on workqueue
         =E2=86=92 xlog_cil_committed =E2=86=92 iop_committed / iop_unpin
  CPU 1: new transaction with the same buffer committing
         =E2=86=92 xlog_cil_commit =E2=86=92 iop_committing =E2=86=92 iop_r=
elease
         (or xfs_trans_dirty_buf during the transaction)

The comment at xlog_cil.c:1856 even acknowledges this:
  "the CIL checkpoint can race with us and we can run checkpoint
   completion before we've updated and unlocked the log items"

> IOWs, using READ_ONCE to indicate a data access race is -incorrect-
> in the cases where we actually use the result of the read.

Agreed.  For xfs_buf_item_unpin(), you're right that stale is
only consumed on the last-reference path where no concurrent writer
exists.  But the read at line 510 happens unconditionally _before_
atomic_dec_and_test(), so on the non-last-reference path it does
race with the writes listed above.  The value is discarded in that
case, so there's no semantic issue.

Rather than annotating a race whose result is unused, a cleaner fix
is to move the stale read to after the freed check, so the read
only occurs when we actually need the value -- at which point there
is no race:

    freed =3D atomic_dec_and_test(&bip->bli_refcount);
    ...
    if (!freed) { xfs_buf_rele(bp); return; }
  + stale =3D bip->bli_flags & XFS_BLI_STALE;

This eliminates the concurrent access entirely with no behavior
change.

> There is no consequential race here, either. Once an BLI is marked
> as an XFS_BLI_INODE_ALLOC_BUF under the buffer lock [...] that
> flag never gets cleared from bip->bli_flags.

Correct -- the bit being read (INODE_ALLOC_BUF) is never modified
by the concurrent writers, so the result is always correct.  But
the concurrent writes to other bits in the same word (Write A and
Write B above) do constitute a data access race on that memory
location.  Since the race is confirmed
benign, data_race() is the right annotation.

  - if ((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) && ...)
  + if ((data_race(bip->bli_flags) & XFS_BLI_INODE_ALLOC_BUF) && ...)

So the v2 would be:
  - Move stale read in xfs_buf_item_unpin() after freed check
  - data_race() in xfs_buf_item_committed()
  - Drop everything else (WRITE_ONCE, tracepoint, release-side)

Does this sound reasonable?

Thanks,
Cen
