Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C06137F4C
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 02:39:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A049A304066
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 00:39:08 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ZkZ6Miv3jYJkt92L
	for <xfs@oss.sgi.com>; Fri, 08 Mar 2013 00:39:07 -0800 (PST)
Message-ID: <5139A3B6.3040805@hardwarefreak.com>
Date: Fri, 08 Mar 2013 02:39:18 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem corruption
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<20130306161519.2c28d911@galadriel.home>
	<CAPcwv6wqv0b_CPqDpBfOwVDg23uBi=tpGQSy9XuH2uWS5oVMWQ@mail.gmail.com>
	<20130306232100.6286f640@galadriel.home>
	<5137CD46.6070909@redhat.com>
In-Reply-To: <5137CD46.6070909@redhat.com>
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
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Julien FERRERO <jferrero06@gmail.com>, xfs@oss.sgi.com

On 3/6/2013 5:12 PM, Ric Wheeler wrote:

> We actually test brutal "Power off" for xfs, ext4 and other file
> systems. If your storage is configured properly and you have barriers
> enabled, they all pass without corruption.

Something that none of us mentioned WRT write barriers is that while the
filesystem structure may avoid corruption when the power is cut, files
may still be corrupted, in conditions such as any/all of these:

1.  unwritten data still in buffer cache
2.  drive caches are enabled
3.  BBWC not working properly

If the techs are determined to hard cut power because they don't have
the time or the knowledge to do a clean shutdown, it may be well worth
your time/effort to write a script and teach the field techs to execute
it, before flipping the master switch.  Your simple script would run as
root, or you'd need to do some sudo foo within, and would contain
something like:

#! /bin/sh
sync
echo 2 > /proc/sys/vm/drop_caches
echo "Ready for power down."

This will flush pending writes in buffer cache to disk, and assumes of
course that drive caches are disabled, and/or that BBWC, if present, is
functioning properly.  It also assumes no applications are still
actively writing files, in which case you're screwed regardless.  It's
not a perfect solution and there's no guarantee you won't suffer file
corruption, but this greatly increases your odds against it.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
