Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6121E485
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 12:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730811458; cv=none; b=ePUgQhOAMbw86r9oIxVMKhQxysMUGJjh2vXNr18GOCNVRGerkV52gqGan+R6FYoY2oScfJuzte2m7H/yLYhEiKbqlTOVNKJcHponPIcmnQ0NTOOH0bMVaMJBbeUuXp4RgNYiB9zub0d/xhMBjg8TmQFUaHmUTpwEXM7ZTFa2iME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730811458; c=relaxed/simple;
	bh=/ku5PRRXZ3ZrL4FnlrY2C8l5CYAujq32oU67FlkGuwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lS4Jw0Qg5lld4qt6OrBMFiCeisuY/R0x4sEDtu2911SnzizpaF1NPi3jiTKmAdC7jFrKyZ8A/C/kllfAWI9PL0mDsEiDnn/fLwYjHwkEejp7ZnAXTWe3NtOiHh98Ap1hpMH2/QiKxGEuHjazYJbOrF4eEPNqZxzQV7pM564U4cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hl0UVH6S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hl0UVH6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67552C4CECF;
	Tue,  5 Nov 2024 12:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730811457;
	bh=/ku5PRRXZ3ZrL4FnlrY2C8l5CYAujq32oU67FlkGuwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hl0UVH6SO7K+x5gWXA3PmdlAzHuMEr6xS7hn+0ITy7KEuxUeTsfwT2uvW3EIdHrif
	 1lr14i1S7aC0BHP6g0kcxyYsCIhQwhaVWRCjwD85slei6OOylqSsONbR0hxXE1EI1w
	 VgrApADMfy939zq3mxJwvt/crNXAIdIEC3YNQKu3d4ha4prik5vpVCMa8u5mOI+haG
	 3CcaQq066G8M3mA748KpRARG4oO5uuGdssFiPQmKnyRBABxzBldyncyJ4/BKwUt8C/
	 0Cnv18Hb8LszeLi9MjkAwX/sKmEJINxu+IISPxvxZfiThR9nbuAir///V1zix5q7Sf
	 THxb7CWLxXJ0w==
Date: Tue, 5 Nov 2024 13:57:33 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com
Subject: Re: [PATCHSET v5.4] xfs: improve ondisk structure checks
Message-ID: <pe7qdtl3omqnhxw7qbtqko4ywvhhrtcljvbfz6d54po7kpabch@l2a6ftl7p7ir>
References: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173049942744.1909552.870447088364319361.stgit@frogsfrogsfrogs>

On Fri, Nov 01, 2024 at 03:18:28PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Reorganize xfs_ondisk.h to group the build checks by type, then add a
> bunch of missing checks that were in xfs/122 but not the build system.
> With this, we can get rid of xfs/122.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for a couple of weeks with no problems.
> Enjoy!  Comments and questions are, as always, welcome.  Note that the branch
> is based off the metadir patchset.

This is giving me some conflicts on top of -rc6. I'm assuming you'll rebase it
on top of -rc6 and send a PR later on?

Cheers.

> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=better-ondisk
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=better-ondisk
> ---
> Commits in this patchset:
>  * xfs: convert struct typedefs in xfs_ondisk.h
>  * xfs: separate space btree structures in xfs_ondisk.h
>  * xfs: port ondisk structure checks from xfs/122 to the kernel
> ---
>  fs/xfs/libxfs/xfs_ondisk.h |  186 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 137 insertions(+), 49 deletions(-)
> 
> 
