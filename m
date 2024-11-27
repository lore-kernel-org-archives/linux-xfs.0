Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342B8200132;
	Wed, 27 Nov 2024 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732725344; cv=none; b=rkyG7um2Db/EyrzNXQ1at7jBZWawk8xFmxYSfOcE3wOcVobeg/AYjdLnLTZAQ7Ocm2mHtKV3Mn4XaHeiXQGAbRmUv2X2XReFs2LB92ZW3wuPgcj9E4cQ9rD+x5gNz/EI5+Hb/zpIATGg4BYDm7tw4yvXHrBzQoQjrTxwUJcSR5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732725344; c=relaxed/simple;
	bh=UEd+3zNPwj1r5T3Kg0hZHbxmUUi1LYnRRY2GM+gt1lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FH0o5jc0JqWJnVHcD2+gzSG5cSso99K0pcnecA1AvalMEWq8qQY5UA7I6BlbQX6roWkKz4uRSyjm+jpccIC1s+5dXJSS3YatPu6KExNLdXxWBLYsmdz1LwZAhaB4otMAt7Q/ehYCfOcYPPNrdQNJWBnEPKT8uSlGLHOvBz8qnsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lrZ6g2Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lrZ6g2Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB912C4CED2;
	Wed, 27 Nov 2024 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732725343;
	bh=UEd+3zNPwj1r5T3Kg0hZHbxmUUi1LYnRRY2GM+gt1lc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lrZ6g2Gt/Ap5r3f3sFp0SbUEkh6fFbUbQ0pLIQ1D6rnH13qJFr/+iDSJtBV2rDnEG
	 JeyVvnyAFwoHcgROQZcgEJQMa2iy11JtC9RYqaCLAyljwvdkpxwhTOT9fUVF9uWrEn
	 k59Jc3vNLHKT68kCSv9f+WmOU7DcHo3vDRHUPRJTX1jLfu4fvkZOmBarsBdUinEPzV
	 dJFxjcp0xIZI5igFaNgMelAy3gHaTZyL9gmbMNmf5DYdF4oimn7j44mDrjscnOJiXx
	 RIV5ShLT+W3j2TszeH9eWX06n+uPFYNUDmVuA+ZNpEFFZVMCULFohko4578hGdRI2E
	 eaNq0e2XaVYlQ==
Date: Wed, 27 Nov 2024 08:35:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, zlang@kernel.org, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/16] generic/459: prevent collisions between test VMs
 backed by a shared disk pool
Message-ID: <20241127163543.GU9438@frogsfrogsfrogs>
References: <20241126011838.GI9438@frogsfrogsfrogs>
 <173258395050.4031902.8257740212723106524.stgit@frogsfrogsfrogs>
 <20241126202729.GP9438@frogsfrogsfrogs>
 <Z0axjgDuiC5m-xUO@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0axjgDuiC5m-xUO@infradead.org>

On Tue, Nov 26, 2024 at 09:43:42PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 26, 2024 at 12:27:29PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If you happen to be running fstests on a bunch of VMs and the VMs all
> > have access to a shared disk pool, then it's possible that two VMs could
> > be running generic/459 at exactly the same time.  In that case, it's a
> > VERY bad thing to have two nodes trying to create an LVM volume group
> > named "vg_459" because one node will succeed, after which the other node
> > will see the vg_459 volume group that it didn't create:
> > 
> >   A volume group called vg_459 already exists.
> >   Logical volume pool_459 already exists in Volume group vg_459.
> >   Logical Volume "lv_459" already exists in volume group "vg_459"
> > 
> > But then, because this is bash, we don't abort the test script and
> > continue executing.  If we're lucky this fails when /dev/vg_459/lv_459
> > disappears before mkfs can run:
> 
> How the F.. do the VG names leak out of the VM scope?

I ran fstests-xfs on my fstests-ocfs2 cluster, wherein all nodes have
write access to all disks because we're all one big happy fleet.  Each
node gets a list of which disks it can use for fstests so in theory
there's no overlap ... until two machines tried to create LVM VGs with
the same name at exactly the same time and tripped.  A sane prod system
would adjust the access controls per fstests run but I'm too lazy to do
that every night.

(Yeah, I just confessed to occasionally fstesting ocfs2.)

> That being said, the unique names looks fine to me, so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
