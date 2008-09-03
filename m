Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 16:11:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83NBBF0014421
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 16:11:13 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D900125FE14
	for <xfs@oss.sgi.com>; Wed,  3 Sep 2008 16:12:36 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id PUSqMQRJwz5iwUFI for <xfs@oss.sgi.com>; Wed, 03 Sep 2008 16:12:36 -0700 (PDT)
Date: Thu, 4 Sep 2008 09:12:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: REVIEW: Zero rest of superblock sector always
Message-ID: <20080903231220.GB15950@disturbed>
References: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugv7zt013jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 03, 2008 at 04:51:19PM +1000, Barry Naujok wrote:
> I found that zeroing the "garbage" beyond the end of the superblock in
> the first sector of each AG rather inconsistant. It depended on some
> obscure combination of version bits to be set.

Just for filling out hte history, that isfixing a bug in an old, old
mkfs.xfs on Irix where a certain version failed to zero the
superblock(s) before initialising them. Every XFS filesystem made in
the last 10 years should have properly initialised superblocks.

But still, doing it unconditionally is fine as it will fix stuff
like fsfuzzer damage....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
