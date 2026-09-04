Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D343447A871;
	Fri,  4 Sep 2026 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534690; cv=none; b=UIu2TSqfCNODJvaGbm8iI1jeiZkh+YzuiZLl6Jkx552HwF+N1Ls71jaEM8jsHiMib7MH8NBiJi1TfT2F3VeRyYnUSmzdtf3oR3b47harr7oZC4EuXbK8phytiLtuPEPnuFc0wr7LpxBLgZpJye3HMp59amjpZtB21+X/+9TnJl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534690; c=relaxed/simple;
	bh=6cz+gX7aJ7S9z52gvwYuLB6oD2bwAIyjmu/ULDoJ6Dw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LxORkY4IdO/L2A933VsDhbs3beisU5ddgqA0gj5liwcHzpgwVFSIrMlbomjwMA8mwuv/KXkKPolHfo6+erTc4Y56lErgQ540eGp1PwLQJklb28WZh++322l//29d7EH1EOyls9i1ctnJww+EGsPcSE/fAHNFNmQb6oQqPIgrxK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TenLC1ub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TenLC1ub"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 49FB81F00A3D;
	Fri,  4 Sep 2026 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788534688;
	bh=SMK0XXK6q2YSzNtsaaFazLjsUOVRWRr95c9/hhnNQaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TenLC1ubUYgAOfo97ls0AgFreu7QifE93pEsaTFK0QpoB/MUTnN0XEBcC2yRwP8Bq
	 hlaDH3VVJ5H98TQw4+tUPqylUKNmeLwe3pWsmYg3GjPs+/YFrbD0qIswmVtGr5sNR0
	 v/cJa5dbtNosYKpgH1CrYpvEpQSJm/EhzT7Znf4t/JXshC0JHozeT2SASm04kVMq83
	 9WBWzBJasTnmlcFVjvX/Ac6dwV8fSNqhbyBuVOob+P+v9YKSRMgV3nZsglSETDYqVd
	 2esqPsZLSzYdjfhORqU8Nq8Yy9LReQFGOeqFkM9eC9MfqSTsHbRwnJWt2MIRhW0GkP
	 sWxn6K0mTbjEg==
Date: Fri, 4 Sep 2026 08:11:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] iomap: fix typo "metdata" in comment
Message-ID: <20260904151128.GH6047@frogsfrogsfrogs>
References: <20260904103825.8752-1-hemanth.selam@gmail.com>
 <20260904103825.8752-2-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904103825.8752-2-hemanth.selam@gmail.com>

On Fri, Sep 04, 2026 at 04:08:22PM +0530, Hemanth Selam wrote:
> Correct "metdata" to "metadata", reported by scripts/checkpatch.pl using
> the misspelling list in scripts/spelling.txt.  Only touches comments, no
> code changes.
> 
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce8..b70f86292049 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -505,7 +505,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  		 * We can only do inline completion for pure overwrites that
>  		 * don't require additional I/O at completion time.
>  		 *
> -		 * This rules out writes that need zeroing or metdata updates to
> +		 * This rules out writes that need zeroing or metadata updates to
>  		 * convert unwritten or shared extents.
>  		 *
>  		 * Writes that extend i_size are also not supported, but this is
> -- 
> 2.48.1
> 
> 
