Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AF220E03F
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771945273; cv=none; b=bIh7JEwix4nhDPydLSZQ8Pu+Y7yAuKSie3XZvtRhZR5MWbNZ3LJiFsolGn16REmEDnXr+vhzOTM4z8u35HZrtC8qc7AHrwQIZSCpk3z5w1XdoM1VbaFIrX2AkANxdcvEh3HCcjkCBvpwy0TOaAp7w0Zxn3Pa3cU8O8zdtglhRV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771945273; c=relaxed/simple;
	bh=75+IVSnaYkUllJjEvFfQyG4IE4WFdm1JcQupf727Ps0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JCs9WEzXRCk+UbFa5j50MCUo7h5yebtJKe9AzDQSdsTcqvY9qcV32YfiCAnBST4j1oPMXz4gjGtvgBc/tIV+W2ES7CyhkaeeOU94PZJRycVZI0CVPyMetNQlc5VYjREeh0jEu2f3RsolJBT2bYasU7AaaAIwmJ/r1QSt0KackPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cqeu6Wi/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cqeu6Wi/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Un4RnpiXLdw8F0LP4/Q+d87+F5vSjxj4+l0RjO04Jto=; b=cqeu6Wi/7t9ICnmrHeSY854ABC
	oVwY+T8YoFhyLn2pOV43cxodXqk5ICChf7w4T49xSG2GSulmgmdSJ30bk+kh46H8+GzCeDgM6YWkN
	WPpaSu9nQzmmjoALCngAh1qRaRQXKTN22Enye+iHQTPUWV48DHFjL/jwYL/KpJ/sRYlgEW66jt5hg
	HqD3lzyeaNsrZpnkYnMOQ0U6iPC1Xbxe4KxclB3YjebQTv47xxc0QhMOUXbhaRHNqRlKM+HlfB1zU
	yCVxMpwkTwmG/i7g8V/rY71DWTp47lXqaY+C3SIoB31kwRHCrj6nuMGNTKfAN5ffsoItokW8QZmxj
	sZ0dEtUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vutuR-00000002Hhr-2Jj7;
	Tue, 24 Feb 2026 15:01:11 +0000
Date: Tue, 24 Feb 2026 07:01:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <aZ29NxAM6CpGXVWl@infradead.org>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
 <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
 <20260223230840.GD2390353@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260223230840.GD2390353@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 23, 2026 at 03:08:40PM -0800, Darrick J. Wong wrote:
> On Tue, Feb 24, 2026 at 12:29:49AM +0500, Марк Коренберг wrote:
> > ```
> > cp: failed to clone
> > '/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx'
> > from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx':
> > No space left on device
> 
> Ah, that.  coreutils seems to think that FICLONE returning ENOSPC is a
> fatal error.  I wonder if we need to amend the ficlone manpage to state
> that ENOSPC can happen if there's not enough space in an AG to clone and
> that the caller might try a regular copy; or just change xfs to return a
> different errno?

I think the problem is that we report ENOSPC for this.  The historic
error code coming from the old btrfs days is EINVAL for "can't support
this for random unlisted reason", which btrfs does for example for
inline extents.  We really should turn ENOSPC into that.

