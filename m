Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EB776915;
	Fri, 12 Jan 2024 16:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgmCx3jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A38C433F1;
	Fri, 12 Jan 2024 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705077799;
	bh=4dwi9Ro2n1kyZE3BVKpYXvvZBdj2Baqhfvb92rjKYio=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgmCx3jJhegq5AT/jEmgfXn6BbLDQj3pck5BDPeppHdXOmv34K3Z9yXWaPL4qv1e2
	 WOfS8p7jARgEbVOJ+EpgPeC1oiEHzI75MGDugHyoLBMD0E+2QG/hCLa/Qlf6v1GVT+
	 T+uc6fjrdos+B7yhx/V+NMWt5jvut8xcqLPv8i2fnj7hmJwf3dk0iRm+kgXgfBmlmP
	 q7ZBZzAp9ZJ9w96/jW7QKt/k+M+CqcXAlqnUTqWSGKNN1FlQkU2lcDDXAtzE+NU2rW
	 tOWtG6D+ME5zum4Si1vGU0ECuaQYQrKYMnuCs1bsrd0VyqYq8K0fk7l1PsbQTXmatA
	 up2gIMxBaeH2w==
Date: Fri, 12 Jan 2024 08:43:18 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs/506: call _scratch_require_xfs_scrub
Message-ID: <20240112164318.GT722975@frogsfrogsfrogs>
References: <20240112050833.2255899-1-hch@lst.de>
 <20240112050833.2255899-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112050833.2255899-5-hch@lst.de>

On Fri, Jan 12, 2024 at 06:08:33AM +0100, Christoph Hellwig wrote:
> Call _scratch_require_xfs_scrub so that the test is _notrun on kernels
> without online scrub support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

With whatever name we picked for the helper,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  tests/xfs/506 | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tests/xfs/506 b/tests/xfs/506
> index 157dac293..b6ef484a5 100755
> --- a/tests/xfs/506
> +++ b/tests/xfs/506
> @@ -21,6 +21,9 @@ _require_xfs_spaceman_command "health"
>  
>  _scratch_mkfs > $seqres.full 2>&1
>  _scratch_mount
> +
> +_scratch_require_xfs_scrub
> +
>  _scratch_cycle_mount	# make sure we haven't run quotacheck on this mount
>  
>  # Haven't checked anything, it should tell us to run scrub
> -- 
> 2.39.2
> 
> 
