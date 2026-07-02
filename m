Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4804C3A9861;
	Thu,  2 Jul 2026 10:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988032; cv=none; b=KcwIKun2I5d6tsq3K8yiiOErM8NCORfeHUo0CuVOgr2UGCLEAcjYgFDlFSfxqdgBcxPARO+3z1eL8kjC2uxsp/hTrxgyHkQvjDvnRrtbypnOnIwoooay7b60+qEUqiWQ32Xv2OR0JUHVNakiO9cj/Vuvv3t3AAY8DFefADPptPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988032; c=relaxed/simple;
	bh=Ii8HglSf588SoGDAT6pEq7kUdME/oJt1MpciuR55l2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fp8beeSFqgbgfHrrMK6P0kwlT4TofOzbO9frr+PlDiXvXndAYL24P53mZq91owk7l/w6dRJNmnKJey098IYPB//GloIAl334A2hYgXr6iPKEOiSa/BWy4nAVuZ/9JfOTgCEhl/7CepY3tZxBK0y9vj5uRk0V5nHILmhvm/rTa8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 35C9B68BEB; Thu,  2 Jul 2026 12:27:06 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:27:06 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Kelu Ye <yekelu1@huawei.com>, Yifan Zhao <zhaoyifan28@huawei.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.linux.dev,
	ntfs3@lists.linux.dev, linux-erofs@lists.ozlabs.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] iomap: consolidate bio submission
Message-ID: <20260702102705.GB6252@lst.de>
References: <20260629121750.3392300-2-hch@lst.de> <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-davon-kniegelenk-gedehnt-96476b242a09@brauner>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 01, 2026 at 03:27:40PM +0200, Christian Brauner wrote:
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.

Hmm, both this mail and the merge commit in git reference the first
commit instead of the cower letter.  Is there an issue with your
automation that made it miss the cover letter?
