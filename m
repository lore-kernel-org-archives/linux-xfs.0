Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DFC47F4A
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 04:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738902684; cv=none; b=C7y1wqyEdRlf/H8hsl1Qs0J/Sgnlpyx9kDcC2OlEBiFo8jiIB8VDHQjxpZQZOAeG0IJXr8/c21xg1UEcy7/2fk6lJirN+mL30Iwu6/xNw0kFttvCsBs1hQVrihBWEAdvq/kR6ZOfoD96H/Gy3Kb9zCSdkT3gg/5PIp/7qoc7OIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738902684; c=relaxed/simple;
	bh=sHiwm7AHhNCCq8xtAI4S1ttR0rhEAEqpiD9tR5VRXVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S9vzoFhQAFkEkctDHr/dwQoQ3VHkxUMXD7gJPwNYEws6UOdIKgWMhCF6EmG5heiHiNWO6ljd9qVXYkWH9NQ+B7BK3pwXDWNa1koY7Jq3xPy4Kp+Q9y+m8jRc4ZHTXZdQf3Hob/PiZwJzETtOczTI4ILP9FqcSfv2vzSohcbsS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CgUPzHtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CgUPzHtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D55C4CED1;
	Fri,  7 Feb 2025 04:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738902683;
	bh=sHiwm7AHhNCCq8xtAI4S1ttR0rhEAEqpiD9tR5VRXVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgUPzHtNsI1CyWG8lWvVO7m4FNMbbydMZEi3nIPJwThxg1lEq/XdGueL7yTHRLy2Z
	 0/kfX8J7K3W8/jZqCtqO6Y6U/UXA5FnEq/A4+3aet0DPmb06WlaBwhb/wNS4LF7aZY
	 PP0hGS/uKlFk11uUWV4/f/5ioxErY/s+YgT2/98vru49fmagTnR1sHg+bLFxgBFQpa
	 DdrguRwk/WPccZvwrojLdeFk8CvEhT3aFugt4DsGizHw0j8i8DhtttImClOE2j9FCB
	 VRR78uMBOpwZQi+h8JMde3dlUCxqPBsHHWCXpwQZxBGu4CGm2J8KTQ4De2v1V7mUcI
	 QtImN9mfRzuwQ==
Date: Thu, 6 Feb 2025 20:31:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/43] xfs: disable reflink for zoned file systems
Message-ID: <20250207043123.GM21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-35-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-35-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:50AM +0100, Christoph Hellwig wrote:
> While the zoned on-disk format supports reflinks, the GC code currently
> always unshares reflinks when moving blocks to new zones, thus making the
> feature unusuable.  Disable reflinks until the GC code is refcount aware.

It might be worth mentioning that I've been working on a refcount-aware
free space defragmenter that could be used for this kind of thing,
albeit with the usual problems of userspace can't really stop the
kernel from filling its brains and starving our defragc process.

It would be interesting to load up that adversarial thread timing
sched_ext thing that I hear was talked about at fosdem.

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reluctantly,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 34b0f5a80412..ceb1a855453e 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1824,6 +1824,13 @@ xfs_fs_fill_super(
>  			goto out_filestream_unmount;
>  		}
>  
> +		if (xfs_has_zoned(mp)) {
> +			xfs_alert(mp,
> +	"reflink not compatible with zoned RT device!");
> +			error = -EINVAL;
> +			goto out_filestream_unmount;
> +		}
> +
>  		if (xfs_globals.always_cow) {
>  			xfs_info(mp, "using DEBUG-only always_cow mode.");
>  			mp->m_always_cow = true;
> -- 
> 2.45.2
> 
> 
