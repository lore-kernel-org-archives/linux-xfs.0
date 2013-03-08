Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E83B7F4C
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 06:20:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 053048F8033
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 04:20:44 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DpTDzSgFibME4zz7 for
	<xfs@oss.sgi.com>; Fri, 08 Mar 2013 04:20:41 -0800 (PST)
Message-ID: <5139D792.4090304@redhat.com>
Date: Fri, 08 Mar 2013 07:20:34 -0500
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
In-Reply-To: <5139A3B6.3040805@hardwarefreak.com>
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
To: stan@hardwarefreak.com
Cc: Julien FERRERO <jferrero06@gmail.com>, xfs@oss.sgi.com

On 03/08/2013 03:39 AM, Stan Hoeppner wrote:
> On 3/6/2013 5:12 PM, Ric Wheeler wrote:
>
>> We actually test brutal "Power off" for xfs, ext4 and other file
>> systems. If your storage is configured properly and you have barriers
>> enabled, they all pass without corruption.
> Something that none of us mentioned WRT write barriers is that while the
> filesystem structure may avoid corruption when the power is cut, files
> may still be corrupted, in conditions such as any/all of these:
>
> 1.  unwritten data still in buffer cache

This is true only for user data, not the file system metadata. We should always 
be able to drop power without seeing corruption (like the garbled ls output).

> 2.  drive caches are enabled

Write barriers will take care of drives with write cache enabled, as long as the 
hardware RAID card is not in the middle and misleading us.

> 3.  BBWC not working properly

This should not be a worry. If the battery (or in more modern cards, flash 
backed) is not working, a good card will flip into write through caching. Should 
be slow, but safe.

Note that the write cache state on the drives is still a question mark - that 
needs to be disabled normally.

>
> If the techs are determined to hard cut power because they don't have
> the time or the knowledge to do a clean shutdown, it may be well worth
> your time/effort to write a script and teach the field techs to execute
> it, before flipping the master switch.  Your simple script would run as
> root, or you'd need to do some sudo foo within, and would contain
> something like:
>
> #! /bin/sh
> sync
> echo 2 > /proc/sys/vm/drop_caches
> echo "Ready for power down."
>
> This will flush pending writes in buffer cache to disk, and assumes of
> course that drive caches are disabled, and/or that BBWC, if present, is
> functioning properly.  It also assumes no applications are still
> actively writing files, in which case you're screwed regardless.  It's
> not a perfect solution and there's no guarantee you won't suffer file
> corruption, but this greatly increases your odds against it.
>

For file system *metadata* consistency, you should not have to do this ever if 
the stack is properly configured.  The application data will still be lost.

Also, if there are active writers, this is inherently racy. A better script 
would unmount the file systems :)

Ric


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
