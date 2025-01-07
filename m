Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF8193402
	for <linux-xfs@vger.kernel.org>; Tue,  7 Jan 2025 22:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736287882; cv=none; b=DST2noLu6+Z8auk5s9lmkv2ZH28OwKaWPbwNbEyPVY+/TfwkGUZnfthsoK1r1HotmZun3q0zKGsIVh3mFPC5Bnk+ccThjFC0ewoGOP2K789eQkoGZr0T7BYOTTWsKctuK/9cBOyByNrc+ua9gUMckE8AgKj1+36CgXqUVNJBV+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736287882; c=relaxed/simple;
	bh=C7bQMkP/70kTjzY87IvYTMnwGOI+q7RvMWxNfv34oQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pTSuY924B5EnaJrHeGK6W2c/MODoWWhd5NoZpBGRqzd/c18EKrQAjMKbhLQIWufBPdNtX2QRBJZT9QrzrvBMTBO68GDQT9Pps9tg/aLbXCjpjqAKz5nJVgAVtnHd11GQd0rT8r/cGBzk3dk/R12+d7cEd7jSw7fil7XPqQ5cbB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oSLanviR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oSLanviR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613E2C4CED6;
	Tue,  7 Jan 2025 22:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736287882;
	bh=C7bQMkP/70kTjzY87IvYTMnwGOI+q7RvMWxNfv34oQo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oSLanviRYxjMAgEPRxm2EhUNcBwsaTu5nDpCur2fHjkepMyU1k/JgsqOl395rR+GR
	 wSW7PZExxTGIr4IvVLvjhfY6Lv5P6lqTy4+gffbgseF8i6LebR3t+0eMtyn52Jbr46
	 eqp0IWr3/05wETexkqJfzLgxPLTELp5beo9bRdHjhbXL0edhJcNCA4aLII4S4mL1Y/
	 F1f8g6sX+Ri4MpJuiyEMSKLb8q+ZuLeTBvyaNK8qhOSQOlip4I8imlqimH164xepK4
	 loEelz3I6Wt8AyAg1QMIyJCiSikX6ovVGodXiAu6XKbaAZOdYrrugbkkuyeqTFoSHD
	 qH5tvy0t4STUg==
Date: Tue, 7 Jan 2025 14:11:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Sai Chaitanya Mitta <mittachaitu@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: Approach to quickly zeroing large XFS file (or) tool to mark XFS
 file extents as written
Message-ID: <20250107221121.GK6174@frogsfrogsfrogs>
References: <CAN=PFfLfRFE9g_9UveWmAuc5_Pp_ihmc7x_po0e6=sTt2dynBQ@mail.gmail.com>
 <20241223215317.GR6174@frogsfrogsfrogs>
 <CAN=PFfKDd=Y=14re01hY970JJNG7QCKUb6NOiZisQ0WWNmhcsw@mail.gmail.com>
 <20250106194639.GH6174@frogsfrogsfrogs>
 <Z3zGS9Ha13I8VBtI@infradead.org>
 <20250107070459.GI6174@frogsfrogsfrogs>
 <Z3znwD53VIBdrlbL@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3znwD53VIBdrlbL@infradead.org>

On Tue, Jan 07, 2025 at 12:37:20AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 06, 2025 at 11:04:59PM -0800, Darrick J. Wong wrote:
> > I get this funny feeling that a lot of programs might like to lease
> > space and get told by the kernel when someone wants/took it back.
> > Swapfiles and lilo ftw.
> 
> Well, for swapfiles we can't really take them back.  Similarly the lilo
> model is just broken as any chance of the mapping would actually require
> re-installing the boot load in the boot block pointing to the blocks.

I bet the rdma users might like a lease that can't be taken back.  We
/did/ talk a hojillion years ago at LSFMM about having a type of lease
that expires when someone tries to change the file; and a different type
of lease that can't expire but causes file operations to error out.

OTOH it's not like I've ever tried to solve this problem. :P

--D
