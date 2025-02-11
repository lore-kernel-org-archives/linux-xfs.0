Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBAE1E282D
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739296728; cv=none; b=I/Te0+xMtO4QsU2umJupgRX/whKWGdJey7k+yDFl9xvUYsPF6H+J2E0l0Bm6Xut/jeg+G9xW0ZjLjWvJCWwWMOHZ4T4otMHIHwNtkhdtGQwnUlZZHBUI4qRiCLl+iOrJ2wakndmzqoYiEk+c5Mh5MNVxHVFMCofOM2JbD+jUL+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739296728; c=relaxed/simple;
	bh=Fvc6pKY7wqPBgeCMdVLP0P+tbPnMX6OI2fqXjtjfxNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sufGrk4drrgjN9FcqCXmApyxVpiJjpQvGa++2g1mN/eWQOKB8wBudunT92Jmo/I4MqlJKJvkPCMN/hPUpFuzt8ezzb0zT3UaZv+aPPySNwaURNiWp3jrEl8Z91RLi1LM0NZ/Um55yh0L9T7vSioEAnEGJm/7V0QCj5ZcMNjtJ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jV1V/45Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jV1V/45Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B31C4CEDD;
	Tue, 11 Feb 2025 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739296728;
	bh=Fvc6pKY7wqPBgeCMdVLP0P+tbPnMX6OI2fqXjtjfxNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jV1V/45QCv1Pqdu+N204XHW9qhsvUdl56T3RdlxtCdkbGv8izX4YPPQTIURtJRh7M
	 jOfDnJc4x18J8YP+gMjHoOpxAb4lobTQ43fgdtfph6KusMay7P5ECCnal15cbNDJTR
	 Z38qb6BiggFmE004fJd0OiQ9z9UV4vml8N0Pj6DRXuJ2on2FLsmMiUYB20JMgiZjaR
	 OMiTqwLyCFHkvowZXyovNH94YO4GhU/rXkM6MqCvV5m0AGOrEQsAs3OYIr0bvWVLD5
	 dO2YpfSTdTNPbTSEgy3W21Dq9wiEVzlWCCOY5Nlz8kXb6rFVx1j9uOCiGzJ8zbsOYw
	 6dGLoVwWxM+FQ==
Date: Tue, 11 Feb 2025 09:58:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 7/8] release.sh: use git-contributors to --cc
 contributors
Message-ID: <20250211175847.GC21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-7-7b80ae52c61f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211-update-release-v3-7-7b80ae52c61f@kernel.org>

On Tue, Feb 11, 2025 at 06:26:59PM +0100, Andrey Albershteyn wrote:
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  release.sh | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/release.sh b/release.sh
> index a2afb98c2391c418a1b1d8537ea9f7a2f5138c1e..3d272aebdb1fe7a3b47689b9dc129a26d6a9eb20 100755
> --- a/release.sh
> +++ b/release.sh
> @@ -132,6 +132,7 @@ mail_file=$(mktemp)
>  if [ -n "$LAST_HEAD" ]; then
>  	cat << EOF > $mail_file
>  To: linux-xfs@vger.kernel.org
> +Cc: $(./tools/git-contributors.py $LAST_HEAD.. --delimiter ' ')

I think you want a delimiter of ',' here?

Cc: foo@bar.com, gruk@micorsoft.com

--D

>  Subject: [ANNOUNCE] xfsprogs $(git describe --abbrev=0) released
>  
>  Hi folks,
> 
> -- 
> 2.47.2
> 
> 
