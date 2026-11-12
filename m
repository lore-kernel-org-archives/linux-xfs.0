Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794527405;
	b=jlxhb1b3KM/hJEesGtgIeVqfhK49O+0RxcoSpU23ptr7x4wE0CRScXhQ68KLIW5b2FUw
	 16wfi36vo7P7iZCW92wQVHyUZl9ogCQn6VOyFiAWDVvNqVOliQ65uk3WDr4uhlPdezhnz
	 mkACUTED8WRgEB6kET37OTAVMgHWzmRitH4enPDk7lKGyNme2UiYO6/aR0DIKVb2Lfdtq
	 5lIF6hR+g74pcGDr/OOHpEJIwzIcTAB8fj2Bl2rioxjCiflyPo2WeZz4z6xxurLv/sdqQ
	 2cOfxKtsci35LfRN2lfDbX6giNqCeqEDwvVm8heZT79r8tJ9KM5YP6pYItN+B027oZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794527405;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=DYL9F9Xf20wtm1YT3AZWVUNgFIn6OkZgpCx2j4cV6Jk=;
	b=rUsnZIkvluHmRdVTjw8o/sSDe/XrVax+eDpWinGjKQP4PswCXYvJmiIhRV38S7ZVooOQ
	 NuGyzGe9MrrjpFTFEy0fQXGiSO+DjU4jxA3OGkS3Hq6hZI/6wm17j+1Kk497QGTAZsGs1
	 Ccp/CHXEYslEVZS2AvWe9G3Tz+zeIU/RiTGhBq833sHlK/QiQ2jiZxmdDZE/quczINY29
	 PAl/JMD90/JJaiuPCqFW+d9FPpMZTaaTAn/Ct2KIxLsWqPGr7uWEcgCQcmyCzfDz4c0/k
	 IV4gzdA1XkJgDaLf219/Fgm+/UVYt6bfqOWlFt/8/vYzIF1NfSDMolXtPu1gYtg/9qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B55606A321;
	Thu, 12 Nov 2026 23:50:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81B55606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0F9386732A; Fri, 13 Nov 2026 00:50:00 +0100 (CET)
Date: Fri, 13 Nov 2026 00:49:59 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chris Mason <mason@kernel.org>
Cc: tytso@mit.edu, cem@kernel.org, david@fromorbit.com, jack@suse.cz,
	djwong@kernel.org, josef@toxicpanda.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, tz2294@columbia.edu, brauner@kernel.org
Subject: Re: [PATCH v9 11/14] xfs: take the MMAPLOCK in xfs_fileattr_set()
Message-ID: <20261112234959.GA13410@lst.de>
References: <20261112214604.67875-1-mason@kernel.org> <20261112214604.67875-12-mason@kernel.org>
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
In-Reply-To: <20261112214604.67875-12-mason@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

The comment reads a bit weird, but I think it's time to stop nitpicking,
so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

