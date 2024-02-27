Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586474EB4E
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 18:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057951; cv=none; b=Rk5C8gM56bOc9IhfBFtKkBk5goEUFu5JPercUgsMk6bVD4J+GTzmHaDj/wYHqnJMSmS7Bb36cWCOcKfJSq69h2VLfRXDYwG64Oz2gMlo5BWicX8frqHnNhN18pomizXpMeLsdyJcOvsHZYVDmBJcGNLYHqqWge6+6Z0wg4aCSeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057951; c=relaxed/simple;
	bh=VyYcUGaFOQItVVZV2LxagKFh8VrJ6FLhrUiMzuxY0Q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjRa2Ntxd4I/yYnrC+wK4oj8uRendue7qSxM/hmiE+SMjo0T5uTDBJt6YMSTEzOyd7wIUwlFJekR7TewWmLbDgldHR2we5vLk72JUhkOTPy11ONKxfrtYDeatOnhq+fDDVxJraiMst9akm+IZnTl3VjJbQQ7du66Qf5oLcprVj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRdAPpdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRdAPpdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1529C433F1;
	Tue, 27 Feb 2024 18:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709057950;
	bh=VyYcUGaFOQItVVZV2LxagKFh8VrJ6FLhrUiMzuxY0Q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lRdAPpdkx+tpxL1/HplaeriV485Llx3yMw1ApxNJNxhlptolyDB5WAxVRHvhUguV5
	 2/iFCfdGTtRnrOXmJa/XleP/ca9IqeUM8RmOFpD0StjlioyIVwDEs/O40G2Ra0wcS5
	 9QP64nSMxy5F5fL7JrRYJSLyusths8qIelUG6Vcs20uqeZELK1bWcfrQtVuPuXOwhU
	 a+PSkiNfLGERRxgbyKSt/ovN2fdOXn3TsHie8vtCNiC7JF3S/YEbY6LUgCa3y7fi4Z
	 Y/QzmEQhVyWExMUfO3CiLAHkFyZfYLv5kTBdbhV3PFoebX8uCJ4n8lBMhs2Mi0PnJS
	 jPmBnHIRxih+w==
Date: Tue, 27 Feb 2024 10:19:10 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: only add log incompat features with explicit
 permission
Message-ID: <20240227181910.GY616564@frogsfrogsfrogs>
References: <170900010739.937966.5871198955451070108.stgit@frogsfrogsfrogs>
 <170900010779.937966.9414612497822598030.stgit@frogsfrogsfrogs>
 <Zd4lUAcj2zSX74R7@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd4lUAcj2zSX74R7@infradead.org>

On Tue, Feb 27, 2024 at 10:09:20AM -0800, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> (although the CAP_SYS_ADMIN override is a bit odd if we explicitly
> asked to not do automagic feature upgrades)

Wellll... it's 'add_log_feat' (allow adding log features) or
"noadd_log_feat" (stop allowing adding log features).  There's no
setting for "don't allow, even for sysadmins".

I could turn it into a stringly typed option "log_feat={allow,forbid}"
but yuck. ;)

--D
