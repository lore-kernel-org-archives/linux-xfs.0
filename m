Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BACC07F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:43:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9AA798F8059
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:43:49 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Jv4evf4COyFp9Rjl for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:43:48 -0700 (PDT)
Date: Thu, 16 May 2013 07:43:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rambling noise #2: Learning to use the v8 pquota/uquota patchset
Message-ID: <20130515214346.GA24635@dastard>
References: <5191FB46.2080300@gmail.com> <519241A1.9050704@oracle.com>
	<51933585.80400@gmail.com> <51938AA4.4090008@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51938AA4.4090008@oracle.com>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Wed, May 15, 2013 at 09:16:20PM +0800, Jeff Liu wrote:
> On 05/15/2013 03:13 PM, Michael L. Semon wrote:
> > On 05/14/2013 09:52 AM, Jeff Liu wrote:
> >> Hi Michael,
> >>
> >> Have you tried this patch set with the v2 user space changes?
> >>
> >> Looks this is the latest update from Chandra that I can searched from
> >> the mailing list:
> >> http://oss.sgi.com/archives/xfs/2012-07/msg00293.html
> >>
> >> Thanks,
> >> -Jeff
> > 
> > It looks like it's not patching very well in light of Dave's CRC 
> > userspace changes, and I botched the mkfs part of the merge.
> Yes, that is based on the older version of xfsprogs with out CRC changes
> applied.
> 
> So we have to wait until an updated version is delivered. :)

There's a tarball that currently applies the CRC changes to the
libxfs code in userspace. I'll post a new series out later today
and you can rebase userspace on top of that.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
