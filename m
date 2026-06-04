Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F2A13B293
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575389; cv=none; b=JxUC8yBxejJBX4h9i75dalpiXn1IyTyJ04BhNORb9W6ogeNY/FINtQ9xX8yKwPEH2WOl8ddtJBGeus0RlzG8Rauq+fEDNnoIZuyW/2TxZkyxlRpuh3vEUhoenSsojc93IaceD3ncISlOSxZtyBMelMAKV1eF9j0BE0E3NWzfbXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575389; c=relaxed/simple;
	bh=6yMCaB3qu4i+zxxs7xcgMNDHinWZTFvrYH+drkDDDso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3idU0N2eJ1+fNmsm21CrX9Xcxr51SX806m9ArG48DVGazez+9T6U2IBTjUq2TEC+73luAj19CNIuYa3apEnMiqLt9fMRk4acWeWeVwhJYeatsuvHGJM+1J/d3vQzy/B13jYD3Gx5GHrp2TrfmzTsGkMUef9fcx0xBB+1NEtZtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fVcgwRJo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fVcgwRJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F441F00893;
	Thu,  4 Jun 2026 12:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575388;
	bh=yxN1/7Qm28U1hjwnRmtZ2va+TdjsK/BVgorD65Xc1mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fVcgwRJocjJcMQ6AQq6J4uJRnpPOdAFTUyDBs8QF3DPgugElsNpp6ARGLGKh5wssY
	 RLeWEe2Pno7uhGUCFduHcv4zSlMA7e8CErozZRCkI18aoy1EDdT8QaM+/0cEdrESkE
	 ZcwTZ4rCyZD+LhbpIe/XDwPDUOzlr6a9kKCj9oZ9ILjK0rPNUNE89axyfYFxT02PVv
	 MZ3Rsx4ePK1vBTuOKdFYdOMgtiuTqr7SXDXmLW0RDKWmXO8eo5OhLCGg5uDbG7CK1c
	 +sfT9bfnmKBnB5SCzuAy67eolgIEfyYglD3N+ALQdJkMsWBXuE4laEL8xIMF6GRjDd
	 797l/7fh0MvXA==
Date: Thu, 4 Jun 2026 14:16:24 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/21] xfs_scrub_media_fail: reduce security lockdowns to
 avoid postfix problems
Message-ID: <aiFj_pIHg7SsGPqV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303127.2608728.13759559996989386020.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303127.2608728.13759559996989386020.stgit@frogsfrogsfrogs>

On 2026-06-03 23:04:36, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The same lockdown logic of commit 9042fcc08eed6a ("xfs_scrub_fail:
> tighten up the security on the background systemd service") was applied
> to the media scan failure reporting service.  Therefore, it's also
> broken on systems that have setgid mailer programs (e.g. postfix).
> Fix this by applying the same change from commit 15fd6fc686d5ce here
> too.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.17.0
> Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")

Fixes: 45ec29cfba02 ("xfs_scrub_all: support metadata+media scans of all filesystems")
This one, no?

Otherwise looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
