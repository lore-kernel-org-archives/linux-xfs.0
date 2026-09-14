Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375DA424D76
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 09:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378252; cv=pass; b=GPLEy9yPGcmmy2zYOL/jXmSyGLj6EaRV1wc1xigGIAaSiw3/8rxdk9ggW7JVCR3PC3ls8FFaHHcOYKxgpycDJqX/H0H0KmjIdKzmZj2WntsEqlTC2vy4vFinpfh9Y1I7gd8wi7olfCVIjatCDyjUoZIptTErvMgxlNmy68TJ9zo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378252; c=relaxed/simple;
	bh=yMDmYjD/QjN+ThEE2I3uZmzaiIY8a1IMAGL7HsQ05pw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eNzKK0mtgQvRuYv2fd5e4mxTv0qL1OzRLaPHq9H96FkiQ974ktv56YkZ9gg2ci1dT8ivEnGnCClS13Y/TnCCJSZEybL8W5IUh/kxzr6CD+uNP6cgVOPoYkdivQxnGbNBMZjxZGujfuwQDH6rIypGa97/AyQCzUmaaYlryWWWovk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=frim7drr; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="frim7drr"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2946dc8dbfso422185666b.0
        for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 02:30:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789378248; cv=none;
        d=google.com; s=arc-20260327;
        b=FW9LNnNOEjS528X1SghVvwzw0UEfSiIYpSeCOhKo5ngEj0xg6oZmD33qyZmo5MJ3jg
         DGMlEhQTI4newtkgK8V+r0wDDDVvT3V8CngM/fyTEmCb2KE1BoMi1T9X1cMjRRPxz33R
         9Ri0yF6ybp7pzohGxGH2IuGIlXDRyh9duJVjPoER8mJzviQYx67YGNho7gy46Jgd9hOH
         HigjyXpq4ZYOYgwgAOPiWhWLWVZnXmqP+GawWmLMCxA/ioMNzx2t9+dHN8p/kftfmZ+6
         sD9J4HAhgeAsVhq6h3zWUsG3xEA7jWvbWSO7B/j0qfDdM3Vpp3Qyiw1g7gS0PpabPVTI
         AY3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gqCFChTJvZQiYI9CDzsGoxIiJto3HJ/+K2JM3MTXW54=;
        fh=OZEe4M2d5nWjeBROpZP/D6QBzocQG6bACdf11AiD3V0=;
        b=O/U0RSM2x3FRo5NP2p2Hm46Qno380bQpVzH0rPQp9/7xWdb259UqdlEP9H0ImsL0Jr
         J+xAlnZKwYFEmCKPsLz4TNjdQc53YscSv/TkuwpXjnZWmaMq+BVGp+2k0TAWDpvwrx3L
         sXNPUmB2G4rnkFshFwMvjDZTN6+m/AZ3ER4y4c3P76wGfFQEpoUgf3WfPm3YADdY+KKa
         bbKFRzMzY6CVY/E10kmECGCBzZRw3VQUjerYnD5PsLZlmv7xZHMq8WxDkKS5ffZdR/uT
         yte/FZ5a4mKoPr1PI0MJ3e1acnkrH4Wj5T1+rFbYN2OdpLR4RPUAqtZHRQnxjqRZ6yEs
         VIkg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789378248; x=1789983048; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqCFChTJvZQiYI9CDzsGoxIiJto3HJ/+K2JM3MTXW54=;
        b=frim7drrmFcIbTuy8UH0jSOMwbLLREzGS2kbEf7NS8uRW0kaduJXyppXIwUKTcNiTu
         OGC6DgkEwznRLzWrwY73Mj2ur4dxm7D81JgsV9P92psNJZQW8usC3IDk67dpF8kfkMC/
         eHPnNcMV4efBWUvKJ/higBS8UTFY0SYyXZ4keyvtRnHonZuGLbSXFyJTbtFKGN+qNANn
         j1Onjj75+lMTMjV3Px6t5GNNAwViMbePUUZYpJCTY/+QtJrUfG96unjpPNUlZXa+AGhR
         /sDHZZMTn0LMVPnMLISKFu9r1Ragr267Cltp8NQCfwdAcDrq1zuSwUIS7KkfLWYTNZBS
         cDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789378248; x=1789983048;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqCFChTJvZQiYI9CDzsGoxIiJto3HJ/+K2JM3MTXW54=;
        b=Dsv999VFGc2uBRNCrTNTWO6QKXC9qDHDjFExWdI/f6AwtTqPUwyIQQ02YdgRkkNQ6T
         UT/X0giIvEeSuxbzvJcKIr8giSpeAWJ0nLt71bL8knyr8+y7N9Mjdms/jKxlR86tsHiq
         1USmxxomOZtiInIWht4XAm9lfmCX3QiLUlJZaFfIvo6VG8JrGtzPDT4uoeouL04ZTytM
         hhJCY0jbqQYHpJfWJXgYE1RSdil4R4GXkHlL79pLtUQdzrNVmxhw6gZJzlEhdOBUFlIY
         7Hy/GVxlQGwSvU9Jp5/HCUwCOysElaCtOMs0FYOq8MS4lmJ+YvA6pQOjrpKi7IFqFAYT
         W9yA==
X-Forwarded-Encrypted: i=1; AKwUvBwcZ02JnRJAeUSeLFdxxl+2CK6wkOBzUhxXKoRfPRsG+ec9ApYZQV5kKdz/pFcQaaxfDCpQERewhVg=@vger.kernel.org
X-Gm-Message-State: AFuF++l4JS6H4XHpv+b9SI6mHsD6SPqBT36lfHUNOeniLL3V5APLWTcd
	uWJaU5KjHdKGYV2Yeuzu5057ZQ9pv3Vcb6UF7Kn3f9KcgrbVRXEwui73rAIDjD6V5YnYI5qQigV
	jPstZU5KitvlBiLHKaFDuXiYRaZP03HI=
X-Gm-Gg: AYBFou14H+Zfxh8Dm4B/8ksSlDCkmSsdhpwPvr4LckcAnX1j8s0AQrzQope9kSAhaHm
	EEuyppXVkFMo6bbQZY9Jkfaz160Yil+Dz3O1wBZzW++wLKF0CcVmPouW7CDDyauTBZ3q1FwSUdj
	tRNGNnGBLpZY24w6rlqraAZQHLh6+OQnXugX82kJb7e8EyX5XUHeQ1D6RndLJSwixJxuzCaGg2r
	iKi55eq5f1hvztXwQqTS2KR/pZfdLZcimkx+afiEoppaQzQDCIFiqxgyFKKpeM89XR/+TKNVFPs
	UswggqEHL0WlbxBFENeRSRzbgBYdNQNGcYGUP5ToCwpnp7LD+xmAtDgQ8dqS7QcebuMv6l8Egpw
	41WX25qxicrT2
X-Received: by 2002:a17:907:1b27:b0:c29:5b0c:1b44 with SMTP id
 a640c23a62f3a-c29b8733bb2mr100686866b.37.1789378247563; Mon, 14 Sep 2026
 02:30:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914082836.1658-1-aditya.ansh182@gmail.com> <20260914082836.1658-2-aditya.ansh182@gmail.com>
In-Reply-To: <20260914082836.1658-2-aditya.ansh182@gmail.com>
From: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Date: Mon, 14 Sep 2026 15:00:35 +0530
X-Gm-Features: AcwNN1UKHLJZwYVZA4DlDXXu8oZSCFJnOVBFsjArqTq1h7YDBAIr11HuW0Nojew
Message-ID: <CAK5ssPMkijN987z4YTQDbe4xJd0a2PqXuTUezcRh0zA6g=igUw@mail.gmail.com>
Subject: Re: [PATCH] xfs: prevent close() from hanging on frozen filesystems
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please ignore this email as the subject is missing v6
sorry about the noise on the mailing list. Will resend
with the correct subject line and version.

Thanks,
Aditya

On Mon, Sep 14, 2026 at 1:59=E2=80=AFPM Aditya Prakash Srivastava
<aditya.ansh182@gmail.com> wrote:
>
> When a file is closed, xfs_file_release() attempts to trim speculative
> post-EOF blocks. This requires allocating a transaction, which blocks
> indefinitely if the filesystem is frozen.
>
> Fix the hang by wrapping the preallocation cleanup block with
> sb_start_write_trylock() and xfs_ilock_nowait() to bypass the trim
> best-effort when the filesystem is frozen or locking fails.
>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
> ---
>  fs/xfs/xfs_file.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index d8202da15aca..dd6d2e08faff 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1872,17 +1872,21 @@ xfs_file_release(
>                 return 0;
>
>         /*
> -        * If we can't get the iolock just skip truncating the blocks pas=
t EOF
> -        * because we could deadlock with the mmap_lock otherwise. We'll =
get
> -        * another chance to drop them once the last reference to the ino=
de is
> -        * dropped, so we'll never leak blocks permanently.
> +        * If we can't get the iolock or if the filesystem is frozen, jus=
t skip
> +        * truncating the blocks past EOF because we could deadlock with =
the
> +        * mmap_lock or hang the close() call. We'll get another chance t=
o drop
> +        * them once the last reference to the inode is dropped, so we'll=
 never
> +        * leak blocks permanently.
>          */
>         if (!xfs_iflags_test(ip, XFS_EOFBLOCKS_RELEASED) &&
> -           xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> -               if (xfs_can_free_eofblocks(ip) &&
> -                   !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> -                       xfs_free_eofblocks(ip);
> -               xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +           sb_start_write_trylock(mp->m_super)) {
> +               if (xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> +                       if (xfs_can_free_eofblocks(ip) &&
> +                           !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RE=
LEASED))
> +                               xfs_free_eofblocks(ip);
> +                       xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> +               }
> +               sb_end_write(mp->m_super);
>         }
>
>         return 0;
> --
> 2.47.3
>
