Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F455466B
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 22:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JhhZxxF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64021C433C8;
	Mon, 11 Dec 2023 22:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702333167;
	bh=HX02/8t4sHORUwbgef8GcwF4FUFLh2+ThR1QvPPTSrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JhhZxxF29l8UcUAvHDhb5z92avy5DCExDixqRCuxQrmnb4DJ3aZh4gGTF/nfBWFr+
	 cBIYcw3gggW43BfSSPuCptx/S+qgbmLZP7V1IVZ49BQUrCmD1mzafsFJuoVrtVAaml
	 m5bQgMn8wmZptM2HkG3nj1KxNb1KAASKGcAwZ88eavQ74hjCs/EU1g42VseXnc8Rm0
	 fbKQ8otUL28dpAor1DQxAogRx60neAuiwdHgsoGdmsOEn8MYTvc2n1RdCIo87xexBF
	 ueNHx96nqFaI9DuazirUD6YRcVEvrYZl8x7mtxLEUPf+HQi7/uhIKj9WxOuRHyn25y
	 EsYRxoLg5fKKw==
Date: Mon, 11 Dec 2023 14:19:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs: repair obviously broken inode modes
Message-ID: <20231211221926.GX361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666254.1182270.6610873636846446907.stgit@frogsfrogsfrogs>
 <ZXFhuNaLx1C8yYV+@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFhuNaLx1C8yYV+@infradead.org>

On Wed, Dec 06, 2023 at 10:10:00PM -0800, Christoph Hellwig wrote:
> I really do not thing turning an unknown mode, which means potentially
> user controlled data in regular files or symlink bodies into file system
> metadata in directories is ever a good idea.  Quite contrary, I think
> it is a security risk waiting for exploits.  So for anything that takes
> an unknown inode and turns it into a directory or block/char special
> file: NAK.

I probably shouldn't have resent this as the COVID fever set in.
Granted, I predicted (mostly correctly) that I'd still be a bit messed
in the head five days later.

block/char/special files... I guess those can just turn into zero length
regular files.

Would this NAK remain even if there were external corroborating
evidence?

For example, what if we read the dirents out of the first directory
block, seek out parent pointers in the alleged children, and confirm a
1:1 match between the alleged dirents and pptrs?  Unprivileged userspace
can certain create a regular file N that looks like a dirent block, but
it cannot create dangling pptrs back to N to trick the verification
algorithm.

(Obviously any patch implementing this will come much later in the
series)

--D
