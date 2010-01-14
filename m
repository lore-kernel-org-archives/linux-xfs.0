Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E2WesW213485 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 20:32:40 -0600
Received: from omr7.networksolutionsemail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E36F116474E
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 18:33:36 -0800 (PST)
Received: from omr7.networksolutionsemail.com (omr7.networksolutionsemail.com
	[205.178.146.57]) by cuda.sgi.com with ESMTP id
	65f9F1Fg0YLyUgkN for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 18:33:36 -0800 (PST)
Received: from mail.networksolutionsemail.com (mail.networksolutionsemail.com
	[205.178.146.50])
	by omr7.networksolutionsemail.com (8.13.6/8.13.6) with SMTP id
	o0E2Xapd027757 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 21:33:36 -0500
Message-ID: <4B4E8283.90001@chaven.com>
Date: Wed, 13 Jan 2010 20:33:39 -0600
From: Steve Costaras <stevecs@chaven.com>
MIME-Version: 1.0
Subject: Re: XFS data corruption with high I/O even on hardware raid
References: <4B4E6F3F.1090901@chaven.com>
	<20100114022409.GW17483@discord.disaster>
In-Reply-To: <20100114022409.GW17483@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 01/13/2010 20:24, Dave Chinner wrote:
> On Wed, Jan 13, 2010 at 07:11:27PM -0600, Steve Costaras wrote:
>    
>> Ok, I've been seeing a problem here since had to move over to XFS from
>> JFS due to file system size issues.   I am seeing XFS Data corruption
>> under ?heavy io?   Basically, what happens is that under heavy load
>> (i.e. if I'm doing say a xfs_fsr (which nearly always triggers the
>> freeze issue) on a volume the system hovers around 90% utilization for
>> the dm device for a while (sometimes an hour+, sometimes minutes) the
>> subsystem goes into 100% utilization and then freezes solid forcing me
>> to do a hard reboot of the box.
>>      
> xfs_fsr can cause a *large* amount of IO to be done, so it is no
> surprise that it can trigger high load bugs in hardware and
> software. XFS can trigger high load problems on hardware more
> readily than other filesystems because using direct IO (like xfs_fsr
> does) it can push far, far higher throughput to the starge subsystem
> than any other linux filesystem can.
>
> The fact that the IO subsystem is freezing at 100% elevator queue
> utilisation points to an IO never completing. This immediately makes
> me point a finger at either the RAID hardware or the driver - a bug
> in XFS is highly unlikely to cause this symptom as those stats are
> generated at layers lower than XFS.
>
> Next time you get a freeze, the output of:
>
> # echo w>  /proc/sysrq-trigger
>
> will tell use what the system is waiting on (i.e. why it is stuck)
>
> ...
>    

Thanks will try that, some times I do have enough time to issue a couple 
commands before the kernel hard locks and no user input is accepted.


>> Since I'm using hardware raid w/ BBU when I reboot and it comes back up
>> the raid controller writes out to the drives any outstanding data in
>> it's cache and from the hardware point of view (as well as lvm's point
>> of view) the array is ok.    The file system however generally can't be
>> mounted (about 4 out of 5 times, some times it does get auto-mounted but
>> when I then run an xfs_repair -n -v in those cases there are pages of
>> errors (badly aligned inode rec, bad starting inode #'s, dubious inode
>> btree block headers among others).    When I let a repair actually run
>> in one case out of 4,500,000 files it linked about 2,000,000 or so but
>> there was no way to identify and verify file integrity.  The others were
>> just lost.
>>
>> This is not limited to large volume sizes I have seen similar on small
>> ~2TiB file systems as well.  Also when it happened in a couple cases the
>> file system that was taking the I/O (say xfs_fsr -v /home ) another XFS
>> filesystem on the same system which was NOT taking much if any I/O gets
>> badly corrupted (say /var/test ).   Both would be using the same areca
>> controllers and same physical discs (same PV's and same VG's but
>> different LV's).
>>      
> These symptoms really point to a problem outside XFS - the only time
> I've seen this sort of behaviour is on buggy hardware. The
> cross-volume corruption is the smoking gun, but proving it is damn
> near impossible without expensive lab equipment and a lot of time.
>    

That's what I figured both the high I/O (as JFS did not produce as much 
I/O as I see under XFS) as well as the utilization reaching 100% on a 
particular card.

Would enabling write buffers have any positive effect here to at least 
minimize data loss issues?



>> Any suggestions on how to isolate or eliminate this would be greatly
>> appreciated.
>>      
> I'd start by not running xfs_fsr as a short term workaround to keep
> the load below the problem threshold.
>
> Looking at the iostat output - the volumes sd[f-i] all lock up at
> 100% utilisation at the same time. Then looking at this:
>    

Already planning on it, the ?sole? benefit of this corruption is that at 
least the full volume restore has much less fragmentation.   (kind of a 
killer way to defragment but it does work).


Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
