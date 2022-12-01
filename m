Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0118CC4321E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Dec 2022 02:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbiLACMv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 30 Nov 2022 21:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLACMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Nov 2022 21:12:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093CE1583A
        for <linux-xfs@vger.kernel.org>; Wed, 30 Nov 2022 18:12:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FD8761E28
        for <linux-xfs@vger.kernel.org>; Thu,  1 Dec 2022 02:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4435EC433C1;
        Thu,  1 Dec 2022 02:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669860767;
        bh=+uOQVuU56FCKGDr2dGbqkc3UlLC0WmIkeKVPK8NANSM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QNYuT1mdFEWB0Ok4fck/G8N+1I9WW2WccMOdN6w7+WOlXhLY4noqp8AVdoucLo2V4
         vZW0rQQIdbsRYm3/7lCzazA6AusnUnJdC9DHQWsrbvSAzQ1Zb6ZZwGvga9CdrYQq9P
         +cVo/PD4NKgyyBe1PS+srV2HNu2pYQMR+FtJztNVkJM8tV1p1pHmHNfOjhuVz/VNMz
         HRTp9nWpitYfr5NOZ7b2p/lK1SgvW9osJ0jmR1iU1P3l5YomwzmGPAYq0D25ckUzCM
         JAHAY7T/6tmAIeMte19Ev2aROb25sb89yt+bLxc9jePlQ+1xVw+sSfUJ1eJleC/ODk
         dvu2e/gukgrSA==
Date:   Wed, 30 Nov 2022 18:12:46 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chris Boot <lists@bootc.boo.tc>, linux-xfs@vger.kernel.org
Subject: Re: XFS corruption help; xfs_repair isn't working
Message-ID: <Y4gNntJTb1dZLejo@magnolia>
References: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
 <20221129220646.GI3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129220646.GI3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 30, 2022 at 09:06:46AM +1100, Dave Chinner wrote:
> On Tue, Nov 29, 2022 at 08:49:27PM +0000, Chris Boot wrote:
> > Hi all,
> > 
> > Sorry, I'm mailing here as a last resort before declaring this filesystem
> > done for. Following a string of unclean reboots and a dying hard disk I have
> > this filesystem in a very poor state that xfs_repair can't make any progress
> > on.
> > 
> > It has been mounted on kernel 5.18.14-1~bpo11+1 (from Debian
> > bullseye-backports). Most of the repairs were done using xfsprogs 5.10.0-4
> > (from Debian bullseye stable), though I did also try with 6.0.0-1 (from
> > Debian bookworm/testing re-built myself).
> > 
> > I've attached the full log from xfs_repair, but the summary is it all starts
> > with multiple instances of this in Phase 3:
> > 
> > Metadata CRC error detected at 0x5609236ce178, xfs_dir3_block block
> > 0xe101f32f8/0x1000
> > bad directory block magic # 0x1859dc06 in block 0 for directory inode
> > 64426557977
> > bad bestfree table in block 0 in directory inode 64426557977: repairing
> > table
> 
> I think that the problem is that we are trying to repair garbage
> without completely reinitialising the directory block header. We
> don't bother checking the incoming directory block for sanity after
> the CRC fails, and then we only warn that it has a bad magic number.
> 
> We then go a process it as though it is a directory block,
> essentially trusting that the directory block header is actually
> sane. Which it clearly isn't because the magic number in the dir
> block has been trashed.
> 
> We then rescan parts of the directory block and rewrite parts of the
> block header, but the next time we re-scan the block we find that
> there are still bad parts in the header/directory block. Then we
> rewrite the magic number to make it look like a directory block,
> and when repair is finished it goes to write the recovered directory
> block to disk and it fails the verifier check - it's still a corrupt
> directory block because it's still full of garbage that doesn't pass
> muster.
> 
> From a recovery persepective, I think that if we get a bad CRC and
> an unrecognisable magic number, we have no idea what the block is
> meant to contain - we cannot trust it to contain directory
> information, so we should just trash the block rather than try to
> rebuild it. If it was a valid directory block, this will result in
> the files it pointed to being moved to lost+found so no data is
> actually lost.
> 
> If it wasn't a dir block at all, then simply trashing the data fork
> of the inode and not touching the contents of the block at all is
> right thing to do. Modifying something that may be cross-linked
> before we've resolved all the cross-linked extents is a bad thing to
> be doing, so if we cannot recognise the block as a directory block,
> we shouldn't try to recover it as a directory block at all....
> 
> Darrick, what are your thoughts on this?

I kinda want to see the metadump of this (possibly enormous) filesystem.

Probably the best outcome is to figure out which blocks in each
directory are corrupt, remove them from the data fork mapping, and see
if repair can fix up the other things (e.g. bestfree data) and dump the
unlinked files in /lost+found.  Hopefully rsnapshot can deal with the
directory tree if we can at least get the bad dirblocks out of the way.

If reflink is turned on, repair can deal with crosslinked file data
blocks, though anything other kind of block results in the usual
scraping-till-its-clean behavior.

I'm also kinda curious what started this corruption problem, and did any
of it leak through to other files?

--D

> > As it is the filesystem can be mounted and most data appears accessible, but
> > several directories are corrupt and can't be read or removed; the kernel
> > reports metadata corruption and CRC errors and returns EUCLEAN.
> > 
> > Ideally I'd like to remove the corrupt directories, recover as much of
> > what's left as possible, and make the filesystem usable again (it's an
> > rsnapshot destination) - but I'll take what I can.
> 
> Yup, it's only a small number of directory inodes, so we might be
> able to do this with some manual xfs_db magic. I think all we'd
> need to do is rewrite specific parts of the dir block header and
> repair should then do the rest...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
