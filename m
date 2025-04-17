Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54E525332B
	for <linux-xfs@vger.kernel.org>; Thu, 17 Apr 2025 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744902006; cv=none; b=NeAZNYbBWrCdd1yVWyPf7GIHK2ITRrBCzkJIc6+B+cpeVoqSLeSdm/UR8MRLz5IQqBIvRAVIwesWkNtqHDMXK/FBswPRF18RDvkO4+bksj/hUnsoDpPl60xD/n4H9KfUWm1c84LkB5w0ffCCm4ZJMDW6MmCJD5UDNpAC3QKzPJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744902006; c=relaxed/simple;
	bh=9JFUxCX2a7mrdtNgiHeqMGUEXZ7/MK+1Etr+Ef0gTlk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N/jif5445pIuu8W1o9KoshDz9Rl9BL1aBzKa0Zk549KBdAL3Xvlb0kGd2cNynzVfpk8Mzotwz7eyoD4J24ZIoy3OhLe3mGw4wXCxmwWFYIN1ryyDD/+7RtZB5QNJnjR67b4P9SbuvFKu3rhh2AGNXj+WR/qZ5fx83fk7M6Kxr8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0tG3Rs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0tG3Rs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA82C4CEE4;
	Thu, 17 Apr 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744902005;
	bh=9JFUxCX2a7mrdtNgiHeqMGUEXZ7/MK+1Etr+Ef0gTlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0tG3Rs3iAX8+nYEYXbCqX7cjJYUUJBZo8AbZPe2ajyTlxZxHH1IMOnPTK10D2d6H
	 bMp/OEWXLkir063S+jF3br4YpBcI9QeRA8fDz3THDH/4BpM0wsiZ4UkfL5tFebAjZD
	 o4b3Wm5VFiw3Mt0hhua7UA9nKFGPowI21MTTp8X2065GeqXjeRKRoSk0QFu3wai33y
	 iUNCzaDhShh+HCHK55yzZqnZSmEAl/xfdwis227hc6UF66zILf6MaMIr/+5Sky4Pr/
	 lxhEdP1ZnDsiEz4pFy++7fT7K2+MmuvMsvDPms7CeFzd1TFHNG9dSNVpNJC7UiZUM0
	 TaZlPJFzp1CzA==
Date: Thu, 17 Apr 2025 08:00:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: David White <dr.white.nz@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs_scrub_all.service
Message-ID: <20250417150004.GP25675@frogsfrogsfrogs>
References: <CAF9hJQszo5J=5NGuALdQW5iBrx+qB=nY__y3ae=k8P1JgbeUQg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF9hJQszo5J=5NGuALdQW5iBrx+qB=nY__y3ae=k8P1JgbeUQg@mail.gmail.com>

On Thu, Apr 17, 2025 at 10:35:58AM +0100, David White wrote:
> Hi there,
> 
> I'm on Ubuntu 24.10 which has a secondary mount xfs filesystem.
> 
> I have installed xfsprogs. Which installs a /usr/sbin/xfs_scrub_all
> python script, and a systemd service and timer to run it. xfsprogs
> version 6.8.0 (same on 6.9.0 built from source too)
> 
> However, looking at the code for xfs_scrub_all, it's broken. It fails
> on a non-existent "debug" global, and the run_scrub thread target has
> a call to path_to_serviceunit with a "path" parameter that doesn't
> exist. (I'm assuming this is supposed to be "mnt")

Yes, and both bugs were fixed in 6.10.

> I've disabled this service, (and the timer that runs it) and added it
> to my system presets for future installs not to enable this unit.
> 
> What is going on here? What is the purpose?

xfs_scrub_all schedules xfs_scrub@ services to run background online
fsck of mounted XFS filesystems.  That said, xfs_scrub_all before
xfsprogs 6.10 has some of serious bugs in it (as you note!).  Back in
the 6.8 days days the kernel portion was not yet complete, and the
userspace part didn't fully catch up until late last year.

The strange part is that none of that stuff should be active in the
xfsprogs 6.8 package for Debian or Ubuntu, unless I seriously
misunderstand what this line in debian/rules does:

dh_installsystemd -p xfsprogs --no-enable --no-start --no-restart-after-upgrade --no-stop-on-upgrade

which (AFAIK) installs the units but does not enable or start any of
them.  But I'm guessing it got activated on your system anyway?  From
the postinst script of the package in question:

https://mirrors.edge.kernel.org/ubuntu/pool/main/x/xfsprogs/xfsprogs_6.8.0-2.2ubuntu1_amd64.deb

# Automatically added by dh_installsystemd/13.18ubuntu1
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
	if deb-systemd-helper debian-installed 'xfs_scrub_all.timer'; then
		# The following line should be removed in trixie or trixie+1
		deb-systemd-helper unmask 'xfs_scrub_all.timer' >/dev/null || true

		if deb-systemd-helper --quiet was-enabled 'xfs_scrub_all.timer'; then
			# Create new symlinks, if any.
			deb-systemd-helper enable 'xfs_scrub_all.timer' >/dev/null || true
		fi
	fi

	# Update the statefile to add new symlinks (if any), which need to be cleaned
	# up on purge. Also remove old symlinks.
	deb-systemd-helper update-state 'xfs_scrub_all.timer' >/dev/null || true
fi

From my reading, this only enables the timer (but doesn't start it!) if
the debian system helper thought it was already enabled.

On a newer 6.13 package, the --no-enable and --no-start flags are gone,
so postinst gets a new block:

# Automatically added by dh_installsystemd/13.11.4
if [ "$1" = "configure" ] || [ "$1" = "abort-upgrade" ] || [ "$1" = "abort-deconfigure" ] || [ "$1" = "abort-remove" ] ; then
        if [ -z "${DPKG_ROOT:-}" ] && [ -d /run/systemd/system ]; then
                systemctl --system daemon-reload >/dev/null || true
                deb-systemd-invoke start 'system-xfs_healer.slice' 'system-xfs_scrub.slice' 'xfs_scrub_all.timer' >/dev/null || true
        fi
fi

which actually starts it.  But this shouldn't have been started up on
your system.

<confused>

--D

> Thanks,
> 
> David.
> 
