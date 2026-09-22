Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D1D563FB4;
	Tue, 22 Sep 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098446; cv=none; b=aBtO3xqJmGnzyycXrRF+FcCcwn6k/ie4PgBYIMN0TtsibtCVFtqeSQN+gnkLAa+5rfjQvG6tVH0z5i12k+Uro5+ro+nI+I9CwQNyZbnxIjYgmuEw412oRx9z2IwmPQU8Fke6pqgJrubejS/yQuvd+wAhjyXQXffxNd8h9NuhCWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098446; c=relaxed/simple;
	bh=y8cA/MjatoZZMGQ2rVyCPy7jNGsvvliEHfEseYRnk6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLH+TFDRcpZ8z9QbjwhfDVtg3lg9wYEWj8HBQHlOB1b7izN0bEGvYDBhAfSqut2ha1oHjNSpOllvpLLU04CfCYGD2nPuFAWEf4itKhQ957Lh7XocDKUFCZjEw89qasDG9GzjP08lF8MgElTWim21HqH4PtARAH18GVuHjbJLemY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooVMssY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooVMssY1"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D23811F00898;
	Tue, 22 Sep 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790098444;
	bh=6pvZDt16nph3qKIJs+5/bQP+naxvTZ7lUVWiM3EiPTs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ooVMssY1Ve8PxemIu7QFbmSsWVvN0ldCR+8XXvDzbUHxirWH7B5INp+YzGJP7Y2LM
	 5++tL1aYuSJ/dGDOvS9KGSsZas3DYmCu9NxNRtgkBV7j07kOFdMSK+8tl98OPogGkF
	 JxXXogWQyx3smn6neMJh56i6Ki0kJe/J/tWA+w0roMFaNHpB3Du6uJi+Eo68eJqEGF
	 cQudmkFhp4Ai3GhQC5rUxIbhZIx7LlYeyBmX7Y+pOAEPgIn9E2X2/FguGpCu0sNTMN
	 GCCPO0moqbg97Yjab9qAV2YQra6dI2e738fnNb+nlRYSC6cVqAkBJuuyn3tcsHs3gE
	 G2eiRtnq8IfRg==
Date: Tue, 22 Sep 2026 10:34:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/14] xfs: pass xfs_trans_resv object to reservation
 calculation helpers
Message-ID: <20260922173404.GU2705364@frogsfrogsfrogs>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120658.181988.9146739765881528995.stgit@frogsfrogsfrogs>
 <arIPvDO2vAM3jGw5@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arIPvDO2vAM3jGw5@infradead.org>

On Mon, Sep 21, 2026 at 10:18:52PM -0700, Christoph Hellwig wrote:
> On Sun, Sep 20, 2026 at 11:16:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xfs_calc_namespace_reservations computes the directory tree related
> > transaction reservations for a given xfs_trans_resv object.  The helpers
> > it relies on, however, read the live one from the xfs_mount even if
> > we're doing this for minlogsize calculations.  In practice this
> > shouldn't be a big deal since the minlogsize and live reservation
> > objects don't differ in a meaningful way, but LOLLM complained about the
> > inconsistency so let's fix it anyway.
> > 
> > Cc: <stable@vger.kernel.org> # v6.10
> 
> Is this really a stable candidate?  Same for the current merge windos,
> at some point we need to split these fixes into those that could
> cause real issues and those who don't to not flood later -rcs with
> lots of updates.  And this looks like a very clear candidate to not
> rush.

<nod> I'll drop this trailer then.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
