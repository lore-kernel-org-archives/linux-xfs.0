Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D30079F6
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZB1T8lTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35C0C433C8;
	Wed, 29 Nov 2023 06:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701239205;
	bh=2DuOjC0uf6IF9AaYn//BpwiKKO1mWaM/li6f5ZTunv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZB1T8lTZaGVy7YqCaJWwuT4Y8N8qT+kIT+FawFhxz9q85jDvejylYL/lQzkb9yjDG
	 /fm8xkjDur9S9xhVJopgF4BZ+CnMjULwfOFoZinpfrKx7N0TVm+nriOI0OS6FD68wZ
	 R+kEmmMZxvRNfGrueda2oe/ivY2ToerlvN8erNa9v0bLtNlnmKBm0lk0wwiTEhnPnD
	 tiAO5mZz4F7TARvyLfuSdJH43H+yl7SKhyo3Kz+5+FZZaMiHscsPNbNSRAdO8xeGHj
	 IXYqnyQp9h53k4fbLwNzKDL19g9tKTOr6/9GbG8d3ZeHaCyADlLyhSFSHZ+LjyJJ6M
	 cl3sxPcW1M+5A==
Date: Tue, 28 Nov 2023 22:26:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <20231129062645.GT36211@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWYDASlIqLQvk9Wh@infradead.org>
 <20231128211358.GB4167244@frogsfrogsfrogs>
 <ZWbSq7591xG1I+SQ@infradead.org>
 <20231129061819.GA361584@frogsfrogsfrogs>
 <ZWbZOiowP5CVL2KX@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbZOiowP5CVL2KX@infradead.org>

On Tue, Nov 28, 2023 at 10:24:58PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 10:18:19PM -0800, Darrick J. Wong wrote:
> > The gaps (aka the new freespace records) are stashed in the free_records
> > xfarray.  Next, some of the @free_records are diverted to the newbt
> > reservation and used to format new btree blocks.
> > 
> > I hope that makes things clearer?
> 
> Yes.  Can you add this to the code as a comment?

Will do.

--D
