Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F09D27CBF
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 17:00:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 83ACCAC001
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 15:00:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	AsFGfnga7AdoSDVE for <xfs@oss.sgi.com>;
	Thu, 07 Mar 2013 15:00:48 -0800 (PST)
Date: Fri, 8 Mar 2013 10:00:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS IO multiplication problem on centos/rhel 6 using hp p420i
	raid controllers
Message-ID: <20130307230020.GX23616@dastard>
References: <1362060736.1247.30.camel@seahawk> <20130228194023.GQ5551@dastard>
	<1362577992.1247.84.camel@seahawk> <20130307035737.GC6369@dastard>
	<1362651128.16657.13.camel@seahawk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1362651128.16657.13.camel@seahawk>
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
To: Dennis Kaarsemaker <dennis.kaarsemaker@booking.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 07, 2013 at 11:12:08AM +0100, Dennis Kaarsemaker wrote:
> On Thu, 2013-03-07 at 14:57 +1100, Dave Chinner wrote:
> > On Wed, Mar 06, 2013 at 02:53:12PM +0100, Dennis Kaarsemaker wrote:
....
> > > #<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
> > > #cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
> > >    1   0  1636   4219     16      1   2336    313    184    195     12     133 
> > >    1   0  1654   2804     64      3   2919    432    391    352     20     208 
> > > 
> > > [root@bc291bprdb-01 ~]# collectl
> > > #<----CPU[HYPER]-----><----------Disks-----------><----------Network---------->
> > > #cpu sys inter  ctxsw KBRead  Reads KBWrit Writes   KBIn  PktIn  KBOut  PktOut 
> > >    1   0  2220   3691    332     13  39992    331    112    122      6      92 
> > >    0   0  1354   2708      0      0  39836    335    103    125      9      99 
> > >    0   0  1563   3023    120      6  44036    369    399    317     13     188 
> > > 
> > > Notice the KBWrit difference. These are two identical hp gen 8 machines,
> > > doing the same thing (replicating the same mysql schema). The one
> > > writing ten times as many bytes in the same amount of transactions is
> > > running centos 6 (and was running rhel 6).
> > 
> > So what is the problem? it is writing too much on the on the centos
> > 6 machine? Either way, this doesn't sound like a filesystem problem
> > - the size and amount of data writes is entirely determined by the
> > application.
> 
> For performing the same amount of work (processing the same mysql
> transactions, the same amount of IO transactions resulting from them),
> the 'broken' case writes ten-ish times as many bytes.

Thanks for clarifying.

> > > /dev/mapper/sysvm-mysqlVol /mysql/bp xfs rw,relatime,attr2,delaylog,allocsize=1024k,logbsize=256k,sunit=512,swidth=1536,noquota 0 0
> > 
> > What is the reason for using allocsize, sunit/swidth? Are you using
> > them on other machines?
> 
> xfs autodetects them from the hpsa driver. They seem to be correct for
> the raid layout (256 strips, 3 drives per mirror pool) and I don't seem
> to be able to override them.

That's fine, they're set correctly. I'd forgotten that the number
are emitted in /proc/mounts even when they are not specified as
mount options.

> > And if you remove the allocsize mount option, does the behaviour on
> > centos6.3 change? What happens if you set allocsize=4k?
> 
> The allocsize parameter has no effect. It was put in place to correct a
> monitoring issue: due to mysql's access patterns, using the default
> large allocsize on rhel 6 makes our monitoring report the filesystem as
> much fuller than it actually is.

Which is due to speculative EOF preallocation, and so it is only set
on the CentOS box that is showing the larger write behaviour? Have
you tried setting it to 4k? If not, please do - EOF preallocation for
sparse extending writes can result in extra zeroing occurring, and
so if it is anything related to the filesystem, this is the likely
culprit. Setting it to 4k sets it back to the default value used
on older versions of Linux....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
