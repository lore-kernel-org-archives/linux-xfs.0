Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69E42BCFF
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902475; cv=none; b=TG34TVGBr0qhqPDuU4bR6P8j4BU7SyET37p0170RAM8SPTgeRJwUsaKIHWebV4cAB020pWT1KCcZExpQBNXCnHoqqOFyfHzAMu326zRuA0fPApoiCXm9RVpBUJ3+QMwxaTzHLqo5vwTM+vi+WL8i8r/MCF7sdjIOnb0eKHSfPR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902475; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DP/Or/wTZgetL7gzh8VwmyxCJWnuY8xaxRST83gofvoRD7gzE3rwxc2VIQJGzzRhJm778xW5x1sqMjwUeEQudYBVMNI5wNOqcpDdydEb4A+M7IwDy+1Q6GZL6VR2SgldqqC/klWKOC6KEemA/+UKAUQHDyG8RZ2+FaxjiRkEuMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 08D4E68BEB; Tue,  2 Jul 2024 08:41:11 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:41:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 1/2] xfs: create a blob array data structure
Message-ID: <20240702064110.GA25045@lst.de>
References: <171988121771.2010091.1149497683237429955.stgit@frogsfrogsfrogs> <171988121789.2010091.5748728321001846244.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121789.2010091.5748728321001846244.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
