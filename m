Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8ELVmeK149060 for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 16:31:48 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2432617E34A0
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 14:32:36 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id e3Yu7XyYXQODHSsL
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 14:32:36 -0700 (PDT)
Received: by wwb22 with SMTP id 22so7982126wwb.32
	for <xfs@oss.sgi.com>; Tue, 14 Sep 2010 14:32:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C8FD50C.1030905@hardwarefreak.com>
References: <AANLkTin6FSBK3tMXhSxDuLdjyb+R0LhNnaa2CKt37FcV@mail.gmail.com>
	<201009142106.24448.arekm@maven.pl>
	<4C8FD50C.1030905@hardwarefreak.com>
Date: Tue, 14 Sep 2010 18:32:35 -0300
Message-ID: <AANLkTi=E57uuaicbqQBOQ6+H1ySN+TGX9dynpQYLnGMx@mail.gmail.com>
Subject: Re: Delaylog
From: Fabricio Archanjo <farchanjo@gmail.com>
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

When i changed to delaylog option my database performance increased,
so how i have 2 databases one master another slave, i can keep it. If
i have problem on my filesystem, i'll need to changed the slave to
master and recover my master.


Thanks all.

On Tue, Sep 14, 2010 at 5:03 PM, Stan Hoeppner <stan@hardwarefreak.com> wro=
te:
> Arkadiusz Miskiewicz put forth on 9/14/2010 2:06 PM:
>> On Tuesday 14 of September 2010, Fabricio Archanjo wrote:
>>> Hey all,
>>>
>>> =A0 =A0I just trying delaylog in my server that has a mysql database. W=
hen
>>> i monted my /var/lib/mysql with delaylog option, it showed me:
>>> "Enabling EXPERIMENTAL delayed logging feature - use at your own
>>> risk". Ok, i know it's experimental, but what kind of problem could i
>>> have using delaylog?
>>
>> ... and what problems in case of system hang or power loss when compared=
 to
>> nodelaylog mode?
>
> This was covered in prior posts IIRC. =A0Delaylog holds more write
> transactions in memory in an effort to decrease the amount of disk I/O
> and optimize write patterns. =A0The more blocks waiting in the in memory
> log, the more data will be lost due to power outage, controller/disk
> failure, storage HBA/network failure (iSCSI/FC), kernel panics, etc.
>
> Same failure modes as before, but with potentially greater loss of
> data--unless there is an undiscovered bug that can wreck the entire
> filesystem. =A0;) =A0Which I believe is the reason for the "experimental"
> boilerplate.
>
> --
> Stan
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
