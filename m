Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBQJ6eed074357 for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 13:06:41 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23E5B12811A
	for <xfs@oss.sgi.com>; Sat, 26 Dec 2009 11:07:25 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id fsODNoA5hjx2jSdE for
	<xfs@oss.sgi.com>; Sat, 26 Dec 2009 11:07:25 -0800 (PST)
Message-ID: <4B365EBE.5050804@nerdbynature.de>
Date: Sat, 26 Dec 2009 11:06:38 -0800
From: Christian Kujau <lists@nerdbynature.de>
MIME-Version: 1.0
Subject: Re: [Jfs-discussion] benchmark results
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
	<alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
	<4B36333B.3030600@hp.com>
In-Reply-To: <4B36333B.3030600@hp.com>
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

On 26.12.09 08:00, jim owens wrote:
>> I was using "sync" to make sure that the data "should" be on the disks 
> 
> Good, but not good enough for many tests... info sync
[...]
>        On Linux, sync is only guaranteed to  schedule  the  dirty  blocks  for
>        writing;  it  can  actually take a short time before all the blocks are
>        finally written.

Noted, many times already. That's why I wrote "should be" - but in this
special scenario (filesystem speed tests) I don't care for file
integrity: if I pull the plug after "sync" and some data didn't make it
to the disks, I'll only look if the testscript got all the timestamps
and move on to the next test. I'm not testing for "filesystem integrity
after someone pulls the plug" here. And remember, I'm doing "sync" for
all the filesystems tested, so the comparison still stands.

Christian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
