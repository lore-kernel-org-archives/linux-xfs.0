Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C378536074F
	for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777310170; cv=pass; b=Mo8iFc/C5EUa6GPH1A3QgJlWdLoPOE+sqmOYqsT8o9IlkeuDWfs1HyPHev/R51z82Wo6EOUaqw6gUYtQnR2QcjUUy0flPTjN+d3LmVO+RModVr7koYk7KNpYwPYJinLhq2LC8a03n8Y7hAf6EVAIAYn84JQvpdM4yG3M/2oLW+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777310170; c=relaxed/simple;
	bh=jxGA1aqdU5aIJg6I6FITOfxM34vHxNTeEwbnO/2hjXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oO1+kGX1Q3s7XOT8uD729Vmi4quJSV9GERLdN9oGq1gh8vfE9eU2PN9usbR8ngBqvXdVR8Shed2InIDJF8eNtI1xOunwxmlGzrzuFq/ppldivaeiPpr2xCHdVKhnRy++6Us1G8qqvcDUrd7949wBCENPWcdZHjNxVAoxcwflWSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpuJOS8p; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpuJOS8p"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ba6838e76f2so1048533566b.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2026 10:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777310167; cv=none;
        d=google.com; s=arc-20240605;
        b=ApmsaIFFM2bQCpF4l+2sdb12qeWnSOiNMpTiZHMYXCHXF6h+jduZ5Y1XQVC8/DZlVe
         Hqsfi6EAAbL7pLe9nOKf+IHP5fT4GaRO24OGl+mCQrUFvtht4+vu2X8NtIUwnXNZsj81
         5trJZt3Gm3Cibqq4Q/apk48MU+K7KtFuybfTiTeW2WVBkj9kPLkiz2HEzFDp4SvebqvY
         KzzZAj/XRvZsRGZE/JgIyp5na5tY3g0/n6LLYiP5t6IwPB+L9tFlYd5x7lVmhfxIqKME
         mvi8ibAYG3g/nVGGSmRJN4Yrimfgy/nNQBKB11MfH+2ebkwuTLfRE8IPe/JEe414mLXr
         IOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        fh=zmpmWb6Vbnw++xflImwMjnn6VgmcfCsSuWNfIlOQUJo=;
        b=JyGsfi59dfHJdBkWqbI6+gYvEeVIbCLMgrE+PMEG5tlLHhq4o1G8vW6vzpuDNRzouG
         gug/JoPPla5I3s/eIn74/EnEqfzsYxjVTtG6fprv4Q2JNcdjPGCcjfdb8LBYTWZW9WgM
         CpFSoOTfGh9OYRNiQ1OJY3T8xZsr9fKFI87C2MIOtTNzgQ9AoTK9NsShV3bQIwJkmjdF
         Kb1HMIX6W/a4kOtXQYIxg+r+36Fh6g3NMplpf3/NuqLoYYxtFPXIhRZ6OrobtJ+Zf8+Y
         TD6qMc+Nz+JWgH6iwEHj5cF5W8wPCErnFxAaES0+rCexQl+UVl/bVXO664PdxVk/Obog
         hIPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777310167; x=1777914967; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        b=MpuJOS8pwEzOsvsxMz3lW7KiuzyvLgyVO7wisFNgSltReRYyrPHbP6NNKe0oaYvpu4
         L4/qiPrIo73jH5uQpbZR4oGugkQPP98VRlXpFhaW6SeQSqBIaywdcAisu+SOjgHsP6BJ
         eZdgbubwlN5RIiCaceqN3J5Xg3TtJ0r1/lq1s3TKD0ezSflwAqTNO0h3YgOXjIAsjy1a
         KxlXlb2ZfGvAREfKJXgP3Pnp2SBU2M5u/ZfYyI3LZDrqpPa9Hm4RBajS7RjHUfb/xwT0
         5vTV4LndrGlqLFCMVAkAjX/X9yUJAEElN4WQcUDfgtaO6ov2DSnDQk8ypztNzQXw4EDL
         o0fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777310167; x=1777914967;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P6ipWyGGAT6CynzNoASFRro8XE42u5BsugQYyk5ItRc=;
        b=Xyl7AGWAJEfGI41dXup7pLukH8Z1hx92TiQR5AWkMzz3bsclwpVo9aXgj9HX34ecFu
         bEcxNnmS3UuYMVOu5rjtn0UfAy/CkwtLdAnb9bKfMxK5M8TCneshk/CsQ6rppWMuUJ90
         gSw5pvi+fexHydhkdxAVgeyCV97wiyHuSqDhQ0CQZ7iZB+qAn00+OSdxditj1ZkCyPPb
         QP4xeQzhEBNYzmCjbIhgoU7Kdbd0jCcJVR02Tlxrni9zCIPRq7PIDzCDPvj9ZQU93BZ9
         dw8M9fcZkRJfoxGUraNpZ/ffkDcvg0fWuYpNMvzo3a6iiKYQKAlIPaX0E/KYe8mQ9BEY
         bfww==
X-Forwarded-Encrypted: i=1; AFNElJ9iomGkND9jVKpbfkHqz1oxNeafoFRLcCCO8pzdJYc0+8X+fCpukoeYfsooTWzFLLaUDMLltJjQfXc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxBJMFUOztafVIAIX1xORmjzXlkG2zpdoJky5Lv95VvokCFFje0
	FfOG15UVpQWucAP4rmbv/4KLcT+RACP48BYfqGJXzKucuASjeTKF+tsG4XVfoBEQ2o9bnOM/BxA
	jjGQvUKVA2SzxeyHRjgX07G0ExnEbkyk=
X-Gm-Gg: AeBDiesgHfxtS0K4/G/oJkY7YPlQIl81i5egVGRPYQvAr0q8ced64lx3B+V6uNnc3Rb
	Mz499fIv7A0RcVGNjZMKcCzNq5hVQ6RKsmnPePWqKjqMQlVkVcb30ZB10CEqJfFREgdpjCX3Gyd
	jTV7lvQ97c5d+Lqf+gN3hhAXX8FwpKeIPartTycIoANw2ToYbhmwf8EgL4E5C0RAkg5hfF2p7St
	kjDD2D/xSDz4unO9PQTKzEDQKTpKw/qBmOWaXHJcOQr+rk1BGXGC7sfofHxI2jzfukNhsQozT8F
	ZjIDEdMnJvmq3FoLnMecogAkIZUnIWeo6t1Tgj5Begebl0oB/ojb
X-Received: by 2002:a17:907:6e90:b0:ba8:30a6:8b02 with SMTP id
 a640c23a62f3a-ba830a68c0bmr1561283366b.41.1777310166726; Mon, 27 Apr 2026
 10:16:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777281778.git.asj@kernel.org> <d5bff7b1c8f17cffb13c8a8f28bd8ad645306e09.1777281778.git.asj@kernel.org>
In-Reply-To: <d5bff7b1c8f17cffb13c8a8f28bd8ad645306e09.1777281778.git.asj@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 27 Apr 2026 19:15:55 +0200
X-Gm-Features: AVHnY4JyEbKT9mB86SxM37c-LVIlc9Tqn5Mw2-4UgKXGOHZ2QdS3GaMZk-sYwIU
Message-ID: <CAOQ4uxh+YKCZpb_FxwC+P4nbm0f5FfOy71f7+h-NR8=Xc94=BQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/9] fstests: add test for inotify isolation on cloned devices
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-f2fs@vger.kernel.org, zlang@redhat.com, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 12:20=E2=80=AFPM Anand Jain <asj@kernel.org> wrote:
>
> Add a new test, to verify that the kernel correctly differentiates betwee=
n
> two block devices sharing the same FSID/UUID.
>
> Signed-off-by: Anand Jain <asj@kernel.org>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/config         |  1 +
>  tests/generic/800     | 88 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/800.out |  7 ++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 tests/generic/800
>  create mode 100644 tests/generic/800.out
>
> diff --git a/common/config b/common/config
> index 4fd4c2c8af11..605a57947a40 100644
> --- a/common/config
> +++ b/common/config
> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=3D$(type -P btrfs-map-l=
ogical)
>  export PARTED_PROG=3D"$(type -P parted)"
>  export XFS_PROPERTY_PROG=3D"$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG=3D"$(type -P fscryptctl)"
> +export INOTIFYWAIT_PROG=3D"$(type -P inotifywait)"
>
>  # udev wait functions.
>  #
> diff --git a/tests/generic/800 b/tests/generic/800
> new file mode 100644
> index 000000000000..16bc1159a2e1
> --- /dev/null
> +++ b/tests/generic/800
> @@ -0,0 +1,88 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Anand Jain <asj@kernel.org>.  All Rights Reserved.
> +#
> +# FS QA Test 800
> +#
> +# Verify if the kernel or userspace becomes confused when two block devi=
ces
> +# share the same fid/fsid/uuid. Create inotify on both original and clon=
ed
> +# filesystem. Monitor the notification in the respective logs.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto quick mount clone
> +
> +_require_test
> +_require_loop
> +_require_command "$INOTIFYWAIT_PROG" inotifywait
> +
> +_cleanup()
> +{
> +       cd /
> +       [[ -n $pid1 ]] && { kill -TERM "$pid1" 2> /dev/null; wait $pid1; =
}
> +       [[ -n $pid2 ]] && { kill -TERM "$pid2" 2> /dev/null; wait $pid2; =
}
> +       rm -r -f $tmp.*
> +       _unmount $mnt1 2>/dev/null
> +       _unmount $mnt2 2>/dev/null
> +       _loop_image_destroy "${devs[@]}" 2> /dev/null
> +}
> +
> +devs=3D()
> +_loop_image_create_clone devs
> +mkdir -p $TEST_DIR/$seq
> +mnt1=3D$TEST_DIR/$seq/mnt1
> +mnt2=3D$TEST_DIR/$seq/mnt2
> +mkdir -p $mnt1
> +mkdir -p $mnt2
> +
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[0]} $m=
nt1 || \
> +                                               _fail "Failed to mount de=
v1"
> +_mount $(_common_dev_mount_options) $(_clone_mount_option) ${devs[1]} $m=
nt2 || \
> +                                               _fail "Failed to mount de=
v2"
> +
> +log1=3D$tmp.inotify1
> +log2=3D$tmp.inotify2
> +
> +pid1=3D""
> +pid2=3D""
> +echo "Setup inotify watchers on both mnt1 and mnt2"
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt1 > $log1 2>&1 &
> +pid1=3D$!
> +$INOTIFYWAIT_PROG -m -e create --format '%f' $mnt2 > $log2 2>&1 &
> +pid2=3D$!
> +sleep 2
> +
> +echo "Trigger file creation on mnt1"
> +touch $mnt1/file_on_mnt1
> +sync
> +sleep 1
> +
> +echo "Trigger file creation on mnt2"
> +touch $mnt2/file_on_mnt2
> +sync
> +sleep 1
> +
> +echo "Verify inotify isolation"
> +kill $pid1 $pid2
> +wait $pid1 $pid2 2>/dev/null
> +pid1=3D""
> +pid2=3D""
> +
> +if grep -q "file_on_mnt1" $log1 && ! grep -q "file_on_mnt2" $log1; then
> +       echo "SUCCESS: mnt1 events isolated."
> +else
> +       echo "FAIL: mnt1 inotify confusion!"
> +       [ ! -s $log1 ] && echo "  - mnt1 received no events."
> +       grep -q "file_on_mnt2" $log1 && echo "  - mnt1 received event fro=
m mnt2."
> +fi
> +
> +if grep -q "file_on_mnt2" $log2 && ! grep -q "file_on_mnt1" $log2; then
> +       echo "SUCCESS: mnt2 events isolated."
> +else
> +       echo "FAIL: mnt2 inotify confusion!"
> +       [ ! -s $log2 ] && echo "  - mnt2 received no events."
> +       grep -q "file_on_mnt1" $log2 && echo "  - mnt2 received event fro=
m mnt1."
> +fi
> +
> +status=3D0
> +exit
> diff --git a/tests/generic/800.out b/tests/generic/800.out
> new file mode 100644
> index 000000000000..b10842a31210
> --- /dev/null
> +++ b/tests/generic/800.out
> @@ -0,0 +1,7 @@
> +QA output created by 800
> +Setup inotify watchers on both mnt1 and mnt2
> +Trigger file creation on mnt1
> +Trigger file creation on mnt2
> +Verify inotify isolation
> +SUCCESS: mnt1 events isolated.
> +SUCCESS: mnt2 events isolated.
> --
> 2.43.0
>
