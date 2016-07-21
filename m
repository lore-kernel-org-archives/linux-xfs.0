Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 20B1C7CA0
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 20:36:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1F7D8F804B
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 18:36:03 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	r2dT6wgcz4yySNl1 for <xfs@oss.sgi.com>;
	Wed, 20 Jul 2016 18:36:01 -0700 (PDT)
Date: Thu, 21 Jul 2016 11:35:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20160721013558.GO16044@dastard>
References: <20160721110756.7a905ee8@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160721110756.7a905ee8@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jann Horn <jann@thejh.net>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 11:07:56AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in:
> 
>   fs/xfs/xfs_ioctl.c
> 
> between commit:
> 
>   3e0a39654645 ("xfs: fix type confusion in xfs_ioc_swapext")
> 
> from Linus' tree and commit:
> 
>   7f1b62457b58 ("xfs: fix type confusion in xfs_ioc_swapext")
> 
> from the xfs tree.
> 
> These are not quite the same patch :-(

Yeah, I added comments to explain the code, because it's not obvious
why the check was added, and I couldn't find any other examples of
such checks in fs/. So, in five years time when I look at that code
again, the comment will remind me why it's a bad idea to remove what
appears to be an unnecesary check...

> I fixed it up (I used the version in the xfs tree) and can carry the
> fix as necessary. This is now fixed as far as linux-next is concerned,
> but any non trivial conflicts should be mentioned to your upstream
> maintainer when your tree is submitted for merging.

Yup, I planned to let Linus know. Patches in private emails that
aren't tagged [PATCH] in the subject line don't get the immediate
attention of my mail filters, so I didn't see it immediately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
