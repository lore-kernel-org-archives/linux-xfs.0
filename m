Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1PAxov0142384 for <xfs@oss.sgi.com>; Sat, 25 Feb 2012 04:59:50 -0600
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id qZAKVUzynBHxHhgy for
	<xfs@oss.sgi.com>; Sat, 25 Feb 2012 02:59:48 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: creating a new 80 TB XFS
Date: Sat, 25 Feb 2012 11:59:47 +0100
References: <4F478818.4050803@cape-horn-eng.com>
	<201202241720.23581.Martin@lichtvoll.de>
	<4F47C021.7010008@hardwarefreak.com>
	(sfid-20120224_183621_521804_2AD5C893)
In-Reply-To: <4F47C021.7010008@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201202251159.47771.Martin@lichtvoll.de>
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
To: xfs@oss.sgi.com, stan@hardwarefreak.com

Am Freitag, 24. Februar 2012 schrieb Stan Hoeppner:
> On 2/24/2012 10:20 AM, Martin Steigerwald wrote:
> > Am Freitag, 24. Februar 2012 schrieb Richard Ems:
> >>>> MOUNT
> >>>> On mount I will use the options
> >>>> 
> >>>> mount -o noatime,nobarrier,nofail,logbufs=8,logbsize=256k,inode64
> >>>> /dev/sdX1 /mount_point
> >>> 
> >>> I think that the logbufs/logbsize option matches the default here.
> >>> Use delaylog if applicable. See the xfs FAQ.
> >> 
> >> Yes, if I trust the mount manual page, it states "The default value
> >> is 8 buffers for any recent kernel." . I suppose 3.2.6 is "a recent
> >> kernel", so this could be avoided, but having it explicitly on the
> >> mkfs.xfs line does not hurt, or?
> >> And for logbsize: "The default value for any recent kernel is
> >> 32768."
> >> 
> >> But then at the end of the manual page for mount it says "December
> >> 2004", so how actual is this information? Can the default mount
> >> values be shown by running mount with some verbose and dry-run
> >> parameters?
> > 
> > Does cat /proc/mounts show them? /proc/mounts is more detailed than
> > mount or mount -l.
> 
> Vanilla kernel.org 3.2.6:
> 
> ~$ cat /proc/mounts
> /dev/sda7 /samba xfs rw,relatime,attr2,delaylog,noquota 0 0
> 
> It doesn't show the default logbufs and logbsize values.  I asked about
> this specific issue over a year ago, because the documentation is
> inconsistent, and you can't get the default values out of a running
> system.  If you can I don't know how.  If someone stated a method, I
> can't recall it. :(
> 
> I do recall Dave, IIRC, saying something to the effect of 'just use the
> defaults, as they are 8 and 256K in recent kernels anyway'.  That's not
> a direct quote, but my recollection.

As I wrote it I thought about that for XFS the option might not be 
displayed. Cause I remember having seen something similar quite some time 
ago.

With NFS this works quite well, also with Ext4 and vfat it seems to me.

I think it would be good to include default options in /proc/mounts.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
