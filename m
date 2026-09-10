Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C18238C2A;
	Thu, 10 Sep 2026 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016540; cv=none; b=JPjRxK40rWHL2d+mcaBqk34vjml+EB/89pK12MJ8n8qMU7uddIquwmMv88yaxEK0RUdfFoI6sVxr0vovcA29LFA+ZnVDVdRtNdDUrtDC8Xzd4EQoGIaMli4CYWLgOib3ridYrCu6tcwGDF1JsaYk4B3ZaZSpp9aJXa3tANtOMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016540; c=relaxed/simple;
	bh=y9num3uhoPkEG1aKpRiKIaKFyMonMMYDlrsDvvx0HMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AonAr5ZRRKW8BqaLZGATNIZVXsOJAFQcLau4npOluhfByK4zd7iLG3JJCL3gTLbkVxtc88cLV/14w6rEdT8payXygRLQFkvmAHkW9FbFyNBxAdC/lAyFn042UcSGusQAx4wU/Hs+7TltjYLL78cF12+hvYXr0PP+V/zZr1Fu/Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C496E68BFE; Thu, 10 Sep 2026 07:02:15 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:02:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: reset parent pointer args before each dir
 tree unlink repair
Message-ID: <20260910050215.GF26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936749.4057962.1251607208695971705.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936749.4057962.1251607208695971705.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 08, 2026 at 11:05:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xfs_parent_removename only partially initializes the
> passed-in parent pointer arguments object.  In the directory tree repair
> code, we could decide to remove multiple links to a file, so we don't
> want state from one call to bleed into the next one.  Zero the whole
> thing explicitly.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

