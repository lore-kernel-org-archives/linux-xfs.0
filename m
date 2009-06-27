Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5RExr05005736 for <xfs@oss.sgi.com>; Sat, 27 Jun 2009 09:59:53 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2823F30405F
	for <xfs@oss.sgi.com>; Sat, 27 Jun 2009 08:00:21 -0700 (PDT)
Message-Id: <7994423C-3028-4EEE-991B-B21F5019AEBE@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090627070854.GL29416@mail.physik.uni-wuppertal.de>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: corrupt file system -- "Structure needs cleaning"
Date: Sat, 27 Jun 2009 10:00:19 -0500
References: <20090626195804.GG29416@mail.physik.uni-wuppertal.de>
	<B1B6286B-1472-4584-8318-F9BB4E74BF8E@sgi.com>
	<20090627070854.GL29416@mail.physik.uni-wuppertal.de>
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
To: Hendrik Hoeth <hendrik.hoeth@cern.ch>
Cc: xfs@oss.sgi.com


On Jun 27, 2009, at 2:08 AM, Hendrik Hoeth wrote:

> Thus spake Felix Blyakher (felixb@sgi.com):
>
>> Seems like no corruption on disk.
>> The system detected in memory corruption and shut the filesystem
>> down to avoid writing bad (meta)data to disk. I don't have answer
>> for that problem, however you can continue to use the filesystem,
>> and may never see this problem again. If it happens again, it
>> could be useful to run debug XFS, which may point to the problem.
>
> I ran memtest over night, without any errors. So if this happens again
> and I need to run xfs_db,

No, I didn't mean xfs_db. That examines the data structures on disk,
but apparently they're clean anyway.

> what do I need to do to get useful information
> out? Haven't done that before ...

What I meant is to rebuild the XFS with the CONFIG_XFS_DEBUG set.
With that option XFS has much more checks in place and hopefully
will assert earlier, giving us more clues.
It would be great help to XFS developers, but I'm not sure if it's
too much to ask for.

Thanks,
Felix

>
>
>    Hendrik
>
> -- 
> "You have to take the most direct road to go instead of your
> meeting, you have to, this one ended, leave at once the CERN
> domain."         (imprint on the CERN visitor ID cards)
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
