Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53242C001DB
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Aug 2023 22:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjHEWhZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 5 Aug 2023 18:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjHEWhY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Aug 2023 18:37:24 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DE6E78
        for <linux-xfs@vger.kernel.org>; Sat,  5 Aug 2023 15:37:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-686f94328a4so2202599b3a.0
        for <linux-xfs@vger.kernel.org>; Sat, 05 Aug 2023 15:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691275042; x=1691879842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5Y7uZrGV4pXKjcie3SXs7zSDOa1aIfGDI0IxhnDy3nk=;
        b=DQjahdFRlI5byNDZSqWAEOBubzXUjldHCBFPoxk3B3lXCboGqHee7Yre9ZXn/PUpcY
         9UFI6N9LuCgy5xwJG9J/LZGF4GIx4wPUMzN/5ttEClvrrpFMAlCHQQNGlonug2HPfqsf
         hRgyNvSvmctO3yex4SUNlScfV+Zqtec3qlk4oOfTd7ElKdIu0L5VmgDpEmErNqbcT5Pv
         M4QTzfr9sBLhm1Ed1V0zw+p7j1LCYFHYFdIDuIXLLrn0kh2D664+36UxMQZkpQuIBUIH
         +AHX6/KRRAcoqsms3uuQ3AmW6ByEWmikq7s4KuMxAWiLiJxkoNOhH79UKP6SgIiQ/b4w
         2Ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691275042; x=1691879842;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Y7uZrGV4pXKjcie3SXs7zSDOa1aIfGDI0IxhnDy3nk=;
        b=Mg76urpcr6B3nQ69tpWsJDNOTT4mScnb6HCOMCODcgfWvrwj99XTsc1URHMKk3GD/V
         rDWmW6l1zPgSERfvXv9iyZwrGi+A/hlaucaNqBSwefpQ9IaBE0TcqFzXS70WUXT/gApP
         GRb3O8mxr6Ep/MLjW+tPN4e5f09D8VJMRp3I+NXL3By9FSjh96FuFcasmA2BX05JKDUJ
         e2kVFrySvlq45iOTcB4pMw88UVGFc+60mlp6WKzrE5zUNkFeqi3wvCElhTen2aI/t2rh
         I1iMLLWtKltoTXN7IwB4pRuS3e3lUFQdA4TVKZIIyT/qbiyb9+Hs0ATjrcQge/pmyD2R
         1QaQ==
X-Gm-Message-State: AOJu0YxWkWCaXFGlrmwC4Vy3MXyGPdmTkjatySK+P9oBUA2p0LxAmrXm
        5mjuYdz+yKoEwjA0CyPFq0u21VqXHxGoJmrmi54=
X-Google-Smtp-Source: AGHT+IEaA4xYMrkHlxDvRNSof/zIyi+i758GHysiaw9uHRkrpMeKPdDH3p03mc94JSon2kEjvInfXA==
X-Received: by 2002:a05:6a20:729d:b0:125:4d74:cd6a with SMTP id o29-20020a056a20729d00b001254d74cd6amr4473506pzk.3.1691275041945;
        Sat, 05 Aug 2023 15:37:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id g28-20020a63375c000000b005633941a547sm2868668pgn.27.2023.08.05.15.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Aug 2023 15:37:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qSPtd-001aXO-1p;
        Sun, 06 Aug 2023 08:37:17 +1000
Date:   Sun, 6 Aug 2023 08:37:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Corey Hickey <bugfood-ml@fatooh.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: read-modify-write occurring for direct I/O on RAID-5
Message-ID: <ZM7PHRsOqfJ71fMN@dread.disaster.area>
References: <55225218-b866-d3db-d62b-7c075dd712de@fatooh.org>
 <ZMyxp/Udved6l9F/@dread.disaster.area>
 <db157228-3687-57bf-d090-10517847404d@fatooh.org>
 <ZM1zOFWVm9lD8pNc@dread.disaster.area>
 <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f21f5eb-803f-c8d1-503a-bb0addeef01f@fatooh.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 04, 2023 at 06:44:47PM -0700, Corey Hickey wrote:
> On 2023-08-04 14:52, Dave Chinner wrote:
> > On Fri, Aug 04, 2023 at 12:26:22PM -0700, Corey Hickey wrote:
> > > On 2023-08-04 01:07, Dave Chinner wrote:
> > > > If you want to force XFS to do stripe width aligned allocation for
> > > > large files to match with how MD exposes it's topology to
> > > > filesytsems, use the 'swalloc' mount option. The down side is that
> > > > you'll hotspot the first disk in the MD array....
> > > 
> > > If I use 'swalloc' with the autodetected (wrong) swidth, I don't see any
> > > unaligned writes.
> > > 
> > > If I manually specify the (I think) correct values, I do still get writes
> > > aligned to sunit but not swidth, as before.
> > 
> > Hmmm, it should not be doing that - where is the misalignment
> > happening in the file? swalloc isn't widely used/tested, so there's
> > every chance there's something unexpected going on in the code...
> 
> I don't know how to tell the file position, but I wrote a one-liner for
> blktrace that may help. This should tell the position within the block
> device of writes enqueued.

xfs_bmap will tell you the file extent layout (offset to lba relationship).
(`xfs_bmap -vvp <file>` output is prefered if you are going to paste
it into an email.)

> For every time the alignment _changes_, the awk program prints:
> * the previous line (if it exists and was not already printed)
> * the current line
> 
> Lines from blktrace are prefixed by:
> * a 'c' or 'p' for debugging the awk program
> * the offset from a 2048-sector alignment
> * a '--' as a separator
> 
> I have manually inserted blank lines into the output in order to
> visually separate into three sections:
> 1. writes predominantly stripe-aligned
> 2. writes predominantly offset by one chunk
> 3. writes predominantly stripe-aligned again
> 
> -----------------------------------------------------------------------
> $ sudo blktrace -d /dev/md10 -o - | blkparse -i - | awk 'BEGIN { prev=""; prev_offset=-1; } / Q / { offset=$8 % 2048; if (offset != prev_offset) { if (prev) { printf("p %4d -- %s\n", prev_offset, prev); prev="" }; printf("c %4d -- %s\n", offset, $0); prev_offset=offset; fflush(); } else { prev=$0 }} '
> c   32 --   9,10  11        1     0.000000000 213852  Q  RM 32 + 8 [dd]
> c   24 --   9,10  11        2     0.000253462 213852  Q  RM 24 + 8 [dd]

inobt + finobt metadata reads.

> c 1024 --   9,10  11        3     0.000434115 213852  Q  RM 1024 + 32 [dd]

Inode cluster read.

> c    3 --   9,10  11        4     0.001008057 213852  Q  RM 3 + 1 [dd]

AGFL read.

> c   16 --   9,10  11        5     0.001165978 213852  Q  RM 16 + 8 [dd]
> c    8 --   9,10  11        6     0.001328206 213852  Q  RM 8 + 8 [dd]

AG freespace btree block reads.

<inode now allocated>

> c    0 --   9,10  11        7     0.001496647 213852  Q  WS 2048 + 2048 [dd]

Data writes.

> p    0 --   9,10   1      469    10.544416303 213852  Q  WS 6301696 + 2048 [dd]
> c  128 --   9,10   1      471    10.545831615 213789  Q FWFSM 62906496 + 64 [kworker/1:3]
> c    0 --   9,10   1      472    10.548127201 213852  Q  WS 6303744 + 2048 [dd]

Seek for journal IO between two sequential, contiguous data writes.

> p    0 --   9,10   0     5791    13.109985396 213852  Q  WS 7804928 + 2048 [dd]
> c 1027 --   9,10   0     5793    13.113192558 213852  Q  RM 7863299 + 1 [dd]
> c 1040 --   9,10   0     5794    13.136165405 213852  Q  RM 7863312 + 8 [dd]
> c 1032 --   9,10   0     5795    13.136458182 213852  Q  RM 7863304 + 8 [dd]

Data write at tail end of AG, followed by read of the AGF and AG
freespace btree blocks in next AG...

> c 1024 --   9,10   0     5796    13.136568992 213852  Q  WS 7865344 + 2048 [dd]

... And the data write continues but I don;t think that is aligned.

$ echo $(((7865344 / 2048) * 2048))
7864320
$

Yeah, so if that was aligned, it would start at LBA 7864320, not
7865344.

> p 1024 --   9,10   1     2818    41.250430374 213852  Q  WS 12133376 + 2048 [dd]
> c  192 --   9,10   1     2820    41.266187726 213789  Q FWFSM 62906560 + 64 [kworker/1:3]
> c 1024 --   9,10   1     2821    41.275578120 213852  Q  WS 12135424 + 2048 [dd]

Journal IO breaking up two unaligned contiguous data writes.

> c    2 --   9,10   5        1    41.266226029 213819  Q  WM 2 + 1 [xfsaild/md10]
> c   24 --   9,10   5        2    41.266236639 213819  Q  WM 24 + 8 [xfsaild/md10]
> c   32 --   9,10   5        3    41.266242160 213819  Q  WM 32 + 8 [xfsaild/md10]
> c 1024 --   9,10   5        4    41.266246318 213819  Q  WM 1024 + 32 [xfsaild/md10]

Metadata writeback of AGI 0, inobt, finobt and inode cluster blocks.

> p 1024 --   9,10   1     2823    41.308444405 213852  Q  WS 12137472 + 2048 [dd]
> c  256 --   9,10  10      706    41.322338854 207685  Q FWFSM 62906624 + 64 [kworker/u64:11]
> c 1024 --   9,10   1     2825    41.334778677 213852  Q  WS 12139520 + 2048 [dd]

Journal IO.

> p 1024 --   9,10   3     3739    64.424114908 213852  Q  WS 15668224 + 2048 [dd]
> c    3 --   9,10   3     3741    64.445830212 213852  Q  RM 15726595 + 1 [dd]
> c   16 --   9,10   3     3742    64.455104423 213852  Q  RM 15726608 + 8 [dd]
> c    8 --   9,10   3     3743    64.463494822 213852  Q  RM 15726600 + 8 [dd]

Next AG. So the entire AG was written unaligned - that is expected
because this is appending and that aims for contiguous allocation,
not aligned allocation.

> c    0 --   9,10   3     3744    64.470414156 213852  Q  WS 15728640 + 2048 [dd]

And the first allocation in the next AG is properly aligned.

Ok. SO it appears that something is not working 100% w.r.t. aligned
allocation on the transition from one AG to the next. I wonder if
we've failed the "at EOF" allocation because there isn't space in
the AG and then done an "any AG" unaligned allocation as the
fallback?

I'll have to see if I can replicate this now I know that it appears
to be the full AG -> first allocation in next AG fallback that
appears to be going astray....

> > One thing to try is to set extent size hints for the directories
> > these large files are going to be written to. That takes a lot of
> > the allocation decisions away from the size/shape of the individual
> > IO and instead does large file offset aligned/sized allocations
> > which are much more likely to be stripe width aligned. e.g. set a
> > extent size hint of 16MB, and the first write into a hole will
> > allocate a 16MB chunk around the write instead of just the size that
> > covers the write IO.
> 
> Can you please give me a documentation pointer for that? I wasn't able
> to find the right thing via searching.

$ man 2 ioctl_xfs_fsgetxattr
....
       fsx_extsize is the preferred extent allocation size for data
       blocks mapped to this file, in units of filesystem blocks.
       If this value is zero, the filesystem will choose a default
       option, which is currently zero.  If XFS_IOC_FSSETXATTR is
       called with XFS_XFLAG_EXTSIZE set in fsx_xflags and this
       field set to zero, the XFLAG will also be cleared.
....
       XFS_XFLAG_EXTSIZE
	      Extent size bit - if a basic extent size value is set
	      on the file then the allocator will allocate in
	      multiples of the set size for this file (see
	      fsx_extsize below).  The extent size can only be
	      changed on a file when it has no allocated extents.
....
$ man xfs_io
....
       extsize [ -R | -D ] [ value ]
	      Display  and/or  modify  the  preferred extent size
	      used when allocating space for the currently open
	      file. If the -R option is specified, a recursive
	      descent is performed for all directory entries below
	      the currently open file (-D can be used to restrict
	      the  output  to directories only).  If the target file
	      is a directory, then the inherited extent size is set
	      for that directory (new files created in that
	      directory inherit that extent size).  The value should
	      be specified in bytes, or using  one  of  the usual
	      units suffixes (k, m, g, b, etc). The extent size is
	      always reported in units of bytes.
....
$ man mkfs.xfs
....
                   extszinherit=value
			  All  inodes created by mkfs.xfs will have
			  this value extent size hint applied.  The
			  value must be provided in units of
			  filesystem blocks.  Directories will pass
			  on this hint to newly created regular
			  files and directories.
....

> I see some references to size hints in mkfs.xfs, but it seems like you
> refer to something to be set for specific directories at run-time.

It's the same thing, just set up different ways.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
