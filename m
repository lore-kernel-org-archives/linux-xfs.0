Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0S4nikx103884 for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 22:49:45 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4FE698D8096
	for <xfs@oss.sgi.com>; Thu, 27 Jan 2011 20:52:08 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6lHfw5tgpDqNAFbP for <xfs@oss.sgi.com>;
	Thu, 27 Jan 2011 20:52:08 -0800 (PST)
Date: Fri, 28 Jan 2011 15:52:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS Preallocation
Message-ID: <20110128045205.GR21311@dastard>
References: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <155CAEA5D902E7429569DD197567724A01534D42@mail1.ad.kinetx.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jef Fox <jef.fox@kinetx.com>
Cc: xfs@oss.sgi.com

On Thu, Jan 27, 2011 at 07:05:33PM -0700, Jef Fox wrote:
> We are having some problems with preallocation of large files.  We have
> found that we can preallocate about 500 1GB files on a volume using the
> resvsp and truncate commands, but the extents are still showing up as
> preallocated.  Is this a problem?  The OS appears to think the files are
> allocated and correctly sized. 

That's the way it's supposed to work. Preallocated space stays
preallocated (i.e reads as zeros) until it is written to, regardless
of whether you change the file size via truncate commands.

> For reference, we are trying to create files for an external piece of
> equipment to write to a SSD with.  The SSD would then be mounted in RHEL
> and the data pulled off in the 1G chunks.  Because of the nature of the
> data, we need to constantly erase and recreate the files and
> preallocation seems to be the fastest option.

What do you mean by "erase and recreate"? Do you mean you rm the
files, then preallocate them again?

If you were running 2.6.37+ and a TOT xfsprogs, there's also the
"zero" command that converts allocated space back to the
preallocated (zeroed) state without doing any IO. It's the
equivalent unresvsp + resvsp in a single operation.

> We don't really care if
> the data gets 0'ed out.  Is there another method - allocsp takes too
> long for this application?

allocsp is historical interface, pretty much useless and should
probably be removed. I can't think of any situation where allocsp
would be better than resvsp or zero....

> Or, does it matter if XFS thinks the extents
> are preallocated but unwritten if no other files are written to the
> disk?

I'm not sure what you are asking there...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
