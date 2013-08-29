Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 214B77F37
	for <linux-xfs@oss.sgi.com>; Thu, 29 Aug 2013 03:30:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 080B18F8033
	for <linux-xfs@oss.sgi.com>; Thu, 29 Aug 2013 01:30:06 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 9iC5apniYJ4fz9D7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 01:30:05 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1VExcB-0006nL-OF
	for linux-xfs@oss.sgi.com; Thu, 29 Aug 2013 10:30:03 +0200
Received: from 124-254-118-11-static.bb.ispone.net.au ([124.254.118.11])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 29 Aug 2013 10:30:03 +0200
Received: from chris by 124-254-118-11-static.bb.ispone.net.au with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 29 Aug 2013 10:30:03 +0200
From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: [PATCH] xfs: inode log reservations are too small
Date: Thu, 29 Aug 2013 08:20:29 +0000 (UTC)
Message-ID: <slrnl1u12l.seg.chris@chris.onthe.net.au>
References: <1377670235-4168-1-git-send-email-david@fromorbit.com>
Reply-To: chris@onthe.net.au
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

On 2013-08-28, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> We've been seeing occasional problems with log space leaks and
> transaction underruns such as this for some time:

[ snip]

> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
> index 24110f3..69bcba2 100644
> --- a/fs/xfs/xfs_trans_resv.c
> +++ b/fs/xfs/xfs_trans_resv.c
> @@ -73,6 +73,39 @@ xfs_calc_buf_res(
>  }
>  
>  /*
> + * Logging inodes is really tricksy. They are logged in memory format,
> + * which means that what we write into the log doesn't directory translate into

directory => directly

Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
