Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbdHaK2k (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Aug 2017 06:28:40 -0400
Date: Thu, 31 Aug 2017 18:28:37 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 3/4] xfs: test rmapbt updates are correct with
 insert/collapse range
Message-ID: <20170831102837.GK27835@eguan.usersys.redhat.com>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
 <150406806291.31349.16354828502139354709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406806291.31349.16354828502139354709.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Aug 29, 2017 at 09:41:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that we update the rmapbt correctly when we collapse-range a
> file and the extents on both sides of the hole can be merged.  We can
> construct this pretty trivially with insert-range and write, so test
> that too.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  src/punch-alternating.c |   15 +++++-
>  tests/xfs/706           |  127 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/706.out       |    9 +++
>  tests/xfs/group         |    1 
>  4 files changed, 150 insertions(+), 2 deletions(-)
>  create mode 100755 tests/xfs/706
>  create mode 100644 tests/xfs/706.out
> 
> 
> diff --git a/src/punch-alternating.c b/src/punch-alternating.c
> index 25228cd..281e283 100644
> --- a/src/punch-alternating.c
> +++ b/src/punch-alternating.c
> @@ -24,6 +24,7 @@ int main(int argc, char *argv[])
>  	struct stat	s;
>  	struct statfs	sf;
>  	off_t		offset;
> +	off_t		start_offset = 0;
>  	int		fd;
>  	blksize_t	blksz;
>  	off_t		sz;
> @@ -33,11 +34,19 @@ int main(int argc, char *argv[])
>  	int		size = 1;	/* punch $SIZE blocks ... */
>  	int		interval = 2;	/* every $INTERVAL blocks */
>  
> -	while ((c = getopt(argc, argv, "i:s:")) != EOF) {
> +	while ((c = getopt(argc, argv, "i:o:s:")) != EOF) {

Update usage info too?

Otherwise looks fine to me.

Thanks,
Eryu
