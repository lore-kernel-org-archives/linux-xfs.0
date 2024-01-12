Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F1664AAA;
	Fri, 12 Jan 2024 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9A6EF68CFE; Fri, 12 Jan 2024 15:14:10 +0100 (CET)
Date: Fri, 12 Jan 2024 15:14:10 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: add a _scratch_require_xfs_scrub helper
Message-ID: <20240112141410.GB5876@lst.de>
References: <20240112050833.2255899-1-hch@lst.de> <20240112050833.2255899-3-hch@lst.de> <20240112133205.yvdeh27in7l4qzu2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240112133205.yvdeh27in7l4qzu2@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jan 12, 2024 at 09:32:05PM +0800, Zorro Lang wrote:
> Usually we name a require helper as _require_xxxxxxxx, you can find that
> by running `grep -rsn scratch_require common/` and `grep -rsn require_scratch common/`.
> 
> So better to change this name to _require_scratch_xfs_scrub. That's a simple
> change, I can help to change that when I merge this patchset.

Fine with me.  I just took the name that Darrick suggested.

