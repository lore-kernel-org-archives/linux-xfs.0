Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368C1225A1
	for <linux-xfs@vger.kernel.org>; Wed, 17 Jan 2024 23:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705535868; cv=none; b=sIjTSYYI0/FRAyVqzqGejZgqsWTQ1gpN1bc+jgPprXh1FRK0kbpwCFp7Y5x9jASYPsBvlK9uGHknnHogSuZzdN5c76hxngRRJQ6wYJo6PCpx5kS5zzTlbrr8epjA18Mjnfy1nJRaBRHPAyhxZs6zIRqP5XkunR3h1LxeirqW1xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705535868; c=relaxed/simple;
	bh=CWccj175A/lXLpNwH9S2ANhPEBIeXYoqssqUF44SX9w=;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To; b=TX+MDH+a/OOCNQnGyl7AOPvVAaCYCvB8mqL8k1apfqzgeRmdJxCUJk0GbqNZoi/kGSNP0fRQfWJq3HRTSgKIVDhKo3kQVmwoVMeqv4TPE1XV0JTLBJUCu4Aus8Q0RXabNP1HzF+H3sqvnmYxZwfydEN2IqX09Y56Kq/m+Efu9ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b5RXYvyE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5RXYvyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A454BC433F1;
	Wed, 17 Jan 2024 23:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705535867;
	bh=CWccj175A/lXLpNwH9S2ANhPEBIeXYoqssqUF44SX9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b5RXYvyEoDT65j/b0Cv0/EdFtRWwaQMJOe/Z2HPxAkbdhbImrDWJV+viW8Jjg338X
	 5wPNQot5aFplh0+nYHwYeLAcEK5CO25xFnWW5deHf9eyRnzw5vojYa/Aw0Kfrs2PNo
	 b8Am0Aa+RzPlqzRknWeX66GIzZuS05EnMXOO07pjf8vAzRHdvT4w8KIHGGQc8i4hLi
	 WIRvUgwlIa1HbBR+MlwYwmLj+PDKGjiHTzKP4BD45hTGJ9WahXcFUOpGwngm1va85C
	 +CqcOWCiSgusRvPbeX74U7fLdR0VYkCFY7wSfRp71rBRfVhpgkeldrQ0LdSQzFPQZ0
	 DpuIm3BZwXZww==
Date: Wed, 17 Jan 2024 15:57:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] libxfs: remove the S_ISREG check from
 blkid_get_topology
Message-ID: <20240117235747.GB674499@frogsfrogsfrogs>
References: <20240117173312.868103-1-hch@lst.de>
 <20240117173312.868103-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240117173312.868103-4-hch@lst.de>

On Wed, Jan 17, 2024 at 06:33:10PM +0100, Christoph Hellwig wrote:
> The only caller already performs the exact same check.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense now,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  libxfs/topology.c | 9 ---------
>  1 file changed, 9 deletions(-)
> 
> diff --git a/libxfs/topology.c b/libxfs/topology.c
> index 8ae5f7483..3a659c262 100644
> --- a/libxfs/topology.c
> +++ b/libxfs/topology.c
> @@ -181,15 +181,6 @@ blkid_get_topology(
>  {
>  	blkid_topology tp;
>  	blkid_probe pr;
> -	struct stat statbuf;
> -
> -	/* can't get topology info from a file */
> -	if (!stat(device, &statbuf) && S_ISREG(statbuf.st_mode)) {
> -		fprintf(stderr,
> -	_("%s: Warning: trying to probe topology of a file %s!\n"),
> -			progname, device);
> -		return;
> -	}
>  
>  	pr = blkid_new_probe_from_filename(device);
>  	if (!pr)
> -- 
> 2.39.2
> 
> 
