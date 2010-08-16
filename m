Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7G13fFJ209340 for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 20:03:41 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3D744BE6AB
	for <xfs@oss.sgi.com>; Sun, 15 Aug 2010 18:04:08 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	ipZuuZWTIECwpgx8 for <xfs@oss.sgi.com>;
	Sun, 15 Aug 2010 18:04:08 -0700 (PDT)
Date: Mon, 16 Aug 2010 11:03:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: observed significant performance improvement using "delaylog" in
Message-ID: <20100816010301.GI10429@dastard>
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<20100813141344.GE10429@dastard> <4C65AE4D.6070502@sandeen.net>
	<201008141328.18436.Martin@lichtvoll.de>
	<4C688691.2020100@austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C688691.2020100@austin.ibm.com>
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
To: Steven Pratt <slpratt@austin.ibm.com>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Keith Mannthey <kmannth@us.ibm.com>, Stan Hoeppner <stan@hardwarefreak.com>

On Sun, Aug 15, 2010 at 07:30:09PM -0500, Steven Pratt wrote:
> Martin Steigerwald wrote:
> >Hi!
> >
> >Cc'd Steve as I think he is running the benchmarks.
> >
> >Am Freitag 13 August 2010 schrieb Eric Sandeen:
> >>Dave Chinner wrote:
> >>>On Fri, Aug 13, 2010 at 08:29:07AM -0400, Christoph Hellwig wrote:
> >>...
> >>
> >>>>And asking
> >>>>him/her to add -o delaylog would also be good.
> >>>Yes, that would be an interesting comparison...
> >>I was thinking the same thing; I'll do that.
> >
> >I think its Steven Pratt from IBM.
> >
> >Steve, could you add a case for mount option "-o delaylog" to your
> >benchmark runs?
> Which filesystem is this for?  Keith has been helping me with some
> of these runs. We'll see if we can add this.

XFS - it's a new mount option for 2.6.35. Gory details in
Documentation/filesystems/xfs-delayed-logging-design.txt.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
