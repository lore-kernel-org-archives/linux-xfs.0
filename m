Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793276743;
	b=sqpkX+yZLp86f4C93o+b9d6rAUBE2iELog6TxSX+i3YXCib52ECJWLkpI8sG3yGHZGeU
	 pnvhRBLsSVOa+I6KLlEVtfL1kviBdVAFIvLxBcynMyMNfQ8hhgCiu8cguskBw7fTdGHOQ
	 ErYKrLmcFIMNbZZWhcT48RNbVSzHMCHtS/A9QP31CGUDH4vTUY4MGz2fdYiU3Zkl+72To
	 JEdSeB0uhh7n6GFxJn9EkZTbWRGyNBKtXbOPTQmtwy8mLuVdpBulgg6Wq56sDi16wIyK2
	 mUbXFey6YhfG9fKEVzaOQNONlEIxigHzfKcUVp2NZcme+joN+riJFtdg8pofzKFb55A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793276743;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=aShoOWMQtI6kpARIbOBKfJ+D4MCc5UK8EnPBegPB/rM=;
	b=dMgzBanvYi0pW+FiEawEQyZLorqi5Fcvn/I7gDztpGEqDdNzHgRtRFfuhO97YX32ZUD6
	 G9HsJt2XoH64e8VPMnCb6SKFsK7p7DOFZBcU86OZQ5HPNOIYXQ6BumP2zphjVMUI7cxFQ
	 lqinF1XGOj+Z+90BwDxT9ii993pbTtnxOriimu2EwDBYETamzlGJviuDZ+VPAFjFIUZHh
	 rdtyiKTvHqnFEYyGaUFSqGSZjalfnFwCzl2Yhs+FWEqRDT9JgTCyJtrphdlzkyZNku7+W
	 c4SFLDDR2HYeHOZz1IR513UuPsbaO4ddrT3BUZHjLdkWcq/IbxvAJXN7pF/AEs7xTFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8D9606A31A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF8D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1CBAD68BEB; Thu, 29 Oct 2026 13:25:38 +0100 (CET)
Date: Thu, 29 Oct 2026 13:25:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, cihan.cihan@gmail.com,
	cmaiolino@redhat.com, dchinner@redhat.com, dgc@kernel.org,
	djwong@kernel.org, floss@jetm.me, hch@lst.de,
	hemanth.selam@gmail.com, jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com, kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn, yun.zhou@windriver.com,
	zenghongling@kylinos.cn
Subject: Re: [PATCH 00/28] xfsprogs: libxfs sync for v7.3
Message-ID: <20261029122537.GA25162@lst.de>
References: <20261029120631.803074-1-aalbersh@kernel.org>
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
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

From a quick look over all the changes not directly ported from the
kernel this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
