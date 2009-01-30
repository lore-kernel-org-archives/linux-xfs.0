Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0U5XbmZ261050 for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 23:33:38 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5C4E188A26C
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2009 21:32:56 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id dtn4efPqJ4F2XaE7 for
	<xfs@oss.sgi.com>; Thu, 29 Jan 2009 21:32:56 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: xfs regression in linux_2.6.28,
	"XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c"
Date: Fri, 30 Jan 2009 02:18:51 +0100
References: <200901150402.39801.edvx1@systemanalysen.net>
	<200901161008.02387.edvx1@systemanalysen.net>
	<20090117072553.GJ8071@disturbed>
In-Reply-To: <20090117072553.GJ8071@disturbed>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901300218.51948.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

On Saturday Jan 17th 2009 at 08:25:53 Dave Chinner wrote:
> On Fri, Jan 16, 2009 at 10:08:01AM +0100, Roland Eggner wrote:
> > all 2.6.28 builds which I have tried so far are broken,
> > today tried linux_2.6.29-rc1 and got the same "XFS_WANT_CORRUPTED_GOTO .."
> > note:  SAME failure with
> > linux_2.6.28
> > linux_2.6.28-git7
> > linux_2.6.28-git9
> > linux_2.6.29-rc1
> 
> These would all appear to be 2.6.29 trees you are testing. I'm
> pretty certain of this because in the vanilla stable 2.6.28 tree
> fs/xfs/xfs_btree.c only has 914 lines in it and it has no
> WANT_CORRUPTED_GOTO() macros in it either. See here if you don't
> beleive me:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=fs/xfs/xfs_btree.c;h=cc593a84c34572211cc2ff44997457838bbe4f5d;hb=4a6908a3a050aacc9c3a2f36b276b46c0629ad91
> Linus pulled the XFS tree between -git1 and -git2, which is
> why the file now has ~3700 lines in it and the bug you are
> hitting....
Thanks for this helpful info, now with grep and wc I can check if it is a pre- or post-XFS-commit kernel:
$  wc -l fs/xfs/xfs_btree.c
914 fs/xfs/xfs_btree.c
$  grep WANT_CORRUPTED_GOTO fs/xfs/xfs_btree.c

Based on your info compiled linux_2.6.28.1 .. runs flawlessly for several days :-))
> ..
> Cheers,
> 
> Dave.

-- 
Roland Eggner

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
