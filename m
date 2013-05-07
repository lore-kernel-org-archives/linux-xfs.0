Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6C91E29E03
	for <linux-xfs@oss.sgi.com>; Tue,  7 May 2013 17:07:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 504BE304067
	for <linux-xfs@oss.sgi.com>; Tue,  7 May 2013 15:07:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	n595WAGpAZa1avpW for <linux-xfs@oss.sgi.com>;
	Tue, 07 May 2013 15:07:46 -0700 (PDT)
Date: Wed, 8 May 2013 08:07:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.9.0: general protection fault
Message-ID: <20130507220742.GC24635@dastard>
References: <kltu6o$33j$1@ger.gmane.org> <km7oop$28c$1@ger.gmane.org>
	<20130506122844.GL19978@dastard> <5187A663.707@itwm.fraunhofer.de>
	<20130507011254.GP19978@dastard>
	<5188E2F5.1090304@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5188E2F5.1090304@itwm.fraunhofer.de>
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
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-xfs@oss.sgi.com

On Tue, May 07, 2013 at 01:18:13PM +0200, Bernd Schubert wrote:
> On 05/07/2013 03:12 AM, Dave Chinner wrote:
> >On Mon, May 06, 2013 at 02:47:31PM +0200, Bernd Schubert wrote:
> >>On 05/06/2013 02:28 PM, Dave Chinner wrote:
> >>>On Mon, May 06, 2013 at 10:14:22AM +0200, Bernd Schubert wrote:
> >>>>And anpther protection fault, this time with 3.9.0. Always happens
> >>>>on one of the servers. Its ECC memory, so I don't suspect a faulty
> >>>>memory bank. Going to fsck now-
> >>>
> >>>http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >>
> >>Isn't that a bit overhead? And I can't provide /proc/meminfo and
> >>others, as this issue causes a kernel panic a few traces later.
> >
> >Provide what information you can.  Without knowing a single thing
> >about your hardware, storage config and workload, I can't help you
> >at all. You're asking me to find a needle in a haystack blindfolded
> >and with both hands tied behind my back....
> 
> I see that xfs_info, meminfo, etc are useful, but /proc/mounts?
> Maybe you want "cat /proc/mounts | grep xfs"?. Attached is the
> output of /proc/mounts, please let me know if you were really
> interested in all of that non-xfs output?

Yes. You never know what is relevant to a problem that is reported,
especially if there are multiple filesystems sharing the same
device...

> And I just wonder what you are going to do with the information
> about the hardware. So it is an Areca hw-raid5 device with 9 disks.
> But does this help? It doesn't tell if one of the disks reads/writes
> with hickups or provides any performance characteristics at all.

Yes, it does, because Areca cards are by far the most unreliable HW
RAID you can buy, which is not surprising because they are also the
cheapest. This is through experience - we see reports of filesystems
being badly corrupted ever few months because of problems with Areca
controllers.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
