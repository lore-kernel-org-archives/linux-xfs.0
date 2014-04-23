Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6A62F29DFD
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 15:02:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F3968F8040
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 13:02:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id RYkwj9BQTTSuHrtp for
	<xfs@oss.sgi.com>; Wed, 23 Apr 2014 13:02:36 -0700 (PDT)
Date: Wed, 23 Apr 2014 16:02:32 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v3 00/20] xfsprogs: introduce the free inode btree
Message-ID: <20140423200232.GG5225@bfoster.bfoster>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<20140423063559.GQ15995@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423063559.GQ15995@dastard>
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

On Wed, Apr 23, 2014 at 04:35:59PM +1000, Dave Chinner wrote:
> On Thu, Apr 10, 2014 at 12:10:50PM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > This is the v3 userspace portion of finobt support corresponding to v5
> > of the kernel series.
> > 
> > Patches 1-10 are straight application of the corresponding kernel patches
> > with omissions where appropriate.
> 
> I haven't done anything more than passed a quick eye over them and
> tested them. I'll review them fully in the kernel context, and we
> can apply any changes to the kernel code directly to them...
> 

Ok...

> > Patch 11 adds mkfs support. Patches 12 and 13 provide a couple minor db
> > and repair fixes to support the new agi fields and calculate the fs
> > format respectively. Patches 14-18 add real repair support for the
> > finobt. Patch 19 adds support to report finobt state in xfs_info. Patch
> > 20 adds support for metadump.
> > 
> > Thoughts, reviews, flames appreciated.
> 
> I've made comments on the patches that i think need a bit of work,
> but all the remainder (11-20) I haven't made any direct comment on
> you can consider:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 

Sounds good. Thanks for the reviews! :)

Brian

> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
