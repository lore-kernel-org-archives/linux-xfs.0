Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CA32BE7CD
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 15:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780587039; cv=none; b=DwOAQm98Bp6CzW0TSsT9Ow4jz04rQk8IuvMmvh1X76LaBVMeUcVLl1aIegIQdGqxfUw93wj1z8tzpdOxNwPuirdZmhEmwLLByW6bWrTHHQafjKg22ZlWzEnEMP3aYgWs2LuRt6ql5RUFR4dhZGXhlUnGbgQMvZtan3QUqB9qURY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780587039; c=relaxed/simple;
	bh=NoVn71QBVCoeA+L73XCtviryEPLSCxlUKj1eZj/9bRs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QE+zRZD1llWz3IkOilSAtzYFN8IGrsC01uingQEo9Yo5ckgsCfbgF7MKSOMsvh4j3eYlm6YF8onVkRlOYk+lLtKSJUKonHKof5t4RthNvOBY4JglZZvtXCScOQOSV2n4LfNxbAiQs3epaWze83PXJtZwOfPYULAzTfeHO3Bo4xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MV37G3+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV37G3+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0362A1F00893;
	Thu,  4 Jun 2026 15:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780587038;
	bh=EDGzKVg+ZfUHleDbaX5rrOMtXlG9G6w17eRGReNjlMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MV37G3+diaCA6WsZTC0R3au9qP/pyoXWmddyBXVgm0Zhxv3c5a4zGvfr4h8RbOBYZ
	 0JvMn2guMSGdbfZGa6DPwqedyFX16aN3Dl79Qq8JA/56iSu4aSpeF3J4WvV7SSN9DM
	 /KqQTdIHP1XlCDbBl23umA1FU7/JdAaoqAUpRjzTgL4JBtHL27sza/GrWJ/FFaUp78
	 F9gmGsiAjROm68ALBD4cPvdz3LuG6DmIJclZn20UMMD1b6Gl78iIgfBmnIM6zJQYwx
	 yZvfjSGYazwFOSu4U5t5us1ZhC6SE8VPXyBXjpkcBhuXhubM4c+h3JZQO8tsXD1Np4
	 KoazlY96Y/DaA==
Date: Thu, 4 Jun 2026 17:30:34 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 20/21] xfs_scrub: bitmap iteration functions must retur
Message-ID: <aiGaDCJwXKWty_dI@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303476.2608728.8389975048890577690.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303476.2608728.8389975048890577690.stgit@frogsfrogsfrogs>

On 2026-06-03 23:09:31, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> bitmap_iterate doesn't generate its own errors, so don't invert the sign
> of the errors returned from retry_deferred_inode_range.  This keeps them
> all positive, which is something that Codex is good at noticing and I'm
> not. :P
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 5a30504f0c60e1 ("xfs_scrub: defer phase5 file scans if dirloop fails")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
