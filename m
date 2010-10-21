Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L4i9EB182716 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 23:44:09 -0500
Received: from mail1.noloco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 776E41959FDD
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 21:45:22 -0700 (PDT)
Received: from mail1.noloco.com (mail.skunberg.com [38.119.107.104]) by
	cuda.sgi.com with ESMTP id d39HVK2ayCYVpiJf for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 21:45:22 -0700 (PDT)
Received: from ASSP.nospam (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id 4B290268001
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 23:45:24 -0500 (CDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail1.noloco.com (Postfix) with ESMTP id A0A1BE11C5
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 23:45:23 -0500 (CDT)
Received: from mail1.noloco.com ([127.0.0.1])
	by localhost (mail1.noloco.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CDLgBzvlSJXP for <xfs@oss.sgi.com>;
	Wed, 20 Oct 2010 23:45:18 -0500 (CDT)
Received: from [127.0.0.1] (173-165-241-186-minnesota.hfc.comcastbusiness.net
	[173.165.241.186])
	by mail1.noloco.com (Postfix) with ESMTPSA id 3E8B7E118F
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 23:45:18 -0500 (CDT)
Message-ID: <4CBFC54F.8030403@dolphinlogic.com>
Date: Wed, 20 Oct 2010 23:45:03 -0500
From: Shawn Usry <shawn@dolphinlogic.com>
MIME-Version: 1.0
Subject: Re: Interesting possible XFS crash condition
References: <4CBE887F.6020506@dolphinlogic.com>	<201010201012.39778@zmi.at>	<4CBF3C6C.2020803@dolphinlogic.com>
	<20101020232758.51ac507a@galadriel.home>
In-Reply-To: <20101020232758.51ac507a@galadriel.home>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


On 10/20/2010 4:27 PM, Emmanuel Florac wrote:
> Le Wed, 20 Oct 2010 14:01:00 -0500 vous =E9criviez:
>
>> 2.  I did upgrade the firmware on the controller to a newer version
>> AFTER the issue appeared, hoping this would resolve it.  Same results.
>>
>> At this point I'm leaning toward faulty hardware somewhere.
> Another possibility is a memory problem, possibly making the machine
> crash under heavy load; if most RAM is used as filesystem caching, this
> maybe may lead to apparently xfs related errors. You could try running
> memtest86+ on the system for a couple of hours.
>
Great minds think alike :)  Actually I have indeed already run a =

memtest86+ on the system which completed without a problem.   Loading up =

read/writes on other single disks on the system also doesn't produce a =

problem.  Just this one filesystem ;)     It's a stumper!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
