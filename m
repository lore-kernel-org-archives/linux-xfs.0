Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VoWzEhCw"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6790110CA
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 09:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FU8n5YMzCbYfDxVHkzpRrA7kTxP/WmwL3/8i2fSt/dQ=; b=VoWzEhCwc2gC4WxsSmToo/mzgM
	1ocFsE1aDwNx0WJEyPU5QRz5g4q2qzCNoWEUY4Z+7vdE7CSx2XRYMuq5aRS02uUbxzl90ARXAvB9C
	n4YvtEKlXBT+/vrHnAAtiwHAziN+iOsX2Xq+xT+guHX2KPid9cx4mBdlJD7klOA0x4VZUXpBOxASQ
	1kCdW4IEsyxs4cAvye0rcPWlJH9ocZDNRhtUoz+Cu0pJCE1WLL8YjNg2qGiVIOxQqj1DoR+ZuyEid
	6/H8k3e/Lywva6rk4s7wMNv4ym+zo+l9kMl8ETzUZc17ksekhl7ZeLvWM1oj6Qaj6X9ESF5JnownO
	HSpbWKNQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r81aI-005tZt-0t;
	Tue, 28 Nov 2023 17:09:18 +0000
Date: Tue, 28 Nov 2023 09:09:18 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] libxfs: don't UAF a requeued EFI
Message-ID: <ZWYevgmlkkzhJtOH@infradead.org>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
 <170069441966.1865809.4282467818590298794.stgit@frogsfrogsfrogs>
 <ZV7zCVxzEnufP53Q@infradead.org>
 <20231127181024.GA2766956@frogsfrogsfrogs>
 <ZWV8izIb2XTOc9dJ@infradead.org>
 <20231128170121.GX2766956@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231128170121.GX2766956@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Nov 28, 2023 at 09:01:21AM -0800, Darrick J. Wong wrote:
> Oh!  You're talking about moving xfs_rmap_update_defer_type and the
> functions it points to into xfs_rmap.c, then?

Yes.

> Hmm.  I just moved
> ->iop_recover into xfs_defer_op_type, let me send an RFC for that.
> 
> (You and I might have hit critical mass for log item cleanups... ;))

Yeah..

