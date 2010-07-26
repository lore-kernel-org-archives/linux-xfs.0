Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QIUFrW135834 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 13:30:15 -0500
Received: from knox.decisionsoft.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 632284731AB
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 11:33:18 -0700 (PDT)
Received: from knox.decisionsoft.com (knox-be.decisionsoft.com
	[87.194.172.100]) by cuda.sgi.com with ESMTP id
	6d1YchLByjc1ZPvZ for <xfs@oss.sgi.com>;
	Mon, 26 Jul 2010 11:33:18 -0700 (PDT)
Received: from [82.152.70.89] (port=54064 helo=[192.168.1.64])
	by knox.decisionsoft.com ([10.0.0.120]:587)
	with esmtpsa (ldap_plain:strr) (TLSv1:AES256-SHA:256)
	id 1OdSUH-0002Pn-QH (Exim 4.69) for xfs@oss.sgi.com
	(return-path <strr-debian@decisionsoft.co.uk>);
	Mon, 26 Jul 2010 19:33:17 +0100
Message-ID: <4C4DD4E7.5070602@decisionsoft.co.uk>
Date: Mon, 26 Jul 2010 19:33:11 +0100
From: Stuart Rowan <strr-debian@decisionsoft.co.uk>
MIME-Version: 1.0
Subject: Re: filesystem shrinks after using xfs_repair
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>	<20100712134743.624249b2@harpe.intellique.com>	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>	<20100724005426.GN32635@dastard>	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>	<20100724023922.GP32635@dastard>	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>	<20100726034545.GE655@dastard>	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>	<20100726060604.GF7362@dastard>	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>	<20100726114940.7a97f29e@harpe.intellique.com>
	<AE59CF1C-6E28-4468-892A-394AE324EEF0@ucsc.edu>
In-Reply-To: <AE59CF1C-6E28-4468-892A-394AE324EEF0@ucsc.edu>
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

How about:
http://www.sysresccd.org/

This has xfsprogs 3.1.2 and kernels 2.6.32.16 and 2.6.34.1 in version =

1.5.8 of the CD according to the changelog.

Cheers,
Stu.

On 26/07/2010 18:22, Eli Morris wrote:
>
> On Jul 26, 2010, at 2:49 AM, Emmanuel Florac wrote:
>
>> Le Sun, 25 Jul 2010 23:46:29 -0700
>> Eli Morris<ermorris@ucsc.edu>  =E9crivait:
>>
>>> Updating the OS takes me a day or two for the whole cluster and all
>>> the user programs. If you're pretty sure that will fix the problem,
>>> I'll go for it tomorrow. I'd appreciate it very much if you could let
>>> me know if Centos 5.4 is recent enough that it will fix the problem.
>>>
>>
>> Alternatively simply boot the system from a live CD with a recent
>> kernel to do the resize.
>>
>>> I will note that I've grown the filesystem several times, and while I
>>> recall having to unmount and remount the filesystem each time for it
>>> to report its new size [...]
>>
>> This definitely should not happen. After using xfs_growfs, the
>> filesystem appears immediately bigger.
>>
>> --
>> ------------------------------------------------------------------------
>> Emmanuel Florac     |   Direction technique
>>                     |   Intellique
>>                     |	<eflorac@intellique.com>
>>                     |   +33 1 78 94 84 02
>> ------------------------------------------------------------------------
>
> Hi Emmanuel,
>
> I think the Live CD is a great suggestion. I was just thinking though. do=
 you know of a Live CD that has XFS utilities on it? From what I've seen, I=
've had to install XFS utilities after installing the OS, which I don't thi=
nk one can do with a live CD. I can look, but if you know of one, that woul=
d probably save some digging.
>
> thanks,
>
> Eli
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
