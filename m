Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 20A6B7CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 15:44:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E684A304048
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 13:44:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	EAbuscIvHvkOaCZx for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2016 13:44:32 -0700 (PDT)
Date: Wed, 6 Apr 2016 06:44:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs: return EPERM on immutable inode
Message-ID: <20160405204430.GG11238@dastard>
References: <1459862890-22957-1-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459862890-22957-1-git-send-email-guaneryu@gmail.com>
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
To: Eryu Guan <guaneryu@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, "open list:GFS2 FILE SYSTEM" <cluster-devel@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>

On Tue, Apr 05, 2016 at 09:28:10PM +0800, Eryu Guan wrote:
> In most cases, EPERM is returned on immutable inode, and there're only
> a few places returning EACCES. And EPERM looks more reasonable to me.
> 
> So converting all EACCES to EPERM on immutable inode.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>
> ---
> 
> I noticed this when running LTP on overlayfs, setxattr03 failed due to
> unexpected EACCES on immutable inode.

This should be in the commit message itself, rather than "EPERM
looks more reasonable".

Other than that, change seems fine to me.

Acked-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
