Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430638DE9;
	Tue, 15 Oct 2024 03:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728963570; cv=none; b=P9TZtp43BcuXJMTlHpmPVF8RNu9hww/tg6Dptv5SL3A09c+SX42bNmgF11xZ9HWeCT5QdUsQnH0jmbA4+L/Mx7UjYJv/R1Ay9FEWV8Zay39+mfZSM+00RjTzb6CS4DndI1rG4T33KynMwjxfJpQTcUcZnfdfSr29urSQSjXQMak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728963570; c=relaxed/simple;
	bh=eZvEyZ5jVyn4switoDz7DVocaz1Nx8UTN5/eDVA4pFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYHRH7gn64LNszHY845WymgIIp1BaMkXpr0qzmCbENG2W9mT11zeUkMBQupOzeWYuy6tcWpr5a3FCQoY6dNz/TsIcbU/pb3q+KZiO1iZ3O/5qeLkwyiTGW/Yvo6vFgDWmmPYv4rR2qHbgcJuHME2GN93tM3okqVrci+KBz/zwXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DF3FD227AA8; Tue, 15 Oct 2024 05:39:23 +0200 (CEST)
Date: Tue, 15 Oct 2024 05:39:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20241015033923.GA15971@lst.de>
References: <20240924084551.1802795-1-hch@lst.de> <20240924084551.1802795-2-hch@lst.de> <20241001145944.GE21840@frogsfrogsfrogs> <20241013174936.og4m2yopfh26ygwm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20241014060725.GA20751@lst.de> <20241014152428.GQ21840@frogsfrogsfrogs> <20241014174650.wms62e3ogzilcnn5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014174650.wms62e3ogzilcnn5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Oct 15, 2024 at 01:46:50AM +0800, Zorro Lang wrote:
> >From the output we can see the sector size is 4096.
> The mount option is "-o dax=always/inode/never", no more, without external
> log device, no rtdev.

Hmm.  Given how unreliable these tests are maybe we should just drop
them given that they are trying to verify optimal expected behavior and
not just correctness.  Maybe Dave who originally wrote them can chime
in.

