Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8D4258ED9
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 23:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760398053; cv=none; b=Q6GzsHhe24cb/GIys2Q9OT5L9Su+/ehZdZp6jL8FyXbWKZVm2ixJA2J75d4Kch0hy81wTS6t3Sw+hhTB2fCAcaFuQUqRqdGczAWdp8H2zP15dKvqGXmgDq98Dqra5p4k4GOCLyXHzpo9jKgv38FMeHWax09IlrrmicoLDVHmBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760398053; c=relaxed/simple;
	bh=std2TnBT+fJSFxdWPBF5uWdpj9gLRbq23biPLeKY8PQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0itUCKGc8XTrQOIRP7lWq/OKafwMC7GxbbV7ZtG8ItippVztizecI6ojP4s3VW8s7UN8VNacvhwp4h/9vOjmXYcJq6dkwYfdP35Vi37GVAziFLdj3hUDhBZG5B/9UEUIPnMSJMs0/V5EDwlwmiBZphKEoYYBu3Wo+Uo9zZYySk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CopWADJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CopWADJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13876C4CEE7;
	Mon, 13 Oct 2025 23:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760398052;
	bh=std2TnBT+fJSFxdWPBF5uWdpj9gLRbq23biPLeKY8PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CopWADJkmrUJM+8QeFyIm6tA/vedVLb8id1/YlEv0hGOHeHotBMuYvM2rrils3UTZ
	 1KvdOu/QHVLAICD32K8vGX6iWQrH0u1jqGRCf/nEqMDD8bEIb1voeCk8zzUGP4AewS
	 7KgdzN3ZfkYw7V8X3E6LeUg1vsnM88GSODvURx2AoFdR/WQas0tRCa4fbKv6f7cx64
	 LcahXd4u1E86SpsgQGUutcXzU66omBkDtDTUaMfmXMaW1cRMYtUWaA0Q/EgcoTbamQ
	 Ddr9Jc1e97QLyjYKk8Id9di43pO35uI1Ftc5ZpC+O66wbz8oBRah23zAEVDcb2ifID
	 5zWMzUQkh9dCQ==
Date: Mon, 13 Oct 2025 16:27:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: 1116595@bugs.debian.org
Cc: Iustin Pop <iustin@debian.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: Bug#1116595: Packaging issue: xfs_scrub_all_fail.service
 NoNewPrivileges breaks emailing reports
Message-ID: <20251013232731.GQ6188@frogsfrogsfrogs>
References: <aNmt9M4e9Q6wqwxH%40teal.hq.k1024.org>
 <20251013174106.GN6188@frogsfrogsfrogs>
 <aO1calELgCjY8C7o@teal.hq.k1024.org>
 <aNmt9M4e9Q6wqwxH@teal.hq.k1024.org>
 <20251013223156.GF6215@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013223156.GF6215@frogsfrogsfrogs>

On Mon, Oct 13, 2025 at 03:31:56PM -0700, Darrick J. Wong wrote:
> [directly cc the xfs list now because dealing with the debian bug
> tracker is just too hard]
> 
> On Mon, Oct 13, 2025 at 10:09:14PM +0200, Iustin Pop wrote:
> > On 2025-10-13 10:41:06, Darrick J. Wong wrote:
> > > [yay, debian bugs aren't cc'ing linux-xfs consistently]
> > 
> > They try to, but fail because the (new) bug source address is not
> > subscribed to linux-xfs, and thus there is a bounce. I haven't had time
> > to report this, sorry.
> > 
> > > > I've struggled with this for a while because all my logs were spammed by
> > > > hundreds of lines of:
> > > > 
> > > > postfix/postdrop[37291]: warning: mail_queue_enter: create file maildrop/480926.37291: Permission denied
> > > > 
> > > > And it took me a long while to dig this down to xfs_scrub reporting.
> > > > Problem setup:
> > > > 
> > > > - mailer is postfix, which uses a setgid /usr/sbin/postdrop binary to
> > > >   write to /var/lib/postfix/maildrop (mode 0730, group postdrop)
> > > > - the systemd unit for the xfs_scrub reporting,
> > > >   /usr/lib/systemd/system/xfs_scrub_all_fail.service, contains:
> > > >   
> > > >   # xfs_scrub needs these privileges to run, and no others
> > > >   CapabilityBoundingSet=
> > > >   NoNewPrivileges=true
> > > > 
> > > > Together, this means that the script
> > > > (/usr/libexec/xfsprogs/xfs_scrub_fail) composes the email, and pipes it
> > > > to "/usr/sbin/sendmail -t -i", which in turn invokes the postdrop
> > > > binary, but which can't get the sgid bit. But since it calls sendmail
> > > 
> > > IOWs, postfix is installed and postdrop needs to be able to run as
> > > setgid, right?
> > 
> > Correct.
> > 
> > > Do you only need us to change the xfs_scrub_fail@.service file to have
> > > "NoNewPrivileges=false", or do you also need it to have
> > > "CapabilityBoundingSet=CAP_SETGID" ?
> > > 
> > > The systemd documentation implies that you only need
> > > NoNewPrivileges=false to run setgid programs, but I don't know for sure.
> > > I'll try to test this and report back, but it sounds like you're in a
> > > better position to say for sure that postfix works.  (I use msmtp)
> > 
> > I don't know either, but sometimes in the next weeks I hope to get time
> > to test it. I suspect CapabilityBoundingSet=CAP_SETGID is an improvement
> > on NoNewPrivileges=False, but not required.
> 
> No, both configuration directives fail to fix the problem.  I even tried
> to selectively disable directives in the service configuration file, but
> for whatever reason it still fails even with seemingly unrelated things
> like RestrictRealtime=yes turned back on.
> 
> The one thing that /does/ work consistently is to add
> SupplementalGroups=postdrop, but that makes the whole service fail if
> you don't happen to have postfix installed.
> 
> Evidently postfix is *really* dependent upon postdrop being a setgid
> program and thereby being able to write to /var/spool/postfix/maildrop.
> There are some horrifying workarounds like this:
> 
> https://github.com/cyberitsolutions/prisonpc-systemd-lockdown/blob/main/systemd/system/0-EXAMPLES/30-allow-mail-postfix-via-msmtp.conf
> 
> That advocate for installing msmtp, bindmounting msmtp over sendmail,
> and injecting a config file that just relays mail to the localhost MTA.
> I guess that works, but YUCK.
> 
> I'll play around with this a little more, but maybe email reporting just
> isn't worth the trouble.

Even the bindmounting craziness doesn't work, because that breaks
systems where msmtp is set up as the MTA, but not to listen on port 25
of ::1.  At this point maybe I'll just revert to the approach that we
had prior to commit 9042fcc08eed ("xfs_scrub_fail: tighten up the
security on the background systemd service") and run with unrestricted
privileges as user mail.  Then setgid works fine.

--D

> --D
> 
> > > > repeatedly, I get for a few days, every hour, hundreds of flagged log
> > > > entries by logcheck.
> > > 
> > > Yikes.
> > > 
> > > > Now, the Trixie kernel seems to not support scrubbing anyway, so I can
> > > > simply disable this, but it would be better to fix this and do an update
> > > > (in trixe), otherwise the log spamming is really annoying.
> > > 
> > > Indeed.  Forky (assuming it gets 6.18/6.24) should have online fsck
> > > turned on since upstream changed the kconfig default.  Not that I have
> > > any idea how one gets kconfig options changed in Debian...
> > 
> > Me neither, but I assume a new setting would just get the default. Once
> > sid kernels get to 6.18, I can test in a VM.
> > 
> > thanks!
> 
