Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E95E57F37
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 13:35:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 76FACAC001
	for <xfs@oss.sgi.com>; Sun, 17 Nov 2013 11:35:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	la5qGtr9JY2rlZ8H for <xfs@oss.sgi.com>;
	Sun, 17 Nov 2013 11:35:22 -0800 (PST)
Date: Mon, 18 Nov 2013 06:35:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsprogs: properly check size arguments for growfs
Message-ID: <20131117193518.GS6188@dastard>
References: <1384459290-16291-1-git-send-email-guangyu.sun@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1384459290-16291-1-git-send-email-guangyu.sun@oracle.com>
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
To: Guangyu Sun <guangyu.sun@oracle.com>
Cc: Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com

On Thu, Nov 14, 2013 at 12:01:30PM -0800, Guangyu Sun wrote:
> xfs_growfs has lowercase options to grow a filesystem as big as possible
> (e.g. the -d option) and uppercase options to grow a filesystem to a
> specified size, expressed in blocks. (e.g. the "-D size" option)
> 
> If the size parameter is not numerical, the parameter is either trimmed or
> ignored. In the latter case, the filesystem is grown as big as possible. This
> may happen when users accidentally specify the size in a format similar to
> mkfs.xfs (e.g. "-D 100m" or "-D size=16384")
> 
> In both cases, xfs_growfs should return an error instead of resizing the
> filesystem.
> 
> To reproduce:
>   # mkfs.xfs -f -d size=20m -L koenfs /dev/dm-3
>   # mount /dev/dm-3 //mnt
>   # xfs_growfs -D 10000andmorethan10invalidcharacters /mnt
>   (...)
>   data blocks changed from 5120 to 10000
>   # xfs_growfs -D invalidargument20000containingnumbers /mnt
>   (...)
>   data blocks changed from 10000 to 19659543
> 
> Reported-by: Koen De Wit <koen.de.wit@oracle.com>
> Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>

Perhaps this should be changed to use cvtnum() from libxcmd? That
will fix the input validation problem, and also allow xfs_growfs to
all the different methods of specifying size that we use elsewhere
in xfsprogs...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
