Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8A6179BC;
	Sat,  2 Mar 2024 14:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709388106; cv=none; b=PB8LTV8mctnXcVSHQVKiswb3MJXHcGw2gBzFFb2LZqEiA1XWzraXN58apg07Sj2+2QjndQKCWQiAC1U4q6sb/euvfnhh/DaqOfUKQy180geVPMkOJGGgiQhtkybB8nZj1qfkTJPNivCgZ4A8xJgocIlLbdZC5QWRtv8rXm2KG84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709388106; c=relaxed/simple;
	bh=T+eWyvhiHxks5GPZJvK34JMkOwJq4Lhiy22/9cVRn3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mC830ZFdM/QkvWY0IFBcp2W04nUAeMs32q+LYLRG50hwHvzo7fqzrILfI/S+Bn9PD3rmiKYIO9ghhaW2KswbrrnyJ+YMFNe6Lv2q9kCpT/RAF3ocPCVd8fVJbH5ivqhczczH7mYt+DxzquGgZvacAfmNtJ3mLGHAHuCNQ7UwIGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 46C3A67373; Sat,  2 Mar 2024 15:01:41 +0100 (CET)
Date: Sat, 2 Mar 2024 15:01:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240302140141.GA1170@lst.de>
References: <20240301152820.1149483-1-hch@lst.de> <20240301174756.GG1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240301174756.GG1927156@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 01, 2024 at 09:47:56AM -0800, Darrick J. Wong wrote:
> Might want to leave a comment here about why xfs uses $loop_dev unlike
> the other clauses that use $img_file

Well, as I tried to explain in my commit message running it against
the file always seemed weird.  The loop device is the canonical place
to run fs tools against.  I can throw in a cleanup patch to also do
this for the other file systems.

