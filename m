Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S0c9Zx179715 for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:38:09 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B16E6149D8CE
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:42:26 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 2VT5ijtKjilsUBfC
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:42:26 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 8339F6C24C
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:40:32 -0500 (CDT)
Message-ID: <4BFF118F.3090508@hardwarefreak.com>
Date: Thu, 27 May 2010 19:42:55 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: NOW: o_direct   --  WAS: Re: WARNING in xfs_lwr.c, xfs_write()
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>	<20100523101856.GL2150@dastard>	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>	<4BF9FCA8.8090906@hardwarefreak.com>	<20100524143428.6f3a117c@abend.internal.xtremedata.com>	<20100526070620.GT2150@dastard>	<4BFD3926.6040208@hardwarefreak.com>
	<87mxvlbfu6.fsf@willster.local.flamingspork.com>
In-Reply-To: <87mxvlbfu6.fsf@willster.local.flamingspork.com>
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

Stewart Smith put forth on 5/27/2010 9:05 AM:

> Also, email smtpd delivering a message on a machine, you could quite
> likely have imapd come along and read that soon after, so using the
> cache makes sense.

Ah, that's a good point.  I've been using Postfix and Dovecot Local Delivery
Agent long enough that I'd forgotten about those folks who have their MTA drop
mail into /var/mail/%u etc which is then picked up by their imapd.  Dovecot
LDA receives from Postfix via pipe, so mail doesn't actually hit the disk
until Dovecot decides where it goes, via sieve scripts, for example.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
