Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbdF3EWL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 00:22:11 -0400
Date: Fri, 30 Jun 2017 12:22:08 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 12/8] ext4: don't online scrub ever
Message-ID: <20170630042208.GZ23360@eguan.usersys.redhat.com>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170630041331.GG5871@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630041331.GG5871@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 29, 2017 at 09:13:31PM -0700, Darrick J. Wong wrote:
> The ext4 online scrub program is no longer under active development,
> so remove all the test code that tried to use it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/fuzzy   |    2 +-
>  tests/ext4/023 |    1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index 304268e..686cf77 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -70,7 +70,7 @@ _require_scrub() {
>  # Scrub the scratch filesystem metadata (online)
>  _scratch_scrub() {
>  	case "${FSTYP}" in
> -	"xfs"|"ext4"|"ext3"|"ext2")
> +	"xfs")
>  		$XFS_SCRUB_PROG -d -T -v "$@" $SCRATCH_MNT
>  		;;
>  	*)
> diff --git a/tests/ext4/023 b/tests/ext4/023
> index 4f5cf3e..4491936 100755
> --- a/tests/ext4/023
> +++ b/tests/ext4/023
> @@ -53,7 +53,6 @@ _scratch_populate_cached > $seqres.full 2>&1
>  
>  echo "Scrub"
>  _scratch_mount >> $seqres.full 2>&1
> -_scratch_scrub >> $seqres.full

Just a quick glance at this one, shouldn't ext4/023 be removed? If
_scratch_scrub is removed from the test, all the test does is populating
the fs and mount and pass.

And I think _require_scrub should be updated too to remove ext4 support.

Thanks,
Eryu

>  
>  # success, all done
>  status=0
