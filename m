Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBRLtOYq208476 for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 15:55:24 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2413D1C1C2FE
	for <xfs@oss.sgi.com>; Sun, 27 Dec 2009 13:56:08 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.171]) by cuda.sgi.com with ESMTP id
	xRvcWfjKBdjvDrqm for <xfs@oss.sgi.com>;
	Sun, 27 Dec 2009 13:56:08 -0800 (PST)
Date: Sun, 27 Dec 2009 13:55:26 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <4B37BA76.7050403@hp.com>
Message-ID: <alpine.DEB.2.01.0912271346240.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
	<4B36333B.3030600@hp.com> <4B365EBE.5050804@nerdbynature.de>
	<4B37BA76.7050403@hp.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: jim owens <jowens@hp.com>
Cc: Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Larry McVoy <lm@bitmover.com>, reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Sun, 27 Dec 2009 at 14:50, jim owens wrote:
> And I don't even care about comparing 2 filesystems, I only care about
> timing 2 versions of code in the single filesystem I am working on,
> and forgetting about hardware cache effects has screwed me there.  

Not me, I'm comparing filesystems - and when the HBA or whatever plays 
tricks and "sync" doesn't flush all the data, it'll do so for every tested 
filesystem. Of course, filesystem could handle "sync" differently, and 
they probably do, hence the different times they take to complete. That's 
what my tests are about: timing comparision (does that still fall under 
the "benchmark" category?), not functional comparision. That's left as a 
task for the reader of these results: "hm, filesystem xy is so much faster 
when doing foo, why is that? And am I willing to sacrifice e.g. proper 
syncs to gain more speed?"

> So unless you are sure you have no hardware cache effects...
> "the comparison still stands" is *false*.

Again, I don't argue with "hardware caches will have effects", but that's 
not the point of these tests. Of course hardware is different, but 
filesystems are too and I'm testing filesystems (on the same hardware).

Christian.
-- 
BOFH excuse #278:

The Dilithium Crystals need to be rotated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
