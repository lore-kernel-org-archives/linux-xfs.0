Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D4897F4C
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 17:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 679728F8064
	for <xfs@oss.sgi.com>; Tue, 19 Mar 2013 15:53:03 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5JqVqSIG6tN80f6W for <xfs@oss.sgi.com>;
	Tue, 19 Mar 2013 15:52:32 -0700 (PDT)
Date: Wed, 20 Mar 2013 09:52:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/13] xfstests: filter new repair/mkfs output for CRCs
Message-ID: <20130319225230.GB17758@dastard>
References: <1363348411-21867-1-git-send-email-david@fromorbit.com>
	<1363348411-21867-2-git-send-email-david@fromorbit.com>
	<20130319205801.GG22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130319205801.GG22182@sgi.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, xfs@oss.sgi.com

On Tue, Mar 19, 2013 at 03:58:01PM -0500, Ben Myers wrote:
> Hey Rich,
>    
> On Fri, Mar 15, 2013 at 10:53:19PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > This patch it to ensure that xfstests passes on non-crc filesystems
> > with a CRC enabled userspace.
> > 
> > Filter out the mkfs/xfs_info CRC line from tests that capture the
> > output of these commands.
> > 
> > Filter out new error noise from xfs_repair that occurs for
> > xfs_repair as a result of the CRC changes.
> 
> IIRC this change was a temporary one so that xfstests could be run with crc
> enabled filesystems.

It's going to be a permanent change because we dump mkfs.xfs output
into golden output files and that means the "crc=X" line will always
need to be filtered out

> > diff --git a/common.repair b/common.repair
> > index 23a1ed6..db160bb 100644
> > --- a/common.repair
> > +++ b/common.repair
> > @@ -77,6 +77,9 @@ s/\s+- \d+:\d\d:\d\d:.*\n//g;
> >  /^agi_/ && next; # remove agi counts
> >  /^sb_/ && next; # remove sb counts
> >  /^agi unlinked/ && next; # remove agi unlinked bucket warning
> > +# crc enabled filesystem output
> > +/XFS_CORRUPTION_ERROR/ && next;
> > +/^bad uuid/ && next;
> 
> Doesn't this filter out xfs repair failures which should be reported?

No, because repair will issue errors when bad metadata is read off
disk now, and as such they are brand new output introduced by the
CRC patches. Over time this might get cleaned up, but at least for
initial testing and debugging this noise will remain in the repair
code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
