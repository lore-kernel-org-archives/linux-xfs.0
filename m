Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p76ECilu168082 for <xfs@oss.sgi.com>; Sat, 6 Aug 2011 09:12:45 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A00A1EF75A6
	for <xfs@oss.sgi.com>; Sat,  6 Aug 2011 07:12:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	8GOEVr0S7Fhn3pK7 for <xfs@oss.sgi.com>;
	Sat, 06 Aug 2011 07:12:43 -0700 (PDT)
Date: Sun, 7 Aug 2011 00:12:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_repair 3.1.4/3.1.5: fatal error -- couldn't malloc dir2
	buffer data
Message-ID: <20110806141241.GF3162@dastard>
References: <20110806121728.GA20341@schmorp.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110806121728.GA20341@schmorp.de>
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
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

On Sat, Aug 06, 2011 at 02:17:28PM +0200, Marc Lehmann wrote:
> When trying to xfs_repair a 15GB image file, I get this:
> 
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
> 
> fatal error -- couldn't malloc dir2 buffer data
> 
> this is 3.1.5 - 3.1.4 simply segfaults. using ltrace shows this as
> last call to malloc:
> 
>    malloc(18446744073708732928)                                  = NULL
> 
> I think thats a bit unreasonable of xfs_repair :)

Can you share a metadump of the image in question?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
