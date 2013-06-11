Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F0F629DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 01:05:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E6C4304051
	for <xfs@oss.sgi.com>; Mon, 10 Jun 2013 23:05:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oJ9XsXyL9Juce3Zj for <xfs@oss.sgi.com>;
	Mon, 10 Jun 2013 23:05:49 -0700 (PDT)
Date: Tue, 11 Jun 2013 16:05:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/9] xfs: don't emit v5 superblock warnings on write
Message-ID: <20130611060546.GK29376@dastard>
References: <1369636707-15150-1-git-send-email-david@fromorbit.com>
	<1369636707-15150-2-git-send-email-david@fromorbit.com>
	<51A62F2F.6040807@redhat.com> <20130530174915.GB20932@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130530174915.GB20932@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, May 30, 2013 at 12:49:15PM -0500, Ben Myers wrote:
> On Wed, May 29, 2013 at 12:39:11PM -0400, Brian Foster wrote:
> > On 05/27/2013 02:38 AM, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > We write the superblock every 30s or so which results in the
> > > verifier being called. Right now that results in this output
> > > every 30s:
> > > 
> > > XFS (vda): Version 5 superblock detected. This kernel has EXPERIMENTAL support enabled!
> > > Use of these features in this kernel is at your own risk!
> > > 
> > > And spamming the logs.
> > > 
> > > We don't need to check for whether we support v5 superblocks or
> > > whether there are feature bits we don't support set as these are
> > > only relevant when we first mount the filesytem. i.e. on superblock
> > > read. Hence for the write verification we can just skip all the
> > > checks (and hence verbose output) altogether.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> Applied.

Ben, while I see this in the xfsdev tree, I don't see it in Linus'
tree. Did it get missed on the recent merges? If so, can you queue
it up for 3.10-rc6?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
