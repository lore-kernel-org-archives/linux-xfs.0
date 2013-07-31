Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F12977CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:29:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D398C8F8033
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 16:28:58 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	7TM0VuOyXq4sXocD for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 16:28:54 -0700 (PDT)
Date: Thu, 1 Aug 2013 09:28:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 7/7] enable building user namespace with xfs
Message-ID: <20130731232852.GE7118@dastard>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com> <20130731002119.GR13468@dastard>
	<20130731132523.GS3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130731132523.GS3111@sgi.com>
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
Cc: Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Wed, Jul 31, 2013 at 08:25:23AM -0500, Ben Myers wrote:
> Hey,
> 
> On Wed, Jul 31, 2013 at 10:21:19AM +1000, Dave Chinner wrote:
> > On Tue, Jul 30, 2013 at 06:40:21PM -0500, Ben Myers wrote:
> > > On Mon, Jul 29, 2013 at 11:07:09PM -0400, Dwight Engen wrote:
> > > > >From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17 00:00:00 2001
> > > > From: Dwight Engen <dwight.engen@oracle.com>
> > > > Date: Tue, 2 Jul 2013 09:52:54 -0400
> > > > Subject: [PATCH 7/7] enable building user namespace with xfs
> > > > 
> > > > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > > 
> > > Was there a patch running around to limit bulkstat to init_user_ns?  Any other
> > > items that needed to be addressed before applying this patch?
> > 
> > Bulkstat has a capable(CAP_SYS_ADMIN) check and therefore can only be
> > executed in the init name space. Similarly, all the open-by-handle
> > interfaces have the same capable() checks so they can only be
> > executed int he init name space, too.
> 
> Gah.  I was under the impression that you could have a process with
> CAP_SYS_ADMIN in a namespace other than init_user_ns.

Ben, until about a week and a half ago I was also working under that
same understanding as you.  So don't feel bad about not knowing
about this basic, fundamental rule because it is completely
undocumented and it's not obvious to anyone reading the code until
someone points it out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
