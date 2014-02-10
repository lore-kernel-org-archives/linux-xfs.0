Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8C1FD7F3F
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 19:51:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6EFA4304048
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 17:51:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bDAJldEU2chjxLYW for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 17:51:09 -0800 (PST)
Date: Mon, 10 Feb 2014 12:51:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs/033: add golden output for CRC enaled filesystems
Message-ID: <20140210015105.GN13647@dastard>
References: <1391588590-6035-1-git-send-email-david@fromorbit.com>
	<20140207174950.GB31464@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140207174950.GB31464@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Feb 07, 2014 at 09:49:50AM -0800, Christoph Hellwig wrote:
> On Wed, Feb 05, 2014 at 07:23:10PM +1100, Dave Chinner wrote:
> > diff --git a/common/filter b/common/filter
> > index 04d12c4..bb7fb33 100644
> > --- a/common/filter
> > +++ b/common/filter
> > @@ -152,6 +152,9 @@ _filter_mkfs()
> >      if (/^\s+=\s+sectsz=(\d+)\s+attr=(\d+)/) {
> >          print STDERR "sectsz=$1\nattr=$2\n";
> >      }
> > +    if (/^\s+=\s+crc=(\d)/) {
> > +        print STDERR "crc=$1\n";
> > +    }
> 
> I think this variable is named way to genericly.  And that probably
> applies to others as well.
> 
> I'd suggest at least xfs_feature_crc or similar.

I can't say I like adding that prefix to the mkfs varaibles. I'll
change this one to something less generic, but I'm going to ignore
the others right now because changing them involves modifying 30+
tests....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
