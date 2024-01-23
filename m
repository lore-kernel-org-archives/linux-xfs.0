Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECD557300
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jan 2024 10:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006029; cv=none; b=W3xc255NtnopCvLRYrCsYsXkRPmaRSYmlTZRbq+t9F/zygrehVzlYmNKfFwMhAkOkFtoW2sB1GM+QbPo3qykx4+GnqWnEOlyxTa1PetuAPzJh8Si5pvdW/TQhjcVUVNdv0l662dGFe7e7KlSCeBcqpSELvoggbMAg39Zb6lETtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006029; c=relaxed/simple;
	bh=eLJEbeklUkoKs3RDYSckoStco76tZcqcSnTsyXYsON8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/Db4nqbJR6vBRwjqPar75XeGhTeOQqFI//CYSIPKHO6sJspTcM3K3zrzbSn/gGe/1zI86adbLvckVguw/Q8Gnu1Oal+lY9L7eXoxL8nPFMR21mOf4WaeHMbDy4Z/3XjZVA8w/Ri51sLyccm9iwf0wfS9hi4J8kSdlK0nqPYQKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvhsOMj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvhsOMj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E41C433F1;
	Tue, 23 Jan 2024 10:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706006029;
	bh=eLJEbeklUkoKs3RDYSckoStco76tZcqcSnTsyXYsON8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvhsOMj+Y6a3zUA13mA8MdyOADC4LfD23SxjNkXA2s9o6pO4/VzdIi0B01scR2sdz
	 D/d96y/6noJtSkQkWt67slsXDmr8iUDjs6Aa8x6837ifK2R7Oz+dX/2fX6bspyjHLe
	 iAp76LsWNVfDhI+2cXGpfI8gRrdylonxtDB3GcZJUIze5pv2xGFos0zRsNGC93P4K4
	 fQ+MiV+g7I0UngFfxaNE3WpgGdQSM/Sl6tip1pvcr9tsksa1XKX9djOB+8OSWIOQMv
	 aEaoS5QOxMHOwtdfymW2T8wXVXXbxcro95QsIcAO/4PcpE13inaeWrtJzDHaVK++h9
	 +I9g/WtRxBk7g==
Date: Tue, 23 Jan 2024 11:33:44 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: glitsj16@riseup.net, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL 6/6] xfs_scrub: tighten security of systemd services
Message-ID: <mws7bjjvztoeneefr7he4vtec6s4mhf5o5i7ur4cs6dfvsy75o@ciunmrv2bbqp>
References: <r5ZmE3Y-_E8Hew0HCzp7lyf_Q6HlOYM1PCbjnrZP2j6es7Eq3mFWFJlBnQMogrRy_gTQkJEeeIzwjdSp6u63Jw==@protonmail.internalid>
 <170502573653.996574.9591002351083368679.stg-ugh@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170502573653.996574.9591002351083368679.stg-ugh@frogsfrogsfrogs>

On Thu, Jan 11, 2024 at 06:17:43PM -0800, Darrick J. Wong wrote:
> Hi Carlos,
> 
> Please pull this branch with changes for xfsprogs for 6.6-rc1.
> 
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
> 
> The following changes since commit 1c95c17c8857223d05e8c4516af42c6d41ae579a:
> 
> xfs_scrub_all: fix termination signal handling (2024-01-11 18:08:47 -0800)
> 
> are available in the Git repository at:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git tags/scrub-service-security-6.6_2024-01-11
> 
> for you to fetch changes up to 13995601c86574e2f65d93055ac7a624fbde4443:
> 
> xfs_scrub_all: tighten up the security on the background systemd service (2024-01-11 18:08:47 -0800)

As we spoke, this branch contain patches without Reviewed-by tags, I won't be
pulling this branch by now.

Cheers,
Carlos
> 
> ----------------------------------------------------------------
> xfs_scrub: tighten security of systemd services [v28.3 6/6]
> 
> To reduce the risk of the online fsck service suffering some sort of
> catastrophic breach that results in attackers reconfiguring the running
> system, I embarked on a security audit of the systemd service files.
> The result should be that all elements of the background service
> (individual scrub jobs, the scrub_all initiator, and the failure
> reporting) run with as few privileges and within as strong of a sandbox
> as possible.
> 
> Granted, this does nothing about the potential for the /kernel/ screwing
> up, but at least we could prevent obvious container escapes.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> ----------------------------------------------------------------
> Darrick J. Wong (6):
> xfs_scrub: allow auxiliary pathnames for sandboxing
> xfs_scrub.service: reduce CPU usage to 60% when possible
> xfs_scrub: use dynamic users when running as a systemd service
> xfs_scrub: tighten up the security on the background systemd service
> xfs_scrub_fail: tighten up the security on the background systemd service
> xfs_scrub_all: tighten up the security on the background systemd service
> 
> man/man8/xfs_scrub.8             |  9 +++-
> scrub/Makefile                   |  7 ++-
> scrub/phase1.c                   |  4 +-
> scrub/system-xfs_scrub.slice     | 30 +++++++++++++
> scrub/vfs.c                      |  2 +-
> scrub/xfs_scrub.c                | 11 +++--
> scrub/xfs_scrub.h                |  5 ++-
> scrub/xfs_scrub@.service.in      | 97 +++++++++++++++++++++++++++++++++++-----
> scrub/xfs_scrub_all.service.in   | 66 +++++++++++++++++++++++++++
> scrub/xfs_scrub_fail@.service.in | 59 ++++++++++++++++++++++++
> 10 files changed, 270 insertions(+), 20 deletions(-)
> create mode 100644 scrub/system-xfs_scrub.slice
> 
