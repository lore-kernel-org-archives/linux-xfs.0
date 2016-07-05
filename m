Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC60D7CB3
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 23:11:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F31EAC001
	for <xfs@oss.sgi.com>; Mon,  4 Jul 2016 21:11:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id c51v7Ac0OmWctoMf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jul 2016 21:11:38 -0700 (PDT)
Date: Mon, 4 Jul 2016 21:11:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 19/20] xfs: run xfs_repair at the end of each test
Message-ID: <20160705041134.GB18951@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
	<146612808160.25024.5986137574652014794.stgit@birch.djwong.org>
	<20160705035617.GD23649@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160705035617.GD23649@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 05, 2016 at 11:56:17AM +0800, Eryu Guan wrote:
> On Thu, Jun 16, 2016 at 06:48:01PM -0700, Darrick J. Wong wrote:
> > Run xfs_repair twice at the end of each test -- once to rebuild
> > the btree indices, and again with -n to check the rebuild work.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  common/rc |    3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 1225047..847191e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2225,6 +2225,9 @@ _check_xfs_filesystem()
> >          ok=0
> >      fi
> >  
> > +    $XFS_REPAIR_PROG $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> > +    cat $tmp.repair | _fix_malloc		>>$seqres.full
> > +
> 
> Won't this hide fs corruptions? Did I miss anything?

I could've sworn it did:

xfs_repair -n
(complain if corrupt)

xfs_repair

xfs_repair -n
(complain if still corrupt)

But that first xfs_repair -n hunk disappeared. :(

Ok, will fix and resend.

--D

> 
> Thanks,
> Eryu
> 
> >      $XFS_REPAIR_PROG -n $extra_options $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
> >      if [ $? -ne 0 ]
> >      then
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
