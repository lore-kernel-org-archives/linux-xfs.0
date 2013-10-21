Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58BA07F5A
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 10:10:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C83D6AC002
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 08:10:24 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id S7sEtbkuA5FtlDtn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 21 Oct 2013 08:10:23 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 25A009A06B0
	for <xfs@oss.sgi.com>; Mon, 21 Oct 2013 09:10:23 -0600 (MDT)
Date: Mon, 21 Oct 2013 11:10:21 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 3/8] xfstests: stat the dev we're removing to make sure
	its' really gone V2
Message-ID: <20131021151021.GI6924@localhost.localdomain>
References: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
	<1382120790-31060-3-git-send-email-jbacik@fusionio.com>
	<52654329.8050808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52654329.8050808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>, xfs@oss.sgi.com

On Mon, Oct 21, 2013 at 10:07:21AM -0500, Eric Sandeen wrote:
> On 10/18/13 1:26 PM, Josef Bacik wrote:
> > I've been periodically failing btrfs/003 because my box sometimes takes a little
> > longer to unregister the device when we remove it and so the output from btrfs
> > dev show doesn't match what we are wanting since it still sees the device.  To
> > fix this just stat and sleep if we still see the device node and only continue
> > once udev or whatever actually removes the device node so that we don't get
> > random failures.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> > V1->V2: Take Eric's suggestion to do this in the helper function
> > 
> >  common/rc       | 9 +++++++++
> >  tests/btrfs/003 | 2 +-
> >  2 files changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/common/rc b/common/rc
> > index b253948..253bd05 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2093,7 +2093,16 @@ _require_freeze()
> >  # ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
> >  _devmgt_remove()
> >  {
> > +	local h=$1
> 
> $h is never used?  You use ${1} directly below.  Is that intentional?
> (Not sure if you just meant to eat $1 or if you forgot to replace it
> in the echo string).
> 
> (if you respin, maybe give "$h" a more meaningful name?)
> 

Yeah I screwed up, I'll respin.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
