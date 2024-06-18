Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56104F881;
	Tue, 18 Jun 2024 06:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718692014; cv=none; b=Uxf8TVYzGy4Az/vNXcdSjTYJkrykFxnMCK13t9itY665JcibOyX/JDwckS/o4z8FZExiUPWfIXltM483KKp3LydgG7XVbu9W8j89W8PE+NK4MjhTQKQjC0BP+hTNRJkX1snT26tQpmA6tMg1aLB++xETLvhp1wk8fMESsmK8T3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718692014; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qATgJ2bIlTyI2/6zJPPkBXbRJ2kYDbL4I7UKtXPBKGup13yV01XpylxnOEOrniyU6o7oKRpABzwd8MiJt5YA+mduudjRLErrf5A+7pg05nv/ABL5w/V5WSaUfyhqmh6iKER6NlnztWMEZyA+hLowNbt9HQAsWlyTOuct7vU8dPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5B3E367373; Tue, 18 Jun 2024 08:26:46 +0200 (CEST)
Date: Tue, 18 Jun 2024 08:26:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs/348: partially revert dbcc549317 ("xfs/348:
 golden output is not correct")
Message-ID: <20240618062646.GA28522@lst.de>
References: <171867147038.794588.4969508881704066442.stgit@frogsfrogsfrogs> <171867147055.794588.9928537254200607808.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867147055.794588.9928537254200607808.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
