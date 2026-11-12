Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794491079;
	b=2ydJH8Tcnfr5ReYrDc/7JWH8S6wZ/LquFZVd2H95NJyR4lQ0YPMR9X34de94b4/x6Gxp
	 NFDe49dfNvDGT7s/DxjIMo4v+mA8eHqeuesDWxMbzzTF/dmf2qIpiAfH3xYHQv4TQtEpf
	 7dWZNrVloYohHzElhxOOZbMWxymZFzLgZ0OHH59HIK9qHSGPhSKZvk1tExGJqEwZiD9ph
	 KJRZgEzCGZEZC6LbxlSRTdWrplGHnnaC6cX3Q2Ftd617bYCStlKE6rf1oog8HG2GdjKCX
	 MVU613ktZ3zDnBK/AWaGHgF+YWD7lESA93TKBAGwRp4S7787vkJthV0pY52wDH8gV+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794491079;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=huV7xmuDVdG97XQMo4Y+bmwA9xBpsETbVZrx/+nEpOw=;
	b=H2lZA1ranDIdM3v6urkuceHJ4vz9gQ/Jqsp0RQdSzZpQk2blmK5L0KMoG+CvMwMtWvdX
	 w9LTBQDhtDlwHxgG//upIXCx33slXqOorkJIS/uc5O2b69++oS89fs+/1Q2Opz4I+kzAX
	 LzuX18EpeH9konr0UgU4IEPbDJ48ubZ5+WJYKtfl3JKRHvBevJqHFd+x6QzXA20xAmRg+
	 xfUvFCesYy831N7uhM9GQJlmBUWiKRyvUDRiPFq7iLUo0ZOSH08FNq1GhhirnGsFvOSvW
	 0IlFO4MYHffunvRTOd7svWpY58DF0NqTTA9NKw0Iu5C6s653hGaqOgBwxK+kSU/hMvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60426606A321;
	Thu, 12 Nov 2026 13:44:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60426606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3446F68D05; Thu, 12 Nov 2026 14:44:35 +0100 (CET)
Date: Thu, 12 Nov 2026 14:44:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix f_bfree underflow in statfs()
Message-ID: <20261112134434.GA23459@lst.de>
References: <20261112102018.3922571-1-hengyul@cs.unc.edu>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112102018.3922571-1-hengyul@cs.unc.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 12, 2026 at 05:20:18AM -0500, Hengyu Liang wrote:
> The issue can be reproduced on a new 2 GiB filesystem mounted on /mnt:
> 
>     for i in $(seq 3000); do head -c 65536 /dev/zero > /mnt/s$i; done
>     dd if=/dev/zero of=/mnt/big bs=1M
>     xfs_io -x -c 'resblks 100000000' /mnt
>     for i in $(seq 1 2 3000); do rm /mnt/s$i; done
>     sync
>     df -h /mnt

Can you add this to xfstests?

The fix itself looks good, thanks a lot!

Reviewed-by: Christoph Hellwig <hch@lst.de>
