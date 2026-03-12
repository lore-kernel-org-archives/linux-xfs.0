Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2D3CBE8F
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773337440; cv=none; b=Q/dMOLrqqp0C2cA0SKgDcwjSGXZIsdIO9nGYgZNNuxxQccOQh09AcCR9srJYtY9iF4nXGqb+/2sV4WQpVkjEH9/UDHPbuPv8+HwEVoOmwjIYe140zXOHyyAwcxsRi8sXsUeI3Nmh53V8LRk3iJQoyY517fHFjrnqSXtf//WGHR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773337440; c=relaxed/simple;
	bh=ZB9IrrsOCLzNOfLMZauVSsN4oMYVBTfVSf/OEViJw0s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=tJbyLKTjmqkaXE5AjM0JH/9GODMIT0ucry6rxEwTyG8LQ7fUTXJWpVDDEXW0RFAR6nGoPd4hAQjLLOdHat8aA304Dpz5sa5Knbyayecis1Us2QEmBsk8AWdYU8Jg2ac0D9tprA+an3qvQj9nMUj0JR5CeDn+JLr7tSTGs4YVExY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLRkurQB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLRkurQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C40C4CEF7;
	Thu, 12 Mar 2026 17:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773337440;
	bh=ZB9IrrsOCLzNOfLMZauVSsN4oMYVBTfVSf/OEViJw0s=;
	h=Date:From:To:Cc:Subject:From;
	b=oLRkurQBIhemZnFCRgnd/IzBbjmuMGVpFUt4Dy7InhUY2T0Aa3eGb7kdP1PuGcR+g
	 1qAwyh4lyfXpfQ4Iz/h24wy3gDNw0AUWRKa7P4a90cpmVdhoMUOwRsGbtD1fx7tHYp
	 H7STYxqNKEDtBPy20Eqg4zpX9dB4oN5UltdRr7PAqhRMbXt5xuvpyYA5KSD9MBqwsi
	 Py+/oCbiiJAnro7URA7tI92v4K8BydaQGhO9C3wvt1CMc50R74ym6nGveGtbcWzzMb
	 ednzJk39umHOUUMvFafypsV0Y6yYAwknqqToologeRB8Oc6BLU3ffiOFcp7hmhcpEx
	 YCyqpaMaj8dxQ==
Date: Thu, 12 Mar 2026 18:43:56 +0100
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: aalbersh@kernel.org, cmaiolino@redhat.com, djwong@kernel.org, 
	hch@lst.de, linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to 69721699daeb
Message-ID: <i5lfckgdwdhiq5epshvzlm77mlqzus3cbz66dgnzmppl6sb7wo@vn2xh6zc4pfp>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi folks,

The xfsprogs for-next branch in repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed
on the list and not included in this update, please let me know.

The for-next branch has also been updated to match the state of master.

The new head of the for-next branch is commit:

69721699daeba43eed65d00845580812252cb5da

New commits:

Christoph Hellwig (2):
      [705858765a3a] xfs_io: fix fsmap help
      [69721699daeb] xfs_io: print more realtime subvolume related information in statfs

Darrick J. Wong (4):
      [39c683bf82ae] misc: fix a few memory leaks
      [2c9b0236b0d8] libxfs: fix data corruption bug in libxfs_file_write
      [ca3452967778] mkfs: fix protofile data corruption when in/out file block sizes don't match
      [32921df27199] mkfs: fix log sunit automatic configuration

Code Diffstat:

 io/fsmap.c      |  5 +++--
 io/stat.c       |  6 ++++++
 libxfs/util.c   |  5 +++--
 mkfs/proto.c    | 28 ++++++++++++++++++----------
 mkfs/xfs_mkfs.c | 29 ++++++++++++++++++-----------
 5 files changed, 48 insertions(+), 25 deletions(-)

-- 
- Andrey
