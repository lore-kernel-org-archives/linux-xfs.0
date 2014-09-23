Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 001727F4E
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 18:12:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D448D304039
	for <xfs@oss.sgi.com>; Tue, 23 Sep 2014 16:12:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BQnRmRpq4WElZ5H3 for <xfs@oss.sgi.com>;
	Tue, 23 Sep 2014 16:12:34 -0700 (PDT)
Message-ID: <5421FE61.30508@sandeen.net>
Date: Tue, 23 Sep 2014 18:12:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupted file system
References: <5839367.DyqsVHbRuQ@myrada>	<CAA43vkWP5MEv=EoUxthjniyiiLm8hZNSS-agcm2C3dBDMXQ8Zw@mail.gmail.com>
	<6825577.fQrC5yyUIR@myrada>
In-Reply-To: <6825577.fQrC5yyUIR@myrada>
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
To: Diane Trout <diane@caltech.edu>, Sean Caron <scaron@umich.edu>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/23/14 5:29 PM, Diane Trout wrote:
> Hello,
> 
> Yes, I had my doubts about that there's anything reasonable one could do after 
> part of the file system was randomized. I'll trying updating to xfsprogs 3.2.1 
> and see if that does any better.

Yes - you didn't mention which version you used, but I'd definitely try something
current.  The bug rings a bell, maybe fixed now.

To be safe, you can always make an xfs_metadump image (use -o to not obfuscate
filenames for convenience), xfs_mdrestore that, and point repair at that fs image.
Then you'll see what it *would* do before you *do* do.  ;)

But yeah, depending on the damage done to the storage, you may be in trouble
that repair can't help with.  Depends on the failure, though.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
