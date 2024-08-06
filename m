Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81A17AE00
	for <linux-xfs@vger.kernel.org>; Tue,  6 Aug 2024 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722952797; cv=none; b=csrfDKA0GN6BPUKLtl39B5lZ/CTEruXnpAcCXykZ9dN9FeDgFUBCmNJsRWzq/SMnGP7sJv3NXpJGJ9LD+QkklxoPtgN3n85nZoDUAmbPVn+DXRLmN3mPV8LhlcxldQfYPsTiJYoPgujlPW4OhiK654muYyrNVdiHaZIRLEVFYII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722952797; c=relaxed/simple;
	bh=ZYQWfEInD8nDyfTyGBpgjS3FsKxgA8SCjeKmcO7NZi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVf7d5U5TuhC3NE21DtoYC6sJ5UBP95qczmb0ZL0RsejO5A2YB5GPbiZZBmyR8W4PAw40quWp1Ee2UGbowaZ2ZN2UUaOvFbT+Ez2zBIcWHi8pLye7rJ+TRiD2sTev4GrrYyUllChkXi81plTYQzzN7HXnWOGPivPVOYHhnHNsq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M5L2lAcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M5L2lAcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11798C32786;
	Tue,  6 Aug 2024 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722952797;
	bh=ZYQWfEInD8nDyfTyGBpgjS3FsKxgA8SCjeKmcO7NZi4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5L2lAcSwzEYTgEJCocWdt/0kUSvBiIzPbHrGIWxwGvToq/Ph63/lHolaU2AQt7pS
	 Sx6T+oHNFml4N6knyHBHlE2n0QgoxFn8NpZzYb1ifEtIWiYyPGPlKraLUF4ygXoS0n
	 6qPoX6Z455yKIEDzTVut58iG8IzGV+PQvh8+NPw3SprMIltCgFcG0nQz6YJRBgBfbA
	 8hs+vCguvRnbm62A5GlKzSFd6xCgZbBUuJDNOgYObm/XUosMWYcL365sVMqaBaHZ3T
	 gPReZuKgc1zkn898DiMFFTTlGnGnDEktXGhMCQRvN9/OLIHR1fkbTRF/2cm/EjL0Vq
	 X/35cSUfduhBQ==
Date: Tue, 6 Aug 2024 15:59:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [GIT PULLBOMB] xfsprogs: catch us up to 6.10
Message-ID: <dl5cojkq6lwvcdlxpsmx6vrdu3yc2awrwz24qdih3prjpeh4hu@xkkj74xxcswj>
References: <Uf78QBB6F1nNL8oFhCHoo_tQTajG-YLJ8o4lwxOpZD_8bV0ML87407uMy0f-S58Y9aR3CQyEdUaB3QDUBPKjjg==@protonmail.internalid>
 <20240730013626.GF6352@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240730013626.GF6352@frogsfrogsfrogs>

On Mon, Jul 29, 2024 at 06:36:26PM GMT, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull these fully reviewed patchsets for xfsprogs 6.10.

All pulled, thanks!

Carlos

> 
> --D
> 
