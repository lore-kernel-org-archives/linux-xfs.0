Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93B3C13E9
	for <linux-xfs@vger.kernel.org>; Mon, 10 Aug 2026 11:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786362936; cv=none; b=Ya77datx3CSRlZ3FtvTtXOsh3/pzAHV0Qae3Hxk8ggMh4jE+CjfiFSCb+xux3fJXPdcHm8woCJIPIB+hwhOL/PRIkQHsVz9mUqyDQlwQdZPDILquyMhW1Rf+CkhW9vYMadlyyun019S8FsHAse0iTG/lDXM5W0agy9CW6W5X+ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786362936; c=relaxed/simple;
	bh=60rh40AKyFQxJj+tPhReOJUi5CPvOFFlFPWiEUP2a6g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aSTEhPIi/4ZUY3cXqKvm9euP22Nd87oQJv6LTgaVGGMwFsoTjYlQFbnn7GVoIRiQDqiEy7u5/Jexzc494+inXzfd+4TAschozkwgTsUL0oDY0kpG+vB91gvTbd4I07OfPwZBuC11BNp15UwMguN9/+9Hia6O+jy/83Cbgcvtv+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d5d0DheN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d5d0DheN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051591F000E9;
	Mon, 10 Aug 2026 11:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786362934;
	bh=IuDezQ5BBuJSSbD2i7rM36DwCRT72w7uZQ2oy85R0cg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=d5d0DheNaFgF4dhpcqI550dWR64x9eH58lyK9j1FW3lJEwznjsScnNU3FHSgl59VC
	 YyuyPm3f2bNZdfX6XgMnMfzF+JY+VI72rH7mlJRi4TpaCjr/tnpdT2iP7VHYmmm04+
	 JlE5ABNj9f3A5x8IFfbMTW+30TvLYejLjGECipNiUtKsfF4spSYPrmzrOaYYHf1Oa/
	 t34L+BuwZzt/fjj3YGMZvyNi3agBvVJzA96fM65zfsxSbE+8fPzJkhQeITBUV7hD8q
	 6wcRHiP4TMBWuPpwXv0s+W360P6FrHQmyT7XYIyKwlry5hWAW+OHyae/YtkzVakme6
	 EdV4k0G14IbAw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20260715145147.95654-1-hch@lst.de>
References: <20260715145147.95654-1-hch@lst.de>
Subject: Re: misc buffer cache improvements
Message-Id: <178636293365.58486.12109129017004452043.b4-ty@kernel.org>
Date: Mon, 10 Aug 2026 13:55:33 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 15 Jul 2026 16:50:53 +0200, Christoph Hellwig wrote:
> a bunch of misc xfs_buf patches.  These came out of a little
> project that needs a async read API (not actually included here),
> and to get there a lot of lose ends had to be cleaned up, and a
> lockless path for readaheads that doesn't kick off the read fell
> out easily.
> 
> Diffstat:
>  libxfs/xfs_btree_staging.c |    7
>  libxfs/xfs_dquot_buf.c     |    8
>  libxfs/xfs_ialloc.c        |    2
>  libxfs/xfs_inode_buf.c     |   15 -
>  xfs_buf.c                  |  392 +++++++++++++++++++++++----------------------
>  xfs_buf.h                  |    8
>  xfs_buf_item.c             |   10 -
>  xfs_buf_item_recover.c     |    3
>  xfs_dquot_item_recover.c   |    1
>  xfs_fsops.c                |    2
>  xfs_inode.c                |    4
>  xfs_inode_item_recover.c   |    1
>  xfs_log_recover.c          |    5
>  xfs_trace.h                |    2
>  xfs_trans_buf.c            |    7
>  15 files changed, 239 insertions(+), 228 deletions(-)
> 
> [...]

Applied to for-next, thanks!

[01/12] xfs: don't get a pag reference in xfs_buf_get_map
        commit: 45fd506c334ceb79ea3b40986b2c5ebb7802b385
[02/12] xfs: consolidate buffer locking in xfs_buf_get_map
        commit: 568c8798a3d0afabc133d7b34d37155daa95d1f2
[03/12] xfs: split out a lower-level xfs_buf_get_map helper from xfs_find_get_buf
        commit: b6ba780af010f0d1c5bfb970fe692a02559de473
[04/12] xfs: remove spurious XBF_DONE clearing on readahead validation failure
        commit: 7a4eae80b5b3db8d68961af3707fd56f2220cc29
[05/12] xfs: remove _XBF_LOGRECOVERY
        commit: d80fe85bb2fc551e56758606f764e57516b7f9a3
[06/12] xfs: hide b_flags manipulation from code outside of xfs_buf.c
        commit: 9f224de410d7efafc44ce1880aabd0101aa8688f
[07/12] xfs: use WRITE_ONCE to update b_flags
        commit: b15f6520ab6481b89688d4b6362d1fa5d9f9df6b
[08/12] xfs: don't reverify buffers in xfs_buf_readahead_map
        commit: 3d102727432b5c5cff9afa80a430ca8f34b59666
[09/12] xfs: use goto based error unwinding in xfs_buf_read_map
        commit: 819f1cc98aaf09733b30700608a02256f47d7908
[10/12] xfs: merge xfs_buf_reverify into xfs_buf_read_map
        commit: 21cc7775ee5ca2d5cd4be0de0d55fd28b14fd4e1
[11/12] xfs: move buffer locking out of xfs_find_get_buf
        commit: 2aedf844be1d578c4c2746177aaaf096a053d650
[12/12] xfs: add lockless xfs_buf_readahead_map fast path
        commit: 00f40876f417463ef759dc3b0c4cfe15da48b092

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

