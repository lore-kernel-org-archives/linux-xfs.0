Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A597154430
	for <linux-xfs@vger.kernel.org>; Sat, 24 Aug 2024 06:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724481108; cv=none; b=cIBNCBD4zgsKMjJZ+lZL2e54KlK95pCsXGnTMaQ+++ShgeUaFft/8Y1YqN66Q8CMp8IfVctURZJPxmtW/ZyFtdAHO56x31gUn2i3lnc9QSOGrf7o4qjhsch07cOBE2WsztOTaOWQkYdGMNrzJWbS3EdWAct6+/thHQUGBgumzmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724481108; c=relaxed/simple;
	bh=JTRQIqxSiIJc/VgVM/ysNnvn9y3SZNmT61xlCURgQ3g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4528gzb4SuWYBHkgNCCO0pNEafOlDLtvMQPF/SgQq4vIXTlcPiKSchTyWeCjDUC0EqoEbIY6Qp18MP9rmmc3ev8MX9cacOE8utfvff8H2O2GpG2z8wiQIAehAAGZutBkcrX/648vldPn6N3+OIlwExurL2FFPRE/rs7oWqgK5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQiA5g1G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQiA5g1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B664EC4AF09;
	Sat, 24 Aug 2024 06:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724481107;
	bh=JTRQIqxSiIJc/VgVM/ysNnvn9y3SZNmT61xlCURgQ3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQiA5g1GReI5Sx6llISkYYCJTRK83K4sOzcS1Pe7d2F6FmsEZFdqw0fpa5hvUqgRs
	 cqWdCpzUrAinItRMlBPwcuu78sru7TXfbyU+HfSwvoTr8WYC0cqfgdSx0NYPbqSXII
	 +vRB/xF+H83ME6A8TpBfuqYT2XVyEz0kRIMcaZPlclzHuYW8rtNbW1IIIKJQKqs9hj
	 SVy6bBgkCnyNnAq8zUvkDcGmcEGLBv6qiWrYumPhG4cXHnA8DfoVNo5r9fMViigq4n
	 +nKAoosZCjLviSPgjij9HbqfeTJQ7JH+q2AziR0yux2/52JcGec4XlGButAUcFZ02r
	 mGuFvha9rzbyg==
Date: Fri, 23 Aug 2024 23:31:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: ensure st_blocks never goes to zero during COW
 writes
Message-ID: <20240824063147.GV865349@frogsfrogsfrogs>
References: <20240824033814.1162964-1-hch@lst.de>
 <20240824044718.GT865349@frogsfrogsfrogs>
 <20240824045004.GB4813@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240824045004.GB4813@lst.de>

On Sat, Aug 24, 2024 at 06:50:04AM +0200, Christoph Hellwig wrote:
> On Fri, Aug 23, 2024 at 09:47:18PM -0700, Darrick J. Wong wrote:
> > > +	 * data when the entire mapping is in the process of being overwritten
> > > +	 * using the out of place write path. This is undone in after
> > 
> > Nit: "...undone after xfs_bmapi_remap..."
> 
> It's actually undone inside xfs_bmapi_remap, and has to because that
> clears the blockcount to zero.

"This is undone inside xfs_bmapi_remap after it has incremented
di_nblocks for a successful operation."

(and you can still add the rvb)

--D
