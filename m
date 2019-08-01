Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731140AbfHAKsR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 1 Aug 2019 06:48:17 -0400
Date: Thu, 1 Aug 2019 06:48:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/5] xfs: test new v5 bulkstat commands
Message-ID: <20190801104814.GC59093@bfoster>
References: <156462375516.2945299.16564635037236083118.stgit@magnolia>
 <156462379043.2945299.17354996626313190310.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156462379043.2945299.17354996626313190310.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Wed, Jul 31, 2019 at 06:43:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Check that the new v5 bulkstat commands do everything the old one do,
> and then make sure the new functionality actually works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  .gitignore                 |    1 
>  src/Makefile               |    2 
>  src/bulkstat_null_ocount.c |   61 +++++++++
>  tests/xfs/744              |  215 ++++++++++++++++++++++++++++++++
>  tests/xfs/744.out          |  297 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/745              |   47 +++++++
>  tests/xfs/745.out          |    2 
>  tests/xfs/group            |    2 
>  8 files changed, 626 insertions(+), 1 deletion(-)
>  create mode 100644 src/bulkstat_null_ocount.c
>  create mode 100755 tests/xfs/744
>  create mode 100644 tests/xfs/744.out
>  create mode 100755 tests/xfs/745
>  create mode 100644 tests/xfs/745.out
> 
> 
...
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 270d82ff..ef0cf92c 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -506,3 +506,5 @@
>  506 auto quick health
>  507 clone
>  508 auto quick quota
> +744 auto ioctl quick
> +745 auto ioctl quick
> 

One quick note that xfs/744 runs in ~68 seconds in my (low resource)
test VM. Not a problem in and of itself, but it seems slightly long for
the quick group. Can somebody remind me of the quick group criteria?

FWIW if I kick off a quick group run, the first 10-15 tests complete in
10s or so or less with the exception of generic/013, which takes over a
minute. So perhaps anything under a minute or so is fine..? Either way,
that can be easily changed on merge if appropriate:

Reviewed-by: Brian Foster <bfoster@redhat.com>
