Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26570 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754770AbdA0JYn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2017 04:24:43 -0500
Date: Fri, 27 Jan 2017 01:24:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/9] common/fuzzy: move fuzzing helper functions here
Message-ID: <20170127092431.GY9134@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <148498625060.17109.11461581002141350060.stgit@birch.djwong.org>
 <20170127081211.GS1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127081211.GS1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jan 27, 2017 at 04:12:11PM +0800, Eryu Guan wrote:
> On Sat, Jan 21, 2017 at 12:10:50AM -0800, Darrick J. Wong wrote:
> > Move some fuzzing helper functions into a new common/fuzzy file.
> > We'll add a lot more fuzzing helpers in subsequent patches.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/fuzzy    |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  common/populate |   35 ------------------------
> >  tests/ext4/006  |    1 +
> >  tests/xfs/083   |    1 +
> >  4 files changed, 82 insertions(+), 35 deletions(-)
> >  create mode 100644 common/fuzzy
> > 
> > 
> > diff --git a/common/fuzzy b/common/fuzzy
> > new file mode 100644
> > index 0000000..d4f8274
> > --- /dev/null
> > +++ b/common/fuzzy
> > @@ -0,0 +1,80 @@
> ...
> > +# Try to access files after fuzzing
> > +_scratch_fuzz_test() {
> > +	echo "+++ ls -laR" >> $seqres.full
> > +	ls -laR "${SCRATCH_MNT}/test.1/" >/dev/null 2>&1
> > +
> > +	echo "+++ cat files" >> $seqres.full
> > +	(find "${SCRATCH_MNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat) >/dev/null 2>&1
> > +}
> > +
> > +# Do we have an online scrub program?
> > +_require_scrub() {
> > +	case "${FSTYP}" in
> > +	"xfs"|"ext4")
> > +		test -x $XFS_SCRUB_PROG || _notrun "xfs_scrub not found"
> 
> In my release testing I found ext4/023 (moved from ext4/1300) failed due
> to lack of xfs_scrub, because "test -x " returns true, (but "test -x ''"
> doesn't), so I add quotes around $XFS_SCRUB_PROG and fold the update
> into this patch.

Oops!  Thanks for fixing this.

--D

> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
