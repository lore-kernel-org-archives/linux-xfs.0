Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8C9iiD6260070 for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 04:44:45 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4DD2569342
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 02:45:30 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id uZtIhavc3BcOjem7
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 02:45:30 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 96D3A6C097
	for <xfs@oss.sgi.com>; Sun, 12 Sep 2010 04:45:30 -0500 (CDT)
Message-ID: <4C8CA13A.6010103@hardwarefreak.com>
Date: Sun, 12 Sep 2010 04:45:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS defragmentation issue
References: <4C8A4395.5070702@kickstone.com>
	<4C8B27E4.2050102@kickstone.com>	<20100911082330.GG705@dastard>
	<4C8BDAC8.8010203@hardwarefreak.com>
	<20100912104321.5529f74c@galadriel.home>
In-Reply-To: <20100912104321.5529f74c@galadriel.home>
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

Emmanuel Florac put forth on 9/12/2010 3:43 AM:
> Le Sat, 11 Sep 2010 14:38:48 -0500 vous =E9criviez:
> =

>> That's good to know Dave.  Thanks.  I created a short-name script a
>> while back with "echo 3 > /proc/sys/vm/drop_caches" merely so I could
>> "clear the baffles" now and then. =

> =

> But isn't it somewhat risky? isn't there any risk of data loss by
> dropping cache at any moment?

From:  http://linux-mm.org/Drop_Caches

This is a non-destructive operation and will only free things that are
completely unused. Dirty objects will continue to be in use until
written out to disk and are not freeable. If you run "sync" first to
flush them out to disk, these drop operations will tend to free more
memory.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
