Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D09677F51
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 11:29:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 685DBAC003
	for <xfs@oss.sgi.com>; Wed, 26 Jun 2013 09:29:13 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ozEzZXn3FkDwnVLj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Jun 2013 09:29:12 -0700 (PDT)
Date: Wed, 26 Jun 2013 12:29:03 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: Re: [PATCH] xfstests: fix README, FSTYP options
Message-ID: <20130626122903.7420203b@oracle.com>
In-Reply-To: <20130626005029.GY29376@dastard>
References: <20130625153423.513e4074@oracle.com>
	<20130626005029.GY29376@dastard>
Mime-Version: 1.0
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

On Wed, 26 Jun 2013 10:50:29 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jun 25, 2013 at 03:34:23PM -0400, Dwight Engen wrote:
> > commit cbcc88fb changed test selection to use shell globs, so fixup
> > the examples given in the README file.
> > 
> > add options for FSTYPs supported by _scratch_mkfs().
> 
> To tell the truth, I'd prefer to get rid of the -xfs/-udf/... etc
> options rather than propoagate them further. We autodetect the FSTYP
> just fine on Linux via blkid probing of $TEST_DEV. Hence in reality,
> the only CLI option we need is for NFS...

Yep, I realized there was autodetection (nice!) later. I'll resubmit
with only NFS in the list.

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
