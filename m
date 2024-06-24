Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16B161FEB;
	Mon, 24 Jun 2024 08:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719218974; cv=none; b=DAC2FT/j6Jk6htcxS5duurzZGbGbS+wAtO9yPJBlKxl6aM6gnW/0COrWtM3uDYRNp53z6KRqGGRunc52ZdEjwtFAvme09FqdVt6Cs3XnofyO7PfDl+RPnIvMELimqaZhoVgBxB7rp8k6lYD9A8j2Df41LQXl51vV9d2gPdCvdb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719218974; c=relaxed/simple;
	bh=VoEQAphlN7iah+EDpEjJl8vNv0eihHLBQKEpXMiNtbs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msZGNLuUWlA5gyd9TnA6GeKguVWxK2XwGFKP51zHQYmL16rih95xbe3+6hDtFamvmVF/kQgRD0aa0shyWQw4vKI0KibbTExKxpE2f5vl1rqTGObq0BC0Z8OMS4nmXacEexGkoR5sP3TzIqjsv/4aK8kyJFjin/YJo9a+JUmcj2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AA21268C4E; Mon, 24 Jun 2024 10:49:28 +0200 (CEST)
Date: Mon, 24 Jun 2024 10:49:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: new EOF fragmentation tests
Message-ID: <20240624084928.GA20314@lst.de>
References: <20240623053900.857695-1-hch@lst.de> <20240623053900.857695-2-hch@lst.de> <20240623130301.s2r2fv5qjaspmcxi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240623130301.s2r2fv5qjaspmcxi@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jun 23, 2024 at 09:03:01PM +0800, Zorro Lang wrote:
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2019 Red Hat, Inc.  All Rights Reserved.
>                    ^^^^
> Should I keep "2019" or change it to 2024, or no matter :)

No Red Hat employee has touched this since 2019.  And my changes mostly
removed boilerplate code, so there isn't much of a point in adding
my copyright notice here.

> > +_scratch_mkfs 2>&1 >> $seqres.full
> 
> Wrong order:) ">>$seqres.full 2>&1"

Ok.

> If a case has background process, better to do kill&wait in _cleanup,
> for unexpected Ctrl^C when fstests is running. e.g.

Ok.

> 
> _cleanup{}
> {
> 	# try to kill all background processes
> 	wait
> 	cd /
> 	rm -r -f $tmp.*
> }
> 
> I'm not sure if there's a good to way to do "kill all background
> processes" in this case, or if it's necessary. But a "wait" might
> be worth, to avoid the "Device Busy" error. Any thoughts?

No really sure, but I'll play around with a few variants.

