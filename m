Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE6634321F
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 19:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765827186; cv=none; b=pvzNPTQwon5x3Vo0T5vObXbv5DXHe4MtZNv+7KO2BaKo+kTqEt6Ru1dBXS0ZcWm3O/oMc1B49bUeI6v2H2uyfcZSv9Fb2lROHgjPpb3oj/W5/Fq0TgCI5oVhq60DICOqCQQuhWU4ZLqXSNfAB35beQhWdx07+gTJQtezA2ih/6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765827186; c=relaxed/simple;
	bh=phY+rbMkL3dyn0ahWozIWwf3qRamWtIGeF8aXhL0wfk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=phn6P607+GlhIC0vrOOKMfSsDAY2LxGkapXy3riWqbo9F2+blDBRl3obth2W0VKA+mosvT0P+dQwW4Zgb677G2/A5hW3NLbsSpNLSBKaMiajy+sQJrYdpnCBQUAvjFuhSnGSIOJLriZ4JSy65j+E2INipcswRZWUQ8HvLsE0br8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFfjZgKJ; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFfjZgKJ"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fbad1fa90so2591555f8f.0
        for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 11:33:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765827183; x=1766431983; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cNn4YIu2S9C750CDqIGcmEy0wHfg/FUdYgzB3NbG6NM=;
        b=aFfjZgKJ8XuN8q0wZaAmqxvivgngMZY01sSnAt8M11xFAtV123FJ3H8TklvT3LYpSs
         nvawVzouVC225fCv4TZjILRCbtdDWniLRQoVRGvSK/UhfQpV07STbz2+P9Bb/Cr29kQv
         Ns1v/XYur4XsK6NEVDqOzmO8b3oGrqsUEwglh1tCXbbKUvZwqCwzI0K4IjmK/wr/irvp
         kWLEIgEKIFE2yujTAq7drXNLoyXRLUisoagoGlUwI796FvJR6SGnlhxtUlSkoAmr7S4n
         ltLrTgHxk45izSAzA5eAxVIHNkCNPNrKSJjfA9kqIEAo7bBkFYEewXA4n6Lwmh7k0AsY
         16pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765827183; x=1766431983;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cNn4YIu2S9C750CDqIGcmEy0wHfg/FUdYgzB3NbG6NM=;
        b=nWfv9A3pJivzNu9lV+T3dYaBex4Wi62Wb6ShQEcBs+7i8QFI4xPyVGScAMvLnUzadP
         rGqhbLWUu83qYb8Z2Nj3IWIJ5NTJebaxO1zvO7T2Iswe/rQS3tbrY1PgNwv+FpwWZIF1
         zIkUEXx2NETXzTBMjfVXTv750HFRQVO7kdshbwtXljejc4GoopV6a/+yXWno1hQmm32H
         nUS0+mXB9965esrLKmgVxBkXgXubsTr+WZDqvmbHjCCRVQ+mQcnDSQRx1GdGUopAtN8L
         YwkCDRZtL2X12jZT1A6r/yBOxR6teqW+0EAVOurscKU/U/2SrGTWphccqjluGcQhmrmG
         kytA==
X-Gm-Message-State: AOJu0YzgN+QbhCvZ2pzvfauHLEBUGianGeyCim5R1Pf3N9XfGwBQm0qC
	SxpkIkKAQuos0xT04OR6d7tHA79eH9Zz/a91VGThjACzg2USF9hMes1hsovpuA==
X-Gm-Gg: AY/fxX6iTqappeqWdFIS7AkskyF5m5rA3XeGkrfOc4MsFH5WhcdSiKhOUt+VD2GHhaq
	XHHO95pbohG+c1OW+P1kphiEoyxhOGmg0+5QXlplxpvDFFzl1UfUINPr+8q6sDfI2k5HqhV5NJD
	BjNBtLWFiuifbjjGxP9MHF8uhPTfgVdeLT76HXrQb1T7oECzx1uc63M6aKy0qfSwtBdU6c1g33g
	EXtq1lynvATAB+drMGkqdXRHDmJYNymM9WBsm0chOTsRbczX73G8FxXJCRE6xZI74X48heGFryv
	xlBiQ5tLgcdwXExmlPw2tbfKuvTw8dpFE5iMUKlbvbtBtpqYNCB3pazKYwaUjBW039UZqzaCHO/
	u8bNcbp2o3GngEGDDEN2kM9Si9Co4fv9NNuOvU5FDvabNyvygb4ksmliue4mOuGlIXS/A4nXZ+9
	dE9t27RDxWjE+yQSlK9qQmNw==
X-Google-Smtp-Source: AGHT+IHoN94GTUALMGO6okh3Bcbpcwffz7F0cXPhPd4b58aQJdFjGJur3vrvcBaaQ7Sx8lRXU+fmjg==
X-Received: by 2002:a05:6000:420e:b0:430:f241:a11f with SMTP id ffacd0b85a97d-430f241a3cfmr10405784f8f.30.1765827182851;
        Mon, 15 Dec 2025 11:33:02 -0800 (PST)
Received: from [192.168.100.112] ([151.47.89.233])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f675c2basm13725708f8f.18.2025.12.15.11.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 11:33:02 -0800 (PST)
Message-ID: <d5d35842ac21230e0cdd6449548ba41fa6f54783.camel@gmail.com>
Subject: Re: [PATCH v3] xfs: test reproducible builds
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Date: Mon, 15 Dec 2025 20:33:01 +0100
In-Reply-To: <20251215191652.GJ7725@frogsfrogsfrogs>
References: <20251215154529.2011487-1-luca.dimaio1@gmail.com>
	 <20251215191652.GJ7725@frogsfrogsfrogs>
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

On Mon, 2025-12-15 at 11:16 -0800, Darrick J. Wong wrote:
> On Mon, Dec 15, 2025 at 04:45:29PM +0100, Luca Di Maio wrote:
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
> >=20
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > ---
> > =C2=A0tests/xfs/841=C2=A0=C2=A0=C2=A0=C2=A0 | 167
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > =C2=A0tests/xfs/841.out |=C2=A0=C2=A0 3 +
> > =C2=A02 files changed, 170 insertions(+)
> > =C2=A0create mode 100755 tests/xfs/841
> > =C2=A0create mode 100644 tests/xfs/841.out
> >=20
> > diff --git a/tests/xfs/841 b/tests/xfs/841
> > new file mode 100755
> > index 00000000..9a8816ef
> > --- /dev/null
> > +++ b/tests/xfs/841
> > @@ -0,0 +1,167 @@
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
>=20
> Might want to delete IMG_FILE in the _cleanup function so that we're
> not
> leaving too much detritus behind on the test filesystem, but
> otherwise
>=20
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
>=20
> (Thanks for getting us to reproducible mkfs!)
>=20
> --D

Alright, adding a simple _cleanup() thanks

L.

> > +PROTO_DIR=3D"$TEST_DIR/proto"
> > +
> > +# Fixed values for reproducibility
> > +FIXED_UUID=3D"12345678-1234-1234-1234-123456789abc"
> > +FIXED_EPOCH=3D"1234567890"
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
> > +
> > +
> > +	# FIFO (named pipe)
> > +	mkfifo "$PROTO_DIR/fifo"
> > +
> > +	# Unix socket
> > +	$here/src/af_unix "$PROTO_DIR/socket" 2> /dev/null || true
> > +
> > +	# Block device (requires root)
> > +	mknod "$PROTO_DIR/blockdev" b 1 0 2> /dev/null || true
> > +
> > +	# Character device (requires root)
> > +	mknod "$PROTO_DIR/chardev" c 1 3 2> /dev/null || true
> > +}
> > +
> > +_require_test
> > +_check_mkfs_xfs_options
> > +
> > +# Create XFS filesystem with full reproducibility options
> > +# Uses -p to populate from directory during mkfs (no mount needed)
> > +_mkfs_xfs_reproducible()
> > +{
> > +	local img=3D$1
> > +
> > +	# Create fresh image file
> > +	rm -f "$img"
> > +	truncate -s $IMG_SIZE "$img" || return 1
> > +
> > +	# Set environment variables for reproducibility:
> > +	# - SOURCE_DATE_EPOCH: fixes all inode timestamps to this
> > value
> > +	# - DETERMINISTIC_SEED: uses fixed seed (0x53454544)
> > instead of
> > +	#=C2=A0=C2=A0 getrandom()
> > +	#
> > +	# mkfs.xfs options:
> > +	# - -m uuid=3D: fixed filesystem UUID
> > +	# - -p dir: populate filesystem from directory during
> > creation
> > +	SOURCE_DATE_EPOCH=3D$FIXED_EPOCH \
> > +	DETERMINISTIC_SEED=3D1 \
> > +	$MKFS_XFS_PROG \
> > +		-f \
> > +		-m uuid=3D$FIXED_UUID \
> > +		-p "$PROTO_DIR" \
> > +		"$img" >> $seqres.full 2>&1
> > +
> > +	return $?
> > +}
> > +
> > +# Compute hash of the image file
> > +_hash_image()
> > +{
> > +	sha256sum "$1" | awk '{print $1}'
> > +}
> > +
> > +# Run a single reproducibility test iteration
> > +_run_iteration()
> > +{
> > +	local iteration=3D$1
> > +
> > +	echo "Iteration $iteration: Creating filesystem with -p
> > $PROTO_DIR" >> $seqres.full
> > +	if ! _mkfs_xfs_reproducible "$IMG_FILE"; then
> > +		echo "mkfs.xfs failed" >> $seqres.full
> > +		return 1
> > +	fi
> > +
> > +	local hash=3D$(_hash_image "$IMG_FILE")
> > +	echo "Iteration $iteration: Hash =3D $hash" >> $seqres.full
> > +
> > +	echo $hash
> > +}
> > +
> > +# Create the prototype directory with various file types
> > +_create_proto_dir
> > +
> > +echo "Test: XFS reproducible filesystem image creation"
> > +
> > +# Run three iterations
> > +hash1=3D$(_run_iteration 1)
> > +[ -z "$hash1" ] && _fail "Iteration 1 failed"
> > +
> > +hash2=3D$(_run_iteration 2)
> > +[ -z "$hash2" ] && _fail "Iteration 2 failed"
> > +
> > +hash3=3D$(_run_iteration 3)
> > +[ -z "$hash3" ] && _fail "Iteration 3 failed"
> > +
> > +# Verify all hashes match
> > +if [ "$hash1" =3D "$hash2" ] && [ "$hash2" =3D "$hash3" ]; then
> > +	echo "All filesystem images are identical."
> > +else
> > +	echo "ERROR: Filesystem images differ!"
> > +fi
> > +
> > +# success, all done
> > +status=3D0
> > +exit
> > diff --git a/tests/xfs/841.out b/tests/xfs/841.out
> > new file mode 100644
> > index 00000000..3bdfbfda
> > --- /dev/null
> > +++ b/tests/xfs/841.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 841
> > +Test: XFS reproducible filesystem image creation
> > +All filesystem images are identical.
> > --=20
> > 2.51.0
> >=20
> >=20
