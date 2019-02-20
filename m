Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:57856 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbfBTUX1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Feb 2019 15:23:27 -0500
Subject: Re: [PATCH 00/13] xfsdump: (style) remove spaces from parentheses
References: <20190114172528.65250-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5ed12c21-a605-7649-576a-bfb2b9310107@sandeen.net>
Date: Wed, 20 Feb 2019 14:23:26 -0600
MIME-Version: 1.0
In-Reply-To: <20190114172528.65250-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 1/14/19 11:25 AM, Jan Tulak wrote:
> Hi guys
> 
> Another change to make xfsdump more eyes-friendly. I hope you prefer
> this slower, once-in-a-time approach more. :-)

I've applied all of these as one commit, thanks.

-Eric

> First, why this patchset has the weird numbering: it should be just one
> patch, but because the mailing list throws away emails that are bigger
> than some 250 kB or so, I had to split it to multiple emails that all
> are 'small' enough to pass.
> 
> And as they all share the same name, it would be difficult to know which
> patch you are looking at once you apply them, so I added the numbers
> directly into the title. When merging, they can be squashed (and
> individual messages discarded, they are all the same).
> 
> All the patches do the same thing, transforming "( x, y )" to "(x, y)"
> (and dtto for []). Most of patches contain multiple files and
> directories, except 6, 7 and 10, 11. In these two pairs, I had to split
> a single file (dump/content.c and restore/content.c) into two patches as
> they would be still too big otherwise.
> 
> Some information that should help you with the review:
> - I managed to tune the script to avoid all pittfals I could find, so
>   the changes are reproducible.
> - No strings should be changed.
> - No real changes in gcc output: I made a diff of 'make' output before and
>   after and the only differences are the removed spaces where gcc already
>   complained.
> - A sight decrease of long lines (>79 chars), from 217 to 206.
> - Comparing objdumps won't work, a single space can change it. :-(
> 
> I don't think that it made any line particularly more difficult to read
> (or at least I didn't notice any).
> 
> 
> 
> Jan Tulak (13):
>   xfsdump: (1/13) (style) remove spaces from parentheses
>   xfsdump: (2/13) (style) remove spaces from parentheses
>   xfsdump: (3/13) (style) remove spaces from parentheses
>   xfsdump: (4/13) (style) remove spaces from parentheses
>   xfsdump: (5/13) (style) remove spaces from parentheses
>   xfsdump: (6/13) (style) remove spaces from parentheses
>   xfsdump: (7/13) (style) remove spaces from parentheses
>   xfsdump: (8/13) (style) remove spaces from parentheses
>   xfsdump: (9/13) (style) remove spaces from parentheses
>   xfsdump: (10/13) (style) remove spaces from parentheses
>   xfsdump: (11/13) (style) remove spaces from parentheses
>   xfsdump: (12/13) (style) remove spaces from parentheses
>   xfsdump: (13/13) (style) remove spaces from parentheses
> 
>  common/arch_xlate.c     |    8 +-
>  common/cldmgr.c         |  134 +-
>  common/cldmgr.h         |   16 +-
>  common/cleanup.c        |   66 +-
>  common/cleanup.h        |   16 +-
>  common/content.h        |   42 +-
>  common/content_common.c |   94 +-
>  common/content_common.h |    2 +-
>  common/content_inode.h  |   88 +-
>  common/dlog.c           |  284 +-
>  common/dlog.h           |   32 +-
>  common/drive.c          |  170 +-
>  common/drive.h          |  126 +-
>  common/drive_minrmt.c   | 2128 +++++++--------
>  common/drive_scsitape.c | 2948 ++++++++++-----------
>  common/drive_simple.c   |  732 +++---
>  common/exit.h           |    4 +-
>  common/fs.c             |  188 +-
>  common/fs.h             |   12 +-
>  common/global.c         |  206 +-
>  common/global.h         |   28 +-
>  common/hsmapi.c         |   22 +-
>  common/inventory.c      |  302 +--
>  common/inventory.h      |   36 +-
>  common/lock.c           |   14 +-
>  common/lock.h           |    6 +-
>  common/main.c           | 1578 ++++++------
>  common/media.c          |  126 +-
>  common/media.h          |   20 +-
>  common/media_rmvtape.h  |    6 +-
>  common/mlog.c           |  328 +--
>  common/mlog.h           |   58 +-
>  common/openutil.c       |   72 +-
>  common/openutil.h       |   22 +-
>  common/path.c           |  190 +-
>  common/path.h           |    8 +-
>  common/qlock.c          |  116 +-
>  common/qlock.h          |   18 +-
>  common/rec_hdr.h        |    4 +-
>  common/ring.c           |  228 +-
>  common/ring.h           |   20 +-
>  common/stream.c         |   96 +-
>  common/stream.h         |   26 +-
>  common/timeutil.c       |    8 +-
>  common/timeutil.h       |    6 +-
>  common/ts_mtio.h        |    2 +-
>  common/types.h          |   58 +-
>  common/util.c           |  260 +-
>  common/util.h           |   56 +-
>  dump/content.c          | 3644 +++++++++++++-------------
>  dump/getopt.h           |    2 +-
>  dump/inomap.c           |  768 +++---
>  dump/inomap.h           |   32 +-
>  dump/var.c              |   96 +-
>  dump/var.h              |    4 +-
>  include/swab.h          |   24 +-
>  include/swap.h          |   10 +-
>  inventory/getopt.h      |    2 +-
>  inventory/inv_api.c     |  414 +--
>  inventory/inv_core.c    |  106 +-
>  inventory/inv_files.c   |   10 +-
>  inventory/inv_fstab.c   |  152 +-
>  inventory/inv_idx.c     |  274 +-
>  inventory/inv_mgr.c     |  332 +--
>  inventory/inv_oref.c    |   46 +-
>  inventory/inv_oref.h    |    2 +-
>  inventory/inv_priv.h    |  244 +-
>  inventory/inv_stobj.c   |  746 +++---
>  inventory/inventory.h   |   28 +-
>  inventory/testmain.c    |  236 +-
>  invutil/cmenu.h         |   24 +-
>  invutil/fstab.c         |   12 +-
>  invutil/invidx.c        |   76 +-
>  invutil/invutil.c       |  246 +-
>  invutil/invutil.h       |    6 +-
>  invutil/stobj.c         |   32 +-
>  librmt/rmtcommand.c     |    2 +-
>  librmt/rmtfstat.c       |    6 +-
>  librmt/rmtioctl.c       |   18 +-
>  librmt/rmtopen.c        |    4 +-
>  librmt/rmtstatus.c      |    8 +-
>  librmt/rmtwrite.c       |    2 +-
>  restore/bag.c           |   70 +-
>  restore/bag.h           |   20 +-
>  restore/content.c       | 5414 +++++++++++++++++++--------------------
>  restore/dirattr.c       |  682 ++---
>  restore/dirattr.h       |   46 +-
>  restore/getopt.h        |    2 +-
>  restore/inomap.c        |  288 +--
>  restore/inomap.h        |   34 +-
>  restore/mmap.c          |    2 +-
>  restore/namreg.c        |  234 +-
>  restore/namreg.h        |   12 +-
>  restore/node.c          |  328 +--
>  restore/node.h          |   12 +-
>  restore/tree.c          | 2874 ++++++++++-----------
>  restore/tree.h          |   48 +-
>  restore/win.c           |  138 +-
>  restore/win.h           |   12 +-
>  99 files changed, 14417 insertions(+), 14417 deletions(-)
> 
