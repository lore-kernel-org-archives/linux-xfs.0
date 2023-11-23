Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="39jud9Bp"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3D018E
	for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 22:30:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dwCRE7S/Q5qW6xd+AYUSqNpslPbFoJRsNrZmSoxG/BI=; b=39jud9BpB1oGW4MqigVUbBR5Ri
	gr9of/3eXt4US6gfrilxwhpWino9ew79tDTiHrPon/SyeLXgDcsAIPXhJ+nX9pqHLDIP4Tbyl4tJT
	pSXbYbavCixbvEBOce/29+ESWw9WlKxB4DM8TZGMwHppL26madGwk1jNlw8kMDOr3aj4QzVU4vr7e
	L6L4+UNbMcPCIjdnC/yyyQJzzK8YB7m3k28ikQ2ZUPNlgRCWQLd3gFZi1GvFKFuPNRePt22FzV+Oy
	+HyQDxLPUWOuM7oPB/G/nHrIUf4eP9Mjy+LF9vMIkNObM1OQrVpGHyVSgh+BwfSW278vuneiI7taM
	OpL3t1rA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r63E3-003uXx-26;
	Thu, 23 Nov 2023 06:30:11 +0000
Date: Wed, 22 Nov 2023 22:30:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs_io: support passing the FORCE_REBUILD flag to
 online repair
Message-ID: <ZV7xc5ann7oeZNqY@infradead.org>
References: <170069446332.1867812.3207871076452705865.stgit@frogsfrogsfrogs>
 <170069446896.1867812.14957304624227632832.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170069446896.1867812.14957304624227632832.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Nov 22, 2023 at 03:07:48PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add CLI options to the scrubv and repair commands so that the user can
> pass FORCE_REBUILD to force the kernel to rebuild metadata.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

I guess on it's own this looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Howerver I find the code structure here a bit odd and rather hard
to follow.  Why can't parse_args actually just do the parsing
and return control, control2 and flags the caller and let do the
work?

While we're at it, shouldn't all the validation errors in parse_args
set exitcode to 1?

