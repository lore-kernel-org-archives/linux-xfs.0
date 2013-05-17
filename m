Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 86EC37F3F
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 15:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 10327AC001
	for <xfs@oss.sgi.com>; Fri, 17 May 2013 13:09:42 -0700 (PDT)
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id 4BguFYEXyPEZLGLC for <xfs@oss.sgi.com>;
	Fri, 17 May 2013 13:09:41 -0700 (PDT)
Date: Fri, 17 May 2013 13:09:39 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: xattr performance
In-Reply-To: <20130517154436.GW29359@sgi.com>
Message-ID: <alpine.DEB.2.10.1305171300490.13746@trent.utfs.org>
References: <alpine.DEB.2.10.1305170444590.13746@trent.utfs.org>
	<20130517154436.GW29359@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, 17 May 2013 at 10:44, Ben Myers wrote:
> The short version:
> inode core (96 bytes) + literal area == inode size

Ah, yes indeed. I had another issue earlier on the same filesystem and 
Christoph told me[0] that I may have run out of inode attributes. 

xfs_info reports isize=256 for this filesystem and now that I'm using 
xattr even more (I'm storing sha256 checksum plus the filename in each 
file's xattr) this looks like it might exceed the literal area after all. 

> Anyway... If you're a heavy user of EAs you might benefit from using larger
> inodes.  Just something to consider.  Cool tests!  ;)

Yeah, next time I'll have to take this into consideration, but the fs was 
created long ago and I didn't plan to use xattr. Now I do but mkfs is not 
an option right now.

Thanks for the insight,
Christian.

[0] http://oss.sgi.com/archives/xfs/2012-07/msg00116.html
-- 
BOFH excuse #247:

Due to Federal Budget problems we have been forced to cut back on the number of users able to access the system at one time. (namely none allowed....)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
