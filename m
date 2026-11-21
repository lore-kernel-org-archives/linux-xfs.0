Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220791;
	b=vUOGHeoEZKdcmaQUUgMhSNCTSgCS6yE/aYl9Qyr/6IKFT8fHn3h5ldswJEFcCJd8LV2b
	 w5LKTUCUh0X8d9bS3x8EVH86ZI/2tNSPW5D3YHXyzI7vV9cZrTw3+V6uk8PIMWNAKvB+9
	 /dlgbqgTMIA1OUjF3eL5JRwv2dJhbKQG04B6jwnGGeY6uEfIGTGf3btkS4Tz4TKjBRep7
	 BE5oIw0q7iuLhnzflKm/X2Ret7QzFU2cwhr5ioESLkB0wuODPjqqO4mMgAkR4uZGYZr1Y
	 DFwnuJOpwBhZwZB5uVzh6GVdAZwOPHe7OizRF73l+zikbVYVvGV7SJ3GwXHSysrDRdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220791;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=AfL2TEYW1C6XR5/bDZFHdnOO72T6D8+VZynUayUo61QCFFghpPbok8P5MMVHKRbbRlQB
	 xhUrjnpRlKC3GbacqvNxMl+NEw+WgGdKENptYAqsHIwHqej6N8sGMztNlfMNbIpnWkKkZ
	 n103ZEcnmWk0XNgMKalQOTEmGuh/XcAdZ9XS3JBDcYj66/Zw4DnNtnUZPZV1XMtXk8Cjj
	 F/eZqLBG1FzP1Fq0m+zXTEHs377/63IP8dbh9gtxrj9cvJ9ATbd/qHAt6ftmQBWNMW8S2
	 mmu9tOZ5iu3fMm1sftTf+By8Q7XKE6LVLz/k3xOa9vwPKsdJChu27YBY9o8uGUXd8vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C314A60A2608;
	Sat, 21 Nov 2026 00:26:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C314A60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45D736732A; Sat, 21 Nov 2026 01:26:25 +0100 (CET)
Date: Sat, 21 Nov 2026 01:26:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	fsverity <fsverity@lists.linux.dev>,
	linux-xfs <linux-xfs@vger.kernel.org>,
	fsdevel <linux-fsdevel@vger.kernel.org>, david@fromorbit.com,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v19 07/15] xfs: add XFS_BMAPI_UNWRITTEN to unmap
 unwritten extents in __xfs_bunmapi()
Message-ID: <20261121002625.GC13395@lst.de>
References: <20261120155752.192025-1-aalbersh@kernel.org> <20261120155752.192025-8-aalbersh@kernel.org>
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
In-Reply-To: <20261120155752.192025-8-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

