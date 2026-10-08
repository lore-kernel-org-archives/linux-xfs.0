Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52786490C04;
	Thu,  8 Oct 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460807; cv=none; b=fVDTGGucguyR2PHJD/1a7w3iY4KYg474CtNAnIQPii9asC/Pg/uEje/oq1JH+cVS+9nbkBOKbOytcxo5lG6k9pqDj6l8nc4nwy7/cAEG1CU0dCJKy/qdTL+/V7XhfMIydp2x0C7XDcMIVwGH8wHXWxpgiaE6Oq8FMnreQOjza8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460807; c=relaxed/simple;
	bh=M5HXpLE3EJew7/sIc3EPSiDklqzTgQjVzcSupVkHflI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O47rQXUrrZMRBFY/0xoBDLQAdSBzA8xh+EPdB6/KN5h3eg4upVeJLBNT16NvjiPCEg1Oby97HWzDK8n6E13sxPXxEetPhN4/CE6ISchW3vgPgVkab2KSblsGT/NZUKLkA0q1T0SWfTxyzpccmkXtz2xFCQDYwydj+0t0pyz3LcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HboTfyo6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HboTfyo6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cNwJ9FuOsIfo3pk36qGg6zX6ahwxQiImf7juwdPz4LY=; b=HboTfyo6g4rdEVVfHUHFwSf6Uh
	cRlWtwaln7ECFGa5aS1lMshyWDCaSKh8/99MXaGSn9eOtx7XmKAmCDawy7LM8Nw9ZNyJeWS5crcmM
	TmUszeO/7j+6Q8ENc/ylgRML8fWqtqju6rDK8kecYtIDeISYBuYyIpoI9vJyE+LAcXAcSktBoV4kx
	I0F0Nm+UefAtfdPUIZ62YX2WbPUfQtlZJ5RG9jlYuFXXWVpIlSrt7JojGScpviAVRV6dgvuBtsV9o
	lgPQeVpGsDQoDcntpMyHxSirZd7Lohlt9MNIsN2sAHk2FNCj5L5E41o1xMNDKSL1eIOHvdNxU+Gtf
	1WDQru7w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmn7-00000004JM6-3PqO;
	Thu, 08 Oct 2026 12:00:05 +0000
Date: Thu, 8 Oct 2026 05:00:05 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/12] xfs: fix correction of unwritten extents in quota
 file data fork
Message-ID: <aseFxRJQwFyvJM2v@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521385.2728617.15371099582568233395.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521385.2728617.15371099582568233395.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:56:24PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed a couple of problems with the code that fixes unwritten
> mappings in the quota file's data fork: first, we should zero the ondisk
> contents as part of converting them to "unwritten" just in case we crash
> shortly after the conversion.  Second, and more importantly, it noticed
> that we fail to resynchronize the iext tree cursor after modifying the
> iext tree.  If the tree shape changes, we could be in a world of hurt.
> Third, we should force a quotacheck if we reset an ondisk dquot.  Fix
> all issues.

I don't think the existing code here that mixes raw cursor based
iext access and xfs_bmapi_write is safe, and that is probably also
the root cause of the sashiko complaints.  So we'll probably need
to drop out of the loop, finish and restart from the new offset.

