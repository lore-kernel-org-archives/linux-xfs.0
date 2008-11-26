Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mAQCV2Kp013388 for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 06:31:02 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3E5B1BE296A
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 04:31:01 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id gCcHCtfVM6O94AGo for
	<xfs@oss.sgi.com>; Wed, 26 Nov 2008 04:31:01 -0800 (PST)
Received: from shambala.of.teamix.net (blackhole.teamix.net [194.150.191.251])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 1C0475ADF2
	for <xfs@oss.sgi.com>; Wed, 26 Nov 2008 13:30:28 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
Date: Wed, 26 Nov 2008 13:30:26 +0100
References: <1226760254.5089.11.camel@chevrolet> <492B5684.2080107@sandeen.net>
	<1227647010.7992.34.camel@chevrolet>
	(sfid-20081125_220944_366364_C8DFDCD4)
In-Reply-To: <1227647010.7992.34.camel@chevrolet>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811261330.27328.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Am Dienstag 25 November 2008 schrieb Stian Jordet:
> ma., 24.11.2008 kl. 19.36 -0600, skrev Eric Sandeen:
> > I don't know if the storage you're on passes barriers or not, but xfs
> > has barriers on by default, while ext3 does not.  ext3 will still
> > likely
> > win the "untar a kernel" race, but for a fairer test, make the
> > barrier settings consistent between the two.
>
> As I wrote earlier, the point wasn't to find the fastest fs. That's not
> what I'm looking for. I just want xfs to perform at least as good on my
> new workstation as it did on my six years old other workstation.
>
> Which disabling barriers helped (notice the rm -rf with barriers...
> nobarrier is almost 200 times faster, 10 times faster on the
> unpacking):

[...]

> ### Ext3
>
> time bash -c 'tar xjf linux-2.6.27.7.tar.bz2 ; sync'
>
> real 0m18.663s
> user 0m14.693s
> sys 0m2.828s
>
>
> time bash -c 'rm -r linux-2.6.27.7 ; sync'
> real 0m0.635s
> user 0m0.028s
> sys 0m0.564s

It would be interesting to know the value on Ext3 with barriers.

I wonder whether XFS performance with barriers enabled can be improved? 
And whether XFS with disabled write cache (via hdparm) but without 
barriers might even be *faster* than XFS with barriers... One thing to 
test eventually.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
