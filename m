Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE5A47ECC7
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780580923; cv=none; b=RlUeJ1smWd1i/BlZhcVSwxbCtc8LilAuBtOD7uGJSYk+ek9OaiRcd0/pNO7qgKPp6cU4QImk6p+a+L7rMr9N1I8N431nNgmp8knQT3cjNE9y9nLNFydt53r3FMgM7ZTQFCvvC0CsAFFPKRwFEddPPqAAJT6+ryjSzC0gPCT9Ozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780580923; c=relaxed/simple;
	bh=EDqVbHkKfgG4QdejfyUElnKOT+wPZA5n+vrom0fWa0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iInYcFFqNhVovEIsxdOwNQH+rWZwmZDDXF2tybfRtjzHkJBSpI/MBEwlo8nfMb49Jw5lnnZLN4s3igqskOaCzX7RzB65lHsSg6csnWjwDjSBYQPeiTyzpl1X54fxw1BtuFnaIyQHWcqVvvCDeaTz7ktrZXbjBaZZjT82TFijVnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nqX7aGs2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nqX7aGs2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8A31F00893;
	Thu,  4 Jun 2026 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780580921;
	bh=+6x3fiZDLhscW4kXWFLW1Eaxzh/ewoN0GpyfD0ysUEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nqX7aGs2ergDeqtYKxYyptj6mgYLK7hA+XYpd5tUfHeTJUco6z2gYWFvEEclyigVt
	 oPbRW7lZvXgq17SDiSSsD7wByPmFAK8gGJatOBz4X5MyqJAPeMHCAkMaWMmq5t9t5/
	 H3Jx4ItV70QjXzrB10d1bRa/wl6r022LnplSuM4fS9HuYogJ9jNJy9W5KnO/Ci0KyG
	 ZX3fYNwgwTphyEWcb4NQGqtuc7TPJP+ZQgMoi/d4uWDyFwBzITn/HAhi4goQGw78XV
	 uP71jyrRgOtKUS3TdHI+8h8EVD5Ys3hFQBNO8jK3Gjds9Hb16q2e1qEI0gscJsPxeQ
	 wmHNIBwmcmlRA==
Date: Thu, 4 Jun 2026 15:48:36 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 09/21] xfs_scrub: fix work estimation for rtgroups
 filesystems
Message-ID: <aiGCIQFB_HkCbAm5@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303275.2608728.8921400065325146466.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303275.2608728.8921400065325146466.stgit@frogsfrogsfrogs>

On 2026-06-03 23:06:40, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed that phase2_func queues up scrub work items for every
> rtgroup in the system and tracks progress towards that number of work
> items, but that it doesn't include the rtgroups in the estimate.  This
> leads to the user-papercut of the progressbar quickly advancing to 100%
> and then wedging there for most of the rt metadata scan.  Let's fix this
> by amending the group estimator function.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.13.0
> Fixes: 241d915d69d4ae ("xfs_scrub: scrub realtime allocation group metadata")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
