Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A2337CA0
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 17:12:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AAB6CAC003
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 15:12:11 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	PYEcxWGi7qxamjSj for <xfs@oss.sgi.com>;
	Tue, 24 May 2016 15:12:07 -0700 (PDT)
Date: Wed, 25 May 2016 08:12:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LVM snapshot and log record CRC mismatch
Message-ID: <20160524221205.GM21200@dastard>
References: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ab81e19cd6fce41f9d63cdd3695c80f7@assyoma.it>
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
To: Gionatan Danti <g.danti@assyoma.it>
Cc: xfs@oss.sgi.com

On Tue, May 24, 2016 at 02:58:51PM +0200, Gionatan Danti wrote:
> Hi list,
> I have a question about LVM snapshot and XFS.
> 
> Some preliminary information: CentOS Linux release 7.0.1406 (Core),
> with kernel version 3.10.0-123.20.1.el7.x86_64
> 
> Basically, each time I mount a LVM snapshot (with the "nouuid"
> option), I have the following dmesg entries:
> 
> [824501.391058] XFS (dm-7): Mounting Filesystem
> [824502.085459] XFS (dm-7): Starting recovery (logdev: internal)
> [824502.120435] XFS (dm-7): log record CRC mismatch: found
> 0x324293f8, expected 0x43a1b3b5.
> [824502.121035] ffffc90018271000: 00 00 00 10 00 00 00 00 69 01 00
> 00 6d a0 9d a7  ........i...m...
> [824502.121649] ffffc90018271010: 00 00 00 10 69 00 00 00 4e 41 52
> 54 2a 00 00 00  ....i...NART*...
> [824502.122403] XFS (dm-7): log record CRC mismatch: found
> 0x873f6b2, expected 0x49045c16.
....
> 
> From my understanding, this should be more or less the expected
> behavior: the snapshot is a "crash consistent" backup point, and
> mounting the snapshotted filesystem can led to mismatched CRC.

No, a snapshot should not have mismatched CRC errors in the log.
However, log recovery should be seeing only an unmount record during
recovery, so seeing multiple CRC errors indicates that the
filesystem was not quiesced correctly when the snapshot was taken.

How did you take the snapshot? (full command lines, please)

> Anyway, I can read from the snapshot without problems.

Well, until you hit whatever was not replayed out of the log....

> However, issuing a xfs_info on the original volume shows that crc
> options is 0 (crc=0), so I am somewhat puzzled about the warning
> above.

CRCs are now always enabled on the journal. The difference is that
for crc=1 filesystems this is a fatal error and the fs won't mount,
while for crc=0 it is simply a canary for developers when bugs are
reported that something might have gone wrong in log recovery....

> Moreover, on a more recent CentOS 7.2 server (kernel version
> 3.10.0-327.13.1.el7.x86_64), I can not reproduce this warning.
> 
> So I ask:
> 1) it really is the expected behavior, or should I be worried by the
> dmesg entries?

Not expected. indicates a problem with the snapshot image.

> 2) this is kernel-related

Maybe.

> should I update the kernel to newer version?

Depends if it is kernel related...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
