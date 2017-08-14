Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51164 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752382AbdHNUUW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 16:20:22 -0400
Subject: Re: [PATCH RFC 0/2] xfs: refactor ordered buffer logging code
References: <20170814165451.43788-1-bfoster@redhat.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <98b6b601-7f19-8188-eada-7b0add3e2817@oracle.com>
Date: Mon, 14 Aug 2017 13:20:08 -0700
MIME-Version: 1.0
In-Reply-To: <20170814165451.43788-1-bfoster@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

Based on previous discussions, these two look good to me.  You can add 
my review:
Reviewed by: Allison Henderson <allison.henderson@oracle.com>

On 08/14/2017 09:54 AM, Brian Foster wrote:
> Hi all,
>
> Here's an initial refactoring based on the discussion on Alex's empty
> xattr leaf buffer holding patch [1]. These patches split off some of
> xfs_trans_log_buf() into a new helper and update xfs_trans_ordered_buf()
> to use it and thus eliminate the need to log dirty ranges on ordered
> buffers. The secondary purpose here is to create a function that we can
> call from deferred ops processing to relog an already dirty/held buffer
> across transaction rolls.
>
> Note that this has only been very lightly tested and I might have one or
> two more cleanups to tack on. Thoughts, reviews, flames appreciated...
>
> Brian
>
> [1] https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.info_-3Fl-3Dlinux-2Dxfs-26m-3D150227679029089-26w-3D2&d=DwIBAg&c=RoP1YumCXCgaWHvlZYR8PQcxBKCX5YTpkKY057SbK10&r=XFp4B05bcXkJ0dhYaFjd3F8telP01COkBp9cI7mKLb4&m=uWQD8gXmLnvThUaUiXNvMO_K_m7Ggg0h8HanYV0UWOY&s=Tw0p-QrZOdg2EYm3cUzm2ND1Fsoy98wwY9VG8I1viEQ&e=
>
> Brian Foster (2):
>    xfs: refactor buffer logging into buffer dirtying helper
>    xfs: don't log dirty ranges for ordered buffers
>
>   fs/xfs/libxfs/xfs_btree.c  |  3 +-
>   fs/xfs/libxfs/xfs_ialloc.c |  2 --
>   fs/xfs/xfs_trans.h         |  4 ++-
>   fs/xfs/xfs_trans_buf.c     | 71 ++++++++++++++++++++++++++++------------------
>   4 files changed, 48 insertions(+), 32 deletions(-)
>

