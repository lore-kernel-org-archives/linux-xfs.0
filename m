Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008E17106E
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481801; cv=none; b=N9xQpojZWTFI5nyKvaO/Mu01XoJN9381B09Xha7Bmix9QBuwJ9hakaKU84Bu+/LotvWtT4/RLOmUfcXBlUhG61Bdkjq3Y1s1W67Y+KLS6WGaBzs7rA0WN+BfIUVbOmztz1YTcRajCRtY+orrT5ettIZvbMcfDzWbpDdYtS7GX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481801; c=relaxed/simple;
	bh=6xUgLOFdCuxBZJL1hn9eXwjjUUhUqAR1+BQPgXPLP+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JtzjN5GToRfifF5fKWHbUUnUeS1YEF04vMx4V9W72NcRIQoe4TiNbjF9eZbvtYwEgWYY6zOmOF4lxfYakz196AKLO00opr/2ITW/S5T80NsaVQ15VC4nfBxapBY5S+ikyF01q8HtIsk7aYcyuwGtrGlGBFWiIccEvWeA6GLLwyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QihpQKBk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QihpQKBk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714481798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/gvLa7sIDHO8kY1gdoDajG1u00oK5nehvTUav+G6vTU=;
	b=QihpQKBkC7ttYo5IXpUmBinb8+oiWu5RApLbuHRsXwGjZsDF4lf/8rB2YfMWaUBKqjTEt7
	6n30pfX0/QBnF0ij1JzjyNHNDwvNecSysxpMMzXtotRhE0gv2zkhtB6HEBhRcBeLdPNjCs
	mpTgEu/UVDu2rtkrnCfp7CLuupCwp2c=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-rJU0RcRLMXiwOLyNdpzLAA-1; Tue, 30 Apr 2024 08:56:37 -0400
X-MC-Unique: rJU0RcRLMXiwOLyNdpzLAA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-36c5ed3322aso2103265ab.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 05:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714481796; x=1715086596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gvLa7sIDHO8kY1gdoDajG1u00oK5nehvTUav+G6vTU=;
        b=S06Z/tfO343+TIQYZM8OdAzVr0K65hRVme1aaMHsz7n19CqrvB+G38fj5/AkjeEVns
         hJU5QLs42nvhST5jbpLM+oqy6GeEBjPPuJQdZuv2++TGLVYRt1hgpdtqJx0qpVc18A5e
         q6C7HrmSmH0LH5C8WXh4uEzSdbdAkRhTCmnW60jLyv2ZVDD9SAmnK29EthuNHRKPGbmC
         S2qoXcyA51NQLT50enHNgruq7atjHqcE51RQunFNWQPeK60Zb76T2tY5W0pbD1PAwgtx
         +rcGjBlEM8FnjRC/ONrFUV3FFr3toGS3WhEBCqKrWp8Ik0qcNZ0mg21zkIAg+5FGXiTh
         y+Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVZhxt2t/5mrp6zpn7pgNrdxT/AwWAQXOMXXbM4hcze4BLgQeJsRxCmVNiiHLynPRylSez3Gkb4isWLZPVaPLY3MMnJZI44xzgL
X-Gm-Message-State: AOJu0YzzD/GLGHYoruWAioufoE0VvsaQAsicsJrntXsthPktsiQl2E4Y
	ugjzkEYFXcCdVTijnTFE1EpV/xpyonYuDGt+d65IvyJF4miUk0IsOjjHeORtauMO19JCdimNiIt
	Tw5NOEmSisY6UB1xm2IWbQiBTDiRtpObr+SqDMNp9SNwIqW4oK7dBUKeb+npE6pQy
X-Received: by 2002:a05:6e02:1987:b0:36b:837:db0e with SMTP id g7-20020a056e02198700b0036b0837db0emr18708039ilf.1.1714481796420;
        Tue, 30 Apr 2024 05:56:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHAF1DkWU7ljBktLEfu0Y8dV1p17PuOLL/W4Kwzja5W5B2CaMpV5ljAlwN7cy3HrodfzDUArw==
X-Received: by 2002:a05:6e02:1987:b0:36b:837:db0e with SMTP id g7-20020a056e02198700b0036b0837db0emr18708010ilf.1.1714481795897;
        Tue, 30 Apr 2024 05:56:35 -0700 (PDT)
Received: from thinky ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id i1-20020a056e0212c100b0036c4d41e1ebsm1014741ilm.26.2024.04.30.05.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 05:56:35 -0700 (PDT)
Date: Tue, 30 Apr 2024 14:56:32 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, ebiggers@kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: test disabling fsverity
Message-ID: <7v6qwlhjqrgz5vznrwkfucx2tz2uc4qbo4h7hivausf7fzf5wa@ecq64sxnj5t3>
References: <171444687971.962488.18035230926224414854.stgit@frogsfrogsfrogs>
 <171444688055.962488.12884471948592949028.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171444688055.962488.12884471948592949028.stgit@frogsfrogsfrogs>

On 2024-04-29 20:42:05, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a test to make sure that we can disable fsverity on a file that
> doesn't pass fsverity validation on its contents anymore.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/1881     |  111 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1881.out |   28 +++++++++++++
>  2 files changed, 139 insertions(+)
>  create mode 100755 tests/xfs/1881
>  create mode 100644 tests/xfs/1881.out
> 
> 
> diff --git a/tests/xfs/1881 b/tests/xfs/1881
> new file mode 100755
> index 0000000000..411802d7c7
> --- /dev/null
> +++ b/tests/xfs/1881
> @@ -0,0 +1,111 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 1881
> +#
> +# Corrupt fsverity descriptor, merkle tree blocks, and file contents.  Ensure
> +# that we can still disable fsverity, at least for the latter cases.
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
> +_require_xfs_io_command noverity
> +_require_scratch_nocheck	# corruption test
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +_require_xfs_has_feature "$SCRATCH_MNT" verity
> +VICTIM_FILE="$SCRATCH_MNT/a"
> +_fsv_can_enable "$VICTIM_FILE" || _notrun "cannot enable fsverity"

also here, if not needed in 1880

Looks good to me:
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

