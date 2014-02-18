Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31CB97FF2
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 17:07:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D28A8F8081
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:07:22 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 7htEEGBIziWkWhBg
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 15:07:21 -0800 (PST)
Message-ID: <5303E7AC.50903@hardwarefreak.com>
Date: Tue, 18 Feb 2014 17:07:24 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Question regarding XFS on LVM over hardware RAID.
References: <52E91923.4070706@sandeen.net>	<1391022066-sup-5863@al.wesleyan.edu>	<52E99504.4030902@hardwarefreak.com>	<1391090527-sup-4664@al.wesleyan.edu>	<20140130202819.GO2212@dastard>	<52EB3B96.7000103@hardwarefreak.com>	<1391202273-sup-9265@al.wesleyan.edu>	<52ED61C9.8060504@hardwarefreak.com>	<20140202212152.GP2212@dastard>	<1391443675-sup-1730@al.wesleyan.edu>	<20140203214128.GR13997@dastard>	<52F09E36.8050606@hardwarefreak.com>
	<1392748390-sup-1943@al.wesleyan.edu>
In-Reply-To: <1392748390-sup-1943@al.wesleyan.edu>
Reply-To: stan@hardwarefreak.com
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
To: "C. Morgan Hamill" <chamill@wesleyan.edu>, xfs <xfs@oss.sgi.com>

On 2/18/2014 1:44 PM, C. Morgan Hamill wrote:
> Howdy, sorry for digging up this thread, but I've run into an issue
> again, and am looking for advice.
> 
> Excerpts from Stan Hoeppner's message of 2014-02-04 03:00:54 -0500:
>> After a little digging and thinking this through...
>>
>> The default PE size is 4MB but up to 16GB with LVM1, and apparently
>> unlimited size with LVM2.  It can be a few thousand times larger than
>> any sane stripe width.  This makes it pretty clear that PEs exist
>> strictly for volume management operations, used by the LVM tools, but
>> have no relationship to regular write IOs.  Thus the PE size need not
>> match nor be evenly divisible by the stripe width.  It's not part of the
>> alignment equation.
> 
> So in the course of actually going about this, I realized that this
> actually is not true (I think).

Two different issues.

> Logical volumes can only have sizes that are multiple of the physical
> extent size (by definition, really), and so there's no way to have
> logical volumes end on a multiple of the array's stripe width, given my
> stripe width of 9216s, there doesn't seem to be an abundance of integer
> solutions to 2^n mod 9216 = 0.
> 
> So my question is, then, does it matter if logical volumes (or, really,
> XFS file systems) actually end right on a multiple of the stripe width,
> or only that it _begin_ on a multiple of it (leaving a bit of dead space
> before the next logical volume)?

Create each LV starting on a stripe boundary.  There will be some
unallocated space between LVs.  Use the mkfs.xfs -d size= option to
create your filesystems inside of each LV such that the filesystem total
size is evenly divisible by the stripe width.  This results in an
additional small amount of unallocated space within, and at the end of,
each LV.

It's nice if you can line everything up, but when using RAID6 and one or
two bays for hot spares, one rarely ends up with 8 or 16 data spindles.

> If not, I'll tweak things to ensure my stripe width is a power of 2.

That's not possible with 12 data spindles per RAID, not possible with 42
drives in 3 chassis.  Not without a bunch of idle drives.

I still don't understand why you believe you need LVM in the mix, and
more than one filesystem.

>  - I need to expose, in the end, three-ish (two or four would be OK)
>    filesystems to the backup software, which should come fairly close
>    to minimizing the effects of the archive maintenance jobs integrity
>    checks, mostly).  CrashPlan will spawn 2 jobs per store point, so
>    a max of 8 at any given time should be a nice balance between
>    under-utilizing and saturating the IO.

Backup software is unaware of mount points.  It uses paths just like
every other program.  The number of XFS filesystems is irrelevant to
"minimizing the effects of the archive maintenance jobs".  You cannot
bog down XFS.  You will bog down the drives no matter how many
filesystems when using RAID60.

Here is what you should do:

Format the RAID60 directly with XFS.  Create 3 or 4 directories for
CrashPlan to use as its "store points".  If you need to expand in the
future, as I said previously, simply add another 14 drive RAID6 chassis,
format it directly with XFS, mount it at an appropriate place in the
directory tree and give that path to CrashPlan.  Does it have a limit on
the number of "store points"?

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
