Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949C64CB23
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719901710; cv=none; b=vAwTv1VnY8tTpO8iUBpzC3RQInZjuMfXEa+QuBLjL6vlbDpMxp3Rs5Ff4l7ly3ASpieKaMII7vZdkGKNnhBZ5mddbDliUIbiCR6FcPKJW7pn8/rFYXJk6GXIjwLeeFGYCJQ6FJXrKEF0tFsLjiiIWfInxJXEBdNz2kfY0iQgMLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719901710; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mzFZk9oy7GeWbBH/a1EG9AyxC4qAqtIogl7bFZYR99PrwlemB3yWNvNfqnibnlLVKtFgKPrlph065gbtEdZVfseVUXpFgiVXbbWNJVR8ideOUM7RR170MjmOXgbehgd3T4wj0Hq0QoJQNdBeo0cPeR8+F+JcDXmgbApSzLuOdJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EA24C68B05; Tue,  2 Jul 2024 08:28:26 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:28:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
	allison.henderson@oracle.com, hch@lst.de
Subject: Re: [PATCH 13/24] xfs_db: report parent pointers in version command
Message-ID: <20240702062826.GM24089@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121263.2009260.1429651097097993711.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121263.2009260.1429651097097993711.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
