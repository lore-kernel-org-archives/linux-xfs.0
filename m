Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A1F1BE251
	for <linux-xfs@vger.kernel.org>; Thu, 10 Apr 2025 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744265670; cv=none; b=Sx+ZRL2Z9uGAwr3xZUmTscGY17XjTHsVuejFscmBBJ4s782+yjm+ZKEZGLIUl3ZhRPOthYRtUAWcZZjMV/Lfh0ZdunDqEZolFlmVDD1GIR0AcCVepdoSn6xnobJzy6yRXcjbgs3qZgaANjoSNYWsucT4bRCqYAtzUYzrZxFrtHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744265670; c=relaxed/simple;
	bh=m384DF4AW1mYIfRjsRNtrCIXdLQPNuTDVNfVKnCXqfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o/rOpdbqDZMvZHdZhlacPEgxZKhMWAuV9ZDsYF94Wk7fjdlaVad5PBC4SVPzq0NXo6QzU08qVcczNjpoieoPuMNDoSc/v/g/SGI7cJy7dfQsCWyJk2sNJ3d1Qht6+jtVTE8E7waWeiJSxCsrD7W7AOhWRcu+eAGoY4irFGzl17g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D419E68BFE; Thu, 10 Apr 2025 08:14:24 +0200 (CEST)
Date: Thu, 10 Apr 2025 08:14:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/45] libfrog: report the zoned flag
Message-ID: <20250410061424.GD30571@lst.de>
References: <20250409075557.3535745-1-hch@lst.de> <20250409075557.3535745-27-hch@lst.de> <20250409155846.GZ6283@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250409155846.GZ6283@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 08:58:46AM -0700, Darrick J. Wong wrote:
> On Wed, Apr 09, 2025 at 09:55:29AM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder why the other xfs_report_geom change (about the realtime device
> name reporting) wasn't in this patch?

Good question.  I gave it a quick try and it seems to work out much
better indeed and also solve the rtstart issue mentioned earlier.

