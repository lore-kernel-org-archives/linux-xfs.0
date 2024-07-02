Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63C2BCE3
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719899112; cv=none; b=p7E7nlYIfJX4qcaJ/8u0CWLrgst5TkcOlYJsK/6xHSfNpEhB5zkj32yYuW1Pls8qmYS2Z9k5qjwYvEYX+jY/g4VWK6owYJ9krBteX+zkaI7nLMoxvEdGHG9DZP9aZxVGTCUkWSy9n1EhbGFJeqEcxaj3jBirxvJ9Jg+kepyFH+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719899112; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=olYK+lJxQlaxa4MYoGkmj5OBLxBN/AVrU3jcAhP+nZvvqtG3RNw/G7clfvMxEMd1so8ZSlcgUoYL5Z7czFaSOCyjMrkzmNaAJ8TXqKiA70/eHO53bVktSbaOdwgpLLFzvRDQZ3u7o32mrjWNI04JEQ7msFQKvNbVVPnJoiuM59c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C310268B05; Tue,  2 Jul 2024 07:45:08 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:45:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 3/3] xfs_repair: check for unknown flags in attr entries
Message-ID: <20240702054508.GC23465@lst.de>
References: <171988120597.2009101.16960117804604964893.stgit@frogsfrogsfrogs> <171988120647.2009101.16639921173241660983.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988120647.2009101.16639921173241660983.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
