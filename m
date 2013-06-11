Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 28C9329DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 18:13:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB9C8AC004
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 16:13:09 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id QpfdAUeARSjialFg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Jun 2013 16:13:09 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Tue, 11 Jun 2013 17:13:08 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 455023E40044
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 17:12:49 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5BND7l6140950 for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 17:13:07 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5BND7Em018339
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 17:13:07 -0600
Subject: Re: [PATCH v8 4/5] xfs: Add proper versioning support to fs_quota_stat
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130610232722.GF29376@dastard>
References: <1368220889-25188-1-git-send-email-sekharan@us.ibm.com>
	<1368220889-25188-5-git-send-email-sekharan@us.ibm.com>
	<20130517051001.GP24635@dastard>
	<1369433842.9551.967.camel@chandra-dt.ibm.com>
	<20130610232722.GF29376@dastard>
Date: Tue, 11 Jun 2013 18:13:06 -0500
Message-ID: <1370992386.22504.27.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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

On Tue, 2013-06-11 at 09:27 +1000, Dave Chinner wrote:
> On Fri, May 24, 2013 at 05:17:22PM -0500, Chandra Seetharaman wrote:
> > On Fri, 2013-05-17 at 15:10 +1000, Dave Chinner wrote:
> > > On Fri, May 10, 2013 at 04:21:28PM -0500, Chandra Seetharaman wrote:
> > > > Added appropriate pads and code for backward compatibility.
> > > > 
> > > > Copied over the old version as it is different from the newer padded
> > > > version.
> > > > 
> > > > New callers of the system call have to just set the version of the data
> > > > structure being passed, and kernel will fill as much data as requested.
> > > > 
> > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > 
> > > This needs to be cc'd to Steve Whitehouse so he's aware that we are
> > > changing the quota interface...
> 
> > > > +/*
> > > > + * Since Version 1 did not have padding at appropriate places,
> > > > + * a new data structure has been defined for the older version to
> > > > + * provide backward compatibility.
> > > > + * Future extentions of this data structure won't require new
> > > > + * data structure definitions as the current one can be extended
> > > > + * with the logic and padding in place now.
> > > > + */
> > > > +#define FS_QSTAT_V1_SIZE	(sizeof(struct fs_quota_stat_v1))
> > > > +#define FS_QSTAT_V2_SIZE	(offsetof(struct fs_quota_stat, qs_pquota) + \
> > > > +					sizeof(fs_qfilestat_t))
> > > 
> > > Just use sizeof(struct fs_quota_stat) as the size. Indeed, for
> > 
> > My thinking w.r.t not making it sizeof (fs_quota_stat) is ...future
> > changes doesn't have to touch the macro definitions of earlier versions,
> > they can define a new macro just by copying the last V?_SIZE macro and
> > changing the last field name.
> 
> If we need a future revision, we can deal with the structure
> differences and versions at that point in time. Second guessing
> unknown future requirements is not necessary. ;)

sure.
> 
> > > future enhancements, maybe we should add 64 bytes of empty space at
> > > the end of the structure....
> > 
> > Since this version is fully backward compatible, I didn't think a future
> > pad was needed. Do you want me to add ?
> 
> We only really need to change the structure version when we change
> input parameters, the size or the shape of the structure being
> passed in from userspace. If we add padding now, then we can expand
> output of the call without needing to bump the version of the
> structure. Old code simply won't know (or care) about the new output
> in the region of the structure it considers empty padding....

Ok. I will all 64 bytes of additional padding at the end.

> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
