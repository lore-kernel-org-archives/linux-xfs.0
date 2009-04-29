Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n3THTu6d171645 for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 12:29:57 -0500
Received: from millhouse.houseofnate.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8661324D59D
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2009 10:29:54 -0700 (PDT)
Received: from millhouse.houseofnate.net
	(dsl092-086-237.bos1.dsl.speakeasy.net [66.92.86.237]) by
	cuda.sgi.com with ESMTP id VYzmdlq6hnrmNpOJ for
	<xfs@oss.sgi.com>; Wed, 29 Apr 2009 10:29:54 -0700 (PDT)
Message-ID: <49F88E73.7060403@houseofnate.net>
Date: Wed, 29 Apr 2009 13:29:23 -0400
From: "Nathaniel W. Turner" <nate@houseofnate.net>
MIME-Version: 1.0
Subject: Re: crashes with xfs_fsr in 2.6.25-2-amd64 and 2.6.26-1-amd64 (debian)
	(f'up)
References: <20090428032406.GA14234@schmorp.de>
In-Reply-To: <20090428032406.GA14234@schmorp.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Marc Lehmann <schmorp@schmorp.de>
Cc: xfs@oss.sgi.com

Hi Marc,

Marc Lehmann wrote:
> It also happens to the same filesystem each time (maybe because
> it does the heavy I/O),a and it is also the same filesystem where
> xfs_repair hangs in an endless loop often (but not always). (see
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=525880)
>
> The filesystem was created a month or so ago using blocksize of 512 and
> lazy-count=1, but I have many of those xfs filesystems.
>
> Since this is a production system and I have no backup abilities, I have
> to no choice but to reformat the disk now.
>   
I'm not sure about the root cause of your crash, but I just wanted to 
mention that before you blow away this filesystem, you should probably 
try repairing it with a recent version of xfs_repair (like 3.0.0). 

ftp://oss.sgi.com/projects/xfs/cmd_tars/

Also, I have seen similar problems to those described in Debian bug 
525880 with xfs_repair not making progress (although I'm running 
32-bit), and adding "-P" to the xfs_repair invocation helped in many cases.

Cheers,
nate

-- 
Nathaniel W. Turner
http://houseofnate.net/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
