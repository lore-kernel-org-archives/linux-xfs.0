Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEB415ADAB;
	Fri, 22 Nov 2024 16:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292421; cv=none; b=lh7Zi+0x/Lcw6n7zq3VNy8FARO/FOWGAM0fijMj8PNqDVMNnjR33cMpiw5ZABK+BdILqSTcC3viSWm7Q4PMA1Ukd0g0sIy7Zft+YtcfoIwAuGd3WLIN5PMTvrusC+G1EFpZyeI/bnLJ2nIkROkuAqKr8Hibt8rudYnU17KBsu14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292421; c=relaxed/simple;
	bh=+ZtcEuy8NV/VMJuW+Sg2uKkFa4qT14dAIKFpAO5bDos=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAzLpQqDkKRmm0KOcN65ZYZhKZK24tH7UDB9YUimLJ1vFImMRC8DuOZzXL9ywcOLXG82ZBlDaFvokMp/B/X3xHwbunVJhljVlGmsrwixjnwYWQtWpnLio23yOkiQkYC69SOzPTWAW3fIQ8QHVzmGEi21BPjApx8S+XYj1OE0ZmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B337668C7B; Fri, 22 Nov 2024 17:20:15 +0100 (CET)
Date: Fri, 22 Nov 2024 17:20:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122162015.GA8053@lst.de>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs> <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs> <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241121100555.GA4176@lst.de> <Zz8nWa1xGm7c2FHt@bfoster> <20241121131239.GA28064@lst.de> <Zz8_rFRio0vp07rd@bfoster> <20241122123133.GA26198@lst.de> <Z0CL9mrUeHxgwFFg@bfoster> <20241122161347.GA9425@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241122161347.GA9425@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Nov 22, 2024 at 08:13:47AM -0800, Darrick J. Wong wrote:
> I guess I can add yet another patch to switch the replay program to use
> BLKDISCARD if the _init function thinks it's ok, but seriously... you
> guys need to send start sending patches implementing the new
> functionality that you suggest.

I can look into the refactoring and the comments, I wasn't planning
to offload the work onto you, just making sure we have robust
infrastructure.

