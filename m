Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 May 2008 04:38:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4PBc2Rp015800
	for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 04:38:02 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 309B01226C60
	for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 04:38:52 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id SFaTBE2YmCnW0jaH for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 04:38:52 -0700 (PDT)
Received: from [10.0.0.21] (g228074001.adsl.alicedsl.de [92.228.74.1])
	by mail.lichtvoll.de (Postfix) with ESMTP id 8D94A5AE29
	for <linux-xfs@oss.sgi.com>; Sun, 25 May 2008 13:38:50 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS for lots of small files
Date: Sun, 25 May 2008 13:38:48 +0200
References: <4820832B.3070903@dubielvitrum.pl> <200805062055.36755.Martin@lichtvoll.de> <4838DC1A.5010206@sandeen.net> (sfid-20080525_131427_063047_18AAAB7D)
In-Reply-To: <4838DC1A.5010206@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251338.48910.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Sonntag 25 Mai 2008 schrieb Eric Sandeen:
> Martin Steigerwald wrote:
> > And there is quite some fragmentation on it:
> >
> > xfs_db> frag
> > actual 653519, ideal 587066, fragmentation factor 10.17%
>
> No, there's not.

OK, so there is or better was (see below) *some* fragmentation.

> You have 653519 extents out of an "ideal" 587066.
>
> That is 653519/587066 = 1.113 extents per file.
>
> It is not "quite some" fragmentation, it is near perfect (although this
> is subjective, and also depends on the size of your files... if they
> are all 8k then 1.113 extents per file might be a bit high; if they
> average 1G then 1.113 extents on average is pretty darned good.)

They vary a lot. From KMail ~/Mail directory with hundred of thousands of 
mails in maildir format to a picture and movie collection from various 
digicams with 150KB over 2-4 MB to 50-200 MB in size and a music 
collection and kernel sources and and and... would need to run a tool on 
them to gather some statistic.

Anyway, nothing that can't be optimized:

shambala> xfs_db -r /dev/sda5
xfs_db> frag
actual 683648, ideal 617593, fragmentation factor 9.66%
xfs_db> quit

shambala> xfs_fsr /dev/sda5
/home start inode=0

shambala> xfs_db -r /dev/sda5
xfs_db> frag
actual 620316, ideal 617584, fragmentation factor 0.44%
xfs_db> quit

xfs_fsr copied over several gigabytes and the free space of the partition 
temporarily more than once was 4 GB less than the 20 GB of free space it 
had before and after invoking xfs_fsr ;)

Not that I noticed a difference up to now however.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
