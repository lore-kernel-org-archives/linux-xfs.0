Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBBB11198
	for <linux-xfs@vger.kernel.org>; Mon,  5 Feb 2024 06:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707115529; cv=none; b=MlS33Zrc8gydlmBWiexhlZqvROGPeHF5j8ejBgZrC/XlSAnWtmtLBvy9rzQYSWb8heFB1ZCpRSpdFdw7fnxPu/EcVYgIlx7JaQGMjwYDYJc4Pn5UOIegSSIbjn4EYEzTZMVbRe0ppcMnCcMFi4WaNjc4UXs5HUzV0ZcAyfZT9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707115529; c=relaxed/simple;
	bh=g4HnpUBNuh+h8+VzqKt9YmfDla2C6EhCPYVGMztXMiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AvfrPiOOqv445WQaj82i79xjo0becf6yZxCzq3X4DVS09ZWXRgH0deyx1cjm+ErizHi16LyhYnZ6gHxkc8a42LVgE7m2PNZOy/v0YGdnqP+NQY3sn5CfY7h8VdZrRysijx/2itvOyRFdS3AvK72tXpkSP+8BSxv839INMJO2jtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nfNut5Qm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nfNut5Qm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jcJ7AL9FUpX8TD4+SQJsm4jsHslRBM23bjoCU/QKrSc=; b=nfNut5QmUGMEgEP8ZxqtP8DN3a
	jrEROhtf3yiVz8UVtRX3HhPY3WP8uaCpymJFrk5wlKiYjl2Lt2bZcV0qZHvAEN1CnLTnsYZf/vqld
	OldyiXfkOKOZqcmhlkC5M+2RS+lqCnxuvyVkDtN0kgmHIdLWJv9NZDoSr+ZciITliuEk1ODOnKieT
	4hcQQH3ksr3CIXJhcc6sdibpUTKncY7WJVehRYVABb7QA82pt0+/VOjrvvxtgqpBp8zhmSTzryVE6
	svaX/Kf9kRYb8GUov/8hHHqnH5n1fJRq35/etshPcMGDwAvq6XiEQbK+4bj0WaeZDCamsc351ycd2
	nh1WD84g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rWsjP-00000002C44-072W;
	Mon, 05 Feb 2024 06:45:27 +0000
Date: Sun, 4 Feb 2024 22:45:26 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: xfs_clear_incompat_log_features considered harmful?
Message-ID: <ZcCEBkVrMUBeXu78@infradead.org>
References: <20240131230043.GA6180@frogsfrogsfrogs>
 <ZcA1Q5gvboA/uFCC@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcA1Q5gvboA/uFCC@dread.disaster.area>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Feb 05, 2024 at 12:09:23PM +1100, Dave Chinner wrote:
> The issue arises if the host tries to mount the guest VM image to
> configure the clone of a golden image prior to first start. If there
> are log incompat fields set in the golden image that was generated
> by a newer kernel/OS image builder then the provisioning
> host cannot mount the filesystem even though the log is clean and
> recovery is unnecessary to mount the filesystem.

Well, even with the current code base in Darrick's queue a mount alone
won't upgrade features, you need to do an explicit exchrange or online
repair operation.  And I think we should basically never do log or
other format incompatible changes without an explicit user action.
The only exception would be if the feature is so old that we finally
want to get rid of the old implementation, in which case we can think
of automatically doing the upgrade with a big fat warning.

> Hence on unmount we really want the journal contents based log
> incompat bits cleared because there is nothing incompatible in the
> log and so there is no reason to prevent older kernels from
> mounting the filesytsem.

Doing the clearing at unmount time only (and maybe freeze if someone
really cares) sounds perfectly fine.

