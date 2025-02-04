Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCDC25A624
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 04:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738644991; cv=none; b=e/fa/9NwIBn9EY3dwWF5QqVHCfLrEMVk3nnyx6cFVFJrvlOqmQTIwhrUpMGb3hiOwwOLFyVMtzy/8kBvPi/w/YdqjHIQPB33Bv9i8vdrzvGUV+D0iNjVxwuiuXrm/sPPKYaE11Qa82advsmj9oUPNVfnWuTVHRmrUF57dZgmgFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738644991; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n1j3OTPyAa5bSDm6Tyww4ip+nYxCpkOc4pmfQ28t4/HvSfKzD/PlxNeamdP48oVYqO4GQ27hxsH2z8PDYQbpQZ4D7IX574M0G1ETjCuNYuW64DMc4neLTu7avjM9uyhGu3bACfeGsuy9GVyU2g0A3K4AmXAV4RA165XwS45lao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BE13268AFE; Tue,  4 Feb 2025 05:56:25 +0100 (CET)
Date: Tue, 4 Feb 2025 05:56:25 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs_protofile: fix device number encoding
Message-ID: <20250204045625.GC28103@lst.de>
References: <173862239029.2460098.9677559939449638172.stgit@frogsfrogsfrogs> <173862239078.2460098.2761986507883680426.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173862239078.2460098.2761986507883680426.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

