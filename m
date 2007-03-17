Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 17 Mar 2007 06:01:26 -0700 (PDT)
Received: from bay0-omc3-s31.bay0.hotmail.com (bay0-omc3-s31.bay0.hotmail.com [65.54.246.231])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2HD1K6p008578
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2007 06:01:21 -0700
Message-ID: <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c.  Caller 0xc01b00bd
Date: Sat, 17 Mar 2007 14:00:30 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:

> Ok, so an ipsec change. And I see from the history below it
> really has nothing to do with this problem. it seems the problem
> has something to do with changes between 2.6.19.1 and 2.6.19.2.

indeed. Yesterday at 13:00 I have switched from 2.6.19.1 to 2.6.19.2
(without the ipsec fix) and at about 17:30 linux has crashed again.
I have recompiled 2.6.19.2 with all kernel debugging options enabled
and rebooted. Now I'm waiting for the crash...

> There were no changes to XFS between 2.6.19.1 and 2.6.19.2,
> so I'm thinking that your problems are related to something
> other than XFS. Can you do a git bisect to determine what the
> bad patch is?

Ok, monday morning I will try to do a git bisect. I just want tell you
that this machine is a firewall (3 nic) + ipsec gateway (openswan) +
http proxy (squid). I think that the problem is related to the networking.
I have other 2.6.19/2.6.20 linux boxes acting as proftpd/samba/sendmail
without any problem.

>> > Can you run xfs_repair on that filesystem and see if reports
>> > (and fixes) any problems?
>> 
>> I don't need to run xfs_repair to fix the problem,
> 
> Except that the trigger might be on-disk corruption so we
> need to rule that out first.

Ok I will run xfs_repair and post results.

>> I only unplug the power cable and reboot the system,
>> xfs filesystem are correctly mounted.
>> However tell me if I must run xfs_repair to check
>> the filesystem.
> 
> Yes, you need to run xfs_repair.

ok , thanks a lot for the feedback.

PS: I'm running slackware 11 with xfsprogs-2.8.10. Are they fine
or should I upgrade?
