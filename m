Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 00:27:50 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBC8Qo8K010994
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 00:26:52 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F57AB3A547
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 00:26:57 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id Icn909HDWTib4r6v for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 00:26:57 -0800 (PST)
Received: from shambala.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTP id 501585ADDC
	for <linux-xfs@oss.sgi.com>; Wed, 12 Dec 2007 09:25:09 +0100 (CET)
From: Martin Steigerwald <Martin@Lichtvoll.de>
Subject: Re: write barrier over device mapper supported or not?
Date: Wed, 12 Dec 2007 09:26:52 +0100
References: <200712112342.24094.Martin@lichtvoll.de> <475F5746.8080405@sandeen.net> (sfid-20071212_092001_588630_42C71ACD)
In-Reply-To: <475F5746.8080405@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712120926.53348.Martin@lichtvoll.de>
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
>
> see dm_request():
>
>         /*
>          * There is no use in forwarding any barrier request since we
> can't * guarantee it is (or can be) handled by the targets correctly.
> */
>         if (unlikely(bio_barrier(bio))) {
>                 bio_endio(bio, -EOPNOTSUPP);
>                 return 0;
>         }

Thanks for your definitive answer.

What does that mean? What is the target in that case? If it is the libata 
PATA internal notebook drive it actually should support barriers and then 
I actually would like device mapper to support them too. Or is LVM2 the 
target and device mapper can't tell that LVM2 supports it?

I ask myself the question why write barrier if half the kernel does not 
handle it correctly and I am limited to plain partitions if I want to use 
it? Well I think I will just file a bug report at kernel.bugzilla.org 
about it.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
