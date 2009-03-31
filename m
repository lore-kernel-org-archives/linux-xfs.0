Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2VNexxE036311 for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 18:41:09 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B7AD18F80B7
	for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 16:40:36 -0700 (PDT)
Message-Id: <7373F19F-AE1D-479C-9FAA-FF8DEF5BA2B7@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <1238536234-26969-3-git-send-email-jsipek@eecs.umich.edu>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH 2/2] xfstests: Add an ignore file
Date: Tue, 31 Mar 2009 18:13:07 -0500
References: <1238536234-26969-1-git-send-email-jsipek@eecs.umich.edu>
	<1238536234-26969-3-git-send-email-jsipek@eecs.umich.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>
Cc: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>, xfs@oss.sgi.com


On Mar 31, 2009, at 4:50 PM, Josef 'Jeff' Sipek wrote:

> From: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
>
> Ignore generated files.
>
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@eecs.umich.edu>

Do we really need two "Signed-off-by"s :)
Which one do you prefer?

Nice idea. I started doing the same in my tree and was
about to submit the patch.

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
> .gitignore |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++ 
> +++++++++
> 1 files changed, 90 insertions(+), 0 deletions(-)
> create mode 100644 .gitignore
>
> diff --git a/.gitignore b/.gitignore
> new file mode 100644
> index 0000000..2cd722b
> --- /dev/null
> +++ b/.gitignore
> @@ -0,0 +1,90 @@
> +*.lo
> +*.o
> +*.la
> +
> +autom4te.cache
> +configure
> +include/builddefs
> +include/config.h
> +include/config.h.in
> +lib/.libs
> +
> +dmapi/Makefile
> +dmapi/config.log
> +dmapi/config.status
> +dmapi/libtool
> +dmapi/src/Makefile
> +dmapi/src/common/Makefile
> +dmapi/src/common/cmd/.deps
> +dmapi/src/common/cmd/Makefile
> +dmapi/src/common/lib/.deps
> +dmapi/src/common/lib/Makefile
> +dmapi/src/sample_hsm/.deps
> +dmapi/src/sample_hsm/Makefile
> +dmapi/src/simple/.deps
> +dmapi/src/simple/Makefile
> +dmapi/src/suite1/Makefile
> +dmapi/src/suite1/cmd/.deps
> +dmapi/src/suite1/cmd/Makefile
> +dmapi/src/suite2/Makefile
> +dmapi/src/suite2/src/.deps
> +dmapi/src/suite2/src/Makefile
> +
> +ltp/aio-stress
> +ltp/doio
> +ltp/fsstress
> +ltp/fsx
> +ltp/growfiles
> +ltp/iogen
> +
> +src/alloc
> +src/append_reader
> +src/append_writer
> +src/bstat
> +src/bulkstat_unlink_test
> +src/bulkstat_unlink_test_modified
> +src/devzero
> +src/dirperf
> +src/dirstress
> +src/dmiperf
> +src/fault
> +src/feature
> +src/fill
> +src/fill2
> +src/fs_perms
> +src/fstest
> +src/ftrunc
> +src/genhashnames
> +src/getdevicesize
> +src/getpagesize
> +src/godown
> +src/holes
> +src/itrash
> +src/locktest
> +src/loggen
> +src/looptest
> +src/lstat64
> +src/makeextents
> +src/metaperf
> +src/mmapcat
> +src/multi_open_unlink
> +src/nametest
> +src/permname
> +src/preallo_rw_pattern_reader
> +src/preallo_rw_pattern_writer
> +src/randholes
> +src/rename
> +src/resvtest
> +src/runas
> +src/t_access_root
> +src/t_dir_offset
> +src/t_immutable
> +src/t_mtab
> +src/testx
> +src/trunc
> +src/truncfile
> +src/unwritten_mmap
> +src/unwritten_sync
> +src/usemem
> +src/writemod
> +src/xfsctl
> -- 
> 1.6.0.6
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
