Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0F2797F6A
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 20:04:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0072A304039
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 18:04:09 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TaeNoVAtUJbxbuFl for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 18:04:08 -0800 (PST)
Message-ID: <52FD7997.1020407@sandeen.net>
Date: Thu, 13 Feb 2014 20:04:07 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH V3] xfs: skip verification on initial "guess" superblock
	read
References: <52FD3C59.3050400@redhat.com> <52FD55FC.1000103@sandeen.net>
	<20140214002708.GO13997@dastard>
In-Reply-To: <20140214002708.GO13997@dastard>
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

On 2/13/14, 6:27 PM, Dave Chinner wrote:

> Looks fine. I'll run it through some testing and we can go from
> there. FWIW, does this make your "check the sector size in the sb
> verifier" patch redundant?

Well, it'll be safe for the primary SB, but I assume that a corrupted
secondary would still trip things up.

I think that at this point we can switch to using BBTOB(bp->b_length)
in the verifier and be safe.  I'll look into it.

-Eric
 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
