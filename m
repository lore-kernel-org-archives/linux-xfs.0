Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26DD4A2F
	for <linux-xfs@vger.kernel.org>; Thu, 21 Mar 2024 21:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711057144; cv=none; b=NX0vMx7mJHvJqbX5MqMwHWEr7y7vLY6lzLxxvSuYpNdDRW6PYRuWdczg3yuPUYazRAcro96a85NrIu324MZ27z/QWdaeQafE+SM8ZvEHAcCKo8DqLPFpwt5Xv3DEFzxzR6JVuYfTukNshT0rsiS1pkFy4Kkg/1LvtMceWpSnO3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711057144; c=relaxed/simple;
	bh=sqpj6ijDBBGdXBbuk+uaPbY91PQ1CytYpk+ae9Atp5c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nMc2FGX2M+uyAU1jOz3I6h2VCpdRU/Hf0MLDAwNYvbaICFgFVCCtwmSgeOsNctrd4AsLtjjoYQGtHiKJYaehirQBWL1UMWxw3oiMamv0FG/xynA68J9mARopL5wm3Xbp1u+uoOXzEZFguBYmaJyCY4TEKuXjgC1XQvuGDSwbhCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mDxfLqnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mDxfLqnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4519EC433F1;
	Thu, 21 Mar 2024 21:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711057144;
	bh=sqpj6ijDBBGdXBbuk+uaPbY91PQ1CytYpk+ae9Atp5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mDxfLqnSlMDnYDPcJybGcdQfy9X9JdSIfZkuTGokWzwjNYjU+y1zgRxrtAO8j5x6o
	 +Wf3AjN0j/Zc7r6ujc29hXdr8p2OmGmIMCkWkDxqWPEI0eR8gUOvAWJBJIcq5+t611
	 EZZ6cIQfXxv4OtaesNrZfSHSAxDN5cGuh4QMawpaWU4yP6jAW2/qiXUyFuEgYgK21T
	 YkU8WK9r2FLLASe5SOdMrgELxWD+oGsgGSZeB7GnwjFARFa3hbuQ2kf/4eUfJDVcZy
	 LXX50UaDCo4QEBMjplJk7ukwNs9mp0yBKwJmOUBZePlzOUk/9CyKayBNJ63BxbeGKl
	 ZO89edsjASozw==
Date: Thu, 21 Mar 2024 14:39:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <20240321213903.GL6226@frogsfrogsfrogs>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
 <ZfoGh53HyJuZ_2EG@infradead.org>
 <20240321021236.GA1927156@frogsfrogsfrogs>
 <20240321024005.GB1927156@frogsfrogsfrogs>
 <ZfymdyLxJ_-GkFji@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfymdyLxJ_-GkFji@infradead.org>

On Thu, Mar 21, 2024 at 02:28:23PM -0700, Christoph Hellwig wrote:
> On Wed, Mar 20, 2024 at 07:40:05PM -0700, Darrick J. Wong wrote:
> > > Well xfs_verity.c could just zlib/zstd/whatever compress the contents
> > > and see if that helps.  We only need a ~2% compression to shrink to a
> > > single 4k block, a ~1% reduction for 64k blocks, or a 6% reduction for
> > > 1k blocks.
> > 
> > ...or we just turn off the attr remote header for XFS_ATTR_VERITY merkle
> > tree block values and XOR i_ino, merkle_pos, and the fs uuid into the
> > first 32 bytes.
> 
> That does sound much better than wasting the space or crazy compression
> schemes.

It turns out that merkle tree blocks are nearly "random" data, which
means that my experiments with creating fsverity files and trying to
compress merkle tree blocks actually made it *bigger*.  No zlib for us!

--D
