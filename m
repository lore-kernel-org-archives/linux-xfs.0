Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D55C28F948;
	Thu,  2 Jul 2026 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988598; cv=none; b=QBsynNCIhBLtyQbTuPux5wp5qlR259O0GnMMZrRDu/cF/+bOn0K9EsrRKPPwpQVL91MRqiNn7AR05320buHhwmdvCj0BXOrNBbcx6fABu8fxvrhCrry4+jENKxD1tPFP9PzTZet8atVdddIZ/OcaMncjpfQqOmj3e0sXuls97hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988598; c=relaxed/simple;
	bh=Ozzoea/78JW/BPQvJdWnL+J5DzMh/dl8GR4PjvN4cBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCLaS5uB2kIPvVJCoOHyFCT5CC1ov/3WNeR/uZLMT0RAgJhk4rTTwUsG1e7jtKHHSlYoOh+FOYTrc6+22lew4QbAG+M1XmAzpdHxlXQmA7W5Kd843RsAFzS70qJEjt+3XAKqxQ4+pJEDRkJz9pqF+gpldVlStUDhlqmGoOFZGVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DD1E568BEB; Thu,  2 Jul 2026 12:36:33 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:36:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: Re: [PATCH 2/2] xfs/65[56]: don't unset SCRATCH_RTDEV here
Message-ID: <20260702103633.GC6816@lst.de>
References: <20260702035523.GA9381@frogsfrogsfrogs> <20260702035759.GB9381@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702035759.GB9381@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 01, 2026 at 08:57:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Both of these tests claim that they have to unset SCRATCH_RTDEV to avoid
> formatting failures due to the rt bitmap consuming all the space in the
> "small" data device.  However, the format doesn't constrain the size of
> the data device, so the justification doesn't apply.  Remove the whole
> thing.

Looks good, but as-is clashes with my
"formalize and fix disabling the RT subvolume" patch.  It might make
sense to take these two patches first, and then modified version
of

"formalize and fix disabling the RT subvolume"

and

"common: skip data write EIO survival tests on fatal configs"

on top of that.

