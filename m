Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41408 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388110AbeGXBJr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 21:09:47 -0400
Subject: Re: [PATCH 0/4 V2] Remove a few macros
References: <20180307090506.30199-1-cmaiolino@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <76bd325f-4a65-e09c-fde5-a41dcff56d97@sandeen.net>
Date: Mon, 23 Jul 2018 17:06:04 -0700
MIME-Version: 1.0
In-Reply-To: <20180307090506.30199-1-cmaiolino@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org

On 3/7/18 1:05 AM, Carlos Maiolino wrote:
> Hi,
> 
> this is a second version of the patchset aimed to clean up some old macros from
> xfsprogs, as the objective to bring xfs_buf handling code closer to kernel code.
> 
> It fixes some pointer castings Dave mentioned on the V1 patch, also, it removes
> a few unneeded castings I spotted while reviewing the ones Dave mentioned.
> 
> Cheers

Ok, I'll take this, with the explicit char * casts (seems to be the popular
vote, and TBH I guess I prefer the explicit nature of that approach).

There are a couple of extra ones now in your first patch though,
i.e.

ptr = (char *)bp->b_addr;

is not needed.

I fixed up minor conflicts, no need to resend.

-Eric
 
> Carlos Maiolino (4):
>   Get rid of XFS_BUF_PTR() macro
>   Get rid of XFS_BUF_TARGET() macro
>   get rid of XFS_BUF_COUNT() macro
>   Get rid of XFS_BUF_SET_COUNT() macro
> 
>  libxfs/libxfs_io.h        |  6 +-----
>  libxfs/logitem.c          |  2 +-
>  libxfs/rdwr.c             | 10 +++++-----
>  libxfs/trans.c            |  2 +-
>  libxlog/xfs_log_recover.c |  2 +-
>  logprint/log_print_all.c  |  4 ++--
>  mkfs/proto.c              |  8 ++++----
>  mkfs/xfs_mkfs.c           | 14 +++++++-------
>  repair/agheader.c         |  8 ++++----
>  repair/attr_repair.c      |  4 ++--
>  repair/dino_chunks.c      |  2 +-
>  repair/phase6.c           |  4 ++--
>  repair/prefetch.c         |  4 ++--
>  13 files changed, 33 insertions(+), 37 deletions(-)
> 
