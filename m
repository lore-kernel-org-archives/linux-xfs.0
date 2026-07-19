Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF318B0F;
	Sun, 19 Jul 2026 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784489476; cv=none; b=pHwrJ4dlzySaFCAdblIZrnWFJKBTAuEVi8/tNnOMm661Shlzyq1Vy6yjNuk/7CukFrMSnz2zLrLBfXyQM3RuM85jI2JUqva3lrpOFiaeF0RkNy5qMR9x3RKZQb4zy4DOXshpl/tZKUy//1HbIP8j9MmOS1d5sB5oRFkIbfSAMEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784489476; c=relaxed/simple;
	bh=fYmxvvHdweN0lebZsyJ0KedE3CL+WhIq1pPF5OOc8PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DTMPk6lWn21yxhJLg77OtA19KD9I5R0wQeZ80i9XnZJpkvkMv0VBQE+vKXjrKP+LuYiNWJhPR+xKPrzA7gZZQYntnVVTaS9tam6j1g9HHRj/Famo0UmNM1+JJcmj+9Ve7a+Cg69GUbHvR8UhuuNIAn/xQHy+rsv/nPCZnJ37PK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1KP40UZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1KP40UZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E761F000E9;
	Sun, 19 Jul 2026 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784489475;
	bh=E19OCiP3Y58C5dTcmMSveUT7kFfCyIWK6f286JxhVeo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d1KP40UZqURY9ANd2NvEw/zwopekVYEpazUyA/npJMrkqD8cJocGcV+HZprfCVmbl
	 zGi5lLV0ZWkVZNf+rNNKIu/sIgkfdNZ6xtd3x0f+1MwZbN/lAGok57FgJoeuc6VhSG
	 gyhUw4Dyu+Kh5iM4vjv0OogTxgDiFc2uVZCt+NPyZVi/MynA7GSefHruLn5gfgX29v
	 uROczOun25rGQRgcKzgKZeoHD9f5gVAvYMtT69uFqkgKtAArwktZYa20x3yjc40JQm
	 kaSQBqH07JlYfByI5md10j4sTRvCI4wOMdy51UNGp569mZ2HlutAuMAszYmDEghXcz
	 bOzCugvbYXCEA==
Date: Mon, 20 Jul 2026 03:31:09 +0800
From: Zorro Lang <zlang@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs/656: rearrange directio pread/pwrite for zoned
 filesystems
Message-ID: <al0l5_nNes-8HM-l@zlang-mailbox>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>, 
	"Darrick J. Wong" <djwong@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260710052747.1841555-1-hch@lst.de>
 <20260710052747.1841555-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710052747.1841555-2-hch@lst.de>

On Fri, Jul 10, 2026 at 07:27:33AM +0200, Christoph Hellwig wrote:
> From: "Darrick J. Wong" <djwong@kernel.org>
> 
> On zoned filesystems, a write failure shuts down the filesystem, which
> makes this test fail with:
> 
>  --- /run/fstests/bin/tests/xfs/656.out	2026-03-13 16:19:08.152939212 -0700
>  +++ /run/fstests/logs/xfs/656.out.bad	2026-06-30 18:16:43.847849604 -0700
>  @@ -1,10 +1,9 @@
>   QA output created by 656
>   Format and mount
>   pwrite: Input/output error
>  -pread: Input/output error
>  +stat: Input/output error
>   pread: Input/output error
>   fsync: Input/output error
>   VICTIM pos NUM len NUM: directio_write: Input/output error
>  -VICTIM pos NUM len NUM: directio_read: Input/output error
>   VICTIM pos NUM len NUM: buffered_read: Input/output error
>   VICTIM pos NUM len NUM: buffered_write: Input/output error
> 
> Reorder the directio pread and pwrite to avoid this unnecessary failure.
> Note that we cycle the mount between the direct and buffered io tests,
> which is why we only need to fix the directio test.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Looks good to me,
Reviewed-by: Zorro Lang <zlang@kernel.org>

>  tests/xfs/656     | 2 +-
>  tests/xfs/656.out | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tests/xfs/656 b/tests/xfs/656
> index 3830d7193fcb..c01276eb384b 100755
> --- a/tests/xfs/656
> +++ b/tests/xfs/656
> @@ -66,8 +66,8 @@ $XFS_IO_PROG -c 'healthmon -c -v' $SCRATCH_MNT >> $tmp.healthmon &
>  healer_pid=$!
>  sleep 1	# wait for program to start up
>  _dmerror_load_error_table
> -$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
>  $XFS_IO_PROG -d -c 'pread -b 256k 10g 16k' $testfile >> $seqres.full
> +$XFS_IO_PROG -d -c 'pwrite -b 256k 12k 16k' $testfile >> $seqres.full
>  _dmerror_load_working_table
>  
>  _dmerror_unmount
> diff --git a/tests/xfs/656.out b/tests/xfs/656.out
> index 83b2f5948a77..4d6633060acd 100644
> --- a/tests/xfs/656.out
> +++ b/tests/xfs/656.out
> @@ -1,10 +1,10 @@
>  QA output created by 656
>  Format and mount
> -pwrite: Input/output error
>  pread: Input/output error
> +pwrite: Input/output error
>  pread: Input/output error
>  fsync: Input/output error
> -VICTIM pos NUM len NUM: directio_write: Input/output error
>  VICTIM pos NUM len NUM: directio_read: Input/output error
> +VICTIM pos NUM len NUM: directio_write: Input/output error
>  VICTIM pos NUM len NUM: buffered_read: Input/output error
>  VICTIM pos NUM len NUM: buffered_write: Input/output error
> -- 
> 2.53.0
> 
