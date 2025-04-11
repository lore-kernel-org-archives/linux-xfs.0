Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905BC45948
	for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744382307; cv=none; b=poiT+bvOXLOH/sgzte5V7HQD0XygSmR19oc6CBnAgyBlJ0Kir7s+G2W3onq0NxnL3e6EWBqqz/Qk3DUCBXeMd4dSZJQLL//8+dApSjDEUFTbe90GD/2Q/KNXw7lbzYIlwsm86PQOAD8AYR/tCKLTqsq0fPDmkJxnapgt5eAoX3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744382307; c=relaxed/simple;
	bh=qloPr57gq7gbSsNsHMTHhfyolZlFYYdTG9Lrw8UFgQE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ezmdJQClg5IxpBhTJGipMXn17tRYhRqW16xa6jvrTjbQXFxY/xsBA5vLKQDckDYlBSjzqN62MXu9CL0CjH8ojtIErcVraGWu897y8vSpi3/OemI+Z+L7M5bPCQBpmAmrP3CO8cqKfSHFXdwfYSzkKhj/B2FKIrSjxGbvedydCkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev; spf=pass smtp.mailfrom=chainguard.dev; dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b=Uo+Fa0z6; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chainguard.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chainguard.dev header.i=@chainguard.dev header.b="Uo+Fa0z6"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-523f1b31cf8so827943e0c.0
        for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 07:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chainguard.dev; s=google; t=1744382302; x=1744987102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pZnznCBXan8+kKf2HUCAYJiscmvl8olm31OXPNAIf+E=;
        b=Uo+Fa0z6bX76X5pOjus5zLOA5DQ7YcBcGtfeUs+VkeFR0CLNFRhRw/bwmQfzLrlBu0
         cfhrExbUPKorBp3se7As4d/QaIp3ed4XlQp05UBBbsIdYa22ln7d4gPvwlNX2NyvbNa6
         ph55VAYGmHLOAnGepYvgDUWjRAK65T3BJxzTWfu02ctA33Cn+zULnwTxS6FLdNxVgIDG
         rk6Tz6JNuv+qQCTr2pMuMEk2s5yV7lTaWWQvOVnRqv8obI+VtRzf8e75j0eNPvMGTjb8
         8MflqyYRDBo8D4xXJrp0XWJ6aIrMzf1Zd9yFyM62hLU1kDVhij31KjHF76uczbLZBQZJ
         kafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744382302; x=1744987102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pZnznCBXan8+kKf2HUCAYJiscmvl8olm31OXPNAIf+E=;
        b=pRqRnjAVNYkeXx4Fmx0I3FPpycAYjhATVhoK6xIGSgWqfBXJnnUckZdI2CnZDHjGVY
         7LEew2V4uioNcV6UuLYPEWR5zOpxG8ht78D4NmnsnPmuOZ20yTwhK47u4cu37FhU45NL
         kp9tMPIaAld2tNs13z3ccXgIO1Cg2MumyWaeZwlUgH90sQ36vtcZSxaet6a10sr3Pxcn
         3kgGUmF06oumNcfJKL5nbfSR/L+yvLqSjoxzBaPvjP65yP4GnVKnDQ91bBF90Z4o8Sbx
         rtdjbDJxzoEbyarMEdlOmWw45dF15y56PtuN3XPCmqZxCUwwQn3rwucKc+RTSG0iBGUA
         ymXw==
X-Gm-Message-State: AOJu0YzEZXB/kvSL231qZ+BnvXlAp8dEXIDO4S+svlhVp8adGnOb8YCu
	KRtxjJtKFY8MqXAmMEVvqavYmlUapIBuWSCHeUCnU8XlPbNMEuj05D4sJu3N8whsleuHo5pLLpe
	tYINXz+sY7tteuRpV9WZLqKeHnp1z9iyUy1aSugh1c7FvMQjWJiEvag==
X-Gm-Gg: ASbGnctXkQZQyAEaGL7aH/+itkVFd2s6bcjb4T/ARx6zDn8u6K56e5RPFmNyYWjuh3d
	TA9tfG5UZu0u3bg7jTqN3hk+ygziSCBCdGosi2iYIYTw589y0VXF4yKzRg5yV8M7Hw/7clW6BGv
	8ce+sUAu9Qh/izZyQw76lJQITgGF6UH0lHcqoNKhRu6K/ypkNyyfk=
X-Google-Smtp-Source: AGHT+IFyxe2aMHAejTpsz5giKF9HjG4BfVfCdg4gOFLebczrX2nUILR2N8NLhQdyT2nIZT/aYpBNd76H3TKBcWbEOfM=
X-Received: by 2002:a05:6122:829d:b0:523:dd87:fe86 with SMTP id
 71dfb90a1353d-527c3587e86mr2113482e0c.6.1744382302096; Fri, 11 Apr 2025
 07:38:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Luca DiMaio <luca.dimaio@chainguard.dev>
Date: Fri, 11 Apr 2025 16:38:10 +0200
X-Gm-Features: ATxdqUGOainL2ddXLhyGOc1K1hDfvRvkJWE0cUqZMIAw2fJiFeeeuGWaJ2RysTo
Message-ID: <CAKBQhKVi6FWNWJH2PWUA4Ue=aSrvVcR_r2aJOUh45Nd0YdnxVA@mail.gmail.com>
Subject: Reproducible XFS Filesystems Builds for VMs
To: linux-xfs@vger.kernel.org
Cc: Scott Moser <smoser@chainguard.dev>, Dimitri Ledkov <dimitri.ledkov@chainguard.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Subject: Reproducible XFS Filesystems Builds for VMs
linux-xfs@vger.kernel.org

Dear XFS Maintainers and Community,

I am a Software Engineer at Chainguard working on reproducible builds for V=
Ms.

While we have successfully implemented reproducible disk images with
EFI+EXT4 partitions, I=E2=80=99ve been unable to replicate this for XFS
filesystems.
Current Approach:

We have successfully implemented reproducible disk images with
EFI+EXT4 partitions using the following methods:

- For FAT32 partitions: `mkfs.vfat --invarian -i $EFI_UUID` with
`$SOURCE_DATE_EPOCH` and populating via mtools
- For EXT4 partitions: `mkfs.ext4 -E hash_seed=3D$EXT4_HASH_SEED -U
$ROOTFS_UUID` with `$SOURCE_DATE_EPOCH` plus the `-d
/path/to/rootfs.tar.gz` to populate it

XFS Challenges:

For XFS, I've attempted to create reproducible filesystems using
extensive parameters:

```
mkfs.xfs \
-b size=3D4096 \
-d agcount=3D4 \
-d noalign \
-i attr=3D2 \
-i projid32bit=3D1 \
-i size=3D512 \
-l size=3D67108864 \
-l su=3D4096 \
-l version=3D2 \
-m crc=3D1 \
-m finobt=3D1 \
-m uuid=3D$ROOTFS_UUID \
-n size=3D16384 \
-n version=3D2 $root_partition
```

I've tried to specify as many options as possible in order to avoid
runtime aleatory decisions.

Unfortunately, this does not produce reproducible results across
different disk images.

I've made progress with empty filesystems by using a combination of
`libfaketime`
to enforce `$SOURCE_DATE_EPOCH` and a custom library that overwrites
the libc's `getrandom()`:

```
~$ export LD_PRELOAD=3D"./deterministic_rng.so /usr/lib/faketime/libfaketim=
e.so.1"
~$ mkfs.xfs \
-b size=3D4096 \
-d agcount=3D4 \
-d noalign \
-i attr=3D2 \
-i projid32bit=3D1 \
-i size=3D512 \
-l size=3D67108864 \
-l su=3D4096 \
-l version=3D2 \
-m crc=3D1 \
-m finobt=3D1 \
-m uuid=3D$ROOTFS_UUID \
-n size=3D16384 \
-n version=3D2 disk1.img
~$ mkfs.xfs \
-b size=3D4096 \
-d agcount=3D4 \
-d noalign \
-i attr=3D2 \
-i projid32bit=3D1 \
-i size=3D512 \
-l size=3D67108864 \
-l su=3D4096 \
-l version=3D2 \
-m crc=3D1 \
-m finobt=3D1 \
-m uuid=3D$ROOTFS_UUID \
-n size=3D16384 \
-n version=3D2 disk2.img
~$ md5sum disk*
c68c202163dcb862762fc01970f6c8b4  disk1.img
c68c202163dcb862762fc01970f6c8b4  disk2.img
```

This approach works for empty filesystems, but when populating the filesyst=
em by
mounting and untarring an archive, different metadata is generated
even after using
`xfs_repair -L` to reset most metadata.

The primary difference appears to be in the allocation group metadata,
which is optimized at runtime.

Question:

EXT4 addresses this issue with the -d flag, which allows populating
from an archive or directory without mounting.
Is there similar functionality available for XFS, or is there interest
in developing a method for generating reproducible XFS root
filesystems?

I'm asking this because we'd be interested in using XFS as a filesystem for=
 the
final product.

Thank you for your time and expertise. Any guidance would be greatly
appreciated.
Regards,
L.
