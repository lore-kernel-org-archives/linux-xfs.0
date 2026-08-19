Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E343009F2;
	Wed, 19 Aug 2026 05:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787118571; cv=none; b=CRSDGAH7PpaARCtBRXQcveIfxzYgrrPFjY0NXXK5Bl9I6l7xqDAbFxRi0mslUJ3NWIm9lZhLMG9xQJGeM5/H99nbFqSyUOmpPNDSPfhCdlY9ljkWI8sXFImpBOVxYUOLrDsxt/hpq4bUANRcQMtgQl5lHNCdix0e4VDRslZAp8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787118571; c=relaxed/simple;
	bh=sy9L4DcUrl9qtKaKqAz1Yxv5Qj49vXg1z0uI2UW7nZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plvIRXne6KvuIk71MysML3bd2rCd3UBwT5ggOMbyTbrU9ovL136JRXc06dpjrjmM1P0jwc97/3IIWide5hXZ3gVy1ks+NC2P+twpW4IHbTcEDjodZd2IP5eQgxQpvpVl6kTJdEIM6Mtublz8s+Y85sYIZIDGzotig4q502QlQoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3FA9068CFE; Wed, 19 Aug 2026 07:49:25 +0200 (CEST)
Date: Wed, 19 Aug 2026 07:49:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, djwong@kernel.org, ebiggers@kernel.org,
	Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org,
	david@fromorbit.com, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v15 00/25] fs-verity support for XFS with post EOF
 merkle tree
Message-ID: <20260819054925.GA32764@lst.de>
References: <20260814092448.1818082-1-aalbersh@kernel.org> <20260817070240.GA17371@lst.de> <aoMZaqbKxmp9lhKs@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMZaqbKxmp9lhKs@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 17, 2026 at 05:37:13PM +0200, Andrey Albershteyn wrote:
> > So let's hash
> > out how we want to handle this for the 7.4-rc merge window after the
> > dust for the current merges settles.
> 
> 7.3-rc?

I hope to have a version for review/comments out as soon as all
relevant trees are pulled by Linus.  Right now only the block tree
is still missing.

