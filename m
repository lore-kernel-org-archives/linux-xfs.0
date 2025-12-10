Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550F51A4F3C
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 06:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765347982; cv=none; b=Pd8t0D5X4ejoK/OtFK1I2mszDWu49BgrfgxVKPBO+NYYyod2xGVD0WDO6itybzlRuZ+rEhrhPxWvht625uOip6sf1PNiWXygWJvcMs1ruttxB9AfY30O5cYfVMd41ZClOE4dTEKfvomTSBNfdC+w1lkZ9kSuXCIoPn4cFtA9M+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765347982; c=relaxed/simple;
	bh=pwhe3OTf4yc8eQT1/rV0rGgZoKbaYeMupg/ITdt3ScI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AM8BYL9IbdeRqB4P2SDckXuzt9KjvpdtjKvvxwxB2nsEPIOF0qTrvKyInbRENGnl4L6XtZtC0yxnmdgN61uffYvihneUjVgQUFow1i6DpbxQ66dRePztMWafk6e8VpIJxSdTPjJ97bNrtfXu/LgCyBm3aLKL4luGy20t7GFNTOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m5lVaV8P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m5lVaV8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF071C4CEF1;
	Wed, 10 Dec 2025 06:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765347980;
	bh=pwhe3OTf4yc8eQT1/rV0rGgZoKbaYeMupg/ITdt3ScI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m5lVaV8PA6VWzqoxdhDPMtJlClinnFGtpIYOMZC9ZYwMklmhG0ftJRi86gK0MRO4J
	 gV+fHlvvc2Cg+LMO2kjVobZHu8BauMkBBKaQSSXrFWyC1boBwpKmQoP4eW017ekv1g
	 hrzwXcxjbiEAt+lt318WLDEHh5G9K9m/Y++vfZA5tNrPQSMrQYSBQNtIR9An4OI/eY
	 YFGarvEUTDVptWPjNO7Fw4XtpjRjUMsA04SJoQCHbVFuN6ipDBRVhqXD5gsuaHgb+g
	 AhAMXsNroQCvzEP+SjQPS48/xjgQ3/eqvATgQU+aERpwcHUE2Ein4sswP1nEcRahFQ
	 ceflXJD3snLjw==
Date: Tue, 9 Dec 2025 22:26:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_logprint: fix pointer bug
Message-ID: <20251210062620.GC7753@frogsfrogsfrogs>
References: <20251209205738.GY89472@frogsfrogsfrogs>
 <aTkEXwp2zbbAI_jI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTkEXwp2zbbAI_jI@infradead.org>

On Tue, Dec 09, 2025 at 09:25:51PM -0800, Christoph Hellwig wrote:
> On Tue, Dec 09, 2025 at 12:57:38PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > generic/055 captures a crash in xfs_logprint due to an incorrect
> > refactoring trying to increment a pointer-to-pointer whereas before it
> > incremented a pointer.
> 
> Oops, sorry.  This somehow did not show up in xfstests for me, where
> did you run into it?

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 ca-nfsdev5-mtr00 6.18.0-xfsx #6 SMP PREEMPT_DYNAMIC Tue Dec  9 10:29:14 PST 2025
MKFS_OPTIONS  -- -f -m metadir=1,autofsck=1,uquota,gquota,pquota, -n size=8k, /dev/sdf
MOUNT_OPTIONS -- /dev/sdf /opt

> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Full log here
https://djwong.org/fstests/output/ca-nfsdev5-mtr00/ca-nfsdev5-mtr00_2025-12-09_18-36-11/generic_055.full.br

user aibots
pass suck

--D
