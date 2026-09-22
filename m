Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259324E1C99
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059652; cv=none; b=aLkuG9pAAp314nFJV0juaUFbZBwBky6nWaBQofW/zPZoPi9tpogN29vVSNRp/PAE6hB2F3dtLrgqcI8yQqDRN7+p6WG7NckFN33NIl0VPklAbe32GVpxEbhd1O3uCFjA1EwuiWYEsQs2vjp9YU84ZdLbmssfAVabx00r4hUYwTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059652; c=relaxed/simple;
	bh=t3dWAQuHSFswYwrVNNvo4hVDioypm5bLoUx6DpGMjEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Afbjx4RmNHqI2/xXDRTeCm/xGcj5cEJoTwRpawyERPWZE0pMDtqgNb+ifaaKPgk3dmno2AG1IToXW/1Yr+4/VgwivdTd+Lq0z4/RFD/+Avun2dV5S1Rpuwt7ZHUHTro0ZegqJA0wC6Ke6tGcCpuMEms2uYDBxwpJXO7kWHHlv4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbtocqWg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbtocqWg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A77E41F000FF;
	Tue, 22 Sep 2026 06:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790059649;
	bh=DF7UoETG2moau/6Z8VA0J51OMh/BPeiWHOrSC/5Yh6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EbtocqWgoSdY6RicKcHa9XJ/ElNdi93EluQ+wJV/UGRJkaSD8pewJB+9H2fEi9GI6
	 PllLrgl5pJt0CejE/2vL/dRTRQXY95k8xSXoqcPa7hnlnzy17laJQKBbiW2eP6uxXe
	 zF5oLkAKeCri9i+zDFw10B0C4rOEmVgJu+92MQVnznR5/ZYXQrEF/pA+wRsp2M0Mc9
	 n24tRyP5BsJ//iWib/aM9NcbEEC2IFfLTDCfHBOGSqsJs6BxLLHHXCPkjxSAHPa8RX
	 ewj0sepfeF7zuAxI11At8rXs0v2XGEUdGFj726WyJehCTwhI2aQojr/JIKqmo+v7+2
	 /jhvmErwWAR2Q==
Date: Mon, 21 Sep 2026 23:47:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/14] xfarray: don't allow users to unset in the middle
 of an array
Message-ID: <20260922064729.GS6283@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120785.181988.9998461891697022684.stgit@frogsfrogsfrogs>
 <arIQ7BTzDz3NhdiF@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIQ7BTzDz3NhdiF@infradead.org>

On Mon, Sep 21, 2026 at 10:23:56PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:17:51PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Now that we've merged online fsck, the only user of xfarray_unset is the
> > free space btree repair code, and it only needs to be able to remove
> > records from the end of the array.
> 
> I don't get the " Now that we've merged" part.  Without that we would
> not have any user, right?

Right.  That could have said "Now that we've merged online repair and
scraped out some clunky parts of the original online check code..."

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
