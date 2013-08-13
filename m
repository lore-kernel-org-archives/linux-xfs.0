Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D6EB7F74
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 13:33:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4A29F8F8064
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 11:33:21 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 4zHzUV6uP3ayzx7M for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 11:33:18 -0700 (PDT)
Message-ID: <520A7BEC.3010301@sandeen.net>
Date: Tue, 13 Aug 2013 13:33:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/2] xfstest btrfs/316: test send / receive
References: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
In-Reply-To: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
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

On 8/13/13 12:24 PM, Jan Schmidt wrote:
> These two patches add the announced tests for btrfs send / receive. As
> requested, the fssum tool is now included.


Thanks for the updates.

Both:
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> --
> v1->v2:
>  - included fssum
>  - test number is now 316 (was 314)
> v2->v3:
>  - added missing -lcrypto to build fssum
>  - removed obsolete change in README now that fssum is included
>  - fixed comment in test/btrfs/316's header (314 -> 316)
> v3->v4:
>  - build fssum with help of autotools only if libssl is available
>  - removed clumsy OPT_TARGETS in src/Makefile
>  - added #define directives for SEEK_DATA and SEEK_HOLE to fssum.c
> 
> Jan Schmidt (2):
>   xfstests: add fssum tool
>   xfstests btrfs/316: test send / receive
> 
>  .gitignore           |    1 +
>  aclocal.m4           |    1 +
>  configure.ac         |    1 +
>  include/builddefs.in |    1 +
>  m4/Makefile          |    1 +
>  m4/package_ssldev.m4 |    4 +
>  src/Makefile         |    8 +
>  src/fssum.c          |  828 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/316      |  116 +++++++
>  tests/btrfs/316.out  |    4 +
>  tests/btrfs/group    |    1 +
>  11 files changed, 966 insertions(+), 0 deletions(-)
>  create mode 100644 m4/package_ssldev.m4
>  create mode 100644 src/fssum.c
>  create mode 100755 tests/btrfs/316
>  create mode 100644 tests/btrfs/316.out
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
