Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AF881724;
	Wed, 20 May 2026 19:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779304042; cv=none; b=l3VFQGDqP8uwB4NDI/kQMd7SI7T30N+oN6QtfE+oAEhf2wQ6AMTz08natDH5A0tADddN3C+/Mb2Qd+B4/tkOcCrPtK2KPlLg8mslSZ8K8F8KetMbbV88kyEbfzRZ5OWhlx21nIdDlaMYs6dwIqL/jo1svBUaBm9j7hR06WvEmJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779304042; c=relaxed/simple;
	bh=w13NPPgdfG2sQ24gdIRbEaqnI4X0VH5g3sga/D7rTgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0EiI+Itd+EYzhFYPliXqZh2wtxEWLnyN0yiLB4Hbtohn1wTsenZp2V+qp0q/0cfV4xXuhXNYKNiw+3gllHHNX37kUzxdy9F6S32p6j36pUf+9GRKopT6/WeS+u8B5QM3ytW9pSRnjHowie8TmVs7nTAjbV0vu8AWtP+DTby38E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VNWkxPBa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VNWkxPBa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B33DA1F000E9;
	Wed, 20 May 2026 19:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779304041;
	bh=TuPPbPM8zpAe4QryA/1tthxBDo9k7tG+N3NSiznpDNI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VNWkxPBavgvYKU9722kNE74XIMhBMVW+G4jyKQJ0nm7VoG+oe3Wf7Bdz8zwHUOCsp
	 BUUK0HGdj/G1ZfTfgY31uAmqaBCMaKDYXRUczZgX0F/7glO62VhDb+Pp0rRP8Ntxss
	 tx7P4nXzdrCw1EIoPvQtbkvhOmZS3hCJ1flylpqcUBMtxxa7G0bs94xeTsu+FGT1j4
	 P+04tUdFUJMWGgONqolYkbzqUDNPi76D6j51YQ/9bOu97Hkmm6DDbHVhKX6aLnI0eH
	 RY5naeBLVTgeqqoPZPRfvlV4WzL/6vOsZlInhn3QKirVl3Us58ghxELQEZKDlfHpj0
	 oQpMazXCUUQGQ==
Date: Wed, 20 May 2026 19:07:19 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	djwong@kernel.org, Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v10 03/22] ovl: use core fsverity ensure info interface
Message-ID: <20260520190719.GB3424023@google.com>
References: <20260520123722.405752-1-aalbersh@kernel.org>
 <20260520123722.405752-4-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520123722.405752-4-aalbersh@kernel.org>

On Wed, May 20, 2026 at 02:37:01PM +0200, Andrey Albershteyn wrote:
> fsverity now exposes fsverity_ensure_verity_info() which could be used
> instead of opening file to ensure that fsverity info is loaded and
> attached to inode.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Acked-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/util.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

I'm still confused by the new implementation of fsverity_active() that
got introduced by "fsverity: use a hashtable to find the fsverity_info",
though.  I should have caught this during review of that commit.  For
one its comment is outdated, but also the memory barrier seems to be
specific to the fsverity_get_info() caller and probably should be moved
to there.  Anyway, that's not directly related to this patch.

- Eric
