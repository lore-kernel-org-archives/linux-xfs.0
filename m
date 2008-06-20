Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Jun 2008 00:31:32 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K7VM85004973
	for <xfs@oss.sgi.com>; Fri, 20 Jun 2008 00:31:24 -0700
Message-ID: <485B5DD4.3020201@sgi.com>
Date: Fri, 20 Jun 2008 17:35:48 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH V2] Always reset btree cursor after an insert
References: <4859F9EB.5050505@sgi.com> <20080619083544.GA19606@infradead.org> <485B0B04.80808@sgi.com> <20080620033710.GZ3700@disturbed>
In-Reply-To: <20080620033710.GZ3700@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Fri, Jun 20, 2008 at 11:42:28AM +1000, Lachlan McIlroy wrote:
>> Christoph Hellwig wrote:
>>> On Thu, Jun 19, 2008 at 04:17:15PM +1000, Lachlan McIlroy wrote:
>>>> After a btree insert operation a cursor can be invalid due to block
>>>> splits and a maybe a new root block.  We reset the cursor in
>>>> xfs_bmbt_insert() in the cases where we think we need to but it
>>>> isn't enough as we still see assertions.  Just do what we do elsewhere
>>>> and reset the cursor unconditionally.  Version 2 adds
>>>> XFS_WANT_CORRUPTED_GOTO checks throughout xfs_bmap.c and removes the
>>>> fix to revalidate the original cursor in xfs_bmbt_insert().
>>> Can you commit the XFS_WANT_CORRUPTED_GOTO checks as a separate patch
>>> before the cursor reset?  ACK from me for those hunks.
>>>
>> Yeah, no problem, thanks.
> 
> The rest of it looks ok as well, Lachlan.
> 

Ta.
