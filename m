Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D48237CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 22:09:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B2D2E304043
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 20:08:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	FwVm4HJX8uOIzQIs for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 20:08:58 -0700 (PDT)
Date: Fri, 14 Jun 2013 13:08:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/8] xfs: log space validation
Message-ID: <20130614030854.GW29338@dastard>
References: <5195C239.5010905@oracle.com> <20130614015928.GP29338@dastard>
	<51BA852F.4040706@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51BA852F.4040706@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 14, 2013 at 10:51:27AM +0800, Jeff Liu wrote:
> Hi Dave,
> 
> On 06/14/2013 09:59 AM, Dave Chinner wrote:
> 
> > On Fri, May 17, 2013 at 01:38:01PM +0800, Jeff Liu wrote:
> >> Hello,
> >>
> >> This is version 2 of fix log space calculation if the log stripe unit is specified.
> >>
> >> I changed the subject in this round since there are many changes belong to the log
> >> space reservation interface adjustment.
> > 
> > Hi Jeff, 
> > 
> > Given that I'm in the middle of reworking the kernel and userspace
> > source structures, do you might if I pull this patchset into my tree
> > for 3.11 and rework it to fit the modified structure I have now?
> > I'll do the same with the userspace patch if you have no objections.
> 
> That sounded fine to me so that I can have more time for investigating
> the possibility of performing quota check in parallel as well as the
> compressed inode caching. :)

Cool, I'll pick it up and work it into my current tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
