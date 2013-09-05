Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B3D6B7F52
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 11:21:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A27F38F804C
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 09:21:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id agV6Npi1qrlHCQZJ for
	<xfs@oss.sgi.com>; Thu, 05 Sep 2013 09:21:02 -0700 (PDT)
Message-ID: <5228AE93.2050001@redhat.com>
Date: Thu, 05 Sep 2013 12:17:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 04/11] xfs: update inode allocation transaction
	reservations for finobt
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<1378232708-57156-5-git-send-email-bfoster@redhat.com>
	<20130905005946.GR23571@dastard>
In-Reply-To: <20130905005946.GR23571@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/04/2013 08:59 PM, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:25:01PM -0400, Brian Foster wrote:
>> Update inode allocation transaction reservations for the finobt. A
>> create via record modification requires a log reservation for the
>> additional finobt record. Any such allocation could result in an
>> finobt removal if the inode chunk has become fully allocated, thus
>> we include a reservation for a finobt btree merge as well.
>> Allocation of a new inode chunk must account for splits in the
>> finobt as well as the existing ialloc tree.
> 
> These transaction reservation changes are only necessary for
> filesystems with free inode btrees, otherwise they just use more log
> space than is necessary.
> 

Yeah, good point.

> Can you add helper functions for the free inode btree reservations,
> and have them return 0 when the feature is not enabled? That way the
> code stays pretty clean, is self documenting and doesn't take
> unnecessary space when the feature is not enabled....
> 

So not new functions that duplicate the entire calculations for the
finobt enabled cases, but new functions that define the additional
requirements for the finobt on top of the existing reservation
calculations for particular operations (i.e., similar to the recent
patch to fix the inode log size, if I recall). Sounds good.

Brian

>> Also update XFS_IALLOC_SPACE_RES() to reserve data blocks for
>> finobt split/merge scenarios.
> 
> Needs to handle the enabled/disabled case, too.
> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
