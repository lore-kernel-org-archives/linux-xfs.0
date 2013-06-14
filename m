Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CDC4E7CBF
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 20:59:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BBFF38F8037
	for <xfs@oss.sgi.com>; Thu, 13 Jun 2013 18:59:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	j5fl59HYdV6Meo7g for <xfs@oss.sgi.com>;
	Thu, 13 Jun 2013 18:59:31 -0700 (PDT)
Date: Fri, 14 Jun 2013 11:59:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 0/8] xfs: log space validation
Message-ID: <20130614015928.GP29338@dastard>
References: <5195C239.5010905@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5195C239.5010905@oracle.com>
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

On Fri, May 17, 2013 at 01:38:01PM +0800, Jeff Liu wrote:
> Hello,
> 
> This is version 2 of fix log space calculation if the log stripe unit is specified.
> 
> I changed the subject in this round since there are many changes belong to the log
> space reservation interface adjustment.

Hi Jeff, 

Given that I'm in the middle of reworking the kernel and userspace
source structures, do you might if I pull this patchset into my tree
for 3.11 and rework it to fit the modified structure I have now?
I'll do the same with the userspace patch if you have no objections.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
