Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C00727FEB
	for <linux-xfs@oss.sgi.com>; Wed, 13 Feb 2013 22:54:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34B9EAC001
	for <linux-xfs@oss.sgi.com>; Wed, 13 Feb 2013 20:54:24 -0800 (PST)
Received: from ca1mailout01.kla-tencor.com (mailout04.kla-tencor.com
	[192.146.1.174]) by cuda.sgi.com with ESMTP id iD29ujW0MhOZtBGQ
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Wed, 13 Feb 2013 20:54:23 -0800 (PST)
Received: from CA1EXBH02.adcorp.kla-tencor.com (ca1exbh02.kla-tencor.com
	[10.60.33.12])
	by ca1mailout01.kla-tencor.com (8.14.4/8.14.4) with ESMTP id
	r1E4sM4C012663
	for <linux-xfs@oss.sgi.com>; Wed, 13 Feb 2013 20:54:22 -0800
Received: from mail93-co1 (localhost [127.0.0.1])	by mail93-co1-R.bigfish.com
	(Postfix) with ESMTP id 149958C0222	for
	<linux-xfs@oss.sgi.com.FOPE.CONNECTOR.OVERRIDE>;
	Thu, 14 Feb 2013 04:54:21 +0000 (UTC)
From: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Subject: RE: Hung in D state during fclose
Date: Thu, 14 Feb 2013 04:53:20 +0000
Message-ID: <3542214BE3A3EF419F236DFE0F878BC9052F35@BL2PRD0310MB374.namprd03.prod.outlook.com>
References: <loom.20130212T071115-446@post.gmane.org>
	<20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212102014.GA26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212202246.GB26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC905190D@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<3542214BE3A3EF419F236DFE0F878BC9051A09@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130213051552.GF26694@dastard>
In-Reply-To: <20130213051552.GF26694@dastard>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>



-----Original Message-----
From: xfs-bounces@oss.sgi.com [mailto:xfs-bounces@oss.sgi.com] On Behalf Of Dave Chinner
Sent: Tuesday, February 12, 2013 9:16 PM
To: Cheung, Norman
Cc: 'linux-xfs@oss.sgi.com'
Subject: Re: Hung in D state during fclose

On Wed, Feb 13, 2013 at 12:12:47AM +0000, Cheung, Norman wrote:
> Dave,
> 
> One other point I have forgotten to mention is that the parent thread 
> will wait for 5 minutes and then lower the thread priority (from -2 
> back to 20) and set a global variable to signal the threads to exit.  
> The blocked thread responded well and exit from D state and fclose 
> completed with no error.

So it's not hung - it's just very slow?

[NLC] It will pause forever.  I tried replaced the timeout with a sleep loop, and it will pause forever.    That is how I got the stack trace.

You have 256GB of memory. It's entirely possible that you've dirtied a large amount of memory and everything is simply stuck waiting for writeback to occur. Perhaps you should have a look at the utilisation of your disks when this still occurs. 'iostat -x -d -m 5' will give you some insight into utilsation when a hang occurs...

[NLC] I  have set the dirty_background_bytes to 40M and dirty_writeback_centisecs to 400; and watched the Meminfo.  I don't get a  lot of dirtied memory accumulation -- 7 to 10 M average.  The disk usage from the sar log was steady at 150M/sec for each of the disk; but a few seconds after the fclose all disk activities stopped. Also the CPU % was quiet as well.     

> This cause me to wonder if it  is possible that  some XFS threads and 
> my application thread might be in a deadlock.

Deadlocks are permanent, so what you are seeing is not a deadlock....

[NLC] Would it be possible that there is priority inversion between my  disk writing threads and the XFS threads & flush threads?  My application thread runs at -2 priority.

Many thanks,
Norman


Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
