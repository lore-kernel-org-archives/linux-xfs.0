Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q45NbrOt017863 for <xfs@oss.sgi.com>; Sat, 5 May 2012 18:37:53 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZDNggeAu7Ww7DzaQ for <xfs@oss.sgi.com>;
	Sat, 05 May 2012 16:37:51 -0700 (PDT)
Date: Sun, 6 May 2012 09:37:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: make 275 xfs specific.
Message-ID: <20120505233744.GE25351@dastard>
References: <1336230429-2939-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1336230429-2939-1-git-send-email-tm@tao.ma>
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
To: Tao Ma <tm@tao.ma>
Cc: xfs@oss.sgi.com

On Sat, May 05, 2012 at 11:07:09PM +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> In my test with ext4, 275 can't pass because ext4
> can create a 8k file in the end not like what xfs
> does. So make this test case xfs only for now.

It's not an XFS specific test - it's a test that is supposed to test
POSIX write behaviour. i.e. if the filesystem is full, and then you
free 4k of space, then an 8k write should only be able to write 4k,
yes?

So doesn't a failure on ext4 indicate that there's something wrong
with ext4 (either it's ENOSPC detection or the short write
handling), not the test?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
