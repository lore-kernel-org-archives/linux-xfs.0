Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C466577105
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 12:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717418544; cv=none; b=f//qiP1lVO5FCIgbwYy6eeQqsqsX7c11EeT0rthK2ddZ9yL+KqD0i/aGFB29L2HuRgMywD5AOGvKG2W+fAMSgOtKRkkKu3cGLjT8btsNgZWvkcsyhn6YjUP/NAGlkl9a8MudVgJcWq6ROXcV8LzRNU1DstoO5zb98yQYNc3NCG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717418544; c=relaxed/simple;
	bh=OslOke9ZmIzaQQjdk/Xb3z91YuXsYSJFDZKJMA4veKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BnFMhIiG/YLsMDYsLhSA/D9ovBZoC2FIXRVCJZtRViZ6aSJHO80N0f3ZGzv0a6t8pENRlV3JT43SIKHJAfJmTDp/IeEYE5doufQnSWbD86GvYz+Qa9X7pgUfkJqKnZcY4sytVOtozhjUdoy+/W+QBdtzVB9x7/L4wV0nzL2C4i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPqthCxk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPqthCxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468E5C2BD10;
	Mon,  3 Jun 2024 12:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717418544;
	bh=OslOke9ZmIzaQQjdk/Xb3z91YuXsYSJFDZKJMA4veKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YPqthCxkA7OHYcWtYxThNxmV48T2jqcimxTE4JLCX3Mub76HHRvY8oConw9iIXSwH
	 mLBYXV/xnmhOOMfNkYhR5RK5wPefYdIzvnS0jydBbdbXx/HBHs4hZhV+f3RHyq6L4W
	 kBAbNfnHqhNYW7viZiNjKWoMp/tNadSkH4BNY2AyMguAHxO6YW9xjhXfTlos8W0ea1
	 bFJS9xt/fDK2PaMwXNSa7siitW8Jkdh7qWIKkYflBECy8pTL3v/ttjeHIgAm3oulzT
	 uqkmA/SRKAhgQ9nhsidep74Wr5p8lQeuouDpYpaDfbd+UQmIGPo9II1h27YkXQuEdp
	 qSkIiAE/ykaCA==
Date: Mon, 3 Jun 2024 14:42:20 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_repair: detect null buf passed to duration
Message-ID: <myn5kmvijvegbg5k2i2rvt3ioawnm4bzyls6fn42bvufr4x664@ovy7iysu7pjk>
References: <20240531201039.GR52987@frogsfrogsfrogs>
 <WgLbGibmOXGXNXCoy90SomamGGdmPDxkXmpXjSQ5RZF1JSNK9--cUD0gjslOvqF14KG5inSv81x6OIcWI3j_gQ==@protonmail.internalid>
 <20240601175853.GY52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240601175853.GY52987@frogsfrogsfrogs>


> diff --git a/repair/progress.h b/repair/progress.h
> index 0b06b2c4f43f..c09aa69413ac 100644
> --- a/repair/progress.h
> +++ b/repair/progress.h
> @@ -38,7 +38,7 @@ extern void summary_report(void);
>  extern int  set_progress_msg(int report, uint64_t total);
>  extern uint64_t print_final_rpt(void);
>  extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
> -extern char *duration(time_t val, char *buf);
> +char *duration(time_t val, char *buf) __attribute__((nonnull(2)));

Once nonnull() is used here, shouldn't we also set -Wnonnull to CFLAGS?

Please don't take it as a review, it's just a question that came to my mind as I don't fully
understand the implications of using nonnull here.

Carlos
