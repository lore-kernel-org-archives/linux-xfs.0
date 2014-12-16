Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5A2797F3F
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 13:58:32 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04913AC006
	for <xfs@oss.sgi.com>; Tue, 16 Dec 2014 11:58:31 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SJr0IqzsplOpRlae for <xfs@oss.sgi.com>;
	Tue, 16 Dec 2014 11:58:29 -0800 (PST)
Date: Wed, 17 Dec 2014 06:58:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141216195815.GB15665@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216123405.111c7ac0@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141216123405.111c7ac0@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Tue, Dec 16, 2014 at 12:34:05PM +0100, Emmanuel Florac wrote:
> The RAID hardware is an adaptec 71685 running the latest firmware
> ( 32033 ). This is a 16 drives RAID-6 array of 4 TB HGST drives. The
> problem occurs repeatly with any combination of 7xx5 controllers and 3
> or 4 TB HGST drives in RAID-6 of various types, with XFS or JFS (it
> never occurs with either ext4 or reiserfs).

Do you have systems with any other type of 3/4TB drives in them?

> As I mentioned, when the disk drives cache is on the corruption is
> serious. With disk cache off, the corruption is minimal, however the
> filesystem shuts down.

That really sounds like a hardware problem - maybe with the disk
drives themselves, not necessarily the controller.

> The filesystem has been primed with a few (23) terabytes of mixed data
> with both small (few KB or less), medium, and big (few gigabytes or
> more) files. Two simultaneous, long running copies are made ( cp -a
> somedir someotherdir) , while three simultaneous, long running read
> operations are run ( md5sum -c mydir.md5 mydir), while the array is
> busy rebuilding. Disk usage (as reported by iostat -mx 5) stays solidly
> at 100%, with a continuous throughput of a few hundred megabytes per
> second. The full test runs for about 12 hours (when not failing), and
> ends up copying 6 TB or so, and md5summing 12 TB or so.
> 
> > I'd start with upgrading the firmware on your RAID controller and
> > turning the XFS error level up to 11....
> 
> The firmware is the latest available. How do I turn logging to 11
> please ?

# echo 11 > /proc/sys/fs/xfs/error_level

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
