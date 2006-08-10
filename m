Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 Aug 2006 22:49:58 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7A5nBDW002906
	for <xfs@oss.sgi.com>; Wed, 9 Aug 2006 22:49:23 -0700
Date: Thu, 10 Aug 2006 15:48:18 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: XFS fix for 2.6.18-rc5
Message-ID: <20060810154817.A2591606@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, xfs@oss.sgi.com

Hi Greg,

Please pull from:
	git://oss.sgi.com:8090/nathans/xfs-rc-2.6

This will update the following files:

 fs/xfs/xfs_alloc.c |  103 +++++++++++++++++++++++++++-------------------------
 1 files changed, 54 insertions(+), 49 deletions(-)

through these commits:

commit 0e1edbd99994270023cea5afe593f972eb09a778
Author: Nathan Scott <nathans@sgi.com>
Date:   Thu Aug 10 14:40:41 2006 +1000

    [XFS] Fix xfs_free_extent related NULL pointer dereference.
    
    We recently fixed an out-of-space deadlock in XFS, and part of that fix
    involved the addition of the XFS_ALLOC_FLAG_FREEING flag to some of the
    space allocator calls to indicate they're freeing space, not allocating
    it. There was a missed xfs_alloc_fix_freelist condition test that did not
    correctly test "flags". The same test would also test an uninitialised
    structure field (args->userdata) and depending on its value either would
    or would not return early with a critical buffer pointer set to NULL.
    
    This fixes that up, adds asserts to several places to catch future botches
    of this nature, and skips sections of xfs_alloc_fix_freelist that are
    irrelevent for the space-freeing case.
    
    SGI-PV: 955303
    SGI-Modid: xfs-linux-melb:xfs-kern:26743a
    
    Signed-off-by: Nathan Scott <nathans@sgi.com>


-- 
Nathan
