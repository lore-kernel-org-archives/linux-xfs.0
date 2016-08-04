Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D246B7CA0
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 23:24:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63267AC003
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 21:24:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9jC3u2dqt6dwxDcB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Aug 2016 21:24:50 -0700 (PDT)
Date: Thu, 4 Aug 2016 12:24:48 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v2] xfs: test attr_list_by_handle cursor iteration
Message-ID: <20160804042448.GR27776@eguan.usersys.redhat.com>
References: <20160802235251.GB8586@birch.djwong.org>
	<20160803225150.GC25565@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160803225150.GC25565@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, Aug 03, 2016 at 03:51:50PM -0700, Darrick J. Wong wrote:
> Apparently the XFS attr_list_by_handle ioctl has never actually copied
> the cursor contents back to user space, which means that iteration has
> never worked.  Add a test case for this and see
> "xfs: in _attrlist_by_handle, copy the cursor back to userspace".
> 
> v2: Use BULKSTAT_SINGLE for less confusion, fix build errors on RHEL6.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  .gitignore                            |    1 
>  src/Makefile                          |    3 -
>  src/attr-list-by-handle-cursor-test.c |  185 +++++++++++++++++++++++++++++++++
>  tests/xfs/700                         |   64 +++++++++++
>  tests/xfs/700.out                     |    5 +
>  tests/xfs/group                       |    1 
>  6 files changed, 258 insertions(+), 1 deletion(-)
>  create mode 100644 src/attr-list-by-handle-cursor-test.c
>  create mode 100755 tests/xfs/700
>  create mode 100644 tests/xfs/700.out
> 

[snip]

> +
> +	read_handle_xattrs(&handle, false);
> +	read_handle_xattrs(&handle, true);

I have to replace false/true with 0/1 to build it on RHEL6. I can fix it
at commit time if there's no other major updates.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
