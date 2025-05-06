Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978BD24B28
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 19:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746561136; cv=none; b=a/vShFCEX5fwTpt+vL+JgSLaYl8vbPxlWKeUp6rpPHXvJKqknbmIyevcyMBhVk62penXF1QT/LkenKlzdkHYWDgdSbNtcVRlwG6Ojo+UI8jU/1z4EUhAQKLAldG9NMV/N8FW988QuT1HznHhmQICkczmFhJu9GuPgegMbrzcG/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746561136; c=relaxed/simple;
	bh=PaPDZVQJdH6x3nG/gLHfslbfMF1fNOGEzzHak1XD6ak=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+nqh6L05qYNbmWJLJQ4Y9oVn4LudbS8lrGEeNS/rUCtxRtKdJ72+75VzMuQIcbWlDkFXVyx+DqdI3Z0NtVhjGnDHskxE1Wr5afNCAvXXsXgrcggA9phc5r34Jlp9wn7AlrRCYLTHMAN+Ojfsh9lc6Iyp2Nh38eqAquxvnHTKag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UzPvexwN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UzPvexwN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746561133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dl4uG7nduGgixZVnZZm5Y9BUK6yJE2KDwcHDY3c99MQ=;
	b=UzPvexwN2TIiiZJ5uLqY7jpRDkRiBEnt9qzH3pyDVa8BLsOZjEg7QqoZc1ZWS0SFDRkvv6
	OJf2zgVjINH4Emcn25U466KtIw9pwuIfyf8ogyfCKm3zQyqUT0J+jy1vbC0jjzDfHYRGpO
	XiFM5t0y5+d4kBEOnxnfYqGOfXhWI6E=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-eDzOTDs7NF6_4bX5n1e7aA-1; Tue, 06 May 2025 15:52:12 -0400
X-MC-Unique: eDzOTDs7NF6_4bX5n1e7aA-1
X-Mimecast-MFC-AGG-ID: eDzOTDs7NF6_4bX5n1e7aA_1746561131
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2242ce15cc3so55113735ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 06 May 2025 12:52:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746561131; x=1747165931;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dl4uG7nduGgixZVnZZm5Y9BUK6yJE2KDwcHDY3c99MQ=;
        b=uTajG78l3Uln8E1q0c8lQ4n6bmU3s/vhsFnvF/pre3zDdbObcirNeA8jW08TPMiWUs
         IG8/M0k1aqH3dvTPTWVmCIrTsYvxuxdSyYqGu7lCQOAIbJZEy2aFvze0QBRM7rj3pkd7
         ZBIQIlDjz0zIf1BRJyY40vP99ftiEVjLcPrn+yiYsoQYqp+1dql6ksApwW25EhIRN9so
         SKM0ok2TixJbtqrmrl7+eTqj0NipcIqfoN0mr4bjJ0uueBDTjYjpRQZxJfwBCAmyqC8l
         68OC227y12KKOdxed7i07ZWyWdq+B88as1aLr3jFaq3juFJdMNAVjrHTef/6aquaaRVn
         2n0Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMIr//O/Pr1XV1YKgnM2EX4aU4iJbv9rdJCJoUt882mbaC1/gSF9A7DxPY2NnqIVLYEqKQYwvO7go=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy47x9LM0G5aroWm7FJ67ToKPiG8JvRCV/w5qmakQETtbncbGfG
	flDqqu+SHUBocMfdDlD2SsIlmXs5yDkwgAgCuHcGzzCWk6FfKElD5CB7PzV9v+0jIKBvsDTpD4s
	t2UdX8/+dqy69wq4rPG4qSUfhI+5RQwWYQc4gkM+8NF22K9ktRB+vQUPqsw==
X-Gm-Gg: ASbGncsmU8C3bo71/uyFbDtqJevSDILnMvgqUxqiSVPaUBfn1GNlC5wp5XTe8t7YYlC
	tCzeVHazqkjhMpcS85Ox5BvEJcxSrjEb3EA3ki4K7Q7uE3BkE0iw9OWfdhULhdtcdqd+KEb5I5/
	fUDnaZWrLAkUCdg8GkkEpnNoFBEbleXHJlXUhiM6P/04RVMmnctFB/VWAouGbQfNjT89VAEkVO5
	l4U9k3C/OBCp2JbzjqHsAAA6fDDHP1LTtjFlZFIuelduaB3XsaQrJoh26o5EvAoCFacpU23ofBh
	/6aLvyx5HWlEcRQftrE8yriGFMOgwfhFSyc8FQDAkTbisiUpjO2q
X-Received: by 2002:a17:903:3ba4:b0:22e:4d50:4f58 with SMTP id d9443c01a7336-22e5ecae63emr6522445ad.31.1746561131044;
        Tue, 06 May 2025 12:52:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHyj0q1yCppfcIDU5BuDEnlGOw3XxRdA3ec82mHrLuK3/maFkgYdbkwqOREHYBFOE31TELSGQ==
X-Received: by 2002:a17:903:3ba4:b0:22e:4d50:4f58 with SMTP id d9443c01a7336-22e5ecae63emr6522215ad.31.1746561130698;
        Tue, 06 May 2025 12:52:10 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fbe2sm77660505ad.139.2025.05.06.12.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 12:52:10 -0700 (PDT)
Date: Wed, 7 May 2025 03:52:05 +0800
From: Zorro Lang <zlang@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/15] xfs: test zone stream separation for two direct
 writers
Message-ID: <20250506195205.hqrkl3wvwpgal2dq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250501134302.2881773-1-hch@lst.de>
 <20250501134302.2881773-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501134302.2881773-9-hch@lst.de>

On Thu, May 01, 2025 at 08:42:45AM -0500, Christoph Hellwig wrote:
> Check that two parallel direct sequential writers are separated into
> different zones.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/4207     | 79 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/4207.out |  3 ++
>  2 files changed, 82 insertions(+)
>  create mode 100755 tests/xfs/4207
>  create mode 100644 tests/xfs/4207.out
> 
> diff --git a/tests/xfs/4207 b/tests/xfs/4207
> new file mode 100755
> index 000000000000..edc22da73bfb
> --- /dev/null
> +++ b/tests/xfs/4207
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Christoph Hellwig.
> +#
> +# FS QA Test No. 4207
> +#
> +# Test that multiple direct I/O write streams are directed to separate zones.
> +#
> +. ./common/preamble
> +_begin_fstest quick auto rw zone
> +
> +_cleanup()
> +{
> +	cd /
> +	_scratch_unmount >/dev/null 2>&1

Same... remove this _cleanup if the "unmount" isn't necessary.

> +}
> +
> +# Import common functions.
> +. ./common/filter

You don't use any filter helpers in common/filter ...

> +
> +_require_scratch
> +
> +_filter_rgno()

I've seen this function in many cases of this patchset, how about move it
to common/filter or common/xfs ?

> +{
> +	# the rg number is in column 4 of xfs_bmap output
> +	perl -ne '
> +		$rg = (split /\s+/)[4] ;
> +		if ($rg =~ /\d+/) {print "$rg "} ;
> +	'
> +}
> +
> +_scratch_mkfs_xfs >>$seqres.full 2>&1
> +_scratch_mount
> +_require_xfs_scratch_zoned 3
> +
> +fio_config=$tmp.fio
> +fio_out=$tmp.fio.out
> +fio_err=$tmp.fio.err
> +
> +cat >$fio_config <<EOF
> +[global]
> +bs=64k
> +iodepth=16
> +iodepth_batch=8
> +size=1m
> +directory=$SCRATCH_MNT
> +ioengine=libaio

_require_aio?

> +rw=write
> +direct=1

_require_odirect ? or _require_aiodio?

> +
> +[file1]
> +filename=file1
> +size=128m
> +
> +[file2]
> +filename=file2
> +size=128m
> +EOF
> +
> +_require_fio $fio_config
> +
> +$FIO_PROG $fio_config --output=$fio_out
> +cat $fio_out >> $seqres.full
> +
> +# Check the files only have a single extent each and are in separate zones
> +extents1=$(_count_extents $SCRATCH_MNT/file1)
> +extents2=$(_count_extents $SCRATCH_MNT/file2)
> +
> +echo "number of file 1 extents: $extents1"
> +echo "number of file 2 extents: $extents2"
> +
> +rg1=`xfs_bmap -v $SCRATCH_MNT/file1 | _filter_rgno`
> +rg2=`xfs_bmap -v $SCRATCH_MNT/file2 | _filter_rgno`
> +if [ "${rg1}" == "${rg2}" ]; then
> +	echo "same RG used for both files"
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/xfs/4207.out b/tests/xfs/4207.out
> new file mode 100644
> index 000000000000..5d33658de474
> --- /dev/null
> +++ b/tests/xfs/4207.out
> @@ -0,0 +1,3 @@
> +QA output created by 4207
> +number of file 1 extents: 1
> +number of file 2 extents: 1
> -- 
> 2.47.2
> 
> 

