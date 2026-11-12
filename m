Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491356;
	b=OsdXCHJH+Ii50eVIi4mWqvQjuTe7hGeDdejWNf22MON9Q7mD9ZxiFFPOYXZ/uZ/rLkvb
	 IulvQpb6kc4nFr+rHLxQPKSM5NbdbpI/v200x0NQYCKFl56dJwdUDKM6DeSc/eOIEC27Q
	 t8ZWgcnX/fMDCaW9FmrG7kaQnur7lJEFa2AHIT5uj+52MTWDIRU3KIhAKa2/S443F3Pzl
	 SUBKC0oUTpjlT04+ve+XN2PBD6fH7zi0TpHuNwSJPiO2OH6lttRAy4X1vtniGxy1efDJ+
	 SsFolLfszKBudgsyl3rjFy42X/n8rsBnXGCtn0F4b/g7JM5eDv4mH8No2WuKDXMHgyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491356;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=iC6vmakhqQNPCILOI6Z6rRxbIkMRJGH9y6mzoLyR+xH7EGaiv2iETUT2Rtzsx6d1EEUp
	 k2vFlXsjqGyeII2b13NOpc14BIfxeviuyDnoc+twrjJcH/gvN9fB+SqdakvbnT8NFIRDX
	 i0GtHeVScemseSY9M7SfAzPmC2b0aU5ZE+JcHFifVGEu27z8ZrTCcJo2HsRxNv2r3iPuh
	 9PuKhIabmjiMDE6Q36Gsn3ixlkJAwbC9WPl3nVvdWdPndNfBNuI3LCLsLcyG4gJtSDCrM
	 oW6DFIp89V7HOpVh0eS/t2+reUteLvZgxy9mpGeJq3zIUYAU+WDwUDPRh6HXGA5hOBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD117606A321;
	Thu, 12 Nov 2026 13:49:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD117606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 894A168D05; Thu, 12 Nov 2026 14:49:11 +0100 (CET)
Date: Thu, 12 Nov 2026 14:49:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	John Garry <john.garry@linux.dev>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: check the disk address for hardware atomic
 writes
Message-ID: <20261112134911.GA23845@lst.de>
References: <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
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
In-Reply-To: <20261112-xfs-hw-atomic-align-v2-1-c90394805e7b@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

