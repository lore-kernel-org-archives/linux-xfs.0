Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA90037A496;
	Tue, 15 Sep 2026 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789454279; cv=none; b=Y2aKU6/Gvdfk5RBa0MDlZeXG+9TJrMCkMLErH+4c6VZsw0oRMVFebYIy6ffUetxhyOwEG/l1Yiuf94NqjpKYuKeUGhjmzjSCJjhwIeo0Ilsizz78BeBncpVFz14jLdO7RwOZ4SQV4LorY+5nXnIYYwsJaXoDcsF37vlYealZEuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789454279; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Imvbcduc/5foEe4ehltaiB+MyEvsv3PsFOhrg/LoDjL/X/CQ9NXPvL5B2ydHvkvWtsvzROG4oFjmN97T9FwzucTOXizTY+tIz/VDZG2EB/F9XUlsktyq/e+GZSPatOESa30RGhxQvN0CR9m4F6BCq4X5Pu7pFafoUT6W4CxDROU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0009868C4E; Tue, 15 Sep 2026 08:37:53 +0200 (CEST)
Date: Tue, 15 Sep 2026 08:37:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Aditya Prakash Srivastava <aditya.ansh182@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/1] xfs: prevent close() from hanging on frozen
 filesystems
Message-ID: <20260915063753.GB13293@lst.de>
References: <20260914093152.1698-1-aditya.ansh182@gmail.com> <20260914093152.1698-2-aditya.ansh182@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914093152.1698-2-aditya.ansh182@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
