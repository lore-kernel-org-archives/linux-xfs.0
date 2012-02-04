Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q14KidAa240929 for <xfs@oss.sgi.com>; Sat, 4 Feb 2012 14:44:40 -0600
Received: from crunch.scalableinformatics.com
	(173-10-54-97-Michigan.hfc.comcastbusiness.net [173.10.54.97])
	by cuda.sgi.com with ESMTP id cyqinHOtk5I9qWTN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 04 Feb 2012 12:44:33 -0800 (PST)
Received: from crunch.scalableinformatics.com (localhost [127.0.0.1])
	by crunch.scalableinformatics.com (Postfix) with ESMTP id 6EC1E805694E
	for <xfs@oss.sgi.com>; Sat,  4 Feb 2012 15:44:35 -0500 (EST)
Received: from [192.168.5.53] (eng [70.88.96.213])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by crunch.scalableinformatics.com (Postfix) with ESMTPSA id
	53ECF8056920
	for <xfs@oss.sgi.com>; Sat,  4 Feb 2012 15:44:35 -0500 (EST)
Message-ID: <4F2D98A9.4090709@scalableinformatics.com>
Date: Sat, 04 Feb 2012 15:44:25 -0500
From: Joe Landman <landman@scalableinformatics.com>
MIME-Version: 1.0
Subject: Re: Performance problem - reads slower than writes
References: <20120130220019.GA45782@nsrc.org> <20120131020508.GF9090@dastard>
	<20120131103126.GA46170@nsrc.org>
	<20120131145205.GA6607@infradead.org>
	<20120203115434.GA649@nsrc.org>
	<4F2C38BE.2010002@hardwarefreak.com>
	<20120203221015.GA2675@nsrc.org>
	<4F2D016C.9020406@hardwarefreak.com>
	<20120204112436.GA3167@nsrc.org>
	<4F2D2953.2020906@hardwarefreak.com>
	<20120204200417.GA3362@nsrc.org>
In-Reply-To: <20120204200417.GA3362@nsrc.org>
Reply-To: landman@scalableinformatics.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 02/04/2012 03:04 PM, Brian Candler wrote:
> On Sat, Feb 04, 2012 at 06:49:23AM -0600, Stan Hoeppner wrote:

[...]

> Sure it can. A gluster volume consists of "bricks". Each brick is served by
> a glusterd process listening on a different TCP port. Those bricks can be on
> the same server or on different servers.

I seem to remember that the Gluster folks abandoned this model (using 
their code versus MD raid) on single servers due to performance issues. 
  We did play with this a few times, and the performance wasn't that 
good.  Basically limited by single disk seek/write speed.

>
>> Even if what you describe can be done with Gluster, the performance will
>> likely be significantly less than a properly setup mdraid or hardware
>> raid.  Again, if it can be done, I'd test it head-to-head against RAID.
>
> I'd expect similar throughput but higher latency. Given that I'm using low

My recollection is that this wasn't the case.  Performance was 
suboptimal in all cases we tried.

> RPM drives which already have high latency, I'm hoping the additional
> latency will be insignificant.  Anyway, I'll know more once I've done the
> measurements.

I did this with the 3.0.x and the 2.x series of Gluster.  Usually atop 
xfs of some flavor.

>
>> I've never been a fan of parity RAID, let alone double parity RAID.
>
> I'm with you on that one.

RAID's entire purpose in life is to give an administrator time to run in 
and change a disk.  RAID isn't a backup, or even a guarantee of data 
retention.  Many do treat it this way though, to their (and their 
data's) peril.

> The attractions of gluster are:
> - being able to scale a volume across many nodes, transparently to
>    the clients

This does work, though rebalance is as much a function of the seek and 
bandwidth of the slowest link as other things.  So if you have 20 
drives, and you do a rebalance to add 5 more, its gonna be slow for a 
while.

> - being able to take a whole node out of service, while clients
>    automatically flip over to the other
>

I hate to put it like this, but this is true for various definitions of 
the word "automatically".  You need to make sure that your definitions 
line up with the reality of "automatic".

If a brick goes away, and you have a file on this brick you want to 
overwrite, it doesn't (unless you have a mirror) flip over to another 
unit "automatically" or otherwise.

RAID in this case can protect you from some of these issues (single disk 
failure issues, being replaced by RAID issues), but unless you are 
building mirror pairs of bricks on separate units, this magical 
"automatic" isn't quite so.

Moreover, last I checked, Gluster made no guarantees as to the ordering 
of the layout for mirrors.  So if you have more than one brick per node, 
and build mirror pairs with the "replicate" option, you have to check 
the actual hashing to make sure it did what you expect.  Or build up the 
mirror pairs more carefully.

At this point, it sounds like there is a gluster side of this discussion 
that I'd recommend you take to the gluster list.  There is an xfs 
portion as well which is fine here.

Disclosure:  we build/sell/support gluster (and other) based systems 
atop xfs based RAID units (both hardware and software RAID; 
1,10,6,60,...) so we have inherent biases.  Your mileage may vary.  See 
your doctor if your re-balance exceeds 4 hours.

> Regards,
>
> Brian.

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
