Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 28CA77CC5
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 16:51:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBE583040FF
	for <xfs@oss.sgi.com>; Fri,  1 Apr 2016 14:51:10 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	nQWQZnxrrLpuGQdM for <xfs@oss.sgi.com>;
	Fri, 01 Apr 2016 14:50:38 -0700 (PDT)
Date: Sat, 2 Apr 2016 08:50:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/133 134 262: limit xfs_quota report to report on
	specific project quota id
Message-ID: <20160401215035.GM30721@dastard>
References: <1459494050-28330-1-git-send-email-eguan@redhat.com>
	<20160401072856.GA3329@dhcp12-237.nay.redhat.com>
	<56FEAED8.2050108@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56FEAED8.2050108@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, Zorro Lang <zlang@redhat.com>, Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org, xfs@oss.sgi.com

On Fri, Apr 01, 2016 at 12:24:40PM -0500, Eric Sandeen wrote:
> 
> 
> On 4/1/16 2:28 AM, Zorro Lang wrote:
> > On Fri, Apr 01, 2016 at 03:00:50PM +0800, Eryu Guan wrote:
> >> With GETNEXTQUOTA support, xfs_quota -c "report" now outputs more quota
> >> info than before, and this breaks xfs/133 xfs/134 and xfs/262, e.g.
> >> xfs/133 fails as
> >>
> >>      Filesystem Blocks Quota Limit Warn/Time Mounted on
> >>      SCRATCH_DEV 0 102400 204800 00 [--------] SCRATCH_MNT
> >>      === report command output ===
> >>     +(null) 0 0 0 00 [--------]
> >>      123456-project 0 102400 204800 00 [--------]
> >>
> >> Fix it by limiting xfs_quota to report on specific project quota number
> >> using -L & -U option, so only the project quota being tested is
> >> reported.
> >>
> >> Signed-off-by: Eryu Guan <eguan@redhat.com>
> >> ---
> >>
> >> I'm not sure if kernel should be fixed, but limiting the quota report on
> >> project number being tested seems something worth doing to me anyway. It avoids
> >> breakage of future changes of quota report output.
> > 
> > Hi,
> > 
> > FYI:
> > About "+(null) 0 0 0 00 [--------]"problem, it has been talked in:
> > http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968
> > 
> > I think:
> > 1) If we consider that this's a bug, the original test cases can
> > be the reproducer of this bug, so we shouldn't change the cases.
> > 
> > 2) If we think print "(null) 0 0 0 00 [--------]" is right(or not
> > wrong), then this patch is good.
> 
> yes, I'm sorry I didn't take care of this sooner.
> 
> I don't think there's value in printing the "(null)" line; I think maybe my
> suggestion from that old thread might be best:
> 
> > We could explicitly look up id 0 and not show it if it's not in the
> > projects file.
> 
> Or now that I think about it - projid 0 is the default project quota, right?

"default" as in "project quota not enabled on this inode". i.e. if
an inode has projid == 0 then it is not tracked by project quotas.

> Assuming that's correct, perhaps we should conditionally print the line,
> changing "(null)" to "default", printing it only if a default quota is 
> set (i.e. not all zeros).

Right, the only thing that the dquot for projid 0 holds is default
quota limits. We probably shouldn't ever print it out, except when
the default limits are queried or set directly...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
