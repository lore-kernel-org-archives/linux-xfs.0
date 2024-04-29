Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2899C83CBA
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714410960; cv=none; b=uPDw5UJS02zgLOhXkhvjPlM5dV6Rrgmh6U+fUwlv3S0YgqeUYLlrnQO3msDJu8WD7AASm2oimaLDUfdY3WSlUg/yqSa4GqDRCnCk2f6UxIeuh55waEQjHWtheHnq1wLFyJjfbyMI1C1+uXSrmTHS/sCfC6IJ45TleLcGdW8naVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714410960; c=relaxed/simple;
	bh=qkUpZCPZhD2W5WwS9q0cBj8bvucBHldBOk2PlisMsV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3Zh5/rrP4kL4mRYCkn9I4Zns4ZGzyMH9TODAeT5tIoSXseHNHdy89VTnh+mU2M6/w3E0reZUKeaeiu4xQbznTGQ16pKvH4X8ZP8ZBIaHq58BDsIO2xY5ehedJJTt6munlr0HGr6eBn6rIgbQt3tuqGAVIx4QxKUxy7t86ssncc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70BAB227AAE; Mon, 29 Apr 2024 19:15:53 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:15:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: restrict the h_size fixup in
 xlog_do_recovery_pass
Message-ID: <20240429171552.GE31337@lst.de>
References: <20240429070200.1586537-1-hch@lst.de> <20240429070200.1586537-3-hch@lst.de> <Zi-QJG3tuRptnDVX@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zi-QJG3tuRptnDVX@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:18:44AM -0400, Brian Foster wrote:
> > -		if (h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> > +		if (!xfs_has_reflink(log->l_mp) && xfs_has_reflink(log->l_mp) &&
> > +		    h_len > h_size && h_len <= log->l_mp->m_logbsize &&
> 
> ... but I'm going to assume this hasn't been tested. ;) Do you mean to
> also check !rmapbt here?

Heh.  Well, it has been tested in that we don't do the fixup for the
reproducer fixed by the previous patch and in that xfstests still passes.
I guess nothing in there hits the old mkfs fixup, which isn't surprising.

> Can you please also just double check that we still handle the original
> mkfs problem correctly after these changes? I think that just means mkfs
> from a sufficiently old xfsprogs using a larger log stripe unit, and
> confirm the fs mounts (with a warning).

Yeah.  Is there any way to commit a fs image to xfstests so that we
actually regularly test for it?
