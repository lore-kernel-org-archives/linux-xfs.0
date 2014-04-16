Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 14C9E7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 19:32:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E597E304077
	for <xfs@oss.sgi.com>; Tue, 15 Apr 2014 17:31:59 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	q6fGACaODZA3LZN5 for <xfs@oss.sgi.com>;
	Tue, 15 Apr 2014 17:31:57 -0700 (PDT)
Date: Wed, 16 Apr 2014 10:31:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfstests PATCH] renameat2 syscall: turn EEXIST into ENOTEMPTY
Message-ID: <20140416003105.GX15995@dastard>
References: <20140414104953.GE10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140414104953.GE10187@tucsk.piliscsaba.szeredi.hu>
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
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: xfs@oss.sgi.com

On Mon, Apr 14, 2014 at 12:49:53PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> XFS is returning EEXIST rather than ENOTEMPTY for several of
> these rename tests. The rename man page says this about the errors:
> 
>        ENOTEMPTY or EEXIST
>               newpath is a nonempty directory, that is, contains
>               entries other than "." and "..".
> 
> Which implies that both errors are valid and so the test should pass
> in either case.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
