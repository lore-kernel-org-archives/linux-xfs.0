Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01C8380FC8;
	Wed,  1 Jul 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782924677; cv=none; b=DIsFQyqX2/UEUU2Sn2PiNe5B0UHzxeBV6FDsoWH9wV2kUKHsRkCVdN+Mdx29vPxFlxgO2B6GE5LPYhgWk7/F0z2jOoptQr9wvSGKxr12WnAMznpoA0Hg0PqunHGmcsRsy5omyZkEn6PUpYYsoJn0h1VF7GmEDn8SavYeaEuNHdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782924677; c=relaxed/simple;
	bh=EYP5arDyGi7fz26M9TZiGv6ud9/psm5TcbBtahukErk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDn0LWuK8EgKkg1a2t44f7iJ4FTzXvZFfA57R4wAbVtpbjIzLuf3Pd25Oc9a2vvRkU1Lq5maWcvnsOSHyAuiNQRs8dpFkJrYFKO1DiqlfS1EA/DjlOK5xTUjiTchtkX8xQbcPC/klh91p+ztb75euGPPOD51sxCCKVCT9rIE2WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYETbx4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYETbx4a"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7EB351F00A3A;
	Wed,  1 Jul 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782924675;
	bh=/b9Qoezp1LeZCVOXRFvruSnjgPbii7q8EmhExl4OPsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gYETbx4a/vn0DBNum1/xlkId2YrcyQ1MNy79e3zIliP1NoZj9J+GZ/ilNeejl6q+T
	 oIJXFsDhc8Oyewgh+Yd5plDCcAzco0Pc2r5IjOm9MLyegM0cBCtVnJT3tPqXzbXCCz
	 IIjHtpj6NFfImId45Nl3us47JoohxprKdKwO7xjfBQE1xLvo6ZvAzCB6GaG3bZQ82i
	 RV+ExjLJOgjDqB/sUIV7lwGPl6X43LRNj65Z4lj8kF+zAYH39EQ/9jv6P+o0aYmvdS
	 9TGW0+DSEfQuaTGJEjOzqCxmKIIUmQ/udPTeC3nDlB2v3V9q9uH5epFWcblrbGuB/d
	 YcwDJHzVVmQcA==
Date: Wed, 1 Jul 2026 09:51:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: zlang@kernel.org, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] formalize and fix disabling the RT subvolume
Message-ID: <20260701165114.GD6517@frogsfrogsfrogs>
References: <20260630113526.3601287-1-hch@lst.de>
 <20260630184018.GB6544@frogsfrogsfrogs>
 <20260701105407.GA14404@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701105407.GA14404@lst.de>

On Wed, Jul 01, 2026 at 12:54:07PM +0200, Christoph Hellwig wrote:
> On Tue, Jun 30, 2026 at 11:40:18AM -0700, Darrick J. Wong wrote:
> > On Tue, Jun 30, 2026 at 01:35:26PM +0200, Christoph Hellwig wrote:
> > > Various test unset SCRATCH_RTDEV to avoid dealing with metadata
> > > allocations for the RT subvolume in the main device or differences
> > > in RT subvolume behavior.  Besides being rather ad-hoc, this unset
> > > also fails to disable the internal RT zoned subvolume.
> > > 
> > > Add a _disable_scratch_realtime helper that not only unsets
> > > SCRATCH_RTDEV, but also disables the zoned allocator and with
> > > that the internal RT subvolume.
> > 
> > What if we want to run these tests on the internal rt volume?
> 
> Then we need to stop disabling the RT volume for them..

Ahaha ok with this patch applied, the regressions I see in generic/441
and xfs/656 go away.  generic/441 chokes because the scratch fs goes
down due to writeback error, so I assume it's ok to start excluding this
test.

xfs/656 is a different story:

--- /run/fstests/bin/tests/xfs/656.out	2026-03-13 16:19:08.152939212 -0700
+++ /run/fstests/logs/xfs/656.out.bad	2026-06-30 18:16:43.847849604 -0700
@@ -1,10 +1,9 @@
 QA output created by 656
 Format and mount
 pwrite: Input/output error
-pread: Input/output error
+stat: Input/output error
 pread: Input/output error
 fsync: Input/output error
 VICTIM pos NUM len NUM: directio_write: Input/output error
-VICTIM pos NUM len NUM: directio_read: Input/output error
 VICTIM pos NUM len NUM: buffered_read: Input/output error
 VICTIM pos NUM len NUM: buffered_write: Input/output error

I'm guessing that the write failure takes down the filesystem, which is
why the subsequent xfs_io pread can't even open the file.

Also the comment in xfs/655 and 656 doesn't make sense:

 # Disable the scratch rt device to avoid test failures relating to the
 # rt bitmap consuming all the free space in our small data device.
 unset SCRATCH_RTDEV

We're creating a regular sized data device, so this shouldn't be an
issue.

Eh, whatever, I'll clean up those two healer tests. :)
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
