Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p24AQpZb156489 for <xfs@oss.sgi.com>; Fri, 4 Mar 2011 04:26:52 -0600
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 79667311CFC
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2011 02:29:40 -0800 (PST)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id 12uoA5bfFn9sPEUI for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2011 02:29:40 -0800 (PST)
Received: from [10.0.0.5] (helo=doom.schmorp.de)
	by mail.nethype.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvSGR-000477-U3
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 10:29:40 +0000
Received: from [10.0.0.1] (helo=cerebro.laendle)
	by doom.schmorp.de with esmtp (Exim 4.72)
	(envelope-from <schmorp@schmorp.de>) id 1PvSGR-0002k6-O2
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 10:29:39 +0000
Received: from root by cerebro.laendle with local (Exim 4.72)
	(envelope-from <root@schmorp.de>) id 1PvSGR-0002jB-Mo
	for xfs@oss.sgi.com; Fri, 04 Mar 2011 11:29:39 +0100
Date: Fri, 4 Mar 2011 11:29:39 +0100
From: Marc Lehmann <schmorp@schmorp.de>
Subject: Re: corruption, xfs_repair 3.1.4 segfaults
Message-ID: <20110304102939.GA10416@schmorp.de>
References: <20110302175818.GA8290@schmorp.de>
	<20110302224329.3f62c172@galadriel2.home>
	<20110304071123.GC2316@schmorp.de>
	<20110304085146.368046e7@galadriel2.home>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110304085146.368046e7@galadriel2.home>
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
To: xfs@oss.sgi.com

On Fri, Mar 04, 2011 at 08:51:46AM +0100, Emmanuel Florac <eflorac@intellique.com> wrote:
> Ah, I think the problem may lie in the loop device. Try to run

At least the xfs_repair problem cannot be in the loop device:

>From the strace it's obvious that xfs_repair tries to read close to 2**64
bytes, and then crashes when the kernel rightly says that it can't do that.

It also shows that xfs_repair tries to allocate 3gb of memory (which is in
addition to the 1gb it already uses at that point), which is far more then
it should (specifying -m 990 didn't change that), which is another bug in
xfs_repair.

I think that, no matter what the loop device would do, xfs_repair is buggy
- it simply shouldn't crash, no matter how corrupted the filesystem is.

As a sidenote, I am now about 30% in recovering (copying) and
verifying the data, and it seems the volume isn't corrupted completely
(fortunately), so I can probably recover the important stuff, and reformat
the partition, so this might not turn out to be data loss (fortunately :).

> xfs_repair -f /file/path 
> 
> (not using the loop device).

that will not work, as xfs_repair has no encryption support (which is why
the loop device is used in the first place).

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      schmorp@schmorp.de
      -=====/_/_//_/\_,_/ /_/\_\

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
