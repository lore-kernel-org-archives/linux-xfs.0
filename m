Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC971FBC8C;
	Tue, 25 Aug 2026 18:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787681856; cv=none; b=gaW9V2KueugVsnUdYlP36bi1t0LviA1GUHdZKNcHS5fnU/em5OpF8o4OXbg1dedJ2vyFwJZmKk42d/PtubcfCBO+UWcrMxhFxCWpQGBxeauJUzln3FGsWkyAqc2HrH9EDsGSIV/SN+gXzfSqz/UOYZhIV/cY7uAzlG7kLe3WyAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787681856; c=relaxed/simple;
	bh=gOvPX1XpPUrWaAITujaQpuCI6Pa+BmeP/1/7UVcJWsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FVwcHLdwCDww28JAiKc73bq08fGhwrOQ2u55L7GawF4fEtRYGo0WiBHB0s9SOTSGJZd/7ilCf5rs/PMYMqstRpTsECWURCTQu3/YEMaNecEez4TPm9j7xcKEx6OcH9/Tmqd+FDzGH0UjEoBpeTktG8+gKR++UBbAJIioWRAlzEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MMwIrx+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MMwIrx+d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CF8301F000E9;
	Tue, 25 Aug 2026 18:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787681853;
	bh=1pG0ncluyjDtmg7fOm0a+9w0tDMq8Gbt/R/DJ1LvXaA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MMwIrx+dZgSS57sc9Hcwi5caNQqZdDlMA80YQreos9omersuLsfWXvpJ5GAoXIiSO
	 /7lHhnM3COkzKfZlqhrihHXPD7MbmqRKdJ3UHNrvQVqbmngOtLMDEc1FUDyYZyPppx
	 xWviKwomoWYbi9gdDKKBMAjncaAuD4qkOzrNmaEY35jp/4qyfHxfIPq1x/P/Sn+ThK
	 apqtD1Va2E+7EEf64PPu9eAxRuW7YfmukClsxQpBKIc5gxmWQHuwN9gKC8H/JvueCd
	 YPW9iiXCbzmsAbfF8nxAWXImS1f+VLh4yaNDyUO0DdecrtLOOnI30WH8oil0UVRprd
	 BBMwuwPG4oQqA==
Date: Tue, 25 Aug 2026 11:17:33 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lock the healthmon when inserting unmount event
Message-ID: <20260825181733.GV6072@frogsfrogsfrogs>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs>
 <178760940804.944084.12785441907263638942.stgit@frogsfrogsfrogs>
 <20260825063312.GF24324@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825063312.GF24324@lst.de>

On Tue, Aug 25, 2026 at 08:33:12AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 24, 2026 at 10:35:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > LOLLM complains that xfs_healthmon_unmount does an unlocked insert of
> > the unmount event into the health monitor's event list.  Fix that.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can you also add a lockdep_assert_held to __xfs_healthmon_insert?

Yes, I'll add one each to the _insert and _push functions.

--D
