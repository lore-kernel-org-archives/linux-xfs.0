Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E63D75
	for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2024 02:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710381829; cv=none; b=kIk5u3EZU7ucUSpq+WFB6I1ZoxsVbaSTQp4soNFy0kUN6jWzQS63/4yJ3ept6twfXQv/lMIQs5KpH//V1zgC/wE+ylVQ2WJSxFSktMu+jHvuZT5Y4x9NXcFPCh4cppQTuM3fXoFrDS6C0YM1oKTfM9oJHpnZIwmvwQMk4CgNStM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710381829; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJv0CiUIbs++ovXVor9QWgF2kDsNKcMNdauyJia5po4iU9/WSVRvHeD56r5O5GabO3zCN+RmxZs2RIVKqjORYA5ScaK4oq+/EGF6s+/zJQyXIFif1ZWoNC5ah6jxqksZzeOXFrCkM2VQbO7l9FUauThlc6CYc5MgJcHZlHoteUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZsbgF5x1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZsbgF5x1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ZsbgF5x1DAqFUA40+wDEWfArkL
	KoWNHMQPel+NOiQhT2AdiAdkUjPkcQjXxeLV0esPLImLdMXIiTg7FpnMXvlWfdSLBNkvOvMq3TDtL
	b0vAdhguMez6eYWzf0EfgZzj8P7xRqjJ78lGX6JMuv3YY4tWmKAcnpmn61+1byql67Jwm/LfzS808
	tN/OtMmU0a8lSrD3EIzGI4xiXaA0mUdw+g4jMQut3/aMOVmLR0nLfWyI/9DCu9gVvoM4SFnjFVCYZ
	9A/CY6iH2ajVxjmzHCUk9mEM8MPjVge2SgYA5bod0Uxo/+z8HVqZl/hpGJPqQaVfJl3+Ond6e8xxL
	SG2GCUpw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rkaRg-0000000Cd8q-1rxt;
	Thu, 14 Mar 2024 02:03:48 +0000
Date: Wed, 13 Mar 2024 19:03:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs_repair: constrain attr fork extent count
Message-ID: <ZfJbBBN89k4UjXWD@infradead.org>
References: <171029434718.2065824.435823109251685179.stgit@frogsfrogsfrogs>
 <171029434815.2065824.10714570666464102685.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029434815.2065824.10714570666464102685.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

