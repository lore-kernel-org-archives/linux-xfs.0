Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92191DDCD
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773431166; cv=none; b=cPKXwH09tMLsIlWX27CFVpnQx/vHF7Ql+3wRefWZRlmXPopRITtyP833m+YLi2qQdWQS+2WRmoboEjjkhwzk96KF3XahkYHByZwa8nb4uZ8PsCJBsqAfdicteicE0bWhNvd59fRBLiPNUv76wo3+SV2tl6nMcCvZgWBk4IzCVqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773431166; c=relaxed/simple;
	bh=U4TJIo4d3y6APZkq1LXnPdiX0plhxNz0tNj8VmONZ4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RLfMzlS+ZLPHrfuYOo7usAcNJlvDNKHdeLKwhY5XH1CqizIiJ/V4MNVi0W2vLlPSsRYOocoEX/AO4EsouCh8Dx7HEQWqXnxHkT1W0+YyPUjazvapZTdUzwXEkxbn/zZ/c5LW5/uzM1rU6Pr7BoqYfKIHolvADHCVEfGaEtglPvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXTUSKaw; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=M+M9qsUE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXTUSKaw";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="M+M9qsUE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773431164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3+UJalBt8ooxFAmXhAHDE6Cv2mDVNMgTscGv8utLjlQ=;
	b=ZXTUSKaw+s1Z8vrRNAkm/v2/oHxiSs+2+1btxnTRgn3YLJt4orSEXH4+7G/Rnjw498MkOi
	BDDomrXRdFKfIiCrs4p1oYQcGmWfw8w3J59jPaRxTaV6iT1m9n5A9BsGQZw+ES7bJ2b91A
	ty1iTVOhq+/Fjjp6NitA9uCBSBcXtCk=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-O-MO2hWRMj2BLq5-iVFEEg-1; Fri, 13 Mar 2026 15:46:03 -0400
X-MC-Unique: O-MO2hWRMj2BLq5-iVFEEg-1
X-Mimecast-MFC-AGG-ID: O-MO2hWRMj2BLq5-iVFEEg_1773431162
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-35a1a764225so2106185a91.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773431162; x=1774035962; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3+UJalBt8ooxFAmXhAHDE6Cv2mDVNMgTscGv8utLjlQ=;
        b=M+M9qsUEw7izdj96pyedykVaSoOy9ZueJ0LqJRitc0eEDKmsHd6NcRVUFGatRLONAu
         BiS5aDhq+ViAzVGxUiAKSkLa7UfdRbHcGqRujqw4SaqZfEcObPv+inXwLifBWVAFHY4A
         kIx7/5dtAQ7+iKLAyIxHtpek43vkdexMqy8nGdKXhxnBjeV1kRL2keM6AfF6t6tJEH6F
         +YaOwt0FSAugiOW1AT5H+cOtVppvnXtTUQEhLMHFrfY+HMjD134JN9e6u34wmgvI89dQ
         RbWW1euUmjZCvs8xuJKLjl8heQzD8Ll5DAbhmJWBMB127f7OWLTW9Scs5UE8FQoqraUU
         SNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773431162; x=1774035962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3+UJalBt8ooxFAmXhAHDE6Cv2mDVNMgTscGv8utLjlQ=;
        b=gWP0EkIsGPlcKa0gcVRULoaKurC+4P2Q8OrOyxiSrXXRV8BkG+JoYySucTwH3bG1B8
         0RbhXdDkIiYbsbJrvO2BnTXELx1PYhpSpPpbcGmFDG8lit+RT4XfWO8w9vnO3uf7tF6P
         nd8qxNfApbFjdyrmPmB56pRwumDHLaSBJ1icXUNWgNxoZEg4LS0xW4y/7HqbOBBiTW7D
         kukCFCt2W9+Flqw7fpWhnV+85uM3PzN/Xqlk6w9CEN33m75nHRRyDgqz3ZiQioBIR/Oe
         TNCacmlV/vV/u3HrlVhBPH1js5VBZo38o18EkfN6Ht01tdmszBFVnD/T+VXuKCaCYnqh
         LaxA==
X-Forwarded-Encrypted: i=1; AJvYcCVhnauVPgOycgY9xWjRo6GCYozemhgnw/7sYuOWmX2kjkUaP7HaEb6QoAPiJ03731taju/2U8WM2C0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJHXMOQb9C3gfStg2NZ53Vi1J5HQkrAM/szRmQIOkZhe1Wazt8
	ht5/gkhL5Q2BSRTbVLTP4g4dc/ZPwtCacrId6w3N6b3bqlSCjRtpq1sDztnaiNMQg9y80w9xwSx
	tO87LwzENav2SW7NrxlEgcclfTiEF4vl5+Kep1BB2mlO6S/hqoLeBe+zgE1TgoA==
X-Gm-Gg: ATEYQzxh6nONJqo4JD5CcrMSDMTkEAhJeDRLGeWSf1F/NQK1iAwpJ0aMWkb2y11CmXI
	ClgLIi34mauB9WvsHr/yV96CPGNLTgntxA0N6LYjr4QHizLnIBZzeZenXunG3MKEQIl9mnN02rv
	Atrxv1oSJ0m1QZquVKsHS2LZlX0mDF5cis7Ziwu8D+0xIbyMkmoiAErqCgJ3Wd2nO3ZNdIZ82uM
	u1ulw3cpgM0YQd7pBebewW3GJroA2CRwzQuTRJci8AF3JNEI0inDSDGRzYn3NwVGE737AELcq83
	CqTxU3hjV7q5+ZkHAcdmUM1ZnH1cn3fZpir+Cae2oLTRYb5NOIj9z7q9pdre+em9jqEK4JyrUCp
	NqeSv1GMawyLOYI8+hGi78VGmHU2i00mvDhwAMCaHG0CZeK7vWDRCCIM1wMO8fQ==
X-Received: by 2002:a17:90b:4a47:b0:34a:be93:72ee with SMTP id 98e67ed59e1d1-35a21ec604bmr3647705a91.8.1773431161943;
        Fri, 13 Mar 2026 12:46:01 -0700 (PDT)
X-Received: by 2002:a17:90b:4a47:b0:34a:be93:72ee with SMTP id 98e67ed59e1d1-35a21ec604bmr3647692a91.8.1773431161510;
        Fri, 13 Mar 2026 12:46:01 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a03005f7fsm9235905a91.15.2026.03.13.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:46:01 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:45:57 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/14] xfs: test xfs_healer can report filesystem
 shutdowns
Message-ID: <20260313194557.or7abafu4ctzsm4t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403941.1186408.2309881878313608797.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403941.1186408.2309881878313608797.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:52:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that xfs_healer can actually report abnormal filesystem shutdowns.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1898     |   37 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/1898.out |    4 ++++
>  2 files changed, 41 insertions(+)
>  create mode 100755 tests/xfs/1898
>  create mode 100755 tests/xfs/1898.out
> 
> 
> diff --git a/tests/xfs/1898 b/tests/xfs/1898
> new file mode 100755
> index 00000000000000..2b6c72093e7021
> --- /dev/null
> +++ b/tests/xfs/1898
> @@ -0,0 +1,37 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1898
> +#
> +# Check that xfs_healer can report filesystem shutdowns.
> +
> +. ./common/preamble
> +_begin_fstest auto quick scrub eio selfhealing
> +
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/systemd
> +
> +_require_scratch_nocheck
> +_require_scrub
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +_require_xfs_healer $SCRATCH_MNT
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 500k" -c "fsync" $victim >> $seqres.full
> +
> +echo "Start healer and shut down"
> +_scratch_invoke_xfs_healer "$tmp.healer"
> +_scratch_shutdown -f
> +
> +# Unmount filesystem to start fresh
> +echo "Kill healer"
> +_scratch_kill_xfs_healer
> +cat $tmp.healer >> $seqres.full
> +cat $tmp.healer | _filter_scratch | grep 'shut down'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1898.out b/tests/xfs/1898.out
> new file mode 100755
> index 00000000000000..f71f848da810ce
> --- /dev/null
> +++ b/tests/xfs/1898.out
> @@ -0,0 +1,4 @@
> +QA output created by 1898
> +Start healer and shut down
> +Kill healer
> +SCRATCH_MNT: filesystem shut down due to forced unmount
> 

