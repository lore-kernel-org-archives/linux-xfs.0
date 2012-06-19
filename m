Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5JE5pVI100839 for <xfs@oss.sgi.com>; Tue, 19 Jun 2012 09:05:51 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8vvpzhMxOOPeO71k for
	<xfs@oss.sgi.com>; Tue, 19 Jun 2012 07:05:50 -0700 (PDT)
Message-ID: <4FE08736.4010202@redhat.com>
Date: Tue, 19 Jun 2012 09:05:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Ext4 and xfs problems in dm-thin on allocation and discard
References: <4FDF9EBE.2030809@shiftmail.org> <20120619015745.GJ25389@dastard>
	<20120619031241.GA3884@redhat.com>
	<alpine.LFD.2.00.1206190816440.2241@dhcp-1-248.brq.redhat.com>
	<20120619131649.GA6811@redhat.com>
	<alpine.LFD.2.00.1206191519320.21961@dhcp-1-248.brq.redhat.com>
	<20120619133041.GB6811@redhat.com> <4FE0840F.2050704@shiftmail.org>
In-Reply-To: <4FE0840F.2050704@shiftmail.org>
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
To: Spelic <spelic@shiftmail.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, xfs@oss.sgi.com, device-mapper development <dm-devel@redhat.com>, =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>, linux-ext4@vger.kernel.org

On 6/19/12 8:52 AM, Spelic wrote:
> On 06/19/12 15:30, Mike Snitzer wrote:
>> I don't recall Spelic saying anything about EOPNOTSUPP. So what has made you zero in on an -EOPNOTSUPP return (which should not be happening)? 
> 
> Exactly: I do not know if EOPNOTSUPP is being returned or not.
> 
> If this helps, I have configured dm-thin via lvm2
>   LVM version:     2.02.95(2) (2012-03-06)
>   Library version: 1.02.74 (2012-03-06)
>   Driver version:  4.22.0
> 
> from dmsetup table I only see one option : "skip_block_zeroing", if and only if I configure it with -Zn . I do not see anything regarding ignore_discard
> 
>      vg1-pooltry1-tpool: 0 20971520 thin-pool 252:1 252:2 2048 0 1 skip_block_zeroing
>      vg1-pooltry1_tdata: 0 20971520 linear 9:20 62922752
>      vg1-pooltry1_tmeta: 0 8192 linear 9:20 83894272
>      vg1-thinlv1: 0 31457280 thin 252:3 1
> 
> 
> and in dmesg:
> [   33.685200] device-mapper: thin: Discard unsupported by data device (dm-2): Disabling discard passdown.
> [   33.709586] device-mapper: thin: Discard unsupported by data device (dm-6): Disabling discard passdown.
> 
> 
> I do not know what is the mechanism for which xfs cannot unmap blocks from dm-thin, but it really can't.
> If anyone has dm-thin installed he can try. This is 100% reproducible for me.

Might be worth seeing if xfs is ever getting to its discard code?  There is a tracepoint...

# mount -t debugfs none /sys/kernel/debug
# echo 1 > /sys/kernel/debug/tracing/tracing_enabled
# echo 1 > /sys/kernel/debug/tracing/events/xfs/xfs_discard_extent/enable

<run test>

# cat /sys/kernel/debug/tracing/trace

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
