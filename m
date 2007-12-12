Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 14:06:56 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBCM5nqr031042
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 14:05:55 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26771476135
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 14:05:59 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id rKNSnahzUrmEgjQX for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 14:05:59 -0800 (PST)
Received: from [192.168.1.21] (dslb-084-056-067-095.pools.arcor-ip.net [84.56.67.95])
	by mail.lichtvoll.de (Postfix) with ESMTP id 286705ADDC
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 23:06:18 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: write barrier over device mapper supported or not?
Date: Wed, 12 Dec 2007 23:05:51 +0100
References: <200712112342.24094.Martin@lichtvoll.de> <475F5746.8080405@sandeen.net> (sfid-20071212_092001_588630_42C71ACD)
In-Reply-To: <475F5746.8080405@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712122305.52726.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Mittwoch 12 Dezember 2007 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Hello!
> >
> > Are write barriers over device mapper supported or not?
>
> Nope.

[...]

> > But back then I also looked at the ext3 / jbd sources and found that
> > jbd issues a warning when barrier support is not available. However I
> > do not find that one either.
>
> in journal_write_commit_record() there is such a warning, but not in
> the mount path:
>
>                 printk(KERN_WARNING
>                         "JBD: barrier-based sync failed on %s - "
>                         "disabling barriers\n",
>                         bdevname(journal->j_dev, b));
>
> and if I set barrier=1 on an lvm-root test box, I do get:
>
> JBD: barrier-based sync failed on dm-0 - disabling barriers

Yes, I get it after actually touching a file and waiting for the kjournald 
commit interval of 5 seconds to occur.

Well I reported a bug about it, lets see what happens:

http://bugzilla.kernel.org/show_bug.cgi?id=9554

One might consider it being a feature wish of course.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
