Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0D0BC7F37
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 06:03:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EDDB8304062
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 04:03:03 -0800 (PST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com
	[74.125.82.49]) by cuda.sgi.com with ESMTP id J7VzDAKOgD5sk5Hi
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Dec 2015 04:03:01 -0800 (PST)
Received: by wmww144 with SMTP id w144so19039870wmw.0
	for <xfs@oss.sgi.com>; Thu, 03 Dec 2015 04:03:00 -0800 (PST)
Subject: Re: xfs hang or slowness while removing files
References: <565ED10C.9000604@scylladb.com> <20151202210929.GJ19199@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <56602F72.1020705@scylladb.com>
Date: Thu, 3 Dec 2015 14:02:58 +0200
MIME-Version: 1.0
In-Reply-To: <20151202210929.GJ19199@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 12/02/2015 11:09 PM, Dave Chinner wrote:
> On Wed, Dec 02, 2015 at 01:07:56PM +0200, Avi Kivity wrote:
>> Removing a directory with ~900 32MB files, we saw this:
>>
>> [ 5645.684464] INFO: task xfsaild/md0:12247 blocked for more than
>> 120 seconds.
>> [ 5645.686488] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 5645.687713] xfsaild/md0     D ffff88103f9d3680     0 12247    2
>> 0x00000080
>> [ 5645.687729]  ffff8810136f7d40 0000000000000046 ffff882026d82220
>> ffff8810136f7fd8
>> [ 5645.687732]  ffff8810136f7fd8 ffff8810136f7fd8 ffff882026d82220
>> ffff882026d82220
>> [ 5645.687734]  ffff88103f9d44c0 0000000000000001 0000000000000000
>> ffff8820285aa928
>> [ 5645.687737] Call Trace:
>> [ 5645.687747]  [<ffffffff816098d9>] schedule+0x29/0x70
>> [ 5645.687768]  [<ffffffffa06cd880>] _xfs_log_force+0x230/0x290 [xfs]
>> [ 5645.687773]  [<ffffffff810a9510>] ? wake_up_state+0x20/0x20
>> [ 5645.687796]  [<ffffffffa06cd906>] xfs_log_force+0x26/0x80 [xfs]
>> [ 5645.687808]  [<ffffffffa06d2380>] ?
>> xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
>> [ 5645.687818]  [<ffffffffa06d24d1>] xfsaild+0x151/0x5e0 [xfs]
>> [ 5645.687828]  [<ffffffffa06d2380>] ?
>> xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
>> [ 5645.687831]  [<ffffffff8109727f>] kthread+0xcf/0xe0
>> [ 5645.687834]  [<ffffffff810971b0>] ? kthread_create_on_node+0x140/0x140
>> [ 5645.687837]  [<ffffffff81614358>] ret_from_fork+0x58/0x90
>> [ 5645.687852]  [<ffffffff810971b0>] ? kthread_create_on_node+0x140/0x140
>>
>> 'rm' did not complete, but was killable.  Nothing else was running
>> on the system at the time.
> Which means the filesystem was not hung, nor was rm blocked in XFS.
> That implies the directory/inode reads that rm does were running
> really slowly. Something else going on here.
>
>> The filesystem was mounted with the discard option set, but since
>> that is discouraged, we'll retry without it.
> Ah, yes, that could cause exactly these symptoms.
>
> I'd guess you are using storage that has unqueued TRIM operations
> (i.e. SATA 3.0 hardware somewhere in your storage path, as queued
> TRIM only came along with SATA 3.1 and AFAIA there's not a lot of
> 3.1 hardware out there yet) which means while discards are
> being issued all other IO tanks and goes really slow.

It's bare-metal cloud hardware so I don't immediately know (I don't 
control the machine).  I could find out -

> We have seen individual TRIM requests on some SSDs take tens of
> milliseconds to complete, regardless of their size. Hence if you
> have one of these devices and you're running thousands of TRIM
> commands across ~30GB of data being freed, then you'd see things
> like rm being really slow on the read side and log forces waiting an
> awful long time for journal IO completion processing to take
> place...
>

- but it's probably better to just drop discard and see if it happens again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
