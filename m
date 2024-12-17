Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244C013AA41
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734465775; cv=none; b=OiGtzx7wdf6rP4lttPmR2oKAPg8knO7E2wKjoCmc3p6ohTNVwVUpC2zlUvo/eg+0Bm3cjkAccwPoq6BT6zH1S43k3qNpF/g5cx76l6jLXGTCYGcprFIgOdo+OvQxyNM6sClF1HTW3wuGOPKaPWKTBsSqGpPwFLCrp9yz4MBl6gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734465775; c=relaxed/simple;
	bh=InM+N3xppSVz5G1w+oK7XxQDMxaIexZtP5nu69LDSSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K0iOz7lpPwYkEPry7UmZAh0nRq8S6zgs5Wn027sMauk7/FPCyfgtbmv/7xC4fwq8n2aGioDhgBKZSVyNQnu7U5CvJfwNwMW77Y1tHLfx47NPv2I2RLXimhXSyikGSv0KDKkbJqB5NSxCubwy576tMTUrbJl7Wa1aM4vlWYBYgNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iX9BChoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iX9BChoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5A4C4CED3;
	Tue, 17 Dec 2024 20:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734465774;
	bh=InM+N3xppSVz5G1w+oK7XxQDMxaIexZtP5nu69LDSSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iX9BChoHq77IOSS+vZRjgtd9nWBSS+mhMaQZLIAvgLz/jhJz3yFZT0kIislLi8XpH
	 Zm8ohQzyd/8f3zSVgaG3tpgv8Hr9LJPgjGpPNTsujzeo5OYaIzz23YDmsMMa4d60vb
	 DMWptey9pIEh4SmZWlwvpDb0N0ePXAhcnimiOANx3ONg92HJYMT67jOvG66VfEcv1V
	 SPF7lAjszWxQJrp7cDm4Q2yYgJF1JaVnOG4kieyVEhDpGvcWdtjqXvDigB5P2j3z3Y
	 wHhqO8Zdgb351WW+RIugRW+iGgEj/xVKLCbXS40ILs9XCUIszeuupynm+j0ZEVUf4D
	 sbzMNlrHs9GJQ==
Date: Tue, 17 Dec 2024 12:02:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/37] xfs: introduce realtime rmap btree ondisk
 definitions
Message-ID: <20241217200254.GQ6174@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
 <173405123381.1181370.5283272140713380009.stgit@frogsfrogsfrogs>
 <Z1vS5Rm1819HekO-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z1vS5Rm1819HekO-@infradead.org>

On Thu, Dec 12, 2024 at 10:23:33PM -0800, Christoph Hellwig wrote:
> On Thu, Dec 12, 2024 at 05:01:37PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add the ondisk structure definitions for realtime rmap btrees. The
> > realtime rmap btree will be rooted from a hidden inode so it needs to
> > have a separate btree block magic and pointer format.
> > 
> > Next, add everything needed to read, write and manipulate rmap btree
> > blocks. This prepares the way for connecting the btree operations
> > implementation.
> 
> This isn't really the entire on-disk format, because the metadata
> btrees in data forks comes later in the series.  Not sure how to
> best word this, though.

"This prepares the way for connecting the btree operations
implementation, though embedding the rtrmap btree root in the inode
comes later in the series." ?

> > +#ifndef __XFS_RTRMAP_BTREE_H__
> > +#define	__XFS_RTRMAP_BTREE_H__
> 
> The mix of a space for ifndef and a tab for define is a bit weird.
> І'd suggest to pick one and stick to it.

Will fix.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
