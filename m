Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2CGwhJa089764 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 11:59:03 -0500
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 504DBAC015
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 09:58:20 -0700 (PDT)
Message-ID: <49B9396D.7060809@sgi.com>
Date: Fri, 13 Mar 2009 03:33:49 +1100
From: Greg Banks <gnb@sgi.com>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>	<49B9097C.1070003@sandeen.net>	(sfid-20090312_151043_496061_D19DDB11)	<200903121514.12732.Martin@lichtvoll.de>
	<49B92423.4020708@sandeen.net>
In-Reply-To: <49B92423.4020708@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
>
> It's simple.  Want your data safe on disk?  fsync.  There's not a lot
> more to it than that.  (and if fsync hurts perf too much, re-think how
> you are storing your data)
>
> Filesystems can hack around some heuristics to try to make unsafe apps
> safer, but in the end, it's the app's job to make sure a buffered write
> hits permanent storage when it matters.
>   

Stewart Smith has a highly entertaining presentation on this very topic.

http://www.linux.org.au/conf/2007/talk/278.html

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
