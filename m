Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9D967F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 20:20:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B63ED8F8049
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 18:20:47 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	AO3ZDanfUZJPcpGZ for <xfs@oss.sgi.com>;
	Tue, 25 Jun 2013 18:20:46 -0700 (PDT)
Date: Wed, 26 Jun 2013 11:20:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v9 5/6] xfs: Add proper versioning support to fs_quota_stat
Message-ID: <20130626012044.GC29376@dastard>
References: <1372042107-27332-1-git-send-email-sekharan@us.ibm.com>
	<1372042107-27332-6-git-send-email-sekharan@us.ibm.com>
	<20130625064312.GV29376@dastard>
	<1372199784.8341.102.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1372199784.8341.102.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 25, 2013 at 05:36:24PM -0500, Chandra Seetharaman wrote:
> On Tue, 2013-06-25 at 16:43 +1000, Dave Chinner wrote:
> > On Sun, Jun 23, 2013 at 09:48:26PM -0500, Chandra Seetharaman wrote:
> > > Added appropriate pads and code for backward compatibility.
> > > 
> > > Copied over the old version as it is different from the newer padded
> > > version.
> > > 
> > > New callers of the system call have to set the version of the data
> > > structure being passed, and kernel will fill as much data as requested.
> > 
> > Is there are test for this? i.e. that the different version
> > structures return the same information?
> 
> You want me to add it to xfstests ?

Yes, please. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
