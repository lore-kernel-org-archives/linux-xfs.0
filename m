Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED2D19BBA
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728953392; cv=none; b=DvLr1uojzItWZCBXiK/jcxVzoUFmjJWyntVtCNIAVHM2LLzs7eYTuxJ9S+ozwmpjcAQ2d6cHIE6JCR25gExqtaGDdxG37+Jk8SX35BlI+N7QddIEdNP5ujTGu4QkILMFlMh96CBZhs5kdwoTj+wSDKC/RyQl3FEaqNyU1AE5lb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728953392; c=relaxed/simple;
	bh=oouUP83ooSYZkV2U4WQlRxftU6dBbKeSLznbkGTjvQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cqKypvOlhzZgYtcCA//N+mjTKQ+p4qL9PeKNatzhFsTCdqnsYZU+6tlqfZkgFX5JnUT7KiKOAHCzkM5YqLNMFdty3PB0sJI/g2Y0nGV3pEWSgFrwHrZQqYRsp3MHwbhe86L5oydHkJS8t3Ng5WVL/Z0gAb5ch0CNObvEwPjoK3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqqezQ4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqqezQ4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDCAC4CEC3;
	Tue, 15 Oct 2024 00:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728953391;
	bh=oouUP83ooSYZkV2U4WQlRxftU6dBbKeSLznbkGTjvQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DqqezQ4o7V75bSTqtJgjNHphZY5rjSCbe+CUx7NH16DY3y3hxclWU7xXpJ/nwWsZ2
	 7z2+DqaW4w9ZmHw6mbbkwI1cuLKI78KmSjU1gHQ6EaE8pXcbF6ei4u3tZVzQ1cSvBo
	 HqeH08LwQlkQy3SOI/36zPs0AtonM4c0E+7FaezojrybBlYjwasdUgZBcIVAu3DjBA
	 4fyEtEjeW8Ky8001eWYcDn4dMybv78v5JebLL5wHPi/pmlC9FPntbzR+S6XzU2hf1L
	 QHs8lViX9QQjJhSq5egm4tmVodf9NKrroQTiLmjE6X4gRunIp0UR2Dy/jWAfGr6VU1
	 EYQDP9T3YFQ1A==
Date: Mon, 14 Oct 2024 17:49:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/6] xfs: advertise realtime quota support in the xqm
 stat files
Message-ID: <20241015004951.GN21853@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645712.4180109.12939301427402294508.stgit@frogsfrogsfrogs>
 <ZwzVahNfQbJywQjF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzVahNfQbJywQjF@infradead.org>

On Mon, Oct 14, 2024 at 01:25:14AM -0700, Christoph Hellwig wrote:
> > +#ifdef CONFIG_XFS_RT
> > +		   1
> > +#else
> > +		   0
> > +#endif
> 
> This should use IS_ENABLED()

Done.

static int xqm_proc_show(struct seq_file *m, void *v)
{
	/* maximum; incore; ratio free to inuse; freelist; rtquota */
	seq_printf(m, "%d\t%d\t%d\t%u\t%u\n",
		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT),
		   0, counter_val(xfsstats.xs_stats, XFSSTAT_END_XQMSTAT + 1),
		   IS_ENABLED(CONFIG_XFS_RT));
	return 0;
}

Thanks to your other patch adding IS_ENABLED to xfs_alloc.c that got
merged in -rc3, I had to port that to userspace, so now I actually know
what that macro /really/ does. ;)

--D
