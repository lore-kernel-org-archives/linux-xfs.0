Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925E1329363;
	Mon, 19 Jan 2026 15:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768837446; cv=none; b=dg9dWqAIsK9lvyFupW80Yuh4K0k6g1Qpd2hORW2hzYdhOSAS98bA7r26XPs3Hue2Q75m16oeLsen/flY0ZKLXMqRX3GBhZp1Dr1aTsR9dd8KpZNWHjWL5mYLNxocM9i8RvcjfXdC6dwBhCwVZnol7fZtg4o6AZUBjsHR662bP9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768837446; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jh5YryK895E6qqH3a/VWJHSuI3u+h2hfmJDik5Nu9PQduFoxxUVh8VR7CZF9U8wiOpihx95MGCtDDxgevDNZUSap9EUMbaSLJsvZyEJms0I6HuZiUc+KibKxBRXVFQHJFs5oxRsPHRyqGGa8ym0QDbHjHktjL5YcqbWpclzjAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 195E2227AA8; Mon, 19 Jan 2026 16:44:01 +0100 (CET)
Date: Mon, 19 Jan 2026 16:44:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/11] xfs: convey filesystem unmount events to the
 health monitor
Message-ID: <20260119154400.GA10152@lst.de>
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs> <176852588626.2137143.5311489734226892176.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176852588626.2137143.5311489734226892176.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

