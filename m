Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A8139DBFA;
	Mon,  3 Aug 2026 13:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763383; cv=none; b=ZLwM82Qm2864I6v1UCFxYqL8fdvQpPkFu4UmTj0hdp1XlcZBs8h4G9EwfuaHkPzjKVqTzQWUxbg0Fpb+3DLZZ0zHX6lPBUc2FZt2GC2meVNzqT0mHO8ik8WU2QeUbNTHrtdjAteIvCoCFAf8h6qN16qeThZqnIUxKAOx8wsqRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763383; c=relaxed/simple;
	bh=KpWDT18qrB3CLOwjPhAOWP+kdVcvo2RoORhLAtxoodM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=glINGAEtXAamGK06xds8d7RXbCDUsfIR+1a0iO4IQ0rhpIAi2S3LH/lF60g7t6VzH6LCqs9CwxGa+Fdxyjfr3Iy9dHGKH5qQcLeXbm/WqyA5epDzNmz+Rq3HnV3jFyMoZTwVxMvwNQCNZX4OkIFrQyttL5yzJ8Y6EHcRveE6XU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G9KBmwMN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G9KBmwMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539431F00A3E;
	Mon,  3 Aug 2026 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763373;
	bh=OgJ7rBBmUvMHD5nbYybrMhT7NwwAQF5XPo4wNWzH/XU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=G9KBmwMNQFynjsyoirCrpiQfF7LuOoULKGok0kc7EvJACMiJb9TJb9ASEDmovM/Pd
	 bInR+dhyVnZCVuEGqVBQjh9/KfKwbJfS+r4DuWeybwU6cQgnDSkfBMpcSMIuEeCdXl
	 JrFdcVc8hN3qrE3bR1Kj6JZFdUmCg0buj+QeIcvHHByNSGdzkFnPvCJxB+ZdakVWMC
	 8PLvapkuf+oQw99z/l2WEAGvmIw+lTb7n9eHppfkuvxeRAYoUkQmTonyCfzD3OkTG4
	 +uv/SklRlDiF4Aiw0rXil0RYDZch/LoRqfDtIDmQzCrqjL/FRAfrZPdJLtz0DaGkwy
	 wyNk2QpBUb+ig==
From: Carlos Maiolino <cem@kernel.org>
To: hch@lst.de, "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
In-Reply-To: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
References: <178512389129.1494795.16117444961252720216.stgit@frogsfrogsfrogs>
Subject: Re: [PATCHSET 1/2] xfs: LLM-inspired bug fixes, part 4
Message-Id: <178576337198.315832.4533715333993105847.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:51 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Sun, 26 Jul 2026 22:22:48 -0700, Darrick J. Wong wrote:
> Here's a fourth batch of xfs fixes resulting from a LLaMma.  Mwa mwa
> mwa...
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> [...]

Applied to for-next, thanks!

[1/6] xfs: only check mergeability of bnobt records
      commit: 97efed1091a50e4dbf31307015138b43a972d2e4
[2/6] xfs: don't double-lock when deleting a self-referential directory
      commit: 5fc643fb86599e29b38e7b2c2680b4b15bf8f772
[3/6] xfs: don't return EFSCORRUPTED when scrubbing corrupt parent pointers
      commit: 8af9cd79cdf6ee96ec610d707db22244fa21eb40
[4/6] xfs: don't zap the attr fork on repair when there are queued pptr updates
      commit: 5ee37132ea81abd36213b31a72140660c2aac54b
[5/6] xfs: nlink scrub must take IOLOCK before determining ILOCK state
      commit: b1a296fc2241f724ef8f14da6a4efa800d444dac
[6/6] xfs: avoid UAF on sc->tempip in xrep_tempfile_create
      commit: 0c88e10d12de9ca7cbed1467bb1b52310101bff8

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

