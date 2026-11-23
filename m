Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795438859;
	b=dxvq8iN7eUe0NuWAua08Hw4pOpzDHmwuvIy3f9FWC95voccDiQ1PpOaLbcil5VYjqDHU
	 CfS9m6soYKxycSTZWt24e9HF5AI9fVWZtY9WI4KDDQ9/fjF0+oigpPbAtreMqPwOHc3lA
	 QgHZjNbgqzG4AVTpEGHYP4zjI6RI26Vv9aVz0ZercKg2NaOjgdpjA3hKLCgecaxaGUjb7
	 A4nwXuSV5dclxU6B+TzoSxCWF08Jb9PMr0V94qH6m8vg03MMvSMaUm5leoMfw+ooBNSVv
	 eAIbJ9kLmbz+3k/ru94n2xRAq3JUsgjc3LMgW0WkKF8K/p/fwhSbTXfDcQ3xpM8wG6w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795438859;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
	b=VIcSFhBvk/qaHmTxymjHPOhhikuliFcJbIq6SRW6o/CyA6jS1veWy133MsxhUo7G9Dfx
	 6hv56qniDQZ8DuQ0+XqYbyusHBtb0ifu3mILnGoFwINn6SrftzcAg0HpbY33xB1gu+KQP
	 sXKAwmQij7QBG7kJ8LzdlmYXxBpQOdyv+i6mQ6eQPyGXwgtEuqkfq/LWkK5H+fmewhMU/
	 3bWv29d3SvXRmiLyV6KJaqKJoxsWrDbNOcGRH2L9QUvCwGynhETKqtUptdmuCDHztIAY4
	 vI0Cfj4Ggz+lDSwg9skjOAsycsVvYuRqfQtBNW5HP/olbwogaOrfOmAgxD0MlvLwivw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1491E606A321
	for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 13:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1491E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kkson++k
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso4086261a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Nov 2026 05:00:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795438857; cv=none;
        d=google.com; s=arc-20260327;
        b=Rt6ot1tKC8zazRwz5W4UVoQcXK9zN3+2gNBRZmG7lH+fNyhoENcVvd2djilciUXj6G
         INScyGvi/nR8Tn+m+d3f/guRqx32RJrOfpaB9T5qwBFxubhcrtHiBayk2jfsomCi+0MB
         hMNFjyJndZBdDQ74E4quVZl43BzLeuESrKZtejileDG68EqtqInY2WKb0Yk9iY/D9FOj
         5/bEyMPAeKZZpsEnsB/2Xg8ATbHQliUvSoKZyQ/Lm0jJsqoSte/qz4QcBEjQSgsZxfwF
         2NAzrEmdFcrncsM5G/EfejPSiBJRJAGhfqUwUtFCakvzoKaPjrCnfLjCvYvk0q/zTF0J
         tnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        fh=fq03NGQrXqjAXdWzJBqnh4YciVffvQh+GOOhzEViBkc=;
        b=V08nIIfvzB1hB86BD/UAHG5hmjhpAJiNYNCNFavJfnrlPfgYPdTD5rKPhfGUAtuKCA
         8iIzmhmFZmZJLJWuC71sujM/gWKtGTG34RD5MO3727vAerxhv+zcriahy5KTL78dt/A3
         SfxAsQryXJJyJcvU5FHTt63L6w955zecGZIKz5mEEXNAs9BczUZ1M2PsbC7FN+bBwq+o
         BLolnPuoMj3YEOSV1BPW1iEwCT18cY0RhPsbaj8Re3IN5bXzZtsiZfykFjfNY758zHsP
         RC++jT/CgQ4ZtdIJip/EcXQWdkkzzfJVt8plClh5aI0yi7m4bo5JDqpDl7pcub6A28my
         Lw7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795438857; x=1796043657; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=kkson++kiVuuq7GlVJEDUrQHu19KcH/nihH2BzgLa6gbrvy17AZmxY1D1w0dt2h46y
         /xXI9YCF3W8v6AnWEDT8Xid0rKVtto9xbQeFZkRGR+cb5Y8RIC0oMxupLBYaYJC4CQou
         6ZJgLzs7wocf6G/7L1QJdpNwS2lbDAistHwZiRuhKs46qZQI5UTzUa+r+vixCZl4Sxxv
         NpVQv5tq4rxjVYt/Ok4zCR0OsxODa6kreqGz8wEkn4nw5GUASkqE6hP4ExSDLRPowFf2
         0zimep72RFU7EbpYHdPGxIgrdpvUiN+7UnUUrPJ6dRIQHj227oDE5EmUxVXBkiebQasL
         M4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795438857; x=1796043657;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AMCJ5wbvnIEodr6Bx3XwSyi7m8Nqsc1HfBhVMog/o3w=;
        b=23WJqWUmBqtCvZitpqFZZqFuL4W3ZWbGu8MUa8691Gls87G9WYL3g+54iIqp/GOMRr
         p68ORNBYRPX/uSt1Rrc+aQ/gUDjn5z1krv8x6MijHBFJwbsGq1low60QiWRi9rNzNZMY
         gJRlM6H5v3QojfjJ72R+7gEw1SoTHUpIgdZVF8Xp+c6hfrA4LYwvU4awVyT/073LAngA
         70oDcNSE6yNt6UIawc569rqjusEboLnDKHoO41JqhTWrQ/DYPguXTErvemuW0iDZXPN1
         V6amtDT9K2b2DGy/v1FqJo4LI+GhMUHuDfjcj/D/FHC36VxL3sSOiAITKhK5QYV+t7d0
         Sq0g==
X-Forwarded-Encrypted: i=1; AL+hErFcktAe4D+igL/DV4JYhqZgF1sG1PZFHceS/5ThHEk043/NODgpPSaQl4VEyiR0HDORdQJh71QM31U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+AYdBclS7eQnS0KDhwAldruNd/xva8NekbDtyLkCo9ASnOCICE
	cSX5m0FNgTJM3JaTQ0SoJ2PUVvnibfBy5VM4PrqSevqYnuHE4mzdvawzLzE0AKKKIzcjTVGU1Gp
	6ilvPT6CELNXb3rsnesdBC3EpKNAN7Vg=
X-Gm-Gg: AZFdTZck0fwZcmrh6J0WGm0PjraU1Qe07i68I53/NJTxuQJbyOoo8ttaoTBmLLhsOpr
	Om7fHts9cxuhngRwnB+zNs3FlSoaPQKfSe/98mpWRmWsEYwZxzKz4ySdrHxoW/lkgojUY+fB7Zj
	a0PFmtzPQG2Vl0yP3dBLz8ujqsN7vYv2U/ohNVsYptt62MQGiDKMKf09o4QxJDGeNEAYKSJy/Lj
	JLy4scP+gqy/9GVTDjBH/CIZLFcJyyJlGxy7MmJpf/Iba6Ey2D/HNlia0eqzGg9HigxTtcoSku8
	5HqJSb57u4ZbkiGeAPLGSexVSKYrCCp8J8+C0YMEkCxLLN+NU5/Av93LmHJYT+vIsBCER3REdoX
	n3FnFY/HoXNaW60FRzg+KJy378NCg7D97xFrJjt8eFQRmRxd3guNHCIpYV8bqwDEj5rqIoQ==
X-Received: by 2002:a05:6402:501d:b0:6ba:659c:8ca3 with SMTP id
 4fb4d7f45d1cf-6ba659c8fb1mr5474446a12.10.1795438857096; Mon, 23 Nov 2026
 05:00:57 -0800 (PST)
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122000856.536902-1-koray.fra@gmail.com> <20261122000856.536902-4-koray.fra@gmail.com>
In-Reply-To: <20261122000856.536902-4-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 23 Nov 2026 14:00:44 +0100
X-Gm-Features: Aa3M54oIZEz33KQbWl8M_WOYBLraeDplxcWm8_8Bl8KeH9NFv_L8S3OGX6_s9I0
Message-ID: <CAOQ4uxgc6pP+_xvJMbqj6wOdGzS75Vn6x6i_vUfCJDD46DAA_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] ntfs: switch to the new xflags fileattr API
To: koraynilay <koray.fra@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Darrick J . Wong" <djwong@kernel.org>, Andrey Albershteyn <aalbersh@kernel.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Lauri Gates <lauri.gates@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ntfs@lists.linux.dev, linux-nfs@vger.kernel.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 22, 2026 at 1:09=E2=80=AFAM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Switch ntfs_fileattr_[gs]et() from the legacy FS_*_FL flags to the
> modern xflags (FS_XFLAG_*) fileattr API with masks.
>
> Introduce FS_XFLAG_COMPR and FS_XFLAG_ENCRYPT and add them to
> FS_XFLAG_COMMON (and add FS_COMPR_FL and FS_ENCRYPT_FL to FS_COMMON_FL)
> to be used in this API switch.
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.11
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  fs/file_attr.c           |  8 +++++
>  fs/ntfs/file.c           | 63 +++++++++++++++++++---------------------
>  include/linux/fileattr.h |  6 ++--
>  include/uapi/linux/fs.h  |  2 ++
>  4 files changed, 44 insertions(+), 35 deletions(-)
>
...

> diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
> index 50be49f4c913..fde6fb2fe39c 100644
> --- a/fs/ntfs/file.c
> +++ b/fs/ntfs/file.c
> @@ -155,31 +155,37 @@ int ntfs_file_release(struct inode *vi, struct file=
 *filp)
>   * @dentry: dentry to report the flags of
>   * @fa: filled in with the flags of @dentry
>   */
> +#define NTFS_RO_XFLAGS (FS_XFLAG_COMPR | FS_XFLAG_ENCRYPT | FS_XFLAG_CAS=
EFOLD)
> +#define NTFS_RW_XFLAGS (FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
> +                       FS_XFLAG_NOATIME | FS_XFLAG_NODUMP)

Nit: checkpatch may allow 100 chars, but this due formatting is not
easy on the eyes
pls break to RO line and indent the broken lines below (


> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 4faa40febf11..219e7c8eb601 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -7,12 +7,14 @@
>  #define FS_COMMON_FL \
>         (FS_SYNC_FL | FS_IMMUTABLE_FL | FS_APPEND_FL | \
>          FS_NODUMP_FL | FS_NOATIME_FL | FS_DAX_FL | \
> -        FS_PROJINHERIT_FL | FS_VERITY_FL)
> +        FS_PROJINHERIT_FL | FS_VERITY_FL | FS_COMPR_FL | \
> +        FS_ENCRYPT_FL)
>
>  #define FS_XFLAG_COMMON \
>         (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | FS_XFLAG_APPEND | \
>          FS_XFLAG_NODUMP | FS_XFLAG_NOATIME | FS_XFLAG_DAX | \
> -        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY)
> +        FS_XFLAG_PROJINHERIT | FS_XFLAG_VERITY | FS_XFLAG_COMPR | \
> +        FS_XFLAG_ENCRYPT)


Rule:

You cannot add a flag to common without carefully auditing all
filesystems that support the legacy flag.

FS_XFLAG_ENCRYPT can go into common but must also
go to FS_XFLAG_RDONLY_MASK because it's read-only for
all existing fs.

COMPR is rw for some fs and ro for others.
As with CASEFOLD, you cannot make it COMMON before
converting all casefold fs to new API so that each can say
whether it wants RO or RW.

I think there may be a way to deal with this easily since
ntfs doesn't need to set either but not sure.

>
>  /* Read-only inode flags */
>  #define FS_XFLAG_RDONLY_MASK \
> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index e40806b3a69c..09fc7e066485 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -275,6 +275,8 @@ struct file_attr {
>  #define FS_XFLAG_CASENONPRESERVING 0x00080000  /* case not preserved */
>
>  #define FS_XFLAG_PROJID                0x00100000      /* project ID */
> +#define FS_XFLAG_COMPR         0x00200000      /* Compress file */
> +#define FS_XFLAG_ENCRYPT       0x00400000      /* Encrypted file */

This is a mistake of patch 1. the newline should remain above HASATTR
which is allocated from the end.


>  #define FS_XFLAG_HASATTR       0x80000000      /* no DIFLAG for this   *=
/
>
>  /* the read-only stuff doesn't really belong here, but any other place i=
s

Thanks,
Amir.
>
