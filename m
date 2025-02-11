Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC671F03E2
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 08:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739263479; cv=none; b=NQqd7KVxW6Z4OMXSX9YEfPvGgr35oaSJerQ89oweHuXZevNYNBvRZmwQYp1SY18x8V105LoQcx5/98qGIjEO8gnIqdGQ8PATeW+O5rnEQDn9/4Bcitde6ZaiHlxwdDEDZ4CT7AkMbYclCgeW/WhNF+In0lnSeX2ogUVbpjSZJs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739263479; c=relaxed/simple;
	bh=WvnNFAlOw9BPumajaF89Sey0lak0pDAQKTO9ycmyWes=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=BOu/vjoP3CaZAly+A92eXnueONpK7PO+ZP1ma8FB5FBL/r2WJxdJpY3hROEVlYfY5g8YhCi3MiYWYFG9Ps0XXhjJZjrZIW55aTABgMUJN6iuYdhYXkEzwxFoUfw5UNlFwlN7Bfl5o/GYmx6G8IJy1bnSB6lyk5MY22yfnZmntjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nJmz5eOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJmz5eOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04B4C4CEE7;
	Tue, 11 Feb 2025 08:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739263479;
	bh=WvnNFAlOw9BPumajaF89Sey0lak0pDAQKTO9ycmyWes=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=nJmz5eOUQ/ieLYGAYkUGXAPOH9Ig6xMwfUnjdS3F5wFOHKFrRiUpff/+iD9LpVZsf
	 PNDj4moPD68rH2Kmv9MbfWWXVGzO7aoaOFu0APL42Xiinj6vOGHtc9QRnc3JgIEpGg
	 Oflf08neev8xoDQZnPBUP7bpggsDCE1sYsqewOT9EwHUYdHc0I88sWFmX79y/0diE5
	 sfFZZSkhRz1V529CcoqUgZ39t8LaKOhaQ52SGw0NQlOrS82Nl3LSDXMLvUaN+wmqvD
	 6jJAm9p5IJzbzKkdac5N1n+vv8Z+kCMvcxMVYnGwCWi37OXyxR1cYSVXBsp8Uqiny+
	 Ru5I8Tc7eASGg==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
 Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@kernel.org>, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20250206061507.2320090-2-hch@lst.de>
References: <20250206061507.2320090-1-hch@lst.de>
 <20250206061507.2320090-2-hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-Id: <173926347746.43797.1592734883868328782.b4-ty@kernel.org>
Date: Tue, 11 Feb 2025 09:44:37 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Thu, 06 Feb 2025 07:15:00 +0100, Christoph Hellwig wrote:
> Fix the brand new xfstest that tries to swapon on a recently unshared
> file and use the chance to document the other bit of magic in this
> function.
> 
> The big comment is taken from a mailinglist post by Dave Chinner.
> 
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: flush inodegc before swapon
      commit: 35010cc72acc468c98962f1056480a0a363eb1c3
[2/2] xfs: rename xfs_iomap_swapfile_activate to xfs_vm_swap_activate
      commit: 6f7ce473cca4952e4ac673f0fdf6dad2fac40324

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

