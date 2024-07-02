Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543614E2C1
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 06:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719902281; cv=none; b=l0D9iG0NTnXMTs2Ec2ub1UE68b3cNfCXJiHmwAIYIjpxXNSxdSFyfhHlBsrHnXBfPKfxiIb3gp+fKEp1U6j01N9fQCtf8DPyXkRpnc51avkHKOjvVqyyM57p3N9BzxdIspsDdB6WkzPvHtnoJtQ74ZljswdBfvB6HJSN/SUdR5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719902281; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGdqhoIt2BpxLICE8wdET4uJfsYA/VHmZ2goKHIqKHT/0c1bx4TlC2hR3XsnNWAFdLgdJDAy0lgYE39onWWnK8MIYg6n0pR+x+UNsbicrpn0mQGrS60u7/ng1OcYSNHAyrmeormJvU8Bw06QvDeP6oH1RBhjy7oh7E7yFQ5+zoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1189368B05; Tue,  2 Jul 2024 08:37:57 +0200 (CEST)
Date: Tue, 2 Jul 2024 08:37:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Allison Henderson <allison.henderson@oracle.com>,
	catherine.hoang@oracle.com, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 23/24] mkfs: Add parent pointers during protofile
 creation
Message-ID: <20240702063756.GG24549@lst.de>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs> <171988121418.2009260.2932252649175356725.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988121418.2009260.2932252649175356725.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
