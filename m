Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8B8MwgP192670 for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 03:22:59 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B5AADDBB7CE
	for <xfs@oss.sgi.com>; Sat, 11 Sep 2010 01:35:11 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	A1Yp7lCId0WRdEql for <xfs@oss.sgi.com>;
	Sat, 11 Sep 2010 01:35:11 -0700 (PDT)
Date: Sat, 11 Sep 2010 18:23:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS defragmentation issue
Message-ID: <20100911082330.GG705@dastard>
References: <4C8A4395.5070702@kickstone.com> <4C8B27E4.2050102@kickstone.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4C8B27E4.2050102@kickstone.com>
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
To: John Lister <john.lister@kickstone.com>
Cc: xfs@oss.sgi.com

On Sat, Sep 11, 2010 at 07:55:32AM +0100, John Lister wrote:
>  Stan Hoeppner wrote on 9/10/2010 14:00
> >>On 10/09/2010 15:41, John Lister wrote:
> >Try unmounting and remounting the filesystem, and see if the various
> >tools all report the same thing afterwards. This solved the exact same
> >problem for me very recently, though I'm on kernel 2.6.34.1 and xfsprogs
> >2.9.8.
> 
> Cheers, that got rid of most of it, there is still a slight
> discrepency  (50 extra fragments) which I can live with.

xfs_db used buffered IO on the block device, which is not coherent
with the filesystem. If you are using it on an active filesystem,
then running "echo 1 > /proc/sys/vm/drop_caches" before you run
xfs_db should make it read from disk at least once....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
