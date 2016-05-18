Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B18AE7CA0
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 18:35:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3D583AC001
	for <xfs@oss.sgi.com>; Wed, 18 May 2016 16:35:25 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	BETrGuCKMMaDWstT for <xfs@oss.sgi.com>;
	Wed, 18 May 2016 16:35:23 -0700 (PDT)
Date: Thu, 19 May 2016 09:34:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: struct fsxattr redefinition
Message-ID: <20160518233442.GE21200@dastard>
References: <20160518163733.GB14165@tarantula.localdomain>
	<237c0dad-b27a-7fa0-6283-2832ca00ac43@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <237c0dad-b27a-7fa0-6283-2832ca00ac43@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Wed, May 18, 2016 at 03:44:46PM -0500, Eric Sandeen wrote:
> On 5/18/16 11:37 AM, Jeffrey Bastian wrote:
> > There was a discussion a few months ago about adding a guard for the
> > fsxattr struct [0] because it's defined in two places, the Linux kernel
> > header linux/fs.h [1] and xfsprogs header xfs/linux.h [2].
> 
> > xfs/linux.h has a FS_IOC_FSGETXATTR guard around the struct fsxattr
> > definition, but this only works if linux/fs.h is included *before*
> > xfs/linux.h (or xfs/xfs.h).  If you include linux/fs.h after, then you
> > get a struct redefinition error.
> > 
> > Is it a requirement that linux/fs.h is included first?  If so, then
> > there is a bug in xfstests because it includes them in the wrong order
> > [3] and fails to build.  If there is not an order requirement, then both
> > header files should probably have a HAVE_FSXATTR guard around the struct
> > definition.
> 
> It seems best to me to include fs.h first.  That may not be written in
> stone, but it's at least common practice.
> 
> Having the same definition in both places, and guards going both ways,
> seems a little odd though.
> 
> Maybe xfsprogs' include/linux.h should just directly include
> the kernel's linux/fs.h at the top - would that make sense?

That's the easiest solution - stops people wasting even more time on
this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
