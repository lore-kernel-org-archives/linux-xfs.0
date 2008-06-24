Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 07:24:24 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OEOJq3016400
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 07:24:20 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 02CA1181153C
	for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 07:25:19 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id nDAP7uDmrNyhJlcM for <linux-xfs@oss.sgi.com>; Tue, 24 Jun 2008 07:25:19 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: md raid1 passes barriers, but xfs doesn't use them?
Date: Tue, 24 Jun 2008 16:25:17 +0200
References: <48605A8E.9070903@sandeen.net> <200806241131.12112.Martin@lichtvoll.de> <4860F7E4.2080106@sandeen.net> (sfid-20080624_161808_555876_E63DCB9F)
In-Reply-To: <4860F7E4.2080106@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241625.17511.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

Am Dienstag 24 Juni 2008 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > Hi Eric!

[...]

> > Did you test with ext3 too?
>
> This is xfs-specific; ext3 does not look for the queue ordered flag so
> won't have this problem on md raid1.
>
> > [1] http://bugzilla.kernel.org/show_bug.cgi?id=9554
>
> but that's for device-mapper, which has never supported barriers ....
> I'm talking about md raid1 here (not dm).

Thanks for the info. My misunderstanding - I always thought and I thought 
I even read it somewhere - that md was  a device mapper application.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
