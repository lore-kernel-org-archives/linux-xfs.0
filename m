Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45D1470EB2;
	Thu, 23 Jul 2026 05:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783102; cv=none; b=TESRKqVrcx71emB9Q24E0eIW3f1a6NFOZTrhOjiHcWEBjUUerQ8pSoBYdsaAGRQuOfUAWcZvcA6OAesAeluQz4L7m6aIPSHJBYUxRx/vftnkXiBuTWIWm9lsviogTIvl7Q9yRvnS/arQ3j8Qf5PmkRuQIhR2mlJGmAqanfCNh3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783102; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FEri01hM0LaYAx7+Z6UERXj68UZ+8MLDC9pcJ7Fa47Az8O8CWPhaqqr7wFcKshBH8gZAEw8q2V6s7PzVwmMOdZaF+wROpwJ/BOZfPELFr6xFTutB3fHvHMGsn2rzI8EStHBAvdQhe66qZuKObP7UwME3WFQMTWbSVXlmc5KUrRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA16768AFE; Thu, 23 Jul 2026 07:04:57 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:04:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: don't livelock in scrub on a circular
 unlinked list
Message-ID: <20260723050457.GA7121@lst.de>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs> <178460419532.830862.12113833243550659663.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178460419532.830862.12113833243550659663.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
