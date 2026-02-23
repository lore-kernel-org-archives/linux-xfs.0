Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3416637E2E7
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 23:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771888123; cv=none; b=ODlN31zxFmG/wn99tx8H6crMGHE07PX4TtWAm5zqVUN4C6/+fv88fOS6lscl76yqAVh2Gk6i6E4YJTQlVuWuxhoeKuQwCaI6qeksXbHOEdz2a2liYIung7jsfD7RMlsOm9P/W3DxM3pgpPc981Zv79dElpp1KP5QIlih1l1qwpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771888123; c=relaxed/simple;
	bh=oImiBgtVRuNYLZRUVeW65YJqzAS8vZofsj/hNP8c+Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZaX7liAZ9ncHtDgcf4qfN4fzjWqmCbHNAOjVWHrE+VOzLpzs75sJBeOA1H1sB/ruG7PHdLv6mo+GYFwzTAYvIX1XC6JHyWVUKQsIzoaipL/hSzJJ9wd0O8Gw15wgACf6PUSMm7om7lHhcAaRof1eo3iZzX5IwI5r3rkB33beVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kOzqq8SS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kOzqq8SS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1C1C116C6;
	Mon, 23 Feb 2026 23:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771888122;
	bh=oImiBgtVRuNYLZRUVeW65YJqzAS8vZofsj/hNP8c+Fo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kOzqq8SS6IqWRsZuRziUQPwo4mfbvfP/nyLvWk9EyYcRZFySD0pLc2GXEAM/kifyb
	 04+xU8fAJyHKVUSmGfakvf1oJPZjB9T0BoLsDpeBJ5qcsbuxzShvLO7x8YZwa+Nh29
	 mLeRJUS2vNWQvIgOL81YMMm9i1qmSYYAwzMe9yLzDq0ueXC3dsGENt0FzCOM9OqBvk
	 Wud0Z55S+TVCxwsTe2WtZOMg4CWx9XyjxFlfxUcC8R5bqMqcQwp7VyTqjsQWiN8hV6
	 Ie7a1LOvqv7D5L1CZQsVQuf81O2XRvMFNN957+mkHslYQdbXeBiVSouK/+fSghj58S
	 7dUPdcgfVU0kw==
Date: Mon, 23 Feb 2026 15:08:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <20260223230840.GD2390353@frogsfrogsfrogs>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
 <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>

On Tue, Feb 24, 2026 at 12:29:49AM +0500, Марк Коренберг wrote:
> ```
> cp: failed to clone
> '/run/ideco-overlay-dir/ideco-trash-o4ut52ue/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx'
> from '/run/ideco-overlay-dir/storage/ideco-ngfw-19-7-19/upperdir/var/lib/clickhouse/store/e2b/e2bdef56-6be8-40bf-8fab-d8fb2e9fdd94/90-20250905_11925_11925_0/primary.cidx':
> No space left on device

Ah, that.  coreutils seems to think that FICLONE returning ENOSPC is a
fatal error.  I wonder if we need to amend the ficlone manpage to state
that ENOSPC can happen if there's not enough space in an AG to clone and
that the caller might try a regular copy; or just change xfs to return a
different errno?

--D

> ```
> 
> In all such cases `xfs_bmap -v  ......` always refer to the last AG.
> 
> # xfs_spaceman -c 'freesp -g' /run/ideco-overlay-dir
>         AG    extents     blocks
>          0        461    6658463
>          1         98    6406298
>         .......
>         15        125    6638281
>         16          1          1   <====== (!)
> 
> пн, 23 февр. 2026 г. в 21:23, Darrick J. Wong <djwong@kernel.org>:
> >
> > On Mon, Feb 23, 2026 at 02:48:48PM +0500, Марк Коренберг wrote:
> > > Hi,
> > >
> > > I ran into an issue after growing an XFS filesystem where the final
> > > allocation group (last AG) ended up very small. Most workloads were
> > > fine, but large reflink-heavy copies started failing. In my case,
> > > copying a ClickHouse data directory with:
> > >
> > > `cp -a --reflink=always ...`
> > >
> > > fails on a filesystem with a tiny last AG. Using --reflink=auto
> >
> > How does it fail?
> >
> > --D
> >
> > > doesn’t help either, because `cp` doesn’t fall back to a non-reflink
> > > copy if the reflink attempt fails.
> > >
> > > To work around this, I had to write scripts that compute a “safe”
> > > target size before running xfs_growfs. The alignment I needed is a bit
> > > awkward:
> > >
> > > 1. Round the LV size up to the next multiple of the filesystem AG
> > > size, so the grown filesystem ends exactly on an AG boundary (no
> > > partial/tiny last AG).
> > >
> > > 2. Then round the LV size down to the LVM extents size (4 MiB in my
> > > case). Rounding up to the LVM granularity can reintroduce a tiny last
> > > AG.
> > > If the automatically chosen AG size were aligned to that granularity,
> > > step (2) wouldn’t be necessary.
> > >
> > > This feels like something xfsprogs could support directly. My proposals:
> > >
> > > 1. xfs_growfs: add an option to print an “optimal grow target size”:
> > > the current(new) block device size rounded **down** to a multiple of
> > > the AG size.
> > > A --json output mode would make this easy to consume from scripts.
> > >
> > > 2. AG size calculation/alignment: when choosing an automatic AG size,
> > > always round it down to an alignment such as 4 MiB, or (preferably)
> > > consider the underlying device/LVM extent size when it can be
> > > detected, instead of using a constant.
> > >
> > > 3. Docs (mkfs + AG sizing): when specifying AG size manually,
> > > recommend: choosing filesystem sizing so the final size is an integer
> > > multiple of AG size (i.e., no partial last AG), and aligning the AG
> > > size to the underlying allocation granularity (e.g., LVM
> > > extent/segment size) when applicable.
> > >
> > > 4. Docs (xfs_growfs): add a note that it’s highly preferable to grow
> > > the filesystem in multiples of the existing AG size, to avoid a tiny
> > > last AG.
> > >
> > > 5. Optional grow mode: add a xfs_growfs mode/switch that grows “as
> > > much as possible”, but clamps the resulting filesystem size **down**
> > > to an AG boundary, and reports how much space is left unused (e.g., “X
> > > bytes left unallocated to avoid a partial final AG”).
> > >
> > > This might sound like a corner case, but it’s easy to hit in practice
> > > when the block device is resized to just arbitrary chosen size then
> > > xfs_growfs expands to consume the whole device.
> > >
> > > Thanks,
> > > Mark
> > >
> 
> 
> 
> -- 
> Segmentation fault
> 
