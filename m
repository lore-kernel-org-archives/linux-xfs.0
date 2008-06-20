Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 20:36:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5K3aGUs032152
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 20:36:16 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4DD71230958
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 20:37:15 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id JsHB9fBywnJGq3sb for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 20:37:15 -0700 (PDT)
Date: Fri, 20 Jun 2008 13:37:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] Always reset btree cursor after an insert
Message-ID: <20080620033710.GZ3700@disturbed>
References: <4859F9EB.5050505@sgi.com> <20080619083544.GA19606@infradead.org> <485B0B04.80808@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485B0B04.80808@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 20, 2008 at 11:42:28AM +1000, Lachlan McIlroy wrote:
> Christoph Hellwig wrote:
>> On Thu, Jun 19, 2008 at 04:17:15PM +1000, Lachlan McIlroy wrote:
>>> After a btree insert operation a cursor can be invalid due to block
>>> splits and a maybe a new root block.  We reset the cursor in
>>> xfs_bmbt_insert() in the cases where we think we need to but it
>>> isn't enough as we still see assertions.  Just do what we do elsewhere
>>> and reset the cursor unconditionally.  Version 2 adds
>>> XFS_WANT_CORRUPTED_GOTO checks throughout xfs_bmap.c and removes the
>>> fix to revalidate the original cursor in xfs_bmbt_insert().
>>
>> Can you commit the XFS_WANT_CORRUPTED_GOTO checks as a separate patch
>> before the cursor reset?  ACK from me for those hunks.
>>
>
> Yeah, no problem, thanks.

The rest of it looks ok as well, Lachlan.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
