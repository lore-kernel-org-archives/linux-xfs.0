Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960832;
	b=3LVmiPOOzoF7ckSoD0ztrXjCMw0mm3SqvZtH6d9FdgKXqN7utj76rRYfgljoHhJS31F5
	 nqVDGdEBzFR8z/uIvlwt9L+MMwa8XfpO4ttOj1XP+IPGRmUKbap5B/6KbFnZXpsXxA8WZ
	 b4PrzUbNqIsPD+V9+C1Z6ZVwc8LHBRxHlpcDJ5ClYMRi1JCGzQ6K57S+clVI42voyw9/m
	 +2bG4jyq6rOmFSesiof7n+4BRM3rtj7FBaLW3eZt0nS0dlA24foMY6XtI6Tg8q1inHazn
	 DM7NXL0l4hIRJQdHWVf7xQDvFODHFO1ZqsUIG7permodh9QD41mcDL8bepyk56xxkVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960832;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=uUSBwlsbVQFIEkq9ZQBP7nJMyl1j+nQkn0jSD61gG5+fVSSq7g4W6WfHQF3XLGFLG5wH
	 hjmFFfUTFzNoHEzbra0JWSNC0iQFJTr2ZBLUXWt4LdL2w0j1qw4rH4QMxkVo2nFNu08yq
	 m7xN1YoeLX4uXStUx7wcR24SmqWvGZvvSpJPUme7BL5+USANXf318YExItvq3HgRg7rFZ
	 f+bh4Cdb1bvNUAPX2q2outckVMRYtsnwfLx2+tirTwdvabcBZB18hfPCNribuPgcWxOoR
	 bF5NvlXauqRNGNxiopOCUvEGuPqQgQCO1oMYz40+b4oSICfeT4arwVUmORLw0Fel+Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D2A606A32E;
	Fri,  6 Nov 2026 10:27:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9D2A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6C90068BEB; Fri,  6 Nov 2026 11:27:08 +0100 (CET)
Date: Fri, 6 Nov 2026 11:27:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: ebiggers@kernel.org, hch@lst.de, fsverity@lists.linux.dev,
	dsterba@suse.com, linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	brauner@kernel.org, viro@zeniv.linux.org.uk, jaegeuk@kernel.org,
	chao@kernel.org, tytso@mit.edu
Subject: Re: [PATCH v2 4/5] ext4: use I_VERITY_BUILDING instead of private
 flags
Message-ID: <20261106102708.GD5319@lst.de>
References: <20261105115532.613467-1-aalbersh@kernel.org> <20261105115532.613467-5-aalbersh@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105115532.613467-5-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

