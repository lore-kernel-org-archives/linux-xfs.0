Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684519;
	b=0cdOk2bB75mGAnPcgYnDlXijK+Qb4Z5bzvXcvOdn1E0rfj5UHaCOo6tT1QUGYhP2gH+7
	 00G+xxQgg5briVDOLofW+J2qY00fyWxD6JW+1U7+8JLoWzElo7/i9/Kk9QpzmaCtt2Igz
	 MhLJR4aI6Nl7sHtW3T/ULZbrqOu0Esh9avlLJT8+hDl/2fHFooVxd4B/A1k+4BwhpLMwP
	 VwmA1y+sWf3awrmFWKHhPrbN51AUxNzUuIlT+b8zrhPFf6tCVteB8hiQ+ubQwcuLc3UfE
	 5bxTltDcj5ka7qdXGHv6y1Sd8Wr6HqrYvC6q7fFsSXBRZVfi2pUle6thR0KOY5hNBFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684519;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=bQ8ajFT5xhILdB0dsRYEtZZRvSWnG4oIvX2mQOlC0CI=;
	b=Gbr2BRCLIinP2xc2kLrVO+qrWZx1Xrs1zclomEmz85OELmRlOH4lwzlvVgvXNyoFMlR3
	 gGeAHgMGDc+LL/uUmi/Y5HfFF1srs6Y6mdfi+/vwz80oGbBBx8CWS0XJfAgC+ZILlVi2z
	 JEv+2iLQLx1Thr6iCtjcgmJZRvpHyI4yDV8w0ch5tT1VxLsOWkAscCOc42fxjdBM4hoV2
	 CNXjeMA6T4ipGsJCRoSbw+7RSfze7G22oMocTdV4rlql6eqpnht0EikzHG4w5N7DB+gB3
	 GmtdzAtQFcDL0Q3ylGsGh+h46LwJxc765RmBX7vx9e+AcpOX6Cb5cOjpUQNcboPE/mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BB606A324;
	Tue,  3 Nov 2026 05:41:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E7BB606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3967B68AFE; Tue,  3 Nov 2026 06:41:55 +0100 (CET)
Date: Tue, 3 Nov 2026 06:41:55 +0100
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>,
	Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, exfat@lists.linux.dev,
	linux-mm@kvack.org, ntfs@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-efi@vger.kernel.org,
	linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org,
	stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 33/34] xfs: allow remounting read-only after a
 shutdown
Message-ID: <20261103054155.GB1559@lst.de>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org> <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
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
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-33-2f44f64f0b66@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Btw, if my previous reply wasn't clear:  please add the test for this
to xfstests where they actually get run regularly and not the kernel
selftests which for file systems are basically unused.

Bonus points for having generic tests instead of purely file system
specific ones.

