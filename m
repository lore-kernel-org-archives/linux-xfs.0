Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C35BB7CA0
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 16:42:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 96DAB8F8049
	for <xfs@oss.sgi.com>; Thu, 12 May 2016 14:42:54 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	iqDjOjcVrnQb9VEA for <xfs@oss.sgi.com>;
	Thu, 12 May 2016 14:42:52 -0700 (PDT)
Date: Fri, 13 May 2016 07:42:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 1/2] libxcmd: generalize topology functions
Message-ID: <20160512214232.GB18496@dastard>
References: <1463006717-6104-1-git-send-email-billodo@redhat.com>
	<1463006717-6104-2-git-send-email-billodo@redhat.com>
	<20160512115513.GD32528@infradead.org>
	<20160512122039.GA19699@redhat.com>
	<20160512144726.GA5611@infradead.org>
	<894f9680-a6f2-7c27-7c97-4bc45c3a320b@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <894f9680-a6f2-7c27-7c97-4bc45c3a320b@sandeen.net>
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

On Thu, May 12, 2016 at 10:04:50AM -0500, Eric Sandeen wrote:
> On 5/12/16 9:47 AM, Christoph Hellwig wrote:
> > On Thu, May 12, 2016 at 07:20:39AM -0500, Bill O'Donnell wrote:
> >> xfs_multidisk.h came about a few days ago (4a32b9e928b80)
> >> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > 
> > Gah, looks like I'm stuck on the oss.sgi.com repo..
> 
> We really need to kill that.

I only update xfsprogs on oss at releases. All dev happens on the
kernel.org repo. Before we kill oss.sgi.com we have to sort out how
to get release tarballs up on kernel.org. I'm pretty we can do that
'kup', but I haven't had time to work out the process needed to do
that. This is really the only thing keeping us on oss.sgi.com.

I'm also not sure what to do with all the tarballs from previous
releases that are on oss. I think I can regenerate all the recent
releases (e.g. 3.2.0 onwards) without much trouble, but the older
releases might be more of an issue. More investigation needed.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
