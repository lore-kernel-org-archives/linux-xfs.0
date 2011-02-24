Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OAHfqI128831 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:17:42 -0600
Received: from mail-yx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 08D712F898A
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:20:26 -0800 (PST)
Received: from mail-yx0-f181.google.com (mail-yx0-f181.google.com
	[209.85.213.181]) by cuda.sgi.com with ESMTP id
	0MB4QeDNU5Scf7nX for <xfs@oss.sgi.com>;
	Thu, 24 Feb 2011 02:20:26 -0800 (PST)
Received: by yxm8 with SMTP id 8so239449yxm.26
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:20:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110223162316.45a49880@harpe.intellique.com>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<20110223162316.45a49880@harpe.intellique.com>
Date: Thu, 24 Feb 2011 11:20:26 +0100
Message-ID: <AANLkTi=oATgJyP6eB8eDeE8Q2-c0DTgP-oc+gk6mRkrO@mail.gmail.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
From: Erik Gulliksson <erik@gulliksson.org>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

Thanks for your comments Emmanuel.

> So the RAID array looks OK, the RAID controller doesn't report any
> particular problem. You said it was reported as 0 K. Where did you see
> 0 K reported?

No I meant it is "OK" with "O" :)

> What gives "dmesg | grep 3w-9xxx" ? and "tw_cli alarms" ? Was the
> filesystem under heavy write when the problem occured ?

The server has been restarted since the problems started, so nothing
notable in "tw_cli alarms" or dmesg. The controller was performing
rebuild on another the other unit when it happened, however I don't
think the actual xfs-filesystem was particularly loaded.


>
> I'd start with launching a RAID verify, to detect and correct possible
> on-disk coherency problems (it can't hurt anyway):
>
> tw_cli /c0/u0 start verify
>
> Then "tail -f /var/log/messages | grep 3w-9xxx" ...
I will try this over night and see if something is reported.

> I suppose that there are no problems to be discovered. Most probably
> IOs to the array were lost because of the bus reset.

That's what I am afraid of too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
