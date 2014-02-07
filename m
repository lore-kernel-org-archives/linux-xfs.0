Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 630A27F51
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 22:18:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 37213304071
	for <xfs@oss.sgi.com>; Thu,  6 Feb 2014 20:18:40 -0800 (PST)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
	[209.85.220.47]) by cuda.sgi.com with ESMTP id o38mLx5gL0G4t56S
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 06 Feb 2014 20:18:36 -0800 (PST)
Received: by mail-pa0-f47.google.com with SMTP id kp14so2629620pab.6
	for <xfs@oss.sgi.com>; Thu, 06 Feb 2014 20:18:36 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v3] Btrfs: add regression test for running snapshot and
	send concurrently
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20140206224337.GB13647@dastard>
Date: Fri, 7 Feb 2014 12:18:31 +0800
Message-Id: <D32F9438-DA80-41AF-9247-A81E6EC90497@gmail.com>
References: <1391703008-2322-1-git-send-email-wangshilong1991@gmail.com>
	<20140206224337.GB13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


Hi Dave,

> On Fri, Feb 07, 2014 at 12:10:08AM +0800, Wang Shilong wrote:
>> +$BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
>> +	$SCRATCH_MNT/snap_1 >> $seqres.full 2>&1
>> +
>> +do_snapshots &
>> +snapshots_pid=$!
>> +
>> +$BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 > /dev/null 2>&1 || echo "btrfs send failed"
> 
> Let's stop this anti-pattern before it takes hold.
> 
> If there's output from the send command it should be
> filtered and captured in the golden image. Hence any deviation
> caused by errors is automatically flagged as an error.
> 
> That's the whole point of using golden images for capturing errors -
> you don't need to capture return values from binaries and it
> guarantees that users are informed about failures through error
> messages. IOWs:
> 
> $BTRFS_UTIL_PROG send $SCRATCH_MNT/snap_1 | _btrfs_send_filter
> 
> is what you should be doing here.

I knew what you mean here, in fact, i did this on purpose.
for this test failure, btrfs-prog did not output failure information from the beginning.
So to make older progs can also detect the test failure, i dropped into this way.

Anyway, if you don't like this and think  old btrfs-progs needn't consider this,  i will update
the patch.^_^

Thanks,
Wang

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
