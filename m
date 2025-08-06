Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A371E1A3B
	for <linux-xfs@vger.kernel.org>; Wed,  6 Aug 2025 08:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754469932; cv=none; b=JKTo4Y8HZ53vJzMqMkBwyCmnZ94Y1jgaOmQ+U54D1nlfdm+co7J9dPQGJPDBcstNQUwHNMpPekQX04dlNiwSiGLOw7dq0zLwlMhv7p/6dLMz52Vfdsul2TBYGU361kSD5L6EwLjzpZG3Gb1DhmqA31oZ8U5qnhLkmOv2wKKjklk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754469932; c=relaxed/simple;
	bh=7E3kdADP2GGFaINrnjmjVArv61Yb8BbedyfvILDjD00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IVACY7vY5+pyM2lENop6lZ5CDBWTrDsPcg8bvbDrFoQ0Ed+fjS00o83xMPfpM3Iz1OMCIlSyaQsg5rz6FR8/6fF/bfEGcLqyb8MZ3IGUdTnxX/YbMNEX4HsIGUUoliRQl5++xM1QjT0xKqmGWj87wMSnnRqsn/wO369SoP3snGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+Zjho6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+Zjho6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55DEBC4CEE7;
	Wed,  6 Aug 2025 08:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754469931;
	bh=7E3kdADP2GGFaINrnjmjVArv61Yb8BbedyfvILDjD00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n+Zjho6Me/BQ82/MCRpMKsI6D6ej6JPlAF1GhfsoCK/EysAGkMNTDLmxZJSCmgyjb
	 gS1Ra/38hXbqEh6b7iCuJhj6a6jPEtC/FxYKm5UKP4WQ/XRme3+nOkCOSHWqCFcj9k
	 Mw96Wk5EwugliNUDytPIPK7061ZEzxe2lbIs3tyaV/J+7UE2s7eHSjVlgCa0Z0lU4F
	 ocrw8nDNeQ6jmVf2pU79/ue+w9fhOy+Dnh8w21LUz2a/5knG8Ogkpz5VqE0h98zSvh
	 ArUYXeP0NWS1LvfLBSjOeB50qN3XDaA6Mb/ovUqWvITd/OsCse6fAzHSgsdoN9vbZt
	 Ue/+wt0haLnfg==
Date: Wed, 6 Aug 2025 10:45:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Message-ID: <h2rtuedwnlr6qawsrx3uz4gtkpfvvlijutv7w3pdtfbvord7cu@cm2zjbu3iir5>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid>
 <20250806043449.728373-1-dlemoal@kernel.org>
 <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
 <IFqtoM3P4UP6lDAVnaetg8PD6iHVwJagb5GWUDGNyKYfziLc4ww2iM-CgpCoxACHecTMWYZridqsB1Tewz_EAQ==@protonmail.internalid>
 <756f897c-37d3-47ea-8026-14e21ec3bb1a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <756f897c-37d3-47ea-8026-14e21ec3bb1a@kernel.org>

On Wed, Aug 06, 2025 at 05:04:05PM +0900, Damien Le Moal wrote:
> On 8/6/25 4:46 PM, Carlos Maiolino wrote:
> > On Wed, Aug 06, 2025 at 01:34:49PM +0900, Damien Le Moal wrote:
> >> Enabling XFS realtime subvolume (XFS_RT) is mandatory to support zoned
> >> block devices. If CONFIG_BLK_DEV_ZONED is enabled, automatically select
> >> CONFIG_XFS_RT to allow users to format zoned block devices using XFS.
> >>
> >> Also improve the description of the XFS_RT configuration option to
> >> document that it is reuired for zoned block devices.
> >>
> >> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> >> ---
> >>  fs/xfs/Kconfig | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> >> index ae0ca6858496..c77118e96b82 100644
> >> --- a/fs/xfs/Kconfig
> >> +++ b/fs/xfs/Kconfig
> >> @@ -5,6 +5,7 @@ config XFS_FS
> >>  	select EXPORTFS
> >>  	select CRC32
> >>  	select FS_IOMAP
> >> +	select XFS_RT if BLK_DEV_ZONED
> >
> > This looks weird to me.
> > Obligating users to enable an optional feature in xfs if their
> > kernel are configured with a specific block dev feature doesn't
> > sound the right thing to do.
> > What if the user doesn't want to use XFS RT devices even though
> > BLK_DEV_ZONED is enabled, for whatever other purpose?
> 
> This does not force the user to use XFS_RT, it only makes that feature
> available for someone wanting to format e.g. an SMR HDD with XFS.
> I am not sure how "costly" enabling XFS_RT is if it is not used. There is for
> sure some xfs code size increase, but beside that, is it really an issue ?

The problem I want to raise is not about code size increase, but about
having XFS_RT tied with BLK_DEV_ZONED.
I know it doesn't force users to use XFS_RT, but there are distros out
there which purposely disables XFS_RT, but at the same time might want
BLK_DEV_ZONED enabled to use, for example with btrfs.

> 
> > Forcing enabling a filesystem configuration because a specific block
> > feature is enabled doesn't sound the right thing to do IMHO.
> 
> Well, it is nicer for the average user who may not be aware that this feature
> is needed for zoned block devices.

But for the average user, wouldn't be the distribution's responsibility
to actually properly enable/disable the correct configuration?
I don't see average users building their own kernel, even more actually
using host-managed/host-aware disks.

> mkfs.xfs will not complain and format an SMR
> HDD even if XFS_RT is disabled.

Well, sure, you can't tie the disk to a single machine/kernel.

> But then mount will fail with a message that
> the average user will have a hard time understanding.

Then perhaps the right thing to do is fix the message?

> This is the goal of this
> patch: making life easier for the user by ensuring that features that are
> needed to use XFS on zoned storage are all present, if zoned storage is
> supported by the kernel.

I see, but this is also tying XFS_RT with BLK_DEV_ZONED, which is my
concern here. Users (read Distros) might not actually want to have
XFS_RT enabled even if they do have BLK_DEV_ZONED.

> 
> >
> >>  	help
> >>  	  XFS is a high performance journaling filesystem which originated
> >>  	  on the SGI IRIX platform.  It is completely multi-threaded, can
> >> @@ -116,6 +117,15 @@ config XFS_RT
> >>  	  from all other requests, and this can be done quite transparently
> >>  	  to applications via the inherit-realtime directory inode flag.
> >>
> >> +	  This option is mandatory to support zoned block devices.
> >
> > What if a user wants to use another filesystem for ZBDs instead of XFS, but
> > still want to have XFS enabled? I haven't followed ZBD work too close,
> > but looking at zonedstorage.io, I see that at least btrfs also supports
> > zoned storage.
> > So, what if somebody wants to have btrfs enabled to use zoned storage,
> > but also provides xfs without RT support?
> >
> > Again, I don't think forcefully enabling XFS_RT is the right thing to
> > do.
> >
> >> For these
> >> +	  devices, the realtime subvolume must be backed by a zoned block
> >> +	  device and a regular block device used as the main device (for
> >> +	  metadata). If the zoned block device is a host-managed SMR hard-disk
> >> +	  containing conventional zones at the beginning of its address space,
> >> +	  XFS will use the disk conventional zones as the main device and the
> >> +	  remaining sequential write required zones as the backing storage for
> >> +	  the realtime subvolume.
> >> +
> >>  	  See the xfs man page in section 5 for additional information.
> >
> > 		Does it? Only section I see mentions of zoned storage is
> > 		the mkfs man page. Am I missing something?
> 
> I have not changed this line. It was there and I kept it as-is.
> Checking xfsprogs v6.15 man pages, at least mkfs.xfs page is a little light on
> comments about zoned block device support. Will improve that there.

You didn't change, but the overall context that line referred to did so
it got misleading IMHO, reason I pointed it out.

Cheers,
Carlos

> 
> >
> > Carlos
> >
> >>
> >>  	  If unsure, say N.
> >> --
> >> 2.50.1
> >>
> 
> 
> --
> Damien Le Moal
> Western Digital Research
