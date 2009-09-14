Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8E57cIk022188 for <xfs@oss.sgi.com>; Mon, 14 Sep 2009 00:07:39 -0500
Received: from smtp-rs1.it.helsinki.fi (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90AF7131A122
	for <xfs@oss.sgi.com>; Sun, 13 Sep 2009 22:08:49 -0700 (PDT)
Received: from smtp-rs1.it.helsinki.fi (smtp-rs1.it.helsinki.fi
	[128.214.148.199]) by cuda.sgi.com with ESMTP id
	P8kEFIfIcGmmb9oE for <xfs@oss.sgi.com>;
	Sun, 13 Sep 2009 22:08:49 -0700 (PDT)
Message-ID: <4AADCFDD.3020302@helsinki.fi>
Date: Mon, 14 Sep 2009 08:08:45 +0300
From: Riku Paananen <riku.paananen@helsinki.fi>
MIME-Version: 1.0
Subject: Re: xfs_repair hangs at Phase 6
References: <4AAA15A6.8070700@helsinki.fi> <4AAA71FF.3060706@sandeen.net>
In-Reply-To: <4AAA71FF.3060706@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


>> I have a 39TB xfs filesystem in a SAN that got corrupted. The reasons 
>> for the corruption are unclear. I've been trying to fix it using 
>> xfs_repair but the repair operation always hangs at Phase 6 
>> "traversing filesystem ...".
> Can you try again with -P?
> If that fails can you try again with -P -o bhashsize=1024 ?

With -P -o bhashsize=1024 it finally finished.

Thanks a lot.


Riku Paananen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
