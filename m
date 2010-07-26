Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6QHJMNr132251 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 12:19:22 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F95F11A141A
	for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 10:29:41 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id DTS4XPCfeBYL1nC5 for
	<xfs@oss.sgi.com>; Mon, 26 Jul 2010 10:29:41 -0700 (PDT)
Subject: Re: filesystem shrinks after using xfs_repair
Mime-Version: 1.0 (Apple Message framework v1081)
From: Eli Morris <ermorris@ucsc.edu>
In-Reply-To: <20100726114940.7a97f29e@harpe.intellique.com>
Date: Mon, 26 Jul 2010 10:22:11 -0700
Message-Id: <AE59CF1C-6E28-4468-892A-394AE324EEF0@ucsc.edu>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
	<20100726034545.GE655@dastard>
	<10B6F36F-BE01-4BF7-9815-2E8F6BF71B41@ucsc.edu>
	<20100726060604.GF7362@dastard>
	<F91DF703-4BFF-415B-91B6-87A88F096C91@ucsc.edu>
	<20100726114940.7a97f29e@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com


On Jul 26, 2010, at 2:49 AM, Emmanuel Florac wrote:

> Le Sun, 25 Jul 2010 23:46:29 -0700
> Eli Morris <ermorris@ucsc.edu> =E9crivait:
> =

>> Updating the OS takes me a day or two for the whole cluster and all
>> the user programs. If you're pretty sure that will fix the problem,
>> I'll go for it tomorrow. I'd appreciate it very much if you could let
>> me know if Centos 5.4 is recent enough that it will fix the problem.
>> =

> =

> Alternatively simply boot the system from a live CD with a recent
> kernel to do the resize.
> =

>> I will note that I've grown the filesystem several times, and while I
>> recall having to unmount and remount the filesystem each time for it
>> to report its new size [...]
> =

> This definitely should not happen. After using xfs_growfs, the
> filesystem appears immediately bigger.
> =

> -- =

> ------------------------------------------------------------------------
> Emmanuel Florac     |   Direction technique
>                    |   Intellique
>                    |	<eflorac@intellique.com>
>                    |   +33 1 78 94 84 02
> ------------------------------------------------------------------------

Hi Emmanuel,

I think the Live CD is a great suggestion. I was just thinking though. do y=
ou know of a Live CD that has XFS utilities on it? From what I've seen, I'v=
e had to install XFS utilities after installing the OS, which I don't think=
 one can do with a live CD. I can look, but if you know of one, that would =
probably save some digging.

thanks,

Eli

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
