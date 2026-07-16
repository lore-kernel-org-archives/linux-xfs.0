Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E99142BEA4;
	Thu, 16 Jul 2026 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784214814; cv=none; b=FgcoHPud235k8u27GbdACgCZ+yg54ADzh+X5YoJ3vwPHQiG2Md1/zvQa9drZ6knueEOtPzI9MpBtOrqJ9Qnn9A9eNBY8bE3PU1CHpyoVC+i+4xJFVBg4dpEOAS8oSa0crMqPBj9+9VqFXyCkDnG3GsRUAPaS09rbLkuaPCX947Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784214814; c=relaxed/simple;
	bh=Dg3PimtZ3YU9WQzgCHjBfTgZrQnXzSp+xYrMN1mqk8U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OEOOLP3TSg/XLqMDY6Ut4vIH2duY7CnlP+372SSDb9l6Z3OdaIkoo47R9IEA2OW0nmD5D+ZRgRaNy8PaIC6O82FUaxb/gadCoHwL8OLYiCpd6HG7gMbVCnnFRAyAXjP3Js+vjH5f4tRJ7W1twNR15T1Wahmc6KjGgH28fV0i8tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpJ1ApkF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpJ1ApkF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 65DC61F000E9;
	Thu, 16 Jul 2026 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784214810;
	bh=Nq0o8IkFTSpTPiywOhNUd0Fd8PqK4m+L+GHFzFxFWFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SpJ1ApkFaNCt0lDWPQBfR1F/YdT8kTt9L2dCVh2Db5gLLYhsf87r4iDbOyQbBqXgq
	 KuZ6zgFyiEQDaCZC9to9zRiXEo3dNVAT+IK09QfnyXfG5t6v+lCpYEKlgO8rAWaYbM
	 tNywgi9CKXqcA0dM3DGW3EkWXUVeFyVDCSdAz54/Dq6szLgZ5lBcz/5EHWzCKwDbtT
	 QEo08hHH7aP9cbdYsCBze0+9GnTHogbGa0XQDIgu78ALlP7I+DIkdIH+8s3lOv7UG5
	 vXg4Wx1HhWAUYE5opl4c05csB/7roxQB7XxPCAoPsKcZVL/yyJiP0txtDgeYWO3Se4
	 e7r3xnT6RimaA==
Date: Thu, 16 Jul 2026 08:13:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Avinesh Kumar <avinesh.kumar@suse.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, cem@kernel.org
Subject: Re: [RFC PATCH] libfrog: make cmn_err() emit each message atomically
 to avoid torn output
Message-ID: <20260716151329.GA7371@frogsfrogsfrogs>
References: <20260715173114.359368-1-avinesh.kumar@suse.com>
 <20260715190949.GP7380@frogsfrogsfrogs>
 <3d71046a-2fab-4eab-8f0d-d97c3a5bab88@suse.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d71046a-2fab-4eab-8f0d-d97c3a5bab88@suse.com>

On Thu, Jul 16, 2026 at 09:44:28AM +0200, Avinesh Kumar wrote:
> Hello Darrick,
> 
> 
> On 7/15/26 9:09 PM, Darrick J. Wong wrote:
> > On Wed, Jul 15, 2026 at 07:28:21PM +0200, Avinesh Kumar wrote:
> > > From: Avinesh Kumar <avinesh.kumar@suse.com>
> > > 
> > > fstests xfs/033 fails sporadically with a spurious blank line in the
> > > xfs_repair output:
> > > 
> > > - output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
> > >      --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
> > >      +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
> > >      @@ -103,6 +103,7 @@
> > >       Phase 3 - for each AG...
> > >               - scan and clear agi unlinked lists...
> > >               - process known inodes and perform inode discovery...
> > >      +
> > >       bad magic number 0xffff on inode INO
> > >       bad version number 0xffffffff on inode INO
> > >       inode identifier 18446744073709551615 mismatch on inode INO
> > > 
> > > Root cause is in cmn_err() (libfrog/util.c), which emits a message
> > > and its newline as two separate writes to unbuffered stderr.
> > > xfs_repair's threads all share stderr. If one is preempted between the
> > > two writes, another thread's line lands in between:
> > > 
> > > (snips from `cat -A 033.raw`) -
> > > Phase 3 - for each AG...$
> > >          - scan and clear agi unlinked lists...$
> > >          - process known inodes and perform inode discovery...$
> > > Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
> > > $
> > > bad CRC for inode 128$
> > > bad magic number 0x0 on inode 128$
> > > 
> > > which should be like -
> > > 
> > > Phase 3 - for each AG...$
> > >          - scan and clear agi unlinked lists...$
> > >          - process known inodes and perform inode discovery...$
> > > Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
> > >          - agno = 0$
> > > bad CRC for inode 130$
> > > bad magic number 0x0 on inode 130$
> > > 
> > > _filter_repair() strips the noise line it glued onto but not the lone
> > > newline, which then fails the golden diff.
> > > 
> > > Make the two writes atomic.
> > > 
> > > Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
> > > ---
> > > 
> > > Hi, please give feedback if this should be fixed in a different way.
> > > Thanks!
> > > 
> > >   libfrog/util.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/libfrog/util.c b/libfrog/util.c
> > > index 5bae5bab..3b6df917 100644
> > > --- a/libfrog/util.c
> > > +++ b/libfrog/util.c
> > > @@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
> > >   	va_list	ap;
> > >   	va_start(ap, fmt);
> > > +	flockfile(stderr);
> > >   	vfprintf(stderr, fmt, ap);
> > >   	fputs("\n", stderr);
> > > +	funlockfile(stderr);
> > 
> > I think do_error() in xfs_repair.c is going to need the same treatment
> > but otherwise this chunk looks ok to me.
> > 
> Thanks for the review. I can send a follow up patch for do_error(),
> or do you want these to go in the same patch?

They probably ought to be in the same patch.

--D

> Regards,
> Avinesh
> 
> > --D
> > 
> > >   	va_end(ap);
> > >   }
> > > -- 
> > > 2.55.0
> > > 
> > > 
> 
> 
