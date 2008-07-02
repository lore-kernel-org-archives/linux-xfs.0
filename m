Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Jul 2008 23:37:15 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m626b7LE020112
	for <xfs@oss.sgi.com>; Tue, 1 Jul 2008 23:37:09 -0700
Message-ID: <486B2248.5080400@sgi.com>
Date: Wed, 02 Jul 2008 16:38:00 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Move attr log alloc size calculator to another function.
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com>	<1214196150-5427-2-git-send-email-xaiki@sgi.com>	<20080626082438.GB23954@infradead.org> <nccprq31nz8.fsf@sgi.com>
In-Reply-To: <nccprq31nz8.fsf@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Niv Sardi wrote:
> Attached updated patch.
> 
> Christoph Hellwig <hch@infradead.org> writes:
>> On Mon, Jun 23, 2008 at 02:42:27PM +1000, Niv Sardi wrote:
>>> From: Niv Sardi <xaiki@debian.org>
>>>
>>> We will need that to be able to calculate the size of log we need for
>>> a specific attr (for parent pointers in create). We need the local so
>>> that we can fail if we run into ENOSPC when trying to alloc blocks
> 
> Updated Comments, structs instead of typdefs
>  
>>> Signed-off-by: Niv Sardi <xaiki@sgi.com>
>>> ---
>>>  fs/xfs/xfs_attr.c |   78 +++++++++++++++++++++++++++++++---------------------
>>>  fs/xfs/xfs_attr.h |    2 +-
>>>  2 files changed, 47 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
>>> index e58f321..0d19e90 100644
>>> --- a/fs/xfs/xfs_attr.c
>>> +++ b/fs/xfs/xfs_attr.c
>>> @@ -185,6 +185,43 @@ xfs_attr_get(
>>>  }
>>>  
>>>  int
>>> +xfs_attr_calc_size(
>> should be marked STATIC,
> 
> The whole idea is to be able to use it in xfs_create().
>
I guess in isolation it just looks weird as the only caller is within
the file.
In isolation it would make sense to be STATIC.
(Then again, in isolation, it looks strange returning the "local" parameter -
 as you said, you need it elsewhere).
And I guess, Christoph's point was that it could go in as an isolated
cleanup patch if it was made static.

--Tim
