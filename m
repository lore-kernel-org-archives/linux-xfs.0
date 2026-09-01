Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C883A8758
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 14:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271566; cv=none; b=AEZRPVbQebRM6zu6MxS5O/ctBK3cmn4ftZXaKuCP7YQXnVDUIlO1HyV03MiweXfwDFAcXSLCcsrNa3sYepbzQ5p1c4V1Z3SLaFYRxQe0+LHo4FTyXsJyLGyB918Y48Mgp7vOt6XjR/XqdkiVngZKq2sDO3HIvX/4MMdA8MtGqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271566; c=relaxed/simple;
	bh=8DrvcPzIY8FGvTT5Qxznhw/MNjDAGyPTHj1DHVucZLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tInH5IZXPkClryzEeX1z+YEy92WqGdCHNwZlU9wt025r8L9hdGGpjtkzdARXxrESRn5OmC6WsTD8BoASOcOWyJbCtK4l2kdR55oco4wgjbuCUf9anEaEvsZZd70nPd5ZcbKR9zI8bvT6bdBNERRES6Rc1qmbSFHDbFAsz1p3qhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWJT6CSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWJT6CSb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 00D901F000E9;
	Tue,  1 Sep 2026 14:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271564;
	bh=sKB3OY+JTc1/pMwzIDnyyx5lGrhXL6RnW3PlSI05cfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EWJT6CSb/nciBiyfkP5F/a9kzB5lWYhhAh51zdZNvu23yUTZsxtD5Hag19cZz2Fy0
	 v65LAIOvG4hQRivwjf5dL+7Gxn55FLFAqXiREdhgsyJlxqAhRSVKdj8z9Q2ourSoXy
	 hvSc2VRprbbzNjBFIPIqZyYmTt2zdMHYECLE0pKzdFqVmBNulhvbY56H6DPYXHa5H6
	 9ZbVl3pK2nHbdqhqqO48UCS+224k7BlLuvdwNV08rkH2rwXqjdch3A3W0BiDyc4kn1
	 ryP19cVvY6M850jWiGb/RpSkh4XQMGTBqCCMFULnlGblWkrlGhMt/iXYUTEJ2iMXEv
	 Tfa1ick3U40IA==
Date: Tue, 1 Sep 2026 07:06:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_db: improve the fsmap man page entry
Message-ID: <20260901140603.GL1933798@frogsfrogsfrogs>
References: <20260831071152.2580927-1-hch@lst.de>
 <20260831144604.GE6072@frogsfrogsfrogs>
 <20260901080850.GA22531@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901080850.GA22531@lst.de>

On Tue, Sep 01, 2026 at 10:08:50AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 31, 2026 at 07:46:04AM -0700, Darrick J. Wong wrote:
> > On Mon, Aug 31, 2026 at 10:11:52AM +0300, Christoph Hellwig wrote:
> > > Improve documentation of the flags and optional arguments, and fix up
> > > messed up formatting.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > I wonder if it's worth documenting that fsmap -l shows external
> > log device mappings?
> 
> That would be a bad idea, because it doesn't actually support that
> option (in for-next at least).

Oh, whoops.  That question only makes sense to the xfs_io fsmap command,
not xfs_db.  Stupid question withdrawn. :)

--D
