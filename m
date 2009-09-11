Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8BFoJ0x034474 for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 10:50:19 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B35D21218C1F
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2009 08:51:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id LaljVswDzjOWKvhV for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2009 08:51:29 -0700 (PDT)
Message-ID: <4AAA71FF.3060706@sandeen.net>
Date: Fri, 11 Sep 2009 10:51:27 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair hangs at Phase 6
References: <4AAA15A6.8070700@helsinki.fi>
In-Reply-To: <4AAA15A6.8070700@helsinki.fi>
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
To: Riku Paananen <riku.paananen@helsinki.fi>
Cc: xfs@oss.sgi.com

Riku Paananen wrote:
> Hello.
> 
> I have a 39TB xfs filesystem in a SAN that got corrupted. The reasons 
> for the corruption are unclear. I've been trying to fix it using 
> xfs_repair but the repair operation always hangs at Phase 6 "traversing 
> filesystem ...".

Ok, so strace was stuck?

Can you try again with -P?

If that fails can you try again with -P -o bhashsize=1024 ?

(or so; 1024 is the default, you could double it again if it still hangs)

You might also attach gdb and see where it is.

If increasing the bhashsize fixes it then I probably know what the bug 
is (though not yet the solution...)

If you want to provide an xfs_metadump image of it from before you 
repair it, I could test any eventual fix against that.

thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
