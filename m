Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C211513F43D
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714480151; cv=none; b=EvpbgidMStREKxg+oIDtpWFkhDhwJU6foQsZNRwBsXGpwR4F6nzwZQsKfttCt9z/+45vVpTxlM5o+zKyxEeXMXM04THvhuMnX8WS6+xG/zeXFG6+ZH15LnU73jA37IRvN72JkK0KaVm1pL9a/SUzLBKdwLr5ryH6PgHKdnmNxCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714480151; c=relaxed/simple;
	bh=rvl2LGQYTgzq38mG6SzOpcDNFvD/j4jBEIgOtnfpgmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2798HaxzzmfWM6esxPgt4yXsghqxcdG/3Wy4oMFKPO9PcBhE85vwPtf2c3fb63FkxtIIotDL+ghaotEF4Dr3izkIy39cQsEXxELXNsw/h8AgqziKu5l7jxaNnOVU80jjwogd/1/XlmsrABNFrFGWS1I6dWOh6uHKW4T6Cjrj/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V1GkuDft; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V1GkuDft"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714480148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PSKTo0fsUqmzxcGkY1pyXO8izPBGY9fWGNOTqw95lTQ=;
	b=V1GkuDft48AycKGR997oeX+ZQCEn2VDP6qJan0o3YZHTOUo5GF7hkkaQncDBT/RRjPq7vO
	M3QzUjf3t8zF4x3CWWDUGFc7v9ETovOHkmViCnnaF/2gQxK6qID0ToSFdcpZm045hqRC0s
	Wzw0ASv2sO9nKRN/QOW1nLzHEQqiRng=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-232-t8lU7g11OjKHwgEEtoDBRw-1; Tue, 30 Apr 2024 08:29:06 -0400
X-MC-Unique: t8lU7g11OjKHwgEEtoDBRw-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a51eb0c14c8so213496466b.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714480145; x=1715084945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PSKTo0fsUqmzxcGkY1pyXO8izPBGY9fWGNOTqw95lTQ=;
        b=gUcWlDBT1GJMTY0qaUGXq1+F327DcjC3xK/ZwmoOxrcZ6S6czn9WtuVzpzArLBQCfb
         pu8GLyzwlSjAcxSqL5WMDuknAivCfCz1OTrVDCujhI+Xt5Ag7MAwJ3bEQ+Iivtcl+4SX
         MlJUhoRywskVKpli04UFWiwr7HGfIEI4/KHCCahsgQpHcdF0egOg41RRfH16q6ihJ/a0
         3djfcXq07bzFMm0A+61hZIp1iCWTQOfIFHffMuvNxgDl3bnsarmD+U9WrhzEB9Tu8F35
         Z/Wf3wpaF9O0XfxhDhYfYu203Wy4e+1/LcT6csubSEVFk83/b9svlMHjtvFgKAJ0Vj9M
         gg6w==
X-Forwarded-Encrypted: i=1; AJvYcCWywCn7pkwUoXtm19Y17BwF5nRwPaugJ/Sj3jPOmLlwlHxnJXnFKFoZjGcqI1xr+M8DHntIt2hHWWU4BIGKWAkQoATs+/5LF7kp
X-Gm-Message-State: AOJu0Yy11vZeDUesFmB4HJgvzYLZ/gKqlhLeQ57UX6kYs/h1VZpy3YB6
	6wUMUA/efpw8eJ/76wXX0g01stsVKzIiK449PSxvzdRq62Gzl1B06S9OrofVglrilMS9Qt3M+EC
	Hfpp7aT1dx09BMbjY04f+ORCqLnspI2yfczVl2D3iRh+o/cjlC1KCtZuQ
X-Received: by 2002:a17:906:140a:b0:a55:b05b:cdf2 with SMTP id p10-20020a170906140a00b00a55b05bcdf2mr1982563ejc.21.1714480145011;
        Tue, 30 Apr 2024 05:29:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExbEF0B6PaeOO+gY91rAjKvEnZ0XZPuVp+IG/Xa1dBjLeL09mDJp7gx/hEZ7mhWw+WUvxzVQ==
X-Received: by 2002:a17:906:140a:b0:a55:b05b:cdf2 with SMTP id p10-20020a170906140a00b00a55b05bcdf2mr1982527ejc.21.1714480144432;
        Tue, 30 Apr 2024 05:29:04 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id u3-20020a170906b10300b00a52552a8605sm14992175ejy.159.2024.04.30.05.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 05:29:04 -0700 (PDT)
Date: Tue, 30 Apr 2024 14:29:03 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, ebiggers@kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: test xfs_scrub detection and correction of
 corrupt fsverity metadata
Message-ID: <4atckq27cuppwfue762g3xctp46dnwmjffawuxqsdfq6qeb5rd@g4snomzn7v4g>
References: <171444687971.962488.18035230926224414854.stgit@frogsfrogsfrogs>
 <171444688039.962488.5264219734710985894.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444688039.962488.5264219734710985894.stgit@frogsfrogsfrogs>

On 2024-04-29 20:41:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Create a basic test to ensure that xfs_scrub media scans complain about
> files that don't pass fsverity validation.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/1880     |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1880.out |   37 ++++++++++++++
>  2 files changed, 172 insertions(+)
>  create mode 100755 tests/xfs/1880
>  create mode 100644 tests/xfs/1880.out
> 
> 
> diff --git a/tests/xfs/1880 b/tests/xfs/1880
> new file mode 100755
> index 0000000000..a2119f04c2
> --- /dev/null
> +++ b/tests/xfs/1880
> @@ -0,0 +1,135 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1880
> +#
> +# Corrupt fsverity descriptor, merkle tree blocks, and file contents.  Ensure
> +# that xfs_scrub detects this and repairs whatever it can.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity
> +
> +_cleanup()
> +{
> +	cd /
> +	_restore_fsverity_signatures
> +	rm -f $tmp.*
> +}
> +
> +. ./common/verity
> +. ./common/filter
> +. ./common/fuzzy
> +
> +_supported_fs xfs
> +_require_scratch_verity
> +_disable_fsverity_signatures
> +_require_fsverity_corruption
> +_require_scratch_nocheck	# fsck test
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_require_scratch_xfs_scrub
> +_require_xfs_has_feature "$SCRATCH_MNT" verity
> +VICTIM_FILE="$SCRATCH_MNT/a"
> +_fsv_can_enable "$VICTIM_FILE" || _notrun "cannot enable fsverity"

I think this is not necessary, _require_scratch_verity already does
check if verity can be enabled (with more detailed errors).

Otherwise, looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

