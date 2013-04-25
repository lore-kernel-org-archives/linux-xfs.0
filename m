Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF39029DFA
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 16:40:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DA8F530405F
	for <xfs@oss.sgi.com>; Thu, 25 Apr 2013 14:40:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AUHGLfE8SrF5UdyE for <xfs@oss.sgi.com>;
	Thu, 25 Apr 2013 14:40:42 -0700 (PDT)
Date: Fri, 26 Apr 2013 07:40:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH TARBALL, DEV ONLY] xfsprogs: metadata CRC support V2
Message-ID: <20130425214040.GQ30622@dastard>
References: <20130412145555.GF30622@dastard>
 <51799C24.8010901@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51799C24.8010901@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 25, 2013 at 04:12:04PM -0500, Mark Tinguely wrote:
> On 04/12/13 09:55, Dave Chinner wrote:
> >Hi folks,
> >
> >I've attached a tarball containing the patch series that adds
> >metadata CRC support to xfsprogs. It is still very much a work in
> >progress, but is sufficient to start running xfstests on CRC enable
> >filesystems.
> >
> >THere is much missing functionality, especially with respect to
> >directly/attribute modifications. Only mkfs and xfs_repair have been
> >updated to explicitly support CRC on directory/sttribute blocks,
> >though all the other tools will stil run the result might be a
> >little unpredictable.
> >
> >The patch series is as follows:
> >
> 
> BTW forgot about this gem, the UBER/xfsprogs-kernel-3.8-update patch
> has been kicking up duplicate defines in sles11sp2 (gcc 4.3.4), but
> fine in newer distros (gcc 4.6.2). Looks like a compile difference
> issue:
> 
> xfs_dir2_data_aoff_t  xfs_dir2_format.h and xfs_dir2.h
> xfs_dir2_db_t         xfs_dir2_format.h and xfs_dir2.h
> 
> The one below seems new to me:
> prid_t                project.h and xfs_types.h
> 
> I have been removing the entry in xfs_dir2_format.h in the past to test.
> I don't remember the prid_t duplicate.

Hmmmm. I'm not getting those warnings here (gcc-4.7.2). I'll have a
look into it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
