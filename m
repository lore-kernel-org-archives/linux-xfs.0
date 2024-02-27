Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C9C1B28D;
	Tue, 27 Feb 2024 04:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709008047; cv=none; b=RaB5Ln+jsAiW99ALiBvOORt/x0SuSheRtDpqbIsLX8JGdBKPdIqK01EkjIKN6rbx3WsKH+0sIFz+QTz0PXu7nDI6tZUA5tVxpZq2rlCwKd9RHXbfQQestuntUSdiIWFxXqc/aMjDKO9ieIJlo+J9wBfxG+XxO2iEPdsNvj7tbwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709008047; c=relaxed/simple;
	bh=2drd5i8BlyHlJzgbdujBRo+4AWxOBcXNfRgccJwKWes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDXwz6+ytUvSNTDdG0kUWq1TaCu13I1prR7hxSy2Lb/SNfWEKhXhS3R0NOHD7drcPBKOI1AKCsrd5pb0u9AcN22WpaoQwweCZniHHMjt119eknMogv6t6HiTCWO4vf84SGaP1ZOWMMyNg/JD78qtmXUVkLWCzTOwUzwZMioJh9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rFGLPf4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rFGLPf4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0D7C433C7;
	Tue, 27 Feb 2024 04:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709008047;
	bh=2drd5i8BlyHlJzgbdujBRo+4AWxOBcXNfRgccJwKWes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rFGLPf4lBbH46kF2Scx6Y42jGun1cVmq91Mnp/kW6RrOY6gYFtn+JfbDiVWk+iO2R
	 UitElN14e/kJU/2dBVB0QIgYYdx4uh6ciEpHhxhLgtgfrkEjrsI64PCYHG1u18UG/V
	 X53hl7GfNRAI9gYYVY0IZqTi1wGLjdXDqtvZqGyKdRjiE0nMLrgaMF2APSKYBG5NAN
	 py+KbOWoTmAQre+JdRqXisUEa0dIch77WFp5FNfoHJj4s6qRhhehce6MQN8cUKo28J
	 HYogdXj3/DoXCiYHFsXhSYyEVAH32uP/KAMpjBcdJTirvXQHLUg081YEGdwwIkKhWc
	 79vlMDQZ4OwWw==
Date: Mon, 26 Feb 2024 20:27:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/8] generic/604: try to make race occur reliably
Message-ID: <20240227042726.GR616564@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915233.896550.17140520436176386775.stgit@frogsfrogsfrogs>
 <20240227040449.6qvvdk2k6bzoy6pr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227040449.6qvvdk2k6bzoy6pr@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Tue, Feb 27, 2024 at 12:04:49PM +0800, Zorro Lang wrote:
> On Mon, Feb 26, 2024 at 06:00:47PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This test will occasionaly fail like so:
> > 
> > --- /tmp/fstests/tests/generic/604.out	2024-02-03 12:08:52.349924277 -0800
> > +++ /var/tmp/fstests/generic/604.out.bad	2024-02-05 04:35:55.020000000 -0800
> > @@ -1,2 +1,5 @@
> >  QA output created by 604
> > -Silence is golden
> > +mount: /opt: /dev/sda4 already mounted on /opt.
> > +       dmesg(1) may have more information after failed mount system call.
> > +mount -o usrquota,grpquota,prjquota, /dev/sda4 /opt failed
> > +(see /var/tmp/fstests/generic/604.full for details)
> > 
> > As far as I can tell, the cause of this seems to be _scratch_mount
> > getting forked and exec'd before the backgrounded umount process has a
> > chance to enter the kernel.  When this occurs, the mount() system call
> > will return -EBUSY because this isn't an attempt to make a bind mount.
> > Slow things down slightly by stalling the mount by 10ms.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/generic/604 |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > 
> > diff --git a/tests/generic/604 b/tests/generic/604
> > index cc6a4b214f..a0dcdcd58e 100755
> > --- a/tests/generic/604
> > +++ b/tests/generic/604
> > @@ -24,10 +24,11 @@ _scratch_mount
> >  for i in $(seq 0 500); do
> >  	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
> >  done
> > -# For overlayfs, avoid unmouting the base fs after _scratch_mount
> > -# tries to mount the base fs
> > +# For overlayfs, avoid unmouting the base fs after _scratch_mount tries to
> > +# mount the base fs.  Delay the mount attempt by 0.1s in the hope that the
> > +# mount() call will try to lock s_umount /after/ umount has already taken it.
> >  $UMOUNT_PROG $SCRATCH_MNT &
> > -_scratch_mount
> > +sleep 0.01s ; _scratch_mount
> 
> 0.1s or 0.01s ? Above comment says 0.1s, but it sleeps 0.01s actually :)
> 
> The comment of g/604 says "Evicting dirty inodes can take a long time during
> umount." So how long time makes sense, how long is the bug?

/me has no idea. :/

The 10ms delay is a (racy bs) to try to to let the umount run just
enough that the mount will either end up blocked until the unmount
succeeds or find no contention and no mount either.

--D

> Thanks,
> Zorro
> 
> >  wait
> >  
> >  echo "Silence is golden"
> > 
> 
> 
