Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18428239E9A
	for <linux-xfs@vger.kernel.org>; Wed, 15 Apr 2026 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278458; cv=none; b=Ifzuv27CpmbG+qhD+pb56Fu6eYFuqsVJG16cVwB8e4uJ+hQ70mIN0FIWi3E7bPxorp1tA32oBbiFxVviojAIlauJHXhLTwpY6Y7HO9A7yW29xaSsk64VzPS1mdVdHeavsiYV3Kq3xpSOyk6X3I2G7FMmAF5TMuJrxbuAokV0jP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278458; c=relaxed/simple;
	bh=DhJxDlS2adM22bOMVgQOYd/rHmTdy0MedmhTWUg+DgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JcAg15sHDgzazO1SuvufAk3Yfl+LBWD0zBCWd1cyXc3+tf+2LG2OXk4gnYkx9E0kFrCfeIXNMj2hbfxaoe0/6c/9zayuCylO4zxMvhFXBjA39s/04t8ZIE8h2YkgQbcipTISmrdxEFKxP3UKZ72NsS4ThAJiUMVA8d7kgI8pYN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gTR6eHtQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gTR6eHtQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB00DC19424;
	Wed, 15 Apr 2026 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278457;
	bh=DhJxDlS2adM22bOMVgQOYd/rHmTdy0MedmhTWUg+DgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gTR6eHtQ5LTQAc3aJ+Y94FbG2kXihg3P4fhrZaS0nGVxwPVwmGL+Se5xH195iQ9My
	 c7SirSbGfyeW2iHKK4GwJahyfsFigxIuiH0RSh8GQKxgf+2bxIRRY3tpfLyJLSNgu1
	 u4gzUzDD11DHhqMmcd2Ne3lBZVkpVfTXFbUvKh40CiIdCJLmHO9e3FzC3JALOePuhD
	 GMwuHjA0TuYlSW+9VaJhAdEL1Q+we0W+w54h9se4qbd8RMmm7ERaDAVelO5ouS1/AC
	 plNLr3pS1rUtS+S8S4ggex+c1X2iz/gpJDBQzr1R8f4HqL7EStgDzJ6g75NzXsDvkG
	 fQO7Nnb3Ry0cA==
Date: Wed, 15 Apr 2026 20:40:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: Should we hook up sashiko.dev?
Message-ID: <ad_axvVel2tpEcLq@nidhogg.toxiclabs.cc>
References: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87c6dc3d-ed23-4ae9-8309-0782ffd9b191@sandeen.net>

On Wed, Apr 15, 2026 at 11:49:50AM -0500, Eric Sandeen wrote:
> Hi all - 
> 
> "Sashiko is an agentic Linux kernel code review system. It monitors public mailing lists to thoroughly evaluate proposed Linux kernel changes. The system acts like a team of specialized reviewers covering domains from high-level architecture verification and security audits to low-level resource management and concurrency analysis."
> 
> This is something built by Chris Mason and others, with Google providing the LLM and tokens.
> 
> The website sashiko.dev shows these review results for mailing lists it is subscribed to, so you can browse around and see how it works. I've heard reasonably positive feedback from some who've used it already.
> 
> We could send a PR to request adding linux-xfs, and I think we should try it.
> 
> However, if you look at the config, for example for linux-ext4:
> https://github.com/sashiko-dev/sashiko/commit/d921c59
> 
> there are options to:
> 
> 1) reply back to the patch other (or not), and
> 2) automatically cc: one more more people on every review if desired
> 
> so before single-handedly making this decision for every future patch author
> and/or possible cc: individuals, what do we think?
> 
> (One can drive Sashiko from the command line, too, with or without the list
> subscription mentioned above, see the github repo for details.)
> 
> Oh, and I guess we could add xfs-specific review prompts, too, see
> https://github.com/masoncl/review-prompts/blob/main/kernel/subsystem/btrfs.md
> for example. EXT4, OTOH, does not have this. (and the btrfs prompt looks quite
> limited right now.) Maybe we could distill the xfs documentation into prompts...
> but I'm getting ahead of myself now.
> 

I think it's a fair idea. I've been talking with Mason about it and it's
on my todo list pile to look into it for a while, but I didn't come to
that yet. I have an initial concern on who will be reviewing its output,
but I didn't really put any thoughts about it yet.

> Thanks,
> -Eric
> 
