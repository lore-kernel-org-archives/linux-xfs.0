Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 02:54:14 -0700 (PDT)
Received: from mondschein.lichtvoll.de (ms2.lichtvoll.de [194.150.191.235] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6G9s4DW005598
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 02:54:04 -0700
Received: from localhost (dslb-084-056-110-224.pools.arcor-ip.net [84.56.110.224])
	by mondschein.lichtvoll.de (Postfix) with ESMTP id 6AABFFA4F3
	for <linux-xfs@oss.sgi.com>; Sun, 16 Jul 2006 11:51:41 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS and write barrier
Date: Sun, 16 Jul 2006 11:53:39 +0200
References: <200607151248.56603.Martin@lichtvoll.de> <20060715192857.GA11034@tuatara.stupidest.org>
In-Reply-To: <20060715192857.GA11034@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607161153.40130.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Am Samstag 15 Juli 2006 21:28 schrieb Chris Wedgwood:
> On Sat, Jul 15, 2006 at 12:48:56PM +0200, Martin Steigerwald wrote:
> > What are those intermittent IO errors? I googled but did not find a
> > discussion of this change.
>
> write barriers are enabled by default now, they have been for some
> months (since the end of March)

Hallo Chris,

yes, but for 2.6.17 which was still in development. The stable release of 
it appeared kernel.org on 18-Jun-2006 02:10 according to the date in the 
file listing there!

commit 3bbcc8e3976f8bba2fd607c8850d7dfe7e332fda
Author: Nathan Scott <nathans@sgi.com>
Date:   Fri Mar 31 13:04:56 2006 +1000

    [XFS] Reenable write barriers by default.
[...]


They have been in enabled but then disabled again 5 minutes later for 
2.6.16 which should still be widely in use:

commit 4ef19dddbaf2f24e492c18112fd8a04ce116daca
Author: Christoph Hellwig <hch@sgi.com>
Date:   Wed Jan 11 15:27:18 2006 +1100

    [XFS] enable write barriers by default
[...]

commit b04ed21a1fdbfe48ee0738519a4d1af09589dfea
Author: Nathan Scott <nathans@sgi.com>
Date:   Wed Jan 11 15:32:17 2006 +1100

    [XFS] Disable write barriers for now till intermittent IO errors are
    understood.
[...]


Thus for end users this write barrier support by default in XFS is rather 
new!

What I would like to know whether its safe to use write barriers with 
2.6.16 or even 2.6.15 (if it is possible at all) as well (I guess there 
are not many distributions that shipd with 2.6.17 already) or whether one 
might face those "intermittent IO errors" - whatever they are - when 
using them.

If I do not find anything more on this I will recommend 2.6.17 for XFS 
with write barrier usages as I am pretty much convinced that it works 
stable from my own experience. (See my other post.)

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
