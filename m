Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DB0188A1E
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 17:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435629; cv=none; b=QF5rogCToqYq5FJu7Iefyq+Acr5xBu2pxozBH7bsOlNAzt0SWHmuK95UOP8nQgii7s0jb9TuMTl8JW0trhJNhYOmrQI8+hJv8a0iWIr+t2CLERqk9Ym7MHbgRarpWYEwMB0jhmCOWTm2/EWvRT7DRxhnmmtaZVc56r0WhoR46H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435629; c=relaxed/simple;
	bh=RFvbYFo8U2x4Sg1L95+VsMH6bMpBTeet8oXFpb4yKDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaDbADf4D61OBGFuQSgNq6IA9VHs4BcninTULZqeekmKkmWr2g5Z2Dkde4lVSiQEptc8xM3OK057DzJyIms+NS0+0df10TEtfAyYso2akzvo6YL60jmoL0IOH5XAAaqhA9qSNZ0iGyjrJ03nNHcs+6acCyTr7UZHDDPKLXpEGLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmRdl/l5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmRdl/l5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B88AC32786;
	Fri, 23 Aug 2024 17:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724435628;
	bh=RFvbYFo8U2x4Sg1L95+VsMH6bMpBTeet8oXFpb4yKDg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LmRdl/l5KxaojS4kzpPnmLD+tQbVHp+bc37+a8uEG36N0FzCvlCb2LdO2b1PbhRmR
	 K7t8FEKngUSlPaR+aRxmia4QchNh5bflyak0u2IVMw05vTAXLMCDtMjflhO8Px/QUQ
	 pW9NMoeNu40xZRCDUN21eM8bCd7q2b72BhSI+ytQ/k+86prPfFFwsK1h4Fikp3bFyz
	 eW34wp6kiF0+kVLHyH/DG/J78e9gZnNjz2T52inmfW6dNUiaO47gVELdqRuqxO9wvb
	 p7cRz+scpSi2wDCxYx/CgYtjV1bKAH2UiFRtqHLYPi1lmOvjSLv9i/tF7IVk2z/KXO
	 tHyxw278Kq1SA==
Date: Fri, 23 Aug 2024 10:53:47 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/26] xfs: iget for metadata inodes
Message-ID: <20240823175347.GL865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085223.57482.4228252253880312328.stgit@frogsfrogsfrogs>
 <ZsgRk77J03JO18ry@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsgRk77J03JO18ry@infradead.org>

On Thu, Aug 22, 2024 at 09:35:31PM -0700, Christoph Hellwig wrote:
> On Thu, Aug 22, 2024 at 05:02:56PM -0700, Darrick J. Wong wrote:
> > +#include "xfs_da_format.h"
> > +#include "xfs_dir2.h"
> > +#include "xfs_metafile.h"
> 
> Hmm, there really should be no need to include xfs_da_format.h before
> metafile.h - enum xfs_metafile_type is in format.h and I can't see what
> else would need it.
> 
> I don't think dir2.h is needed here either.

Yeah, I'll go figure out which of these includes can go away.

--D

> Otherwise this looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
