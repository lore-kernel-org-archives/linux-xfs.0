Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 259F27F3F
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 12:51:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F2DC58F8033
	for <xfs@oss.sgi.com>; Thu, 14 Nov 2013 10:51:54 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id BFmiQf5d4zbYDOy0 for <xfs@oss.sgi.com>;
	Thu, 14 Nov 2013 10:51:53 -0800 (PST)
Message-ID: <52851BC8.6040508@sandeen.net>
Date: Thu, 14 Nov 2013 12:51:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] xfs: increase inode cluster size for v5 filesystems
References: <1383280040-21979-1-git-send-email-david@fromorbit.com>
	<1383280040-21979-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1383280040-21979-6-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 10/31/13, 11:27 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> v5 filesystems use 512 byte inodes as a minimum, so read inodes in
> clusters that are effectively half the size of a v4 filesystem with
> 256 byte inodes. For v5 fielsystems, scale the inode cluster size
> with the size of the inode so that we keep a constant 32 inodes per
> cluster ratio for all inode IO.

Ok, I'm happy with this now that I was reminded of the difference
between clusters & chunks.  :/

Ben, regarding your compat concern, I agree w/ Dave that there
should be no failures moving forward or back; as he & I mentioned
(I had missed his other reply), the kernel already (used to) set
different cluster sizes based on the memory available in the machine
that mounted the filesystem.


So:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
