Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751333AbdF3Edu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Jun 2017 00:33:50 -0400
Date: Fri, 30 Jun 2017 12:33:47 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 12/8] ext4: don't online scrub ever
Message-ID: <20170630043347.GA23360@eguan.usersys.redhat.com>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
 <20170630041331.GG5871@birch.djwong.org>
 <20170630042208.GZ23360@eguan.usersys.redhat.com>
 <20170630042610.GH5871@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170630042610.GH5871@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Jun 29, 2017 at 09:26:10PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 30, 2017 at 12:22:08PM +0800, Eryu Guan wrote:
> > On Thu, Jun 29, 2017 at 09:13:31PM -0700, Darrick J. Wong wrote:
> > > The ext4 online scrub program is no longer under active development,
> > > so remove all the test code that tried to use it.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  common/fuzzy   |    2 +-
> > >  tests/ext4/023 |    1 -
> > >  2 files changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/common/fuzzy b/common/fuzzy
> > > index 304268e..686cf77 100644
> > > --- a/common/fuzzy
> > > +++ b/common/fuzzy
> > > @@ -70,7 +70,7 @@ _require_scrub() {
> > >  # Scrub the scratch filesystem metadata (online)
> > >  _scratch_scrub() {
> > >  	case "${FSTYP}" in
> > > -	"xfs"|"ext4"|"ext3"|"ext2")
> > > +	"xfs")
> > >  		$XFS_SCRUB_PROG -d -T -v "$@" $SCRATCH_MNT
> > >  		;;
> > >  	*)
> > > diff --git a/tests/ext4/023 b/tests/ext4/023
> > > index 4f5cf3e..4491936 100755
> > > --- a/tests/ext4/023
> > > +++ b/tests/ext4/023
> > > @@ -53,7 +53,6 @@ _scratch_populate_cached > $seqres.full 2>&1
> > >  
> > >  echo "Scrub"
> > >  _scratch_mount >> $seqres.full 2>&1
> > > -_scratch_scrub >> $seqres.full
> > 
> > Just a quick glance at this one, shouldn't ext4/023 be removed? If
> > _scratch_scrub is removed from the test, all the test does is populating
> > the fs and mount and pass.
> 
> I've been using it to verify that we can create ext4 filesystems with all
> known types of metadata, and that we can actually capture metadata images
> of such a filesystem.

Then the test descriptions should be updated too, it no longer matches
what the test does. And 'echo "Scrub"' then just mounts the fs is
confusing too :)

Thanks,
Eryu

> 
> > And I think _require_scrub should be updated too to remove ext4 support.
> 
> oops, yes.
> 
> --D
> 
> > 
> > Thanks,
> > Eryu
> > 
> > >  
> > >  # success, all done
> > >  status=0
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
