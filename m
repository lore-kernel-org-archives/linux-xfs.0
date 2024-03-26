Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E762A1C6A0
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473874; cv=none; b=PJjxBcg9cSKIeNv2QPTLuIN1I/MqbQdQJczNpgBnccdxQSbucfSU5BQbuJEReVR/gdiGhu76LiNdFSy2Nyck6RQHYLe6jRx2c6j0jaE9zzsfAd5Wq3syv+6u2Brnvy1Q8Zxb0ToFUTQ+pKn5wxkTe4j1b2XmWd/jp6uLPIk9MIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473874; c=relaxed/simple;
	bh=3NY5CW+yydbwPGmA8N2DN+1eiN1pQjI1aZQrZ+1g+Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BNeq1OPyv4dVp1yd+KufuWJMJumxDAzbzwKnx8n2Nmk9x2fn2+nQhdhVTSaDPDLxEKDzyte9tf+EwB0mlBu3YHvLtgC2x9OVfIwSiXYACCbg4LmpSGCSAkvjaYXJv5uJk58T0NP0dRoNk5r8trjo7Y0LJPOrS8VG6W7T+BB8Dts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ngh+OsXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ngh+OsXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD420C433F1;
	Tue, 26 Mar 2024 17:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711473873;
	bh=3NY5CW+yydbwPGmA8N2DN+1eiN1pQjI1aZQrZ+1g+Sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ngh+OsXgm/R/yFlhgZmKw6gB3IOsj28H3IaPckaZqQLcSylmaSIDK127RPAPnFLkz
	 Gf5mMpCNpALrBtvJFQ8MomnaLAaGWyoaUJhYSJUhy95JvZfNAddIpO/ZUSjbTX9Nf5
	 IamGRxKKuHLm0T4hzOrcFxNxpYZTikW2dT/87jivnzgQCRjvx4zSqwFQAXdgDfQeHP
	 eHm6TN5nHoTFl7JWif0JjhYUUQGXsu0C5BPlJpt+g55MpN5swnPe0ucTirysB5Qkvv
	 2QzhNv0dadhrQE2YrLSYePo8wP/Pq8Dst/898NmWANG2qQQBLDC3aFWaXLhhHQPKm/
	 wB4cM8Sk/ciog==
Date: Tue, 26 Mar 2024 10:24:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: compile out v4 support if disabled
Message-ID: <20240326172433.GS6390@frogsfrogsfrogs>
References: <20240325031318.2052017-1-hch@lst.de>
 <20240326000237.GG6414@frogsfrogsfrogs>
 <20240326055047.GA6808@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240326055047.GA6808@lst.de>

On Tue, Mar 26, 2024 at 06:50:47AM +0100, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 05:02:37PM -0700, Darrick J. Wong wrote:
> > > +/*
> > > + * Some features are always on for v5 file systems, allow the compiler to
> > > + * eliminiate dead code when building without v4 support.
> > > + */
> > > +#define __XFS_HAS_V4_FEAT(name, NAME) \
> > 
> > Shouldn't this be called __XFS_HAS_V5_FEAT?
> 
> They are features for v4 and unconditional for v5.  Given that Dave
> came up with the same names independently they can't be all bad,
> although I don't really care very strongly.

Ok, you've both persuaded me then.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D
