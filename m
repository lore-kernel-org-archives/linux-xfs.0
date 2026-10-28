Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793203930;
	b=Bvq9xv2ZtWMeF5h9rgcLeZ5hA5Kcs1f1+/dKq8uMgP+Hde8defysqUQV0AI5qENBYQmU
	 lZvgsi+8rCBmWAtya3OdFytXPOTx3CbSfE9b8v8WyACwRbwAswzqnWAozwqj46ZUdoCJY
	 yUCU9ujy7xZmLeycEbIbZW21YTmN0RsO3KdPVayfcc2a0vGL/NU0/WQ1ncDaGJwbcyMqj
	 8gQtxpEVWXPfOU7hrQlexHfeyZLtvkMb4zZHhE2X4jBGsufojLCmCqo+klX6SU0gpCQP+
	 AfDvI4DMcXWYogdnLjOdlUp/EP+U06nHUZfvJ0cDSDn/ki3kpXb0w1UN/rjnb5LG0Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793203930;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=GNb429SxdXpm4caVuhSn94pFiZc0SV5Ewq2RLfxSttEZ2JF3E3JQDxl2c7YSfmEf/hix
	 v6VXnEVMkS23q52FjhrzPzcBTa6aHTKpksN8U2haK7288C64AHUm5o0dpy+QObThABY08
	 dMzJYDiFJ6v+q9FgQoQve0WkuqsRNGw2scR/B7pBN3M0k0kuDNkGfZvzHXWEhIHX0sWVm
	 QCa4FPchS9S9sR9jIBl/t4RI26wYTLvaKE8B1YkKrOaDSuLfR76C5AHbUXd+lbkzP8n2c
	 8HBJh9j3oI0JLW21NWlZAy7wkmkEsIlFqy79DOEY13dpDRm9gfOlEZSUXVXx88w9r3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA49606A31A;
	Wed, 28 Oct 2026 16:12:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BA49606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0FEF68AFE; Wed, 28 Oct 2026 17:12:06 +0100 (CET)
Date: Wed, 28 Oct 2026 17:12:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>, Dai Ngo <Dai.Ngo@oracle.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/9] xfs: add datasync and log_flushed arguments to
 xfs_log_force_inode()
Message-ID: <20261028161206.GB20998@lst.de>
References: <20261020-xfs-pnfs-batch-v4-0-9230fa2ca4a4@samsung.com> <20261020-xfs-pnfs-batch-v4-8-9230fa2ca4a4@samsung.com>
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
In-Reply-To: <20261020-xfs-pnfs-batch-v4-8-9230fa2ca4a4@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

