Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 18:38:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m5K1bvuQ012226
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 18:37:58 -0700
Message-ID: <485B0B04.80808@sgi.com>
Date: Fri, 20 Jun 2008 11:42:28 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH V2] Always reset btree cursor after an insert
References: <4859F9EB.5050505@sgi.com> <20080619083544.GA19606@infradead.org>
In-Reply-To: <20080619083544.GA19606@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Jun 19, 2008 at 04:17:15PM +1000, Lachlan McIlroy wrote:
>> After a btree insert operation a cursor can be invalid due to block
>> splits and a maybe a new root block.  We reset the cursor in
>> xfs_bmbt_insert() in the cases where we think we need to but it
>> isn't enough as we still see assertions.  Just do what we do elsewhere
>> and reset the cursor unconditionally.  Version 2 adds
>> XFS_WANT_CORRUPTED_GOTO checks throughout xfs_bmap.c and removes the
>> fix to revalidate the original cursor in xfs_bmbt_insert().
> 
> Can you commit the XFS_WANT_CORRUPTED_GOTO checks as a separate patch
> before the cursor reset?  ACK from me for those hunks.
> 

Yeah, no problem, thanks.
