Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B058523C51B
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 15:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747064492; cv=none; b=ovYNC3eMMzsby0ZqgScKyQe9LTCetxThJ2YX8nrf8wbvk7U0BeNU4XBSWn7mULoieO4q+Gvff4F5TP0Ot/xCPNBdec/b+wMRoMPmH4f+jn0OMZeuBnnNt0jRMK42mBoaz7cm38BI3Ut1dWllaj2S/2ZJsj1cYd767wtq7IKyV0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747064492; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+K+RqFT9hBoiavHVEDBmDMyJU/rrJbtcnxh9iq3sYoqmpwU4QArOGCAZx8t4UdcJNAFegRmby0kZPWh8ocY8O4K+BfA7JlQBCIr3ccIeM6jZH/ij3m7vubzZ2VlzfkxvpIfKYoikpIlIWdDzAPVTUA5ALMKTzeUDwCKgU8NOBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3DBA068B05; Mon, 12 May 2025 17:41:26 +0200 (CEST)
Date: Mon, 12 May 2025 17:41:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org,
	david@fromorbit.com
Subject: Re: [PATCH V2 2/2] xfs: Fix comment on xfs_trans_ail_update_bulk()
Message-ID: <20250512154126.GA10764@lst.de>
References: <20250512114304.658473-1-cem@kernel.org> <20250512114304.658473-3-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512114304.658473-3-cem@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

