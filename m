Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E93C79DC7;
	Wed,  7 Aug 2024 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046910; cv=none; b=YU9thReP9Y0GBrDZxvK8c8eZji0nESy6r+h07nDkxoiYPFAQq6ZVMS9LjHGjyMrasIc3Y7w6L3cM0OetJJfZhjZbCG9Je5inBmjQbsepFf6+umFHC5Qubo37vgRn6o05XsRjaG1qsLOsdnCPPBZhtmKn2semkB8U0/mB9PMP0+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046910; c=relaxed/simple;
	bh=MBX/Klr99P+DufRkiU2/pWxc0GdbMzXQSkMr7xvs/E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J22n3pi04jywzs5waRq7az2RgKUYlmc/XJDdMHBZpw/FrPvccyfxbRYzk9qbqyioaOrDJdKhpIbNc22FKqREyHBPxbhK3PV9/Yl9W/6RwffRN4Qiivwupo7Jgw5IhF1Bj4XxOVRXPevtgG2Xugp/cc/XiwmxSvitw3tSQnNIh24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9F68968BFE; Wed,  7 Aug 2024 18:08:24 +0200 (CEST)
Date: Wed, 7 Aug 2024 18:08:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Dave Chinner <dchinner@redhat.com>, hch@lst.de,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/7] xfs_io: edit filesystem properties
Message-ID: <20240807160824.GA9745@lst.de>
References: <172296825181.3193059.14803487307894313362.stgit@frogsfrogsfrogs> <172296825218.3193059.5122114124530927395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172296825218.3193059.5122114124530927395.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 06, 2024 at 11:19:50AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add some new subcommands to xfs_io so that users can administer
> filesystem properties.

s/some //?

> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>Acked-by: Dave Chinner <dchinner@redhat.com>

Missing newline here.

> +	if (!(*print_values)) {

The inner set of braces here should not be needed.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
