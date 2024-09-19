Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F237F3A1AC
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726776437; cv=none; b=bJFRbIlmqBkN5bTl37MlpfGv+M9B/4/1G/bhAyt0SiT2YjPkRtq9ihifuYwmd0dVu/Y64ycKjBpyKCYQ04KA3OYcoISUI38RhwleWvlv44XzMl5VP5roTQGsv5Mu65CVFwi001IX4Z+DuY6YrgiYs3dzhD+5JcZEg98CDK8x3wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726776437; c=relaxed/simple;
	bh=wohWVWBt656j2gIzHGa1bJgbDMrby0RZDe9OH8PtnGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R8TVQGop+JzDTXRmA6BiP8vhHsjn3r52jKPjEAnCE3QnqY0sf8XCRQ6EsTkP9LDGNG/N+2Kb49TJwvXrQ7X7+BF1munVkPYiFM8OyoPSjeciTr38nDq6PUAUwlGIeTrrqKUAMsxkbZIzF8SKxJf7lIk1UnbhB8xn1lX6/CmU7Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aJfr60YG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aJfr60YG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726776431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VNt1sU0+eq8ChEgSPeO4lqDYucWAiLg+nimt5cESx6c=;
	b=aJfr60YGapgQFOftuBpY5W6l/brnGmBY3PHJr4AWAIAsvnxAey48k5Vvjm2x1uZRXfCwtZ
	F9UgzkfbXUzMSW0SWhht4720AnOOZU9dkHr5fzf1jS/WuHPSr+GxB3yZKGCYrMAzoj8wde
	UX1QrKpJNk1CSp1wP/nXP+nCA4Fwgm4=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-mQJVinF4MAyo85m-_aagcA-1; Thu, 19 Sep 2024 16:07:08 -0400
X-MC-Unique: mQJVinF4MAyo85m-_aagcA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-7d511de6348so842186a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 13:07:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726776427; x=1727381227;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNt1sU0+eq8ChEgSPeO4lqDYucWAiLg+nimt5cESx6c=;
        b=Il6eFVPfXPe4ySt1hdOUXJn7wafJER1VLMKdg0YPlNgt//qZ8K6W3joR/4LJP0qpPE
         oBa82Q9xpU4/dBHeKZH5PxU7pIhdFDR67vDO/efCvMB6YBc7H+lo8cfI0OmQxzyV2QR4
         XdvWGL4nfnH0bWVVFI3WopX+R1GQF7LkJr2OAPBEMFMOsYrLTi2H3xdUoYbspISDhq5s
         IFDKnU62veC4Q5ArHCYL9pi4Pbha7yj7Do5VEpXPlegygp7v9nY6IMQK1y4sfkqPX9x7
         1XanMszhlt0BcLxvli4if99Rf4PEkqhCLMyk2CotfemZMF+cYoqQ1udQREZCR1cuxTcN
         eDMw==
X-Gm-Message-State: AOJu0YwYIbVOzIVSKa2KsBf5IwS4FUrnOOd6IerESxf/UQMZNk9YGzYT
	hu+4nnRzBIBbOpYM2lWYXd0Y/Hha3RESUSDe2+Fg8Mad7noT85T5x5dXWzqS6vTQNWwUtddXndj
	cjrQRCWIySCG5V4K8jFFNo7tB0uLoX6VMXuGQNrT2G6y7VP7zdtwnV34lht7DO58Ydb25
X-Received: by 2002:a17:902:db12:b0:207:5cfc:504a with SMTP id d9443c01a7336-208d836cb41mr7607745ad.4.1726776427272;
        Thu, 19 Sep 2024 13:07:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFzHNIfdaF1D8LcmUP6tBZMMwzhEZWBWt+XYEwFqlB9g+bB85zWkCTgZG9/tk0hfvPjiqpz9A==
X-Received: by 2002:a17:902:db12:b0:207:5cfc:504a with SMTP id d9443c01a7336-208d836cb41mr7607285ad.4.1726776426776;
        Thu, 19 Sep 2024 13:07:06 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207945dc13fsm83760445ad.24.2024.09.19.13.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2024 13:07:06 -0700 (PDT)
Date: Fri, 20 Sep 2024 04:07:03 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] generic: add a regression test for sub-block fsmap
 queries
Message-ID: <20240919200703.xyn5tqv5knqzgiq3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <172669301283.3083764.4996516594612212560.stgit@frogsfrogsfrogs>
 <172669301299.3083764.15063882630075709199.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172669301299.3083764.15063882630075709199.stgit@frogsfrogsfrogs>

On Wed, Sep 18, 2024 at 01:57:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Zizhi Wo found some bugs in the GETFSMAP implementation if it is fed
> sub-fsblock ranges.  Add a regression test for this.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/1954     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/1954.out |   15 +++++++++
>  2 files changed, 94 insertions(+)
>  create mode 100755 tests/generic/1954
>  create mode 100644 tests/generic/1954.out
> 
> 
> diff --git a/tests/generic/1954 b/tests/generic/1954
> new file mode 100755
> index 0000000000..cfdfaf15e2
> --- /dev/null
> +++ b/tests/generic/1954
> @@ -0,0 +1,79 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1954
> +#
> +# Regression test for sub-fsblock key handling errors in GETFSMAP.
> +#
> +. ./common/preamble
> +_begin_fstest auto rmap fsmap
> +
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"xfs: Fix the owner setting issue for rmap query in xfs fsmap"
> +_fixed_by_kernel_commit XXXXXXXXXXXX \
> +	"xfs: Fix missing interval for missing_owner in xfs fsmap"

These 2 patches have been merged:

  68415b349f3f xfs: Fix the owner setting issue for rmap query in xfs fsmap
  ca6448aed4f1 xfs: Fix missing interval for missing_owner in xfs fsmap

I'll help to update the commit id when I merge it.

> +
> +. ./common/filter
> +
> +_require_xfs_io_command "fsmap"
> +_require_scratch
> +
> +_scratch_mkfs >> $seqres.full
> +_scratch_mount
> +
> +blksz=$(_get_block_size "$SCRATCH_MNT")
> +if ((blksz < 2048)); then
> +	_notrun "test requires at least 4 bblocks per fsblock"

What if the device is hard 4k sector size?

> +fi
> +
> +$XFS_IO_PROG -c 'fsmap' $SCRATCH_MNT >> $seqres.full
> +
> +find_freesp() {
> +	$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | tr '.[]:' '    ' | \
> +		grep 'free space' | awk '{printf("%s:%s\n", $4, $5);}' | \
> +		head -n 1
> +}
> +
> +filter_fsmap() {
> +	_filter_xfs_io_numbers | sed \
> +		-e 's/inode XXXX data XXXX..XXXX/inode data/g' \
> +		-e 's/inode XXXX attr XXXX..XXXX/inode attr/g' \
> +		-e 's/: free space XXXX/: FREE XXXX/g' \
> +		-e 's/: [a-z].*XXXX/: USED XXXX/g'

As this's a generic test case, I tried it on btrfs and ext4. btrfs got
_notrun "xfs_io fsmap support is missing", ext4 got failure as:

  # diff -u /root/git/xfstests/tests/generic/1954.out /root/git/xfstests/results//default/generic/1954.out.bad
  --- /root/git/xfstests/tests/generic/1954.out   2024-09-20 03:51:02.545504285 +0800
  +++ /root/git/xfstests/results//default/generic/1954.out.bad    2024-09-20 03:58:51.505271227 +0800
  @@ -1,15 +1,11 @@
   QA output created by 1954
   test incorrect setting of high key
  -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
   test missing free space extent
          XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
   test whatever came before freesp
  -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
   test whatever came after freesp
  -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
   test crossing start of freesp
          XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
          XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
   test crossing end of freesp
          XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
  -       XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX

Thanks,
Zorro

> +}
> +
> +$XFS_IO_PROG -c 'fsmap -d' $SCRATCH_MNT | filter_fsmap >> $seqres.full
> +
> +freesp="$(find_freesp)"
> +
> +freesp_start="$(echo "$freesp" | cut -d ':' -f 1)"
> +freesp_end="$(echo "$freesp" | cut -d ':' -f 2)"
> +echo "$freesp:$freesp_start:$freesp_end" >> $seqres.full
> +
> +echo "test incorrect setting of high key"
> +$XFS_IO_PROG -c 'fsmap -d 0 3' $SCRATCH_MNT | filter_fsmap
> +
> +echo "test missing free space extent"
> +$XFS_IO_PROG -c "fsmap -d $((freesp_start + 1)) $((freesp_start + 2))" $SCRATCH_MNT | \
> +	filter_fsmap
> +
> +echo "test whatever came before freesp"
> +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 3)) $((freesp_start - 2))" $SCRATCH_MNT | \
> +	filter_fsmap
> +
> +echo "test whatever came after freesp"
> +$XFS_IO_PROG -c "fsmap -d $((freesp_end + 2)) $((freesp_end + 3))" $SCRATCH_MNT | \
> +	filter_fsmap
> +
> +echo "test crossing start of freesp"
> +$XFS_IO_PROG -c "fsmap -d $((freesp_start - 2)) $((freesp_start + 1))" $SCRATCH_MNT | \
> +	filter_fsmap
> +
> +echo "test crossing end of freesp"
> +$XFS_IO_PROG -c "fsmap -d $((freesp_end - 1)) $((freesp_end + 2))" $SCRATCH_MNT | \
> +	filter_fsmap
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/1954.out b/tests/generic/1954.out
> new file mode 100644
> index 0000000000..6baec43511
> --- /dev/null
> +++ b/tests/generic/1954.out
> @@ -0,0 +1,15 @@
> +QA output created by 1954
> +test incorrect setting of high key
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> +test missing free space extent
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> +test whatever came before freesp
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> +test whatever came after freesp
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> +test crossing start of freesp
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> +test crossing end of freesp
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: FREE XXXX
> +	XXXX: XXXX:XXXX [XXXX..XXXX]: USED XXXX
> 
> 

