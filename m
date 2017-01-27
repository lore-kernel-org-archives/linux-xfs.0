Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754239AbdA0IMO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Jan 2017 03:12:14 -0500
Date: Fri, 27 Jan 2017 16:12:11 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 5/9] common/fuzzy: move fuzzing helper functions here
Message-ID: <20170127081211.GS1859@eguan.usersys.redhat.com>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <148498625060.17109.11461581002141350060.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148498625060.17109.11461581002141350060.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sat, Jan 21, 2017 at 12:10:50AM -0800, Darrick J. Wong wrote:
> Move some fuzzing helper functions into a new common/fuzzy file.
> We'll add a lot more fuzzing helpers in subsequent patches.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/fuzzy    |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/populate |   35 ------------------------
>  tests/ext4/006  |    1 +
>  tests/xfs/083   |    1 +
>  4 files changed, 82 insertions(+), 35 deletions(-)
>  create mode 100644 common/fuzzy
> 
> 
> diff --git a/common/fuzzy b/common/fuzzy
> new file mode 100644
> index 0000000..d4f8274
> --- /dev/null
> +++ b/common/fuzzy
> @@ -0,0 +1,80 @@
...
> +# Try to access files after fuzzing
> +_scratch_fuzz_test() {
> +	echo "+++ ls -laR" >> $seqres.full
> +	ls -laR "${SCRATCH_MNT}/test.1/" >/dev/null 2>&1
> +
> +	echo "+++ cat files" >> $seqres.full
> +	(find "${SCRATCH_MNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat) >/dev/null 2>&1
> +}
> +
> +# Do we have an online scrub program?
> +_require_scrub() {
> +	case "${FSTYP}" in
> +	"xfs"|"ext4")
> +		test -x $XFS_SCRUB_PROG || _notrun "xfs_scrub not found"

In my release testing I found ext4/023 (moved from ext4/1300) failed due
to lack of xfs_scrub, because "test -x " returns true, (but "test -x ''"
doesn't), so I add quotes around $XFS_SCRUB_PROG and fold the update
into this patch.

Thanks,
Eryu
