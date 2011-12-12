Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC0Dhkx061899 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:13:44 -0600
Received: from itoolabs.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 538651EA936C
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 16:13:42 -0800 (PST)
Received: from itoolabs.net (be01.de01.itoolabs.net [188.40.74.239]) by
	cuda.sgi.com with ESMTP id VvII1LvyvdBTHGmF for
	<xfs@oss.sgi.com>; Sun, 11 Dec 2011 16:13:42 -0800 (PST)
Message-ID: <4EE54734.8050603@yahoo.co.uk>
Date: Mon, 12 Dec 2011 00:13:40 +0000
From: Dmitry Panov <dmitry.panov@yahoo.co.uk>
MIME-Version: 1.0
Subject: Re: Data corruption, md5 changes on every mount
References: <4EE4AE61.6000306@yahoo.co.uk> <20111211235334.GJ14273@dastard>
In-Reply-To: <20111211235334.GJ14273@dastard>
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

Hi Dave,

On 11/12/2011 23:53, Dave Chinner wrote:
> On Sun, Dec 11, 2011 at 01:21:37PM +0000, Dmitry Panov wrote:
>> Hi guys,
>>
>> I have a 2TiB XFS which is about 60% full. Recently I've noticed
>> that the daily inc. backup reports file contents change for files
>> that are not supposed to change.
> What kernel/platform? What version of xfsprogs? What kind of
> storage?
It's linux kernel 3.0.0 at the moment, however it used to run different 
versions and I can't tell for sure when the problem started. xfsprogs 
version is 3.1.2.

The storage is a 2 node cluster with hardware RAID1+0 and drbd.
>> I've created an LVM snapshot and ran xfs_check/xfs_repair. xfs_check
>> did report a few problems (unknown node type). After that I ran a
>> simple test: mount, calculate md5 of the problematic files, report
>> if it changed, umount, sleep 10 sec. That script reported that md5
>> sum of at least one file was changing on every cycle.
> That sounds like you've got a dodgy drive.

That would be my guess too, however the problem occurs on both nodes 
(i.e. it doesn't go away when the other node becomes active) and the 
same files affected which makes hard drives or RAID controller or RAM 
failure very unlikely.


Is there any way to perform a more thorough check, than xfs_check does?


Best regards,

-- 
Dmitry Panov

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
