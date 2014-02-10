Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 44D8C7F4E
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 21:36:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 344798F8037
	for <xfs@oss.sgi.com>; Sun,  9 Feb 2014 19:35:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Y3HsexJR8HMvi1mt for <xfs@oss.sgi.com>;
	Sun, 09 Feb 2014 19:35:56 -0800 (PST)
Message-ID: <52F8491B.1020105@sandeen.net>
Date: Sun, 09 Feb 2014 21:35:55 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: add helper for verifying checksums on xfs_bufs
References: <52F83630.4020008@redhat.com> <52F8399B.3050204@sandeen.net>
	<20140210033323.GQ13647@dastard>
In-Reply-To: <20140210033323.GQ13647@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 2/9/14, 9:33 PM, Dave Chinner wrote:
> On Sun, Feb 09, 2014 at 08:29:47PM -0600, Eric Sandeen wrote:
>> Many/most callers of xfs_update_cksum() pass bp->b_addr and
>> BBTOB(bp->b_length) as the first 2 args.  Add a helper
>> which can just accept the bp and the crc offset, and work
>> it out on its own, for brevity.
> 
> The title of the patch is the same as the previous one - I think you
> forgot to "update" it?

Bah, yes.  Probably doesn't really even have to be 2 patches.

> Other than that, same comments as for the previous patch.

ok, thx for the reviews.  Agree that the defines make it better.

-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
