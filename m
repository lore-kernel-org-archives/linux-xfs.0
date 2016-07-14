Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6FD7C7CA2
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 18:33:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3ECF58F8054
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2016 16:33:33 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EQHJJmaWCQAHKKWi for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2016 16:33:29 -0700 (PDT)
Date: Fri, 15 Jul 2016 09:33:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Advice needed with file system corruption
Message-ID: <20160714233327.GT1922@dastard>
References: <5787852A.7030900@st-andrews.ac.uk>
	<20160714130546.GB16096@redhat.com>
	<57879A45.6020307@st-andrews.ac.uk>
	<20160714141751.GC16096@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160714141751.GC16096@redhat.com>
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
To: Steve Brooks <sjb14@st-andrews.ac.uk>, xfs@oss.sgi.com

On Thu, Jul 14, 2016 at 04:17:51PM +0200, Carlos Maiolino wrote:
> On Thu, Jul 14, 2016 at 02:57:25PM +0100, Steve Brooks wrote:
> > Hi Carlos,
> > 
> > Many thanks again, for your good advice. I ran the version 4.3 of
> > "xfs_repair" as suggested below and it did it's job very quickly in 50
> > seconds exactly as reported in the "No modify mode". Is the time reported at
> > the end of the "No modify mode" always a good approximation of running in
> > "modify mode" ?
> 
> Good to know. But I'm not quite sure if the no modify mode could be used as a
> good approximation of a real run. I would say to not take it as true giving that
> xfs_repair can't predict the amount of time it will need to write all
> modifications it needs to do on the filesystem's metadata, and it will certainly
> can take much more time, depending on how corrupted the filesystem is.

Yup, the no-modify mode skips a couple of steps in repair - phase 5
which rebuilds freespace btrees, and phase 7 which correctly link
counts - and so can only be considered the minimum runtime in "fix
it all up" mode. FWIW, Phase 6 can also blow out massively in
runtime if there's significant directory damage that results in
needing to move lots of inodes to the lost+found directory.

> > > Hi steve.
> > > 
> > > On Thu, Jul 14, 2016 at 01:27:22PM +0100, Steve Brooks wrote:
> > > > The "3.1.1"  version of "xfs_repair -n" ran in 1 minute, 32 seconds
> > > > 
> > > > The "4.3"     version of "xfs_repair -n" ran in 50 seconds

And it's good to know that recent performance improvements show real
world benefits, not just on the badly broken filesystems I used for
testing.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
