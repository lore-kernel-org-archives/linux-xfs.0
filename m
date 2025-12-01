Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7CA28504F
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 09:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579713; cv=none; b=syQn0rIAUskb0/EdAnbUJ9xP884bCPwl4nawxqjXNsvpef0osZ+l80co6iMLXc/sceI1nz90QBmPS3hzrH4hppQuEDrbK2+u1XSzyqzLZKZ6hpXFIPOMYz4PMK411j1iANfMSUgt4D8RI9CI+forG514XB1b2gikTTeRt1Mor7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579713; c=relaxed/simple;
	bh=AG5Rp7BxK2LNBXJk+exneN8dM2EQCzIjoKINFTt5/hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5GWKio7xIVcFSqhz3XYv8T2DDe2HELwr6KIlAeNy89b0OziG7OiaSVhwgKBM3NMTCaW8JdLNFN8+usatDP8JOJUDMML1JUH5LF/IfJqqSm/iv7tbPDv5LjkacKY2xQCmSIt3x5kv84bwbrH6iF5BRGQKQoFmDB6uZ/jY5eq3V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZvkqfBOO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZvkqfBOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03C2C4CEF1;
	Mon,  1 Dec 2025 09:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764579713;
	bh=AG5Rp7BxK2LNBXJk+exneN8dM2EQCzIjoKINFTt5/hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZvkqfBOOhXwsfT45/OSIyANBUdtg0kq19soH8pwZjBqCWbiF7J6tmRjfjJ8KqJUKC
	 BUsqD8Bf8/9Fw6qHtYWJ/rWzBaJYuEUYtvdTBYLUH244I1v5un+JIwTLl7nij7ZQ+r
	 3021Jc46JTHfgJ/d/DF7BXajJiUS/xcUa9ekNzaF0NKQfZ6r1HvMGmHRLGcuQpL6Ee
	 tAgmcfLdkD2cdhhgQ48H5rWjgkajlmWRjgfcycjDW6/jrlE1N2zJzUgGr55aLHqurJ
	 5pPPYsQaLfkoW0laAdX281LLxrWhQeN4gADsK67cnZTOHlMW+sU/Kzn/622+TU38vA
	 RJNvmkpVaeGmA==
Date: Mon, 1 Dec 2025 10:01:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] repair: enhance process_dinode_metafile
Message-ID: <nlp7ehyymh44zkdr4h5fg5l4vruun5wwz6q3y6lytzxa33tx3h@6i3mwalslghj>
References: <20251128063719.1495736-1-hch@lst.de>
 <FocUxB56pg--lstcef8fdjrK3tXU6Zpiq7PPbxOAEXYZ8ffiPGJUVWzjDosLu2WcNrdFBQKwUHSfbfrsunWl1A==@protonmail.internalid>
 <20251128063719.1495736-5-hch@lst.de>
 <e5ldi3iunbxl4buq7v6cotylxfd22uhdq2lf2pldyrm55b2ou3@7sq2uv5u7v2o>
 <kb_UeGGutlGPTf7Ij8KzobR5U9gb1xiS_3vxMF_zM6COd67u1k-mVv8_7x7pBLzvaVtxQf-VZux0F2fJBNVZqQ==@protonmail.internalid>
 <20251201062349.GC19310@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201062349.GC19310@lst.de>

On Mon, Dec 01, 2025 at 07:23:49AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 28, 2025 at 09:15:34AM +0100, Carlos Maiolino wrote:
> > 		Perhaps worth adding an assertion to catch a pre-metadir
> > 		reaching here for whatever reason and zapping RT
> > 		bitmap and summary?
> 
> inodes with the metafile flag on non-metadir file systems are caught
> by the inode buffer verifier.

I see, thanks for the info!
