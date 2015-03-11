Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DB8F7F47
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 08:25:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EE3D2AC003
	for <xfs@oss.sgi.com>; Wed, 11 Mar 2015 06:25:36 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	E4HWHFiYQzAAJCat for <xfs@oss.sgi.com>;
	Wed, 11 Mar 2015 06:25:31 -0700 (PDT)
Received: from dave by destitution with local (Exim 4.84)
	(envelope-from <david@fromorbit.com>) id 1YVgdY-0004Bu-OT
	for xfs@oss.sgi.com; Wed, 11 Mar 2015 09:25:24 -0400
Date: Wed, 11 Mar 2015 09:25:24 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] xfs: add RENAME_WHITEOUT support
Message-ID: <20150311132524.GH26657@destitution>
References: <1423653330-25297-1-git-send-email-david@fromorbit.com>
	<20150309181309.GA18016@hades.maiolino.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150309181309.GA18016@hades.maiolino.org>
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
To: xfs@oss.sgi.com

On Mon, Mar 09, 2015 at 03:13:09PM -0300, Carlos Maiolino wrote:
> Hi Dave,
> 
> sorry my delay in take a look into it.
> 
> The code doesn't build, due the missing declaration of function
> xfs_finish_inode_setup() inside xfs_rename_get_wino().
> 
> I couldn't find any reference to this function either. Is there something I'm
> missing here?

IIRC, the patch is against the for-next branch, not the master
branch (i.e. dependent on commit 58c90473 ("xfs: inodes are new
until the dentry cache is set up").

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
