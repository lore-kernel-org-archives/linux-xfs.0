Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AEE67F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 18:14:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B18B8F8037
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 16:14:30 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9nWcAHNbUivo8zEj for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 16:14:24 -0800 (PST)
Date: Fri, 5 Dec 2014 11:11:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix behaviour of XFS_IOC_FSSETXATTR on directories
Message-ID: <20141205001148.GS9561@dastard>
References: <20140829004607.GX20518@dastard>
	<1417666466-31820-1-git-send-email-iustin@k1024.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417666466-31820-1-git-send-email-iustin@k1024.org>
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
To: Iustin Pop <iustin@k1024.org>
Cc: xfs@oss.sgi.com

On Thu, Dec 04, 2014 at 05:14:26AM +0100, Iustin Pop wrote:
> Currently, the ioctl handling code for XFS_IOC_FSSETXATTR treats all
> targets as regular files: it refuses to change the extent size if
> extents are allocated. This is wrong for directories, as there the
> extent size is only used as a default for children.
> 
> The patch fixes this issue and improves validation of flag
> combinations:
> 
> - only disallow extent size changes after extents have been allocated
>   for regular files
> - only allow XFS_XFLAG_EXTSIZE for regular files
> - only allow XFS_XFLAG_EXTSZINHERIT for directories
> - automatically clear the flags if the extent size is zero
> 
> Thanks to Dave Chinner for guidance on the proper fix for this issue.

I'll have to remind myself of the context again - I think I have
some patches in my local queue that I never finished that kill a lot
of the mess around this code. I put that at the head of next week's
queue...

> Signed-off-by: Iustin Pop <iustin@k1024.org>
> ---
>  Trying to revive this fix. Note that this patch is on top of
>  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git master, which
>  seems to have no commits since Oct 26; let me know if I should rebase it on
>  top of something else.

That's the right tree+branch to base dev patches on. I'll commit it
to a topic branch based on linux-xfs/master unless it has
dependencies on patches in other topic branches. Mostly you do not
need to worry about that. If you want to see the latest development
snapshot, then use the for-next branch (note: for-next gets rebased
if necessary). I normally develop against linux-xfs/master, then
merge into linux-xfs/for-next for integration testing....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
