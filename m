Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A9A409610;
	Wed,  8 Jul 2026 09:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783502178; cv=none; b=Dpm5Itr3PNK5Eowsa1vh+p5ySMLDx/MV9FZ4WGTauk7BRCrpBiDahKg1VuEzhKwct4uO0d8fsnRt+t4hY5YwoUGJZscPa/EmuqSsr9no+hyzuCrwcwLdo7NcsnRj1RiixTQd2S/EyZzeacRu0h9eZu/DfEdvUJayeSMwMih0ois=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783502178; c=relaxed/simple;
	bh=uJJjaGilyPul2sWCF4NUpY8S1HJZLLMbGri6NMSU0hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g64swWJWoZWnmV+0EF3cZMyaqj2rWA0O1XlmCg8T4Rk5xCtLT9D+7WFyh+8Zxt7oz94uxsyOkIVwrHJJnXvrIrDzfzN7bGykh1Zo5OTh9z7m5c4VhQF0Lvp+MCqVh4v5ZTQnk4v/+9ma+x8WwfOi99doT0UakRT/GKWX8qjjZbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9536068B05; Wed,  8 Jul 2026 11:16:14 +0200 (CEST)
Date: Wed, 8 Jul 2026 11:16:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: use the rt version of the cow staging checker
Message-ID: <20260708091613.GD5902@lst.de>
References: <178346726054.1271589.14164163317011378817.stgit@frogsfrogsfrogs> <178346726172.1271589.16407045175223390003.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178346726172.1271589.16407045175223390003.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jul 07, 2026 at 10:04:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM also noticed that xchk_rtrmapbt_xref ought to be using the rtdev
> version of the "is this a cow extent?" helper function, not the datadev
> one.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
