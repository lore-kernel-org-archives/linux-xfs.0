Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 05:50:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5ACoMEF022342
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:50:23 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1BA0020C8CF
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:51:18 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id 2iWsyY3SnOafLbtb for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:51:18 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Tue, 10 Jun 2008 08:50:30 -0400
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D3FC9317@bcmail1.VIDMARK.LOCAL>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "'hch@infradead.org'" <hch@infradead.org>
Cc: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

Thanks!

Yes the log died and was zeroed already with xfs_repair already.

So I plan to put a 64bit head on the volumes and leave it that way.

I asuume I need to still keep it under 16 tb since the fs datastuctures are 32bit?

Thanks again for the help!!!

----- Original Message -----
From: Christoph Hellwig <hch@infradead.org>
To: Lance Reed
Cc: Tru Huynh <tru@pasteur.fr>; 'xfs@oss.sgi.com' <xfs@oss.sgi.com>
Sent: Tue Jun 10 08:28:11 2008
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.

On Tue, Jun 10, 2008 at 08:07:18AM -0400, Lance Reed wrote:
> SO, I take it from what you say that that I can running any newer version of xfs progs and a 64bit host (fiber attached, easy to do this), and run xfs_repair on the 32bit XFS volumes without fear of data corruption?
> Is this because XFS is not version specific, and xfs_repair will honor the 32bit file data structures?

Yes, this is fine.  All the actual filesystem structures are endian and
32/64bit clean.  The log needs to be in the same endianess and had 32bit
vs 64bit problems on x86 for a while, but it needs to be recovered
before you run xfs_repair anyway.
