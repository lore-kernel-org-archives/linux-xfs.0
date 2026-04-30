Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA72427A0B
	for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2026 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564228; cv=none; b=SKAAEIXtiCovxkgs9u6BYjTEzpODStvCqLkACo9oHWnWaEUJIjgWN8TW4GdNiLynZn6xl9hUK8c0cNVep8l/yxyyGVxuM7dphyN1uinNwwAznMfpKaVObFaAUaHLFq4Oj16DMddnhABGKON5SYwsY/xI5ZpQEUOhoyqvb8+SJG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564228; c=relaxed/simple;
	bh=jTYOVfslxjxTOQBsZ9f9F+zrjflryG0h8wThs0DIQrk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5/kw+zs3NTQGdraoNUoRjK+dQyp1u5XdMTtuU1k/KvFyH8iSC5inDZZXPp13kUYcv5QyQogQ2wyOGuoKddPop0hOaze+URZ4784juOxAAyinkkv1AIvYBJ+RfY6QyF1aErO21VlRIOHfz8r0Tc58tW7+yYsvwkUp6bWQOSVzCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At1x8LHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At1x8LHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626E2C2BCB3;
	Thu, 30 Apr 2026 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777564228;
	bh=jTYOVfslxjxTOQBsZ9f9F+zrjflryG0h8wThs0DIQrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=At1x8LHJvhG3hbFQs+B3m50ZgkuoRCtcRjLTEDsimo8w4WAx/9Shinqmfn9YnH2QW
	 vU7u/fAtwNGmh3iah2BvXU0JU4p+2Rx7dU0v4pAlUX2STzZeDQEhxBTcdVaMf515e8
	 n5c8T6/1Pzd5fKJxJngBUrY7TaUgpPTCTDamRzG/nY2oi1KfTmxigQ3l55JS8EsVbF
	 YRxPvGul7w0FOjcSkdPS+oFq3QX7ZsaPN50+fL8a0cGRL27A1fY5uSVyzGMx1Gp6ks
	 8lyLm7iFhQ56fa1k4l/iTtXmAHVO52qI/oEU/cUMyxKbhfCP63/l7j3h+I4fd6sVYV
	 LKT2mBkYCYQDw==
Date: Thu, 30 Apr 2026 08:50:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Patrick Fischer <patrick.fischer@siedl.net>
Cc: linux-xfs@vger.kernel.org
Subject: Re: xfs_scrub_all process execution results in a dead lock condition
Message-ID: <20260430155027.GE7751@frogsfrogsfrogs>
References: <323580211.1220195.1777554001363.JavaMail.zimbra@siedl.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <323580211.1220195.1777554001363.JavaMail.zimbra@siedl.net>

On Thu, Apr 30, 2026 at 03:00:01PM +0200, Patrick Fischer wrote:
> Hello,
> I've encountered a bug within the xfsprogs-dev utilities, particular
> within the Python script xfs_scrub_all.  I researched the master
> branch and saw, that the type of sub process call is like within
> kernel version 6.13.0-2 I stumbled across this issue.

"6.13.0-2" ... Debian Trixie?

> Overview:
> xfs_scrub_all.service systemd unit (or manual execution) is hanging
> due to a pipe buffer exhaustion after sub process call of lsblk.
> 
> Steps to reproduce:
> Create a bunch of fake block devices to enlarge the output of lsblk to
> more than 65520 bytes:
> > modprobe scsi_debug max_lunx=3 num_tgts=7 add_hosts=100

/me notes that this wasn't enough to generate more than 60k of lsblk
output.  Creating a fake 130k json file and changing cmd to
['cat', '/tmp/garbage'] was sufficient to reproduce the problem,
however.

> Run the command of xfs_scrub_all.service manually:
> > /usr/sbin/xfs_scrub_all --auto-media-scan-interval 1mo
> 
> 
> xfs_scrub_all shows a wait4 for the sub process lsblk:
> > wait4(2148527,
> 
> 
> Within sub process lsblk there is a write to FD1 / stdout:
> > write(1, "                     {\n         "..., 4096
> 
> 
> Affected Code in /usr/sbin/xfs_scrub_all[1]:
> > 54     cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
> > 55     result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
> > 56     result.wait()
> > 57     if result.returncode != 0:
> > 58         return fs
> 
> 
> Actual Results:
> The execution of the command above launches a sub process of lsblk and
> returns more than 65520 bytes, resulting in an endless wait for
> return.

Yep, that's a bug.

Now that we can assume (demand?) python >= 3.5, I think we can replace
all the string iteration and collection mess in that function with a
simpler call to subprocess.run:

	cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
	try:
		proc = subprocess.run(cmd, capture_output = True, text = True, check = True)
	except Exception as e:
		print(e)
		return fs
	if proc.returncode != 0:
		return fs

	# The lsblk output had better be in disks-then-partitions order
	bdevdata = json.loads(proc.stdout)
	for bdev in bdevdata['blockdevices']:

> Expected Results:
> The unit / process should not enter a dead lock.
> 
> [1] https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub_all.py.in

Thanks for the report, sorry there was a bug.  I'll post a fixpatch
soon.

--D

> 
> Regards,
> Patrick Fischer
> 
> Die E-Mail wurde von IKARUS mail.security geprüft.
> 
