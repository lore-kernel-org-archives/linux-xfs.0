Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7DLKjDj052341 for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 16:20:45 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id VnBqLKNIHlIa7xWv
	for <xfs@oss.sgi.com>; Mon, 13 Aug 2012 14:20:44 -0700 (PDT)
Message-ID: <50296FAD.6070107@hardwarefreak.com>
Date: Mon, 13 Aug 2012 16:20:45 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: howto keep xfs directory searches fast for a long time
References: <6344220.LKveJofnHA@saturn> <5028057F.3090007@hardwarefreak.com>
	<2561870.uQFC4XLYQm@saturn>
In-Reply-To: <2561870.uQFC4XLYQm@saturn>
Reply-To: stan@hardwarefreak.com
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 8/13/2012 11:44 AM, Michael Monnerie wrote:

> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
> 
> CFQ seems bad, but there's no documented way out of that. I've edited 
> that, and added a short vm.vfs_cache_pressure description. Please 
> someone recheck.

The XFS FAQ isn't an appropriate place for that tuning suggestion,
because it doesn't tune XFS.  vm.vfs_cache_pressure tunes the page cache
and is file system agnostic.  Thus you should remove that entry from the
FAQ.  Perhaps a blog entry would be more appropriate, or a post to LKML,
so it gets archived.  However, this is likely already posted somewhere,
as you can't be the first to run into this issue.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
