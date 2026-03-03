Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE18388E7E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 09:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529680; cv=pass; b=Z6OOHz6PKAnvlCXmVtEIoF/6nd8a1gf+h5UO/qZzGZhM2yAxuvFZWBTV65t8jwBzrlSgMBHWvWNx5EUec1E/gkAyChcc04Hy4vkmK5CPGNZWW+Z7BbXuHc+MSxqYbQhVK8pYQmcva2ZsCkUrY6w2thXO3sKoKBAFq2AE8IrazAg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529680; c=relaxed/simple;
	bh=bb64YLXIy3oPeHwsvS7m0P33nEAT9WuWSYWp276y4dI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZTKgAYiEF5XWWB/dFrne3h8GDDSmRxmEAvvIy2JjthEZcf3pTEukBqFCeDEpUFB6oMY/PHnUeWNVff/nT1emDmn3qbLn262Uf0bs43Wvns3vr0adbMPnrUxohiCSKg+ewza4dChC5sB28TS5ZH55Wt3OKrLWmkvn74eHv5FfCKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nGuTpO3B; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nGuTpO3B"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65fa4713bd3so9335171a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2026 01:21:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772529676; cv=none;
        d=google.com; s=arc-20240605;
        b=e2cMb7hkP0xSPU0neIY5CoiJByDs5vPWdD/eyNFHAuTeA02alTFFU7C8BTho+YeddL
         OJBSQm21dm4QJyLdlynU4YyelBoQ4MO3R5PkWjjHrvqClic8X777yxPIOoQNMQ5jb4hT
         DqOxkwRna0l+TFSTPskptW+9kG4H/nYmGqsoL1pACrtXoYn3RVDimHNIzNT6ORns3lHJ
         1F+RxsFk+dE4c/dbPYpCDYqc2SpPGawf1hqUZyE9UWqfhNuiMRDjr9Gz5QLT2CSvM8lF
         3NJIj3uvtdQ5nAgJf/xH7ITqE/E78/U4rbeuEhGA33saNh3GYieP0/9n7APNt7lJxwlC
         NwPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pkig2duPJVssDkbWxtWOY0gHaOnkUNJGF+RUH4/MX7E=;
        fh=W38F1VzYxA84/wM9bdyoSrn3IHg2QLMAKg3cNlm51sk=;
        b=N3BMIXjtqtxmYxBeTGbkp50sE7/pG7dmOnzEwHnF7StTjdD5DmNexE3mD6V0S71YvV
         ZMThWIQ2sw/FK+/+D4lePJsf3ltdhYM4o7X/0dic+oSF5+k6LpdNIs+2B7+ZAtMY7nrX
         VVlnyroMLjpguXB8IwN3xe+s652DhzToVnbzTKar5Liaq8uJEyt7R9d5r3z5UzC+MWBQ
         L0TDnQSloTlQlQFgiBZltf4YJ4YcKE37Q1IiY1KXmqICSC0R83u7zUZEz9zThH1AqddC
         +MWwk4oavccn/CM4obsY2sQw4ZfQIRXI5E1DgqXMGCDoudBIq5Bei+okxRNFW+oKCKjN
         AOlg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772529676; x=1773134476; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkig2duPJVssDkbWxtWOY0gHaOnkUNJGF+RUH4/MX7E=;
        b=nGuTpO3ByxyjjWH2tKgvQehhnLj3L1VHUegh6UFn9Z60eQlD1tg/xJBb10Kh4bUSEP
         YTjjKDswEqoZwpFvPZ9wIEOzbSzGwROyp3rx9ovIDwepfY2GhImOgdmCxodjRVrXVz+p
         Se/gSpfm7dx72pfJ62GfD7/Hnz3LVKnhKgoumXg5urpBgVDYH2wkfY+iybIvkkamghzJ
         LJaIdWxjTKCfKDtR4uiswi+skWBpIYFkW0Xy9l63k9aQd5d460EZrTss88JRcasaZEtA
         HPkRxCpIbSQjQoGYQa1mzndXxuD3h5wu6WZf/iSgaHQeg8pEaNzxZJhWI6Tciu6TqduC
         Y1Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772529676; x=1773134476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pkig2duPJVssDkbWxtWOY0gHaOnkUNJGF+RUH4/MX7E=;
        b=Y9K4XnOXO0rsEQQVKc1UV13/4KVGto4E67QX1xaOQxz5BhpXORM0U4Oml6dRuscXjN
         r22cUiXqdXj3KLjZZ87iXsRGh4mcEoF/739XiQslIARrHFVcS8yIucCqFrp0ZX+B7xQl
         ql7l/+HuRzBSnkgsYgGncF+QQMRy8yZxk7eIeg24IAGY/PpvzkJytJ2xhxsj5TpuLiA0
         lGze+k001MLEsF4pMgKNPhZxEtE2a2klx2bSWcq2TBUVJyfz190/yyGgbKe0+ivUsmQG
         WBgSTzKsQvS5VpJ6SLqfE9DeUexHdKNfTRhpU5gSOS/6kfYxz9YjJO42ygDGt4fQM0zx
         0Hrg==
X-Forwarded-Encrypted: i=1; AJvYcCVjmM2Hq5nnLslwlb30LTWVA6FznsP8r4xpGexsJVm5ZB93d0NTkQ6fhHSdgqYUlfGmr9xASs4ofQg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5t137sPUmLJNMnVD1j+22beMY/zpdGK79tQ+Dvo8g0eZ9IEkA
	MM6BVp4MCKWpBOt/ZwShzjZDfnS1g+SeFRhS/ZpwuZVXzgeOdzw633LUsJUmL3wVGh7hkdter1H
	GjB90dKSnTVBE+2uw/WT/7oDP6pFOIbN/hCGe3Ac=
X-Gm-Gg: ATEYQzz5b1oUwalD21ETouuzfb1simG3DjDa4JvlUJSYJ+Fvlko2J3JKI1XibrhwOTT
	50GM4UvP13425RNTaCBtEEAgv+HrSbwtNCyZa/QjrzXFNV+pWkGMHCeNZro4m8NCOcK90TqswSb
	GRvInOQQSkVgb/0GtJt73lA4kgu/jv0e+swHVNkdKZ5/rqmoQuZOgnj4r6c4PmBt25kQ4NyCA70
	Daf3pqEdl53f8mrLZcsBxo3A15YmxHMle4HCEmM1ILEA1XXz17tSdK+L2BZn+Lk4fqTalF+BsGo
	21GVuiQn3YFUdD8pvppn/0pZvTSeqZpMgDMWr5G8gUauTLOyV0M=
X-Received: by 2002:a17:907:3d51:b0:b87:10fd:b590 with SMTP id
 a640c23a62f3a-b9376590b83mr865582266b.60.1772529675436; Tue, 03 Mar 2026
 01:21:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <177249785452.483405.17984642662799629787.stgit@frogsfrogsfrogs> <177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
In-Reply-To: <177249785472.483405.1160086113668716052.stgit@frogsfrogsfrogs>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 3 Mar 2026 10:21:04 +0100
X-Gm-Features: AaiRm535KwsgAVHj6EheTjrAtrSsGztnAGaoLe1OJY2V4Cm-WW3-sgOnbmd3S6E
Message-ID: <CAOQ4uxgmYNWCs18+WU9-7QDkhp0f_xX6nvKiyDhS8gZzfUXXXA@mail.gmail.com>
Subject: Re: [PATCH 1/1] generic: test fsnotify filesystem error reporting
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	gabriel@krisman.be, jack@suse.cz, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 1:40=E2=80=AFAM Darrick J. Wong <djwong@kernel.org> =
wrote:
>
> From: Darrick J. Wong <djwong@kernel.org>
>
> Test the fsnotify filesystem error reporting.

For the record, I feel that I need to say to all the people whom we pushed =
back
on fanotify tests in fstests until there was a good enough reason to do so,
that this seems like a good reason to do so ;)

But also for future test writers, please note that FAN_FS_ERROR is an
exception to the rule and please keep writing new fanotify/inotify tests in=
 LTP
(until there is a good enough reason...)

>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  src/Makefile           |    2
>  src/fs-monitor.c       |  155 +++++++++++++++++++++++++++++++++
>  tests/generic/1838     |  228 ++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/generic/1838.out |   20 ++++
>  4 files changed, 404 insertions(+), 1 deletion(-)
>  create mode 100644 src/fs-monitor.c
>  create mode 100755 tests/generic/1838
>  create mode 100644 tests/generic/1838.out
>
>
...

> diff --git a/tests/generic/1838 b/tests/generic/1838
> new file mode 100755
> index 00000000000000..087851ddcbdb44
> --- /dev/null
> +++ b/tests/generic/1838
> @@ -0,0 +1,228 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1838
> +#
> +# Check that fsnotify can report file IO errors.
> +
> +. ./common/preamble
> +_begin_fstest auto quick eio selfhealing
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +       cd /
> +       test -n "$fsmonitor_pid" && kill -TERM $fsmonitor_pid
> +       rm -f $tmp.*
> +       _dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/dmerror
> +. ./common/systemd
> +
> +case "$FSTYP" in
> +xfs)
> +       # added as a part of xfs health monitoring
> +       _require_xfs_io_command healthmon
> +       # no out of place writes
> +       _require_no_xfs_always_cow
> +       ;;
> +ext4)
> +       # added at the same time as uevents
> +       modprobe fs-$FSTYP
> +       test -e /sys/fs/ext4/features/uevents || \
> +               _notrun "$FSTYP does not support fsnotify ioerrors"
> +       ;;
> +*)
> +       _notrun "$FSTYP does not support fsnotify ioerrors"
> +       ;;
> +esac
> +

_require_fsnotify_errors ?

> +_require_scratch
> +_require_dm_target error
> +_require_test_program fs-monitor
> +_require_xfs_io_command "fiemap"
> +_require_odirect
> +
> +# fsnotify only gives us a file handle, the error number, and the number=
 of
> +# times it was seen in between event deliveries.   The handle is mostly =
useless
> +# since we have no generic way to map that to a file path.  Therefore we=
 can
> +# only coalesce all the I/O errors into one report.
> +filter_fsnotify_errors() {
> +       _filter_scratch | \
> +               grep -E '(FAN_FS_ERROR|Generic Error Record|error: 5)' | =
\
> +               sed -e "s/len=3D[0-9]*/len=3DXXX/g" | \
> +               sort | \
> +               uniq
> +}

move to common/filter?

Apart from those nits, no further comments.

Thanks,
Amir.
