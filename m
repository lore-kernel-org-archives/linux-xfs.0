Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA151C37
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 19:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0YCMabk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45570C433C9;
	Mon, 11 Dec 2023 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702322131;
	bh=ETR5dBToUZ88fN6HgmwxcUEngLlLKiiSumOA4SLwZl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0YCMabkqcwO4Ft7sy8x0w0urGHYA2HRXqw/WfiNv8OmCSTSDx6Ou5EJTHgVw9EcD
	 FgAuqqx4mZAngsESV+poG6sGz6gGiF5SABaDRvmdBndEaCI1ZK/XybTY9eCQCQc6h/
	 CSDqTWzLrFZkxIJlKLChaO+ulvRlkkMzXMlNt0MO1MCIarnLuX7IS/GuMLVFrQpc2p
	 P6buQi8H3dkIC3viAyC5IHNANGto54pPh4Pu9Mng5a/7HpN1i/vNe+v90sC07yiJGt
	 g6yvr0RJD2YGBCaF9s8uUnzJi7pddre1WHo3ENG/86DoBpb1ZnNF/qwlLtQlFLOCtE
	 ct/13Bj1EGrhw==
Date: Mon, 11 Dec 2023 11:15:30 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: repair free space btrees
Message-ID: <20231211191530.GS361584@frogsfrogsfrogs>
References: <170191665599.1181880.961660208270950504.stgit@frogsfrogsfrogs>
 <170191665696.1181880.11729945955309868067.stgit@frogsfrogsfrogs>
 <ZXFYa7v7m1vkuwnY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFYa7v7m1vkuwnY@infradead.org>

On Wed, Dec 06, 2023 at 09:30:19PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2023 at 06:41:10PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Rebuild the free space btrees from the gaps in the rmap btree.
> > Refer to the linked documentation for more details.
> > 
> > Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-rebuilding-the-free-space-indices
> 
> Nit: linking the file in the kernel tree that this is generated from it
> and requires internet access would seem more useful.

Er... assuming you are asking for a link to the file in the kernel tree
from which the HTML is generated so as /not/ to require internet access,
I'll add:

"Link: Documentation/filesystems/xfs-online-fsck-design.rst"

That said, I couldn't find any particular precedent in Documentation/
for having Link: tags in patches that point to paths underneath
Documentation/ so I guess I'll just make s*** up like always, then wait
and see how many auto-nag emails I get about how I've broken some random
rule somewhere. :P

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
