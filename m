Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199837;
	b=PtwMfuImWEtAdKxuBFeegMi/WymAOeDdX4KF8n2bqRKHvNOX7BkCFs0QvIRYTV/Vf3QT
	 GJ05K6U3q5gCBErm2EZlzS+TJoEgynNuDFYoeCsn3BY3D3NT4viL38H+LxcReh87DFcfl
	 QSh8KVg3LAwwiz6F90KwVy4yX7gAecHCpwxit+SVTa0TytXKOhNpN+9hjdrEZE5I3Yt3m
	 j1E8mmmIJUtgr1AT/UNM1C/+/LyNS1r7tz1W9y5/kE+nswZWJWKFWhHYSyeC3LnZ9mh+B
	 4kIWGndMg5Xo10EtKVDiknuuAFmQqEh8D/GWjqTqg+sGShBfMK94awdi7jiHI7POcgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199837;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=0le1ntxfvRC4d2yTeipRslQlwfq5c+HIqMqxMy7lK1CeTLfUkM8+r/be6YcqczGfyvmt
	 oNY2iss8CqjWAN4Q7qEBe6XmN3awJRUzP+jeCURYETIpiN94gH5fuAVfnCOT3T6GyVD5A
	 O2j3W4oykvUP7IpCrq/tMhOt517e56Dt7rUwNQmtdF+Icr3OMEJmNmQmL+Z92x/vVy5Lm
	 9QVvLzo/WVcjf1zYk3d4baROsqKEmFOCkd+S8+TU4DlZ0Vc8panrmSSTZuhyeVQHQKapl
	 qtgtA42V7xZXUORXB3kctngm9wHdqG3CfCt5mOQVgSbGF62UcqoiAPz4IF8RkyycSAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618AF606A31E;
	Wed, 28 Oct 2026 15:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 618AF606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 867F268AFE; Wed, 28 Oct 2026 16:03:53 +0100 (CET)
Date: Wed, 28 Oct 2026 16:03:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dgc@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: don't skip free extents in later batches of a
 whole-AG FITRIM
Message-ID: <20261028150353.GA16152@lst.de>
References: <20261026-xfs-fitrim-skip-v1-0-cddd8414f99c@samsung.com> <20261026-xfs-fitrim-skip-v1-1-cddd8414f99c@samsung.com>
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
In-Reply-To: <20261026-xfs-fitrim-skip-v1-1-cddd8414f99c@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

