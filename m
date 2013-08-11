Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2AD0A7CBE
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 18:57:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9B451AC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 16:57:37 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Qe5zJDHvB79EhgIm for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 16:57:35 -0700 (PDT)
Date: Mon, 12 Aug 2013 09:57:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH v7 7/7] enable building user
	namespace with xfs
Message-ID: <20130811235733.GF12779@dastard>
References: <20130729230709.11033b2d@oracle.com>
	<20130730234021.GR3111@sgi.com> <20130731002119.GR13468@dastard>
	<20130731132523.GS3111@sgi.com> <20130731232852.GE7118@dastard>
	<20130807145930.GA28565@mail.hallyn.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130807145930.GA28565@mail.hallyn.com>
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
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Ben Myers <bpm@sgi.com>, Dwight Engen <dwight.engen@oracle.com>, xfs@oss.sgi.com

On Wed, Aug 07, 2013 at 02:59:30PM +0000, Serge E. Hallyn wrote:
> Quoting Dave Chinner (david@fromorbit.com):
> > On Wed, Jul 31, 2013 at 08:25:23AM -0500, Ben Myers wrote:
> > > Hey,
> > > 
> > > On Wed, Jul 31, 2013 at 10:21:19AM +1000, Dave Chinner wrote:
> > > > On Tue, Jul 30, 2013 at 06:40:21PM -0500, Ben Myers wrote:
> > > > > On Mon, Jul 29, 2013 at 11:07:09PM -0400, Dwight Engen wrote:
> > > > > > >From e6a9ee0cfa0ed40484f66bc1726dc19de36038b8 Mon Sep 17 00:00:00 2001
> > > > > > From: Dwight Engen <dwight.engen@oracle.com>
> > > > > > Date: Tue, 2 Jul 2013 09:52:54 -0400
> > > > > > Subject: [PATCH 7/7] enable building user namespace with xfs
> > > > > > 
> > > > > > Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> > > > > 
> > > > > Was there a patch running around to limit bulkstat to init_user_ns?  Any other
> > > > > items that needed to be addressed before applying this patch?
> > > > 
> > > > Bulkstat has a capable(CAP_SYS_ADMIN) check and therefore can only be
> > > > executed in the init name space. Similarly, all the open-by-handle
> > > > interfaces have the same capable() checks so they can only be
> > > > executed int he init name space, too.
> > > 
> > > Gah.  I was under the impression that you could have a process with
> > > CAP_SYS_ADMIN in a namespace other than init_user_ns.
> > 
> > Ben, until about a week and a half ago I was also working under that
> > same understanding as you.  So don't feel bad about not knowing
> > about this basic, fundamental rule because it is completely
> > undocumented and it's not obvious to anyone reading the code until
> > someone points it out....
> 
> It's actually all documented in new manpages like namespaces(7) and
> user_namespaces(7).  Unfortunately those don't seem to have been released yet.

User facing documentation goes in man pages.

My comments about the above point at the fact that there is no
developer facing documentation that tell us how to safely and
*securely* implement namespace support in different filesystems.
Information on the architecture, design and use of internal kernel
infrastructure for kernel developers should be in the Documentation/
subdirectory of the kernel tree.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
