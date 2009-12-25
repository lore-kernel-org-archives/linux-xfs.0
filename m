Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBPIoVll206710 for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 12:50:31 -0600
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4F36B127A44
	for <xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:51:15 -0800 (PST)
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.10])
	by cuda.sgi.com with ESMTP id qilRCG28xB2oBinB for
	<xfs@oss.sgi.com>; Fri, 25 Dec 2009 10:51:15 -0800 (PST)
Date: Fri, 25 Dec 2009 10:51:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: [Jfs-discussion] benchmark results
In-Reply-To: <20091225162238.GB19303@bitmover.com>
Message-ID: <alpine.DEB.2.01.0912251042540.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912240205510.3483@bogon.housecafe.de>
	<19251.26403.762180.228181@tree.ty.sabi.co.uk>
	<20091224212756.GM21594@thunk.org>
	<alpine.DEB.2.01.0912241739160.3483@bogon.housecafe.de>
	<20091225161453.GD32757@thunk.org>
	<20091225162238.GB19303@bitmover.com>
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
To: Larry McVoy <lm@bitmover.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Peter Grandi <pg_jf2@jf2.for.sabi.co.UK>, reiserfs-devel@vger.kernel.org, ext-users <ext3-users@redhat.com>, xfs@oss.sgi.com, linux-btrfs@vger.kernel.org

On Fri, 25 Dec 2009 at 08:22, Larry McVoy wrote:
> Dudes, sync() doesn't flush the fs cache, you have to unmount for that.

Thanks Larry, that was exactly my point[0] too, I should add that to the 
results page to avoid further confusion or misassumptions:

   > Well, I do "sync" after each operation, so the data should be on
   > disk, but that doesn't mean it'll clear the filesystem buffers 
   > - but this doesn't happen that often in the real world too.

I realize however that on the same results page the bonnie++ tests were 
run with a filesize *specifically* set to not utilize the filesystem 
buffers any more but the measure *disk* performance while my "generic* 
tests do something else - and thus cannot be compared to the bonnie++ or 
hdparm results.

> No idea if that is still supported, but sync() is a joke for benchmarking.

I was using "sync" to make sure that the data "should" be on the disks 
now, I did not want to flush the filesystem buffers during the "generic" 
tests.

Thanks,
Christian.

[0] http://www.spinics.net/lists/linux-ext4/msg16878.html
-- 
BOFH excuse #210:

We didn't pay the Internet bill and it's been cut off.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
