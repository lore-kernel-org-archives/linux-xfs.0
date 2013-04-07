Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4FA57F75
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 18:08:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E33FAC001
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 16:08:38 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZkA5rPLZ7YBTvaWd for <xfs@oss.sgi.com>;
	Sun, 07 Apr 2013 16:08:36 -0700 (PDT)
Date: Mon, 8 Apr 2013 09:08:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 23/22] xfs: add metadata CRC documentation
Message-ID: <20130407230834.GA17758@dastard>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
	<20130405070006.GJ12011@dastard> <515EB6E4.7060508@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <515EB6E4.7060508@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 05, 2013 at 07:35:00AM -0400, Brian Foster wrote:
> On 04/05/2013 03:00 AM, Dave Chinner wrote:
> > xfs: add metadata CRC documentation
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add some documentation about the self describing metadata and the
> > code templates used to implement it.
> > +
> > +Runtime Validation
> > +------------------
> > +
> ...
> > +
> > +The first step in read verification is checking the magic number and determining
> > +whether CRC validating is necessary. If it is, the CRC32c is caluclated and
> 
> What do you mean by "determining whether CRC validating is necessary?"
> In other words, it's not always enabled but rather triggered by
> something else that elevates suspicion on the object?

It is triggered by either the magic number indicating the object has
CRC checking or (xfs_sb_version_hascrc(sb) == true) indicating the
filesystem has metadata CRC checking enabled.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
