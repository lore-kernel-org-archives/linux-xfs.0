Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:37393 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754162AbeDWI0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Apr 2018 04:26:50 -0400
Received: by mail-wr0-f177.google.com with SMTP id f14-v6so38698240wre.4
        for <linux-xfs@vger.kernel.org>; Mon, 23 Apr 2018 01:26:50 -0700 (PDT)
Date: Mon, 23 Apr 2018 10:26:46 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] db: Stop core dumping on attr3 if block header is
 not recognized
Message-ID: <20180423082646.wmz4vkhhuysdbepd@odin.usersys.redhat.com>
References: <20180418094935.12495-1-cmaiolino@redhat.com>
 <9514c503-e5ba-3ca0-dd5d-83d4c81f97f5@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9514c503-e5ba-3ca0-dd5d-83d4c81f97f5@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

Hi,

> > xfs_db> fsblock 2
> > xfs_db> type attr3
> > Unknown attribute buffer type!
> > Unknown attribute buffer type!
> > xfs_db> p
> > Unrecognized attr3 block, possible magic number:
> > Unrecognized attr3 block, possible magic number:
> > hdr.magic = 0x41423343
> 
> I think that if we are going to print anything, we should print it as an
> entire, known structure so that the user can decide if it even looks close or
> if they just missed... printing only the "magic" which may not even be the
> magic for the actual type of block it /should/ be might not be as helpful,
> especially if we don't even know what type of "header" this magic lives in.
> 
> So it seems like casting it into something the user might expect would
> be better?
> 

Not sure, in this case, the 'user' is expaecting an attr3 type, while xfs_db is
reading some other random, non attr3 type block. So, I wonder, what you meant by
'something the user might expect'? The way I view it is: "The user is expecting
attr3 type", but there is no attr3 data in the block being read, so, the way I
understand what you meant, was trying to print the current block using attr3
format, which, IMHO, might fool the xfs_db user. I think saying the block
doesn't match attr3 format, and printing a possible magic number found in the
block works better. After all, xfs_db is a developer tool, not an user tool. If
I use myself and my xfs_db usage as an example:
If I try to print some block as attr3, and I see a message saying no attr3
format has been found, and I got a dump of a possible magic number, I can check
if that magic number matches some metadata format, or if it doesn't look as a
magic at all, I can simply consider the block corrupted. But well, this is just
my way to view it.

> let's see.
> 
> leaf and node blocks both start with a xfs_da3_blkinfo struct, remote is
> different :( it starts with xfs_attr3_rmt_hdr, and of course they have
> the magic in different places.
> 
> 
> What if we had two "unknown" counter functions, and they each printed 
> their own possible struct after a printf that explains what they're showing,
> something like:
> 
> +       { "unk.blkinfo", FLDT_ATTR3_BLKINFO, OI(0), attr3_unknown_hdr_blkinfo_count,
> +         FLD_COUNT, TYP_NONE },
> +       { "unk.remote", FLDT_ATTR3_REMOTE_HDR, OI(0), attr3_unknown_hdr_remote_count,
> +         FLD_COUNT, TYP_NONE },
> 
> xfs_db> p
> Uknown attr3 type, printing as blkinfo
> Uknown attr3 type, printing as remote
> Uknown attr3 type, printing as blkinfo  <---  dunno why these gets printed twice
> Uknown attr3 type, printing as remote

Probably due a print of the 'parent' and another print on 'child', but it's just
a guess :)

> unk.blkinfo.hdr.forw = 0
> unk.blkinfo.hdr.back = 0
> unk.blkinfo.hdr.magic = 0
> unk.blkinfo.crc = 0 (correct)
> unk.blkinfo.bno = 0
> unk.blkinfo.lsn = 0
> unk.blkinfo.uuid = 00000000-0000-0000-0000-000000000000
> unk.blkinfo.owner = 0
> unk.remote.magic = 0
> unk.remote.offset = 0
> unk.remote.bytes = 0
> unk.remote.crc = 0 (correct)
> unk.remote.uuid = 00000000-0000-0000-0000-000000000000
> unk.remote.owner = 0
> unk.remote.bno = 0
> unk.remote.lsn = 0
> 
> 
> ?
> 
> Is this getting too tricksy?

Ok, but, what's the difference in doing this, and simply printing out an "unknown
type" message? All the fields are zeroed, showing no clue if the block is from a
different type, or corrupted in some way, mainly because, if we ever hit this
'problem', we are likely to have no idea if the current block would be a leaf or
a node, so, IMHO, it is just no informative at all, but again, this is just my
humble opinion :)


-- 
Carlos
