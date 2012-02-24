Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OGpiFB069047 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 10:51:45 -0600
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id taLvQAf1J9gLNA80
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 08:51:43 -0800 (PST)
Message-ID: <4F47C021.7010008@hardwarefreak.com>
Date: Fri, 24 Feb 2012 10:51:45 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: creating a new 80 TB XFS
References: <4F478818.4050803@cape-horn-eng.com>
	<20120224150805.243e4906@harpe.intellique.com>
	<4F47B020.4000202@cape-horn-eng.com>
	(sfid-20120224_171032_352286_A09775B9)
	<201202241720.23581.Martin@lichtvoll.de>
In-Reply-To: <201202241720.23581.Martin@lichtvoll.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

On 2/24/2012 10:20 AM, Martin Steigerwald wrote:
> Am Freitag, 24. Februar 2012 schrieb Richard Ems:
>>>> MOUNT
>>>> On mount I will use the options
>>>>
>>>> mount -o noatime,nobarrier,nofail,logbufs=8,logbsize=256k,inode64
>>>> /dev/sdX1 /mount_point
>>>
>>>
>>>
>>> I think that the logbufs/logbsize option matches the default here.
>>> Use delaylog if applicable. See the xfs FAQ.
>>
>> Yes, if I trust the mount manual page, it states "The default value is
>> 8 buffers for any recent kernel." . I suppose 3.2.6 is "a recent
>> kernel", so this could be avoided, but having it explicitly on the
>> mkfs.xfs line does not hurt, or?
>> And for logbsize: "The default value for any recent kernel is 32768."
>>
>> But then at the end of the manual page for mount it says "December
>> 2004", so how actual is this information? Can the default mount values
>> be shown by running mount with some verbose and dry-run parameters?
> 
> Does cat /proc/mounts show them? /proc/mounts is more detailed than mount 
> or mount -l.

Vanilla kernel.org 3.2.6:

~$ cat /proc/mounts
/dev/sda7 /samba xfs rw,relatime,attr2,delaylog,noquota 0 0

It doesn't show the default logbufs and logbsize values.  I asked about
this specific issue over a year ago, because the documentation is
inconsistent, and you can't get the default values out of a running
system.  If you can I don't know how.  If someone stated a method, I
can't recall it. :(

I do recall Dave, IIRC, saying something to the effect of 'just use the
defaults, as they are 8 and 256K in recent kernels anyway'.  That's not
a direct quote, but my recollection.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
