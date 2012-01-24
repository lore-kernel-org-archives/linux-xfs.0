Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OFoSmO035949 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 09:50:28 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id O8iPBzFQ4jxaXDgi for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 07:50:26 -0800 (PST)
Message-ID: <4F1ED341.4010108@sandeen.net>
Date: Tue, 24 Jan 2012 09:50:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: How to fix bad superblock or xfs_repair: error - read only 0
	of 512 bytes
References: <CALx8gnT9tdPRGfVR0puoSVYz_MDDs4FtWtodST5x29GDnL3A_w@mail.gmail.com>
	<20120123043117.GH15102@dastard>
	<92CDAC52-1BA1-43A8-8470-0E2DCD916610@unixhosts.org>
	<4F1E3BD0.7080604@sandeen.net>
	<B1F1FDAB-0D48-48FE-8FFC-F0567780E052@unixhosts.org>
	<1327414341.24535.582.camel@montana.filmlight.ltd.uk>
	<4D396236-D516-4948-8F43-1AED88539BC4@unixhosts.org>
In-Reply-To: <4D396236-D516-4948-8F43-1AED88539BC4@unixhosts.org>
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
To: Christian Kildau <lists@unixhosts.org>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com

On 1/24/12 9:46 AM, Christian Kildau wrote:
> 
> On Jan 24, 2012, at 3:12 PM, Roger Willcocks wrote:
> 
>>
>> On Tue, 2012-01-24 at 11:13 +0100, Christian Kildau wrote:
>>> Top posting... sorry.
>>>
>>> I have now found dozens of other users with a similar issue! e.g.
>>> http://www.linuxquestions.org/questions/linux-general-1/cannot-mount-hard-disk-block-count-exceeds-size-of-device-bad-partition-table-880149/
>>>
>>> To make it short all of these users were running ext4 and a fs resize to the new geometry fixed their problems! Sadly XFS doesn't support shrinking the fs(?).
>>>
>>
>> It seems fairly clear that your drive or the bios is lying about its
>> capacity. The filesystem occupies the entire disk, but the disk has
>> become 'smaller'. A quick web search suggests a 'hidden protected area'
>> - the two block counts in this link line up with the before and after
>> sizes you're seeing:
>>
>> http://lime-technology.com/forum/index.php?topic=13440.0;wap2
>>
>> It would be instructive to see what 'hdparm -N /dev/sdd' says on your
>> system. And a dmesg log would be handy too.
>>
>> Note that this is /not/ a problem with xfs. The right fix is to tell the
>> drive to report its actual capacity, not to shrink the filesystem.
> 
> I do understand that is definitely not an XFS issue, but some strange issue with ubuntu or their kernel patches...
> 
> I got my data back by dumping the entire hdd (it was partitionless nevertheless) to a bigger 2TB hdd.
> XFS mounts without any problems and I can restore my data.
> 
> Thanks all for your help!

It's likely still missing the end of the filesystem, though.

Can you run the hdparm command Roger suggested on your original hard drive, please?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
