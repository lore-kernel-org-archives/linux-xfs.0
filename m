Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A670F7F3F
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 07:55:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47D3DAC005
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 05:55:27 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id CIqZCK9HSFAWogMv
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 05:55:26 -0700 (PDT)
Message-ID: <5141C8C1.2080903@hardwarefreak.com>
Date: Thu, 14 Mar 2013 07:55:29 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: xfs_fsr, sunit, and swidth
References: <5140C147.7070205@binghamton.edu>
	<514113C6.9090602@hardwarefreak.com>
	<514153ED.3000405@binghamton.edu>
	<5141C1FC.4060209@hardwarefreak.com>
In-Reply-To: <5141C1FC.4060209@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Dave Hall <kdhall@binghamton.edu>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Quick note below, need one more bit of info.

On 3/14/2013 7:26 AM, Stan Hoeppner wrote:
> On 3/13/2013 11:37 PM, Dave Hall wrote:
>> Stan,
>>
>> If you'd rather I can re-post this to xfs@oss.sgi.com, but I'm not clear
>> on exactly where this address leads.  I am grateful for your response.
> 
> No need, I'm CC'ing the list address.  Read this entirely before hitting
> reply.
> 
>> So the details are that this is a 16 x 2GB 7200 rpm SATA drive array in
>> a RAID enclosure.   The array is configured RAID6 (so 14 data spindles)
>> with a chunk size of 128k.  The XFS formatted size is 26TB with 19TB
>> currently used.
> 
> So your RAID6 stripe width is 14 * 128KB = 1,792KB.
> 
>> The workload is a backup program called rsnapshot.  If you're not
>> familiar, this program uses cp -al top create a linked copy of the
>> previous backup, and then rsync -av --del to copy in any changes. The
>> current snapshots contain about 14.8 million files.  The total number of
>> snapshots is about 600.
> 
> So you've got a metadata heavy workload with lots of links being created.
> 
>> The performance problem that lead me to investigate XFS is that some
>> time around mid-November the cp -al step started running very long -
>> sometimes over 48 hours.  Sometimes it runs in just a few hours. Prior
>> to then the entire backup consistenly finished in less than 12 hours. 
>> When the cp -al is running long the output of dstat indicates that the
>> I/O to the fs is fairly light.
> 
> The 'cp -al' command is a pure metadata workload, which means lots of
> writes to the filesystem directory trees, but not into files.  And if
> your kernel is lower than 2.6.39 your log throughput would be pretty
> high as well.  But given this is RAID6 you'll have significant RMW for
> these directory writes, maybe overwhelming RMW, driving latency up and
> thus actual bandwidth down.  So dstat bytes throughput may be low, but
> %wa may be through the roof, making the dstat data you're watching
> completely misleading as to what's really going on, what's causing the
> problem.
> 
>> Please let me know if you need any further information.  
> 
> Yes,  please provide the output of the following commands:

~$ uname -a

> ~$ grep xfs /etc/fstab
> ~$ xfs_info /dev/[mount-point]
> ~$ df /dev/[mount_point]
> ~$ df -i /dev/[mount_point]
> ~$ xfs_db -r -c freesp /dev/[mount-point]
> 
> Also please provide the make/model of the RAID controller, the write
> cache size and if it is indeed enabled and working, as well as any
> errors, if any, logged by the controller in dmesg or elsewhere in Linux,
> or in the controller firmware.
> 
>> Also, again, I
>> can post this to xfs@oss.sgi.com but I'd really like to know more about
>> the address.
> 
> Makes me where you obtained the list address.  Apparently not from the
> official websites or you'd not have to ask.  Maybe this will assuage
> your fears. ;)
> 
> xfs@oss.sgi.com is the official XFS mailing list submission address for
> the XFS developers and users.  oss.sgi.com is the server provided and
> managed by SGI (www.sgi.com) that houses the XFS open source project.
> SGI created the XFS filesystem first released on their proprietary
> IRIX/MIPS computers in 1994.  SGI open sourced XFS and ported it to
> Linux in the early 2000s.
> 
> XFS is actively developed by a fairly large group of people, and AFAIK
> most of them are currently employed by Red Hat, including Dave Chinner,
> who also replied to your post.  Dave wrote the delaylog code which will
> probably go a long way toward fixing your problem, if you're currently
> using 2.6.38 or lower and not mounting with this option enabled.  It
> didn't become the default until 2.6.39.
> 
> More info here http://www.xfs.org and here http://oss.sgi.com/projects/xfs/
> 
>> Thanks.
> 
> You bet.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
