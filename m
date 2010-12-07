Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB7IH1av197241 for <xfs@oss.sgi.com>; Tue, 7 Dec 2010 12:17:02 -0600
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B713C1CA0A0D
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 10:18:49 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id PFSDrdEeJ9KqC9MP
	for <xfs@oss.sgi.com>; Tue, 07 Dec 2010 10:18:49 -0800 (PST)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 27A686C14E
	for <xfs@oss.sgi.com>; Tue,  7 Dec 2010 12:18:49 -0600 (CST)
Message-ID: <4CFE7A89.2010307@hardwarefreak.com>
Date: Tue, 07 Dec 2010 12:18:49 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: kernel panic-xfs errors
References: <30397503.post@talk.nabble.com>	<20101207165917.0c96dd95@harpe.intellique.com>	<30398448.post@talk.nabble.com>
	<20101207190038.61e9dbb7@harpe.intellique.com>
In-Reply-To: <20101207190038.61e9dbb7@harpe.intellique.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Emmanuel Florac put forth on 12/7/2010 12:00 PM:
> Le Tue, 7 Dec 2010 09:20:17 -0800 (PST)
> blacknred <leo1783@hotmail.co.uk> =E9crivait:
> =

>>  [<f894585c>] do_cciss_request+0x397/0x3a3 [cciss]
>> looks like the controller was wedged there?
>>
> =

> Yes, apparently your controller wrote garbage at the beginning of the
> filesystem... you have lots of trouble with these controllers, has
> anything special happened? that's weird.
> =

> You should try using a newer xfs_repair (> 3.x), for instance by booting
> from an Ubuntu 10.10 live CD, and see if it fares any better from there.

The answer for the one server is simple:  back out the firmware--flash
it with the previously installed version.

BTW, what need prompted the new flash in the first place?  I _never_
flash controller firmware unless absolutely necessary.  You've
demonstrated today why I practice that faith.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
