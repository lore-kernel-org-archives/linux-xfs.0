Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B49AD55
	for <linux-xfs@vger.kernel.org>; Sat,  1 Jun 2024 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717264710; cv=none; b=SOY6byLD4sJ5fAW0D7x6Gae8PvWyZte16Z0K+a3F2HL61h0lGapCxDDjAeNqOhnQmGzJx0k5SNrW/c22W+rASZ1UwRoLRxqYeixs2fV6Hs8bsQFQbm8fjvTvjIUSZGKj5IZLH70rXn3qMLUDh7hRDP3Xzany1CbCCwdkxYI9+Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717264710; c=relaxed/simple;
	bh=duP4bFU/Tfuep5K3HhM+erUZYZLxLqkKh+z1VEZBQJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H63Fb1qd6dR1Jq0Fh4+5Fyvo6n6wdtQlYSJO/TUXo8T6/NEzoS8v3mX4S7kJzWFSH5uHdWurvmQ5m72jPNU2a5RDKdzzyIQSa4dKvy6yAAQkqDhtkgbX02kog5GhxpILC4vLnPvz7Xhhen7BBjzEDpCRXCZ08BjdVeRCOm3s25g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJ0sV7Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJ0sV7Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66EA7C116B1;
	Sat,  1 Jun 2024 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717264709;
	bh=duP4bFU/Tfuep5K3HhM+erUZYZLxLqkKh+z1VEZBQJM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJ0sV7Qcnj/axu/qv8h/xNo6+ka7Ml84wwxdOJWZ/hllnsOqJX89oKcbc6WmWNfP6
	 hRyScWPn+OmHGIEjh6jqVLNsLuBggqT2/As/8VrrXB5sR4Wqbr7gM5PE27LWUTgYRc
	 JsCwFwy7d4kDAVQ4QCUvZqhpWkL/biDFdeqRhiurgrVjAMM85C5mcXyt3xs+1UdccO
	 GU9wTcu6fAIxoelYRXaq9phwN+7OInKbzpXb2Too81BFLcuXbzi8X/3LI0txI+SnP3
	 UohzlwL8x9UVupydn/2hMFL0vAUGuOOWurvpF81ZIXRygPkujAb6AW1/xisBQbVF2k
	 yMWGvpUyYlgKw==
Date: Sat, 1 Jun 2024 10:58:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Carlos Maiolino <cem@kernel.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_repair: detect null buf passed to duration
Message-ID: <20240601175828.GX52987@frogsfrogsfrogs>
References: <20240531201039.GR52987@frogsfrogsfrogs>
 <Zlqq6Xmy_cw6uYFP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zlqq6Xmy_cw6uYFP@infradead.org>

On Fri, May 31, 2024 at 10:00:25PM -0700, Christoph Hellwig wrote:
> On Fri, May 31, 2024 at 01:10:39PM -0700, Darrick J. Wong wrote:
> > I think this is a false negative since all callers are careful not to
> > pass in a null pointer.
> 
> Yes.
> 
> > Unfortunately the compiler cannot detect that
> > since this isn't a static function and complains.  Fix this by adding an
> > explicit null check.
> 
> Can you try adding a __attribute__((nonnull(2))) to the declaration like
> this?

Seems to work, I'll send in a v2.

--D

> diff --git a/repair/progress.h b/repair/progress.h
> index 0b06b2c4f..c09aa6941 100644
> --- a/repair/progress.h
> +++ b/repair/progress.h
> @@ -38,7 +38,7 @@ extern void summary_report(void);
>  extern int  set_progress_msg(int report, uint64_t total);
>  extern uint64_t print_final_rpt(void);
>  extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
> -extern char *duration(time_t val, char *buf);
> +char *duration(time_t val, char *buf) __attribute__((nonnull(2)));
>  extern int do_parallel;
>  
>  #define	PROG_RPT_INC(a,b) if (ag_stride && prog_rpt_done) (a) += (b)
> 
