Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD99B3EC82F;
	Wed, 29 Jul 2026 15:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785340012; cv=none; b=aXaQuH3xA1ix7p9xosydBRyUis59WUSg2yHfBlLmHgoEqG5wGAFQvDPAqNv4mUWzGI3Lyt8o4britOLZ3zDfMiu06KtP3crOeXpCErEwisPn1ae5Mn/jPenDIHbJaXEToxfsPE52eeFh19bj7mg2ymLh0qdhnBA2MPGmntDy9HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785340012; c=relaxed/simple;
	bh=G976cK+vtEfwfaWdwLQ7eeA6AcynniFlG5cf7ZMzgFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MC6FQlOUI/Vri/KU/BmLJobI1ZNxZAP+AL19zRSnjKbpegKsx1MaY20mHEmfolXZl62GzWBjY14gHdsJimgpqyEZtudGM5xcxF6jRCBmMbOLPMXmb8zTM6umudXVkD+Aot+qIVOGAk/QILJmGKEdzh6dsXZggWBPWsCcRAnWiAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6XoRKtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6XoRKtJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 374371F00A3A;
	Wed, 29 Jul 2026 15:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785340011;
	bh=KwcZ/4q8tWqy1coSiMxBwywYtsxXFBF097bCYRhnF90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C6XoRKtJYQDuJZcEikPaK7Hp8mD7oF845yR2nT3NmtEN8ORuk/JHPesBbGlmEmNlp
	 lzNM2tXzcuskjbP/0Uv/5grE7Nm/tUkiGtVlMkom6z9ruJhiTbfYrDLlrfW8U+HrSi
	 D9qrvd4JtsX8ttA6VGBBUDaHZ8h7knJwLUZjKXimiLuoO3jRSUWVtE+uGhlXx6wVcF
	 VgFg23O/ghFPVl46rU8R9PqtFcT1BgMvZuVcnLeQVD/XRP5ybWAf7H1n+DT9CeGdXm
	 3wCuIDaH0fTKdz+tFtpNUO2m41/rOHnrqM4mJYi2sTAxPMlyyxuanWTwRbPoug7hG/
	 GwbPqRwX8nEzQ==
Date: Wed, 29 Jul 2026 08:46:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs/507: use mount -t xfs
Message-ID: <20260729154650.GC7371@frogsfrogsfrogs>
References: <20260729125955.2281762-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729125955.2281762-1-hch@lst.de>

On Wed, Jul 29, 2026 at 02:59:55PM +0200, Christoph Hellwig wrote:
> Sometimes mount wants to try every other file system but XFS when
> mounting the loop image, making this test fail.  Force mounting as XFS
> to make it reliably pass.

Weird.  Do you know why it does that?  Did the kernel really skip xfs or
were the sb verifiers simply running in quiet mode?

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/507 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/507 b/tests/xfs/507
> index e1450f4f8f94..a9eb8646680b 100755
> --- a/tests/xfs/507
> +++ b/tests/xfs/507
> @@ -86,7 +86,7 @@ loop_dev=$(_create_loop_device $loop_file)
>  
>  _mkfs_dev -d cowextsize=$MAXEXTLEN -l size=256m $loop_dev >> $seqres.full
>  mkdir $loop_mount
> -_mount $loop_dev $loop_mount
> +_mount -t xfs $loop_dev $loop_mount
>  
>  echo "Create crazy huge file"
>  huge_file="$loop_mount/a"
> -- 
> 2.53.0
> 
> 
