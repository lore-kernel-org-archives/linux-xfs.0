Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5969F47ECD3
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780582412; cv=none; b=vFcKr4XNBDhobbab1xSoUYlfRiqds+RzV3TBtRQ9GVxKZYNRk4wEIb2TX755QLf0He++nAFMxb+1AEaG3pcniKYmTU/7AlgrIdGqPclwFAv5UdXBgVGhC3VaV9hO6G5P1DbfSe83a5aZmiWsoFv7+QuulS4n+rNtJNZ7KGXTy7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780582412; c=relaxed/simple;
	bh=B02p6/09qqPAcx0PHu7NX4LGuZaS/3w0rjvmE5GCu+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZpMjK/GcztQZjxQRPgmIJb+licUKnRhpWlAeBFLn5jA6SbFAXm2UWdi8tUlJIw0WWrVIMGKyXchPD9vnXKwRO9FaBkckYgvoAdn+CYaGqkIJCMYVFQa4uqs/tcaXFiF3kC9dKXkNd34I+76YZiguKtSGjSBry9dhFSE8krcUog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vs+ag9ui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vs+ag9ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E60831F00893;
	Thu,  4 Jun 2026 14:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780582411;
	bh=uJZVNRZzPZmKz/1iBMmfhOM6Vcl9jXUzM/8g/fQLdVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vs+ag9uixucDjxq9GK6m6NtvWOStVZ6X082lOJx1MOy2QGInFhGDYA9QTihktzc0K
	 jbYyPYPHv5E8j+CLabG2E3yeAAVDkIgfPohvzWxgYZOwIm0Kx/qUcqoXtKJBIv6L5i
	 aTQkhEyvmkB6uUeTr5cf+ldX4ptCPT9WngU5elDAc66P7leXFFmCsaS+ChUN4YNw6I
	 zhUjpU8slW2uDQR+BRRzG39q+IEW0HJ4RPI5HNbkOC8UUHZzaOmIG0XF3TI7cnoMbt
	 y7O+obET2HxAUwCmT3NIjxnZ+1Tm+ZupqpD4FVDFw8CSPIoBirOY02epCxu7HRrmiI
	 0pMjpoPHThaSQ==
Date: Thu, 4 Jun 2026 16:13:27 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 15/21] xfs_scrub: don't return garbage value from
 bulkstat_the_rest
Message-ID: <aiGH9M3IOZLjnZlV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303383.2608728.572212891515924769.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303383.2608728.572212891515924769.stgit@frogsfrogsfrogs>

On 2026-06-03 23:08:14, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> bulkstat_the_rest returns an inode mask, but Codex noticed that we
> carelessly return an error number if we can't allocate a bulkstat
> request.  Fix this by returning 0, which forces the caller to singlestep
> the rest of the bulkstat array.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.14.0
> Fixes: 7ae92e1cb0aeeb ("xfs_scrub: try harder to fill the bulkstat array with bulkstat()")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
