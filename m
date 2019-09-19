Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96318C3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 720E621928
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 17:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390157AbfISRTs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 13:19:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389230AbfISRTr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 13:19:47 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A0DA10DCC87;
        Thu, 19 Sep 2019 17:19:47 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9C1D5D9CC;
        Thu, 19 Sep 2019 17:19:46 +0000 (UTC)
Date:   Fri, 20 Sep 2019 01:27:12 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Message-ID: <20190919172711.GN7239@dhcp-12-102.nay.redhat.com>
References: <20190919150024.8346-1-zlang@redhat.com>
 <20190919160206.GL2229799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919160206.GL2229799@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Thu, 19 Sep 2019 17:19:47 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 19, 2019 at 09:02:06AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 19, 2019 at 11:00:24PM +0800, Zorro Lang wrote:
> > xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
> > between tests") get merged.
> > 
> > Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
> > mkfs.xfs detects an old primary superblock, it will write zeroes to
> > all superblocks before formatting the new filesystem. But this won't
> > be done if we wipe the first superblock(by merging above commit).
> > 
> > That means if we make a (smaller) sized xfs after wipefs, those *old*
> > superblocks which created by last time mkfs.xfs will be left on disk.
> 
> One thing missing from this patch -- if the test formatted the scratch
> device with non-default geometry, the backup superblocks from that

Make sense, I didn't think about non-default geometry.

> filesystem will not be erased.  Going back to my example from the email
> thread, if the scratch disk has:
> 
>   SB0 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       SB'1 [1G space] SB'2 [1G space] SB'3 [1G space]
> 
> Where SB[0-5] are the ones written by xfs/030 and SB'[1-3] were written
> by a previous test that did the default scratch device mkfs, then this
> patch will wipe out SB'[1-3] and SB0:
> 
>   000 [16M zeroes] SB1 [16M zeroes] <4 more AGs> <zeroes from 100M to 1G> \
>       0000 [1G space] 0000 [1G space] 0000 [1G space]
> 
> But that still leaves SB[1-5] which xfs_repair could stumble over later.
> For example, if the next test to be run formats a filesystem with 24MB
> AGs (instead of 16) and zaps the superblock, then repair will eventually
> try a linear scan looking for superblocks and find the ones from the
> 16MB filesystem first.
> 
> There isn't a sequence of tests that do this, but so long as we're
> fixing this we might as well zap as much as we can.  So I propose adding
> to try_wipe_scratch_xfs() the following:
> 
> 	dbsize=
> 	_scratch_xfs_db -c 'sb 0' -c 'p blocksize agblocks agcount' 2>&1 | \
> 		sed -e 's/ = /=/g' -e 's/blocksize/dbsize/g' \
> 		    -e 's/agblocks/agsize/g' > $tmp.mkfs
> 	. $tmp.mkfs
> 
> and then repeat the for loop.  If there isn't a filesystem then
> $tmp.mkfs will be an empty file and the loop won't run.

Sure, although I don't know why we must change the variable's name :)

> 
> > Then when we do xfs_repair, if xfs_repair can't find the first SB, it
> > will go to find those *old* SB at first. When it finds them,
> > everyting goes wrong.
> > 
> > So I try to get XFS AG geometry(by default) and then try to erase all
> > superblocks. Thanks Darrick J. Wong helped to analyze this issue.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  common/rc  |  4 ++++
> >  common/xfs | 23 +++++++++++++++++++++++
> >  2 files changed, 27 insertions(+)
> > 
> > diff --git a/common/rc b/common/rc
> > index 66c7fd4d..fe13f659 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
> >  	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
> >  		test -b $dev && $WIPEFS_PROG -a $dev
> >  	done
> > +
> > +	if [ "$FSTYP" = "xfs" ];then
> > +		try_wipe_scratch_xfs
> > +	fi
> 
> We probably ought to delegate all wiping to try_wipe_scratch_xfs, i.e.:
> 
> 	test -b $dev || continue
> 	case "$FSTYP" in
> 	"xfs")
> 		_try_wipe_scratch_xfs
> 		;;
> 	*)
> 		$WIPEFS_PROG -a $dev
> 		;;
> 	esac
> 
> and add the WIPEFS_PROG call to _try_wipe_scratch_xfs.

Sure,

Thanks!
Zorro

> 
> >  }
> >  
> >  # Only run this on xfs if xfs_scrub is available and has the unicode checker
> > diff --git a/common/xfs b/common/xfs
> > index 1bce3c18..34516f82 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -884,3 +884,26 @@ _xfs_mount_agcount()
> >  {
> >  	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
> >  }
> > +
> > +# wipe the superblock of each XFS AGs
> > +try_wipe_scratch_xfs()
> 
> Common helper functions should start with a '_'
> 
> > +{
> > +	local tmp=`mktemp -u`
> > +
> > +	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
> > +		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
> > +			print STDOUT "agcount=$1\nagsize=$2\n";
> > +		}
> > +		if (/^data\s+=\s+bsize=(\d+)\s/) {
> > +			print STDOUT "dbsize=$1\n";
> > +		}' > $tmp.mkfs
> > +
> > +	. $tmp.mkfs
> > +	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
> > +		for ((i = 0; i < agcount; i++)); do
> > +			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
> > +				$SCRATCH_DEV >/dev/null;
> > +		done
> > +       fi
> > +       rm -f $tmp.mkfs
> 
> Add code as discussed above.
> 
> --D
> 
> > +}
> > -- 
> > 2.20.1
> > 
