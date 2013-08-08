Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 256D97F56
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 12:35:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D66E7304064
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 10:35:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id MybvNnWG5GuhDJSr for
	<xfs@oss.sgi.com>; Thu, 08 Aug 2013 10:35:01 -0700 (PDT)
Message-ID: <5203D6BF.4040201@redhat.com>
Date: Thu, 08 Aug 2013 12:34:55 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/2] xfstest btrfs/316: test send / receive
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
In-Reply-To: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Schmidt <list.xfs@jan-o-sch.net>
Cc: sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/8/13 3:17 AM, Jan Schmidt wrote:
> These two patches add the announced tests for btrfs send / receive. As
> requested, the fssum tool is now included.
> 
> One drawback is that I'm unable to edit configure.ac or whatever needs
> to be modified in an autotools preferred way. Any hints appreciated,
> preferrably hints containing all the modifications required to introduce
> something like HAVE_SEEK_HOLE.

Other tests in the tree just add:

#ifndef SEEK_DATA
#define SEEK_DATA       3
#define SEEK_HOLE       4
#endif

> I do not want to make modifications to fssum.c here, if that's
> absolutely required (because one /could/ get along using linux/fs.h,
> which is not the way I would like to go), I'd like to have that changed
> in the far-progs repository where fssum.c comes from as well.

Well, unfortunately it breaks the build w/o some change or other,
on older distros:

Building src
    [CC]    fssum
fssum.c: In function 'sum_file_data_permissive':
fssum.c:243: error: 'SEEK_DATA' undeclared (first use in this function)

so this can't be merged as-is.

Adding the 4 lines above to the xfstests copy seems like a pretty obvious fix
to get the tool building and move this along.

Then, to simply skip this test if the kernel we're running on doesn't grok
SEEK_DATA, add:

_require_seek_data_hole

to your new test in patch 2.

Thanks,
-Eric

> --
> v1->v2:
>  - included fssum
>  - test number is now 316 (was 314)
> v2->v3:
>  - added missing -lcrypto to build fssum
>  - removed obsolete change in README now that fssum is included
>  - fixed comment in test/btrfs/316's header (314 -> 316)
> 
> Jan Schmidt (2):
>   xfstests: add fssum tool
>   xfstests btrfs/316: test send / receive
> 
>  .gitignore          |    1 +
>  common/config       |    2 +
>  src/Makefile        |   11 +-
>  src/fssum.c         |  819 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/316     |  113 +++++++
>  tests/btrfs/316.out |    4 +
>  tests/btrfs/group   |    1 +
>  7 files changed, 950 insertions(+), 1 deletions(-)
>  create mode 100644 src/fssum.c
>  create mode 100755 tests/btrfs/316
>  create mode 100644 tests/btrfs/316.out
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
