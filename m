Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EBDEDC
	for <linux-xfs@vger.kernel.org>; Tue, 12 Dec 2023 01:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MV0TFkjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A872C433C8;
	Tue, 12 Dec 2023 01:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702345968;
	bh=yeamrQTLeDGE4VdaVxh3vxXDzJGkuNeReUg293G6C+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MV0TFkjWNRjk7I4+kyS0z7qIIncoXdhuEJ8qci0EnnJoLVx96tjSiASdMbt28j31/
	 zSH05s4NtIA9DhyyyIikuTJMM8/qxZp9nMKlrQdWBXmPZ+7ZzwUxMvCxVb8vL0UCcF
	 8PN1bR86u52auuhY/EV+CCRLAlnlfR4e9S4N0xAG0TTRk3hWmQToLqxHxeiou99RXr
	 hS7WF8GHVP8BoWZj/KVR70MqMX+g5+a9sm4o90hb/VzecfK6ui9MWWVZCfUNH3G8t8
	 Vuzu8syn0R7b7WT/KFhRVBoFyemXd0/Ppr8Jo/uTHZE23XloYPZHbgjYmRiLfW1Pac
	 O45P/cYcraayg==
Date: Mon, 11 Dec 2023 17:52:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: improve libxfs device handling
Message-ID: <20231212015247.GA361584@frogsfrogsfrogs>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211163742.837427-1-hch@lst.de>

On Mon, Dec 11, 2023 at 05:37:19PM +0100, Christoph Hellwig wrote:
> Hi all,
> 
> this series how libxfs deals with the data, log and rt devices.
> A lot of it is just tidying up cruft old code, but it then introduces
> a libxfs_dev structure that describes a single device to further
> simplify the code.

Yay!  I'm glad the bizarre isreadonly == flags code is gone!

And all that weird dev_t -> fd translation weirdness, and the last of
the irix stuff that makes no sense now.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Diffstat:
>  copy/xfs_copy.c     |   19 --
>  db/crc.c            |    2 
>  db/fuzz.c           |    2 
>  db/info.c           |    2 
>  db/init.c           |   29 +--
>  db/init.h           |    3 
>  db/metadump.c       |    4 
>  db/output.c         |    2 
>  db/sb.c             |   18 +-
>  db/write.c          |    2 
>  growfs/xfs_growfs.c |   24 +--
>  include/libxfs.h    |   87 +++++------
>  include/libxlog.h   |    7 
>  include/xfs_mount.h |    3 
>  libfrog/linux.c     |   39 +----
>  libfrog/platform.h  |    6 
>  libxfs/init.c       |  398 +++++++++++++++-------------------------------------
>  libxfs/libxfs_io.h  |    5 
>  libxfs/rdwr.c       |   16 --
>  libxfs/topology.c   |   23 +--
>  libxfs/topology.h   |    4 
>  libxlog/util.c      |   49 +++---
>  logprint/logprint.c |   79 ++++------
>  mkfs/xfs_mkfs.c     |  249 +++++++++++++-------------------
>  repair/globals.h    |    2 
>  repair/init.c       |   40 ++---
>  repair/phase2.c     |   27 ---
>  repair/prefetch.c   |    2 
>  repair/protos.h     |    2 
>  repair/sb.c         |   18 +-
>  repair/xfs_repair.c |   15 -
>  31 files changed, 453 insertions(+), 725 deletions(-)
> 
