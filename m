Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B23F16F288
	for <linux-xfs@vger.kernel.org>; Mon, 24 Feb 2025 14:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407693; cv=none; b=hfvrdkLdm49VsB3b33JuBK2NwGxkNtgAZ/UoqJhjQ/fWud0eWRVdpfEa+eW8DlVF671eUHPJSzwlRN3eyw11+ZNQ2UKDaGmY7GSk0qFWIS+nPqfuVuxSD/bT7kdC5Pv9e/aWeKTKI/AfnfX5yi5ofIqMOA/4NKtsKFl9a7eQsnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407693; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iaasenzdEQ5mPTya8itDGfVtgZFhwU6khrtcOf84/MaSqAZIhoWW9TWZxk20luuY1tFks8umAthkRh8HsOZeU7NXIhor4H772UqgxCrOExd+hyJqsIbaAQCMWfyJPgJNXgFWmqYVfa2QzDscWtmMyR6YPMvggBmrC2PqdijUXzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7857868BFE; Mon, 24 Feb 2025 15:34:48 +0100 (CET)
Date: Mon, 24 Feb 2025 15:34:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [RFC PATCH] generic/45[34]: add colored emoji variants to
 unicode tests
Message-ID: <20250224143448.GC1406@lst.de>
References: <20250220220758.GT21808@frogsfrogsfrogs> <20250220221027.GU21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250220221027.GU21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

