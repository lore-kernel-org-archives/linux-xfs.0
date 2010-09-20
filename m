Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8K6kSsw207925 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 01:46:29 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 495FF181E2F4
	for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 23:47:18 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id xz9UnxiKpMMN9nPQ
	for <xfs@oss.sgi.com>; Sun, 19 Sep 2010 23:47:18 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 9165B6C015
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 01:47:17 -0500 (CDT)
Message-ID: <4C970375.5060309@hardwarefreak.com>
Date: Mon, 20 Sep 2010 01:47:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Linux and DMAPI
References: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
In-Reply-To: <AANLkTim5FExj9GFQf9v1rzRmxqtNrdw_UR5VPUs4bPMq@mail.gmail.com>
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

Diego Woitasen put forth on 9/18/2010 7:08 PM:
> Hi,
>  I'm looking for software that supports DMAPI on Linux. I haven't
> found anything on the web. I need to implement HSM for a mail server,
> to store old messages in a secondary storage.
> 
>  Are there something implemented? Open source or propietary one? I
> prefer open source obviously...

This may not be exactly what you're looking for, but Dovecot natively
supports two level HSM with the dbox/mdbox mail storage formats.

http://wiki2.dovecot.org/MailboxFormat/dbox

Bottom of the page, "Alternate storage".  See also:
http://wiki2.dovecot.org/Tools/Doveadm/Altmove

So basically you'd cron a script for some duration (daily, weekly,
monthly, etc) containing the above command to move old mails to your
alternate near line storage.

If it's a really busy server you may want to go with the individual user
route with one HSM script per user.  This would allow staggered
scheduling of the cron jobs so as to lessen the load on the server
compared to one cron job which does all users at once.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
