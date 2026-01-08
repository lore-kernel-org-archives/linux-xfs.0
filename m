Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728134FDF33
	for <linux-xfs@vger.kernel.org>; Thu,  8 Jan 2026 14:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767882050; cv=none; b=b5C29KCQScsE4jp5v8ejlmh1KKYQh1Bype2E6zcieIr6XyQwOqyYBpCD2tBF2jmqBFWva/j/BpkL5IqFIqMm6TntMQBG8yQBZtKzYwg911AmcG3T4c5/ApVz/Nq14smykrOWCk7Jahpdo0+8kJuzi9yUSoTPWxGm+WuvAy/sSi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767882050; c=relaxed/simple;
	bh=CqcfOIhDntwY+1BZtk4LKogDJBZr6F4ud4P824Spp3w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SISxJZU1u3YkyUbOW0r+aFFpUO7s1sbNNnUfmdzhs4NRKVdOnoRKhhtCOENFk04ST8vFJlE8mQS9o0YF9r8dQHqXEkxvAovnKLoU/hzHSzTbZnmJ5LJFcqbCGF8Ts4xVjE4Mob8grrSTNZ3EAShRBAu1Nzxxqv6otIjkmbWdXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqrVO42N; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqrVO42N"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-432d28870ddso347598f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Jan 2026 06:20:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767882045; x=1768486845; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sbo/FyhOSNvl7ruES94Wtc14u/YAHpV35jswQh7MZlA=;
        b=cqrVO42NRMmo34MPjwESHztp7EZFR2TbITjHGjg/8FL8g4W38n6ZmfOGv+p3ttdAIB
         wUx9XWZw7BMlV/yZoK9KGALRaHuNsWdQhrb7Y/X5WHBdtGwIWdEkS/QgS3mrLM+67Fmw
         UfYg0dxUmJ2Cc9XfY9ZuJtUr7DWWbhAVLKRN8UxDkLfAsCFS0SsuUtHUoddLW1KSEl85
         c1cZnxuhdPsU/CPgm13Kag//211CM1yvisoOUpWGFfUEUBBKJby9dvejQaGodxUE5Sa9
         r9XgXdOc5WawlWK4sShU5hWWjSAHRu355CX8dGD3qYOgV66bnUzu90+f7FpRDzeubyNR
         GubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767882045; x=1768486845;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sbo/FyhOSNvl7ruES94Wtc14u/YAHpV35jswQh7MZlA=;
        b=GnRymE96+mMUOK3g3BH33rUqxslKi4H7LN1xmPEPeG2JKl3CIqirM0DLy4BsG3Z6S4
         fg2e6/Szke69pPnc8i3Eo+Cnnaw1G8dsDL75/vMAneyX9YhlpaMtuPq2RjnKRy2OUPIq
         36FO4drmE3EtEUYXtPIqOl6OmX5LZSRz42CXOLNmlykfDONl9UZ6SbGlppesfupc6lhU
         gxAOgiX9sr0WAPJO+GDDwwHp1xKV6Gyf8FNKWIpPn/2nm6W2iEjK9gNy6lYJl4LRQF4G
         RvUpTNLSkctTaF5MIxQL1DhmOoqA/4ZuGxpCWrzgtqHHErR57p9mvRS7Gp1Arag+udDT
         94GA==
X-Gm-Message-State: AOJu0YzdIOaG2A09aBMiNrYv8MHI3wL905nW/zOdiE05Nn8nhrQuw9p4
	SEZlGiBbAE7iIJYA51wOn/eKoW2qS6IPKj4HhNesiY8XaVRfk9L60tPs
X-Gm-Gg: AY/fxX4wAJUWcxG4e7mw6RDE2szNU8OSX65TEbRrztg23XOEKwQHsed35NFVwljUXMo
	TssVek//gnOkFfGonBYiwCaeTp5eu7jp3ym2b87Fyu0ePxdNBURWP9PXooy49Cc9VU7sl0DLr5v
	lg78NXgOodVnMva5FkRRWNnLHKcQK9RY1ybdC3m4y9YS3DrHAzRxqJ7CrtW/KFZzlYm7eMQURmc
	cr27Z8i8161PnvD8eQrC+QjGPIWgfEev+Iqe/RuXRaB3PlBL8zbaN68UT5g7ditqH4dl9ZUDNhC
	r/bHrqn0lsOYFtcgEtcYLtE4VVjLZrQspoxLwwa0Gcu/4gR+wxnYxhn9oI9Y0qH99GtgIRcPAlZ
	+PNdM7VNohP6I76Zn0sAdWW1gCyq7mIDWG0CM9CwG4dYmuTcRRG1xcNU7S8kRv8EHB8RjYV/ru1
	SESHYTg7295L0w4lymTj39rKi0VcMWMl7uls1mWP9zR93TslvSG7kYh1M=
X-Google-Smtp-Source: AGHT+IHGlaOPs9eKiRgyftQ9vnmYkdmRdAu4o08vQMaI+8/MKcZZuOgJZkPpfwtApIa0gLZltEElLQ==
X-Received: by 2002:a05:6000:2c0e:b0:432:851d:2180 with SMTP id ffacd0b85a97d-432c3760f55mr8166126f8f.49.1767882045190;
        Thu, 08 Jan 2026 06:20:45 -0800 (PST)
Received: from ?IPv6:2a01:e11:3:1ff0:b48e:204e:3838:b119? ([2a01:e11:3:1ff0:b48e:204e:3838:b119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff0b2sm16669878f8f.42.2026.01.08.06.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 06:20:44 -0800 (PST)
Message-ID: <889c846816c3422e0f43b594f78b6ebde07dbd8d.camel@gmail.com>
Subject: Re: [PATCH v5] xfs: test reproducible builds
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com
Date: Thu, 08 Jan 2026 15:20:41 +0100
In-Reply-To: <20251231221541.td3l6vf6sjkyop4n@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20251217110653.2969069-1-luca.dimaio1@gmail.com>
	 <20251231221541.td3l6vf6sjkyop4n@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Autocrypt: addr=luca.dimaio1@gmail.com; prefer-encrypt=mutual;
 keydata=mQINBGGqRu4BEACybdvi9+LqKuWA/P9HW7+wzGtIbFL2PR/vgJZqLzAscGrJB3ZvpdT2h
 daDdjRX7Maod9EAZceZYl2YVLZ6Q54qhm1hlEp4Iw6/adryfzulrJPX39mvqpJNE6gSkatwUDekhC
 AJpBbpq2aB79wOF08++KofqNW1r0xMIQ/KVoPryE4jNL2y99bEvUpe4S9TEyWTwsv/I0nEIX4SMgf
 VmW9XY842p9Bj6lws5U2dENIU8OD3cgK4uhfueb/ggkYg/5ZcblIBdVY0xDiFCqyTDr8+TVK2Algr
 M+r5MDPUKQXpIxh+gD84PcX8VXDHsmZaWsZmdkryiZ5RFammebqoIdxLF0oqwgUpaA8Ed4hlPAzmd
 TdVjMwFo01IHzFkZvS0g90qVXTf1fTSVG4JZU2gAasKVl0VDh4yJlzK3c1rWueqISv6AiD+BA6sPu
 4zscdBckK6diftYINuGV6Bfw+v+2AFvjCq8isfCQPXY8XHTg+5lktGN6+45SUEghDpeacSM+G/q25
 qCLKbi6dzAtjCDeR8b6o0lRQ645/5fMU4CSyanfsf7YRkw2RqA6pRM3q/i4nlvznMLxR42iNc1BMY
 A3t1jv6RIEE36eke9Ube0p0TsEisGGYo4NTVO4RUeMeSG3waYfLB0eXHe9Ph/K0FrTBq6XE65KwRO
 Bwk0tB6lU0+jwARAQABtCVMdWNhIERpIE1haW8gPGx1Y2EuZGltYWlvMUBnbWFpbC5jb20+iQJOBB
 MBCgA4FiEECdpUF1+FXVXQxDERHMOHTl7ICj4FAmGqRu4CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgE
 CF4AACgkQHMOHTl7ICj5gag/+JtIKsPwWRJWnnexbGS/gGaZ81GtZ4skW/UHhQqfc44//ntToy3uw
 2PFaPB+5WLlA/XAzpLBFjLD5ZscFtHW7/ICGxrBqB/Q6AULoz0zsDhJ8YmO68A5YYNkGCLbWzando
 vrY/GykUEMT1EsReaIHhLpL/+3jsXGyIsztFi6qkjfDsFT+306+llIhIxgY+ZI/B/wlI41BKmSae+
 5WOR4oZb080Famy/5hjx/Mi0AYu2A6cRpw2k+l2/u+aEvunmkgkgB186tA/JhoOPYQvT5xVQ5GYRu
 vcX1kHscYD+Tgx3DhkMS1XqZihH4UE9Ec6QeOJTWrK1czRFTJpTOgPAMmksMdgU8YKKHj0dafCNl3
 /2gld0Q2s5/tAGPpPuOPJf5GUtcOn1Qxr7Re2pyrQdcdr/jUdy1GVHAldzOZlBID3u0dTUGWLsPDA
 dvwGyiwdZiNgnHxTEWchpFo0mwi5S/3+sWcPWAJO2zEVfkqyNhmHSW5EBrwe9nhCT5uqF8dEKb4tf
 FxAAgPAiFfnLhweVxkPIvPK6/rIZo8F6t6qSXibbTIjdi9pLSDMY0m8u/fRZ06DsciFIfrWG1LXlu
 14mDpr4zQSUELe1RRU1NEfD87TyYehjPvEewM6bZlRJ4SLaWQFoRW3OKH7IN1ODUn7T9TIx1uuzs4
 4ViZ2BeR0ow9RQc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-01-01 at 06:15 +0800, Zorro Lang wrote:
> On Wed, Dec 17, 2025 at 12:06:53PM +0100, Luca Di Maio wrote:
> > With the addition of the `-p` populate option, SOURCE_DATE_EPOCH
> > and
> > DETERMINISTIC_SEED support, it is possible to create fully
> > reproducible
> > pre-populated filesystems. We should test them here.
> >=20
> > v1 -> v2:
> > - Changed test group from parent to mkfs
> > - Fixed PROTO_DIR to point to a new dir
> > - Populate PROTO_DIR with relevant file types
> > - Move from md5sum to sha256sum
> > v2 -> v3
> > - Properly check if mkfs.xfs supports SOURCE_DATE_EPOCH and
> > =C2=A0 DETERMINISTIC_SEED
> > - use fsstress program to generate the PROTO_DIR content
> > - simplify test output
> > v3 -> v4
> > - Add _cleanup function
> > v4 -> v5
> > - copy _cleanup from common/preamble
> >=20
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > ---
> > =C2=A0tests/xfs/841=C2=A0=C2=A0=C2=A0=C2=A0 | 173
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > =C2=A0tests/xfs/841.out |=C2=A0=C2=A0 3 +
> > =C2=A02 files changed, 176 insertions(+)
> > =C2=A0create mode 100755 tests/xfs/841
> > =C2=A0create mode 100644 tests/xfs/841.out
> >=20
> > diff --git a/tests/xfs/841 b/tests/xfs/841
> > new file mode 100755
> > index 00000000..60982a41
> > --- /dev/null
> > +++ b/tests/xfs/841
> > @@ -0,0 +1,173 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Chainguard, Inc. All Rights Reserved.
> > +#
> > +# FS QA Test No. 841
> > +#
> > +# Test that XFS filesystems created with reproducibility options
> > produce
> > +# identical images across multiple runs. This verifies that the
> > combination
> > +# of SOURCE_DATE_EPOCH, DETERMINISTIC_SEED, and -m uuid=3D options
> > result in
> > +# bit-for-bit reproducible filesystem images.
> > +
> > +. ./common/preamble
> > +_begin_fstest auto quick mkfs
> > +
> > +# Image file settings
> > +IMG_SIZE=3D"512M"
> > +IMG_FILE=3D"$TEST_DIR/xfs_reproducible_test.img"
> > +PROTO_DIR=3D"$TEST_DIR/proto"
> > +
> > +# Fixed values for reproducibility
> > +FIXED_UUID=3D"12345678-1234-1234-1234-123456789abc"
> > +FIXED_EPOCH=3D"1234567890"
> > +
> > +_cleanup() {
> > +	cd /
> > +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> > +	rm -r -f $tmp.* "$PROTO_DIR" "$IMG_FILE"
> > +}
> > +
> > +# Check if mkfs.xfs supports required options
> > +_check_mkfs_xfs_options()
> > +{
> > +	local check_img=3D"$TEST_DIR/mkfs_check.img"
> > +	truncate -s 64M "$check_img" || return 1
> > +
> > +	# Check -m uuid support
> > +	$MKFS_XFS_PROG -m uuid=3D00000000-0000-0000-0000-
> > 000000000000 \
> > +		-N "$check_img" &> /dev/null
> > +	local uuid_support=3D$?
> > +
> > +	# Check -p support (protofile/directory population)
> > +	$MKFS_XFS_PROG 2>&1 | grep populate &> /dev/null
> > +	local proto_support=3D$?
> > +
> > +	grep -q SOURCE_DATE_EPOCH "$MKFS_XFS_PROG"
> > +	local reproducible_support=3D$?
> > +
> > +	rm -f "$check_img"
> > +
> > +	if [ $uuid_support -ne 0 ]; then
> > +		_notrun "mkfs.xfs does not support -m uuid=3D
> > option"
> > +	fi
> > +	if [ $proto_support -ne 0 ]; then
> > +		_notrun "mkfs.xfs does not support -p option for
> > directory population"
> > +	fi
> > +	if [ $reproducible_support -ne 0 ]; then
> > +		_notrun "mkfs.xfs does not support env options for
> > reproducibility"
> > +	fi
> > +}
> > +
> > +# Create a prototype directory with all file types supported by
> > mkfs.xfs -p
> > +_create_proto_dir()
> > +{
> > +	rm -rf "$PROTO_DIR"
> > +	mkdir -p "$PROTO_DIR"
> > +
> > +	$FSSTRESS_PROG -d $PROTO_DIR -s 1 $F -n 2000 -p 2 -z \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ^^
>=20
> =C2=A0Sorry, what's the $F?=20
>=20
> > +		-f creat=3D15 \
> > +		-f mkdir=3D8 \
> > +		-f write=3D15 \
> > +		-f truncate=3D5 \
> > +		-f symlink=3D8 \
> > +		-f link=3D8 \
> > +		-f setfattr=3D12 \
> > +		-f chown=3D3 \
> > +		-f rename=3D5 \
> > +		-f unlink=3D2 \
> > +		-f rmdir=3D1
>=20
> I think you can write this part as:
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 FSSTRESS_ARGS=3D`_scale_fsstre=
ss_args -d $PROTO_DIR -s 1 -n
> 2000 -p 2 -z
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f creat=3D15 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f mkdir=3D8 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f write=3D15 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f truncate=3D5 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f symlink=3D8 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f link=3D8 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f setfattr=3D12 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f chown=3D3 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f rename=3D5 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f unlink=3D2 \
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 -f rmdir=3D1`
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _run_fsstress $FSSTRESS_ARGS
>=20
> I tried to merge this patch with this change, but I don't what's the
> $F for, so
> ask you for sure :)
>=20
> Thanks,
> Zorro
>=20
>=20

Thanks Zorro for the review, seems like it's one of those
typo/leftovers from the editor, sorry

Incoming v6 with the fix
Thanks

L.
