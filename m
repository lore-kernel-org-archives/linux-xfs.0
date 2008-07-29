Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 28 Jul 2008 21:11:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6T4Ax8w016144
	for <xfs@oss.sgi.com>; Mon, 28 Jul 2008 21:11:00 -0700
Message-ID: <488E9899.2000106@sgi.com>
Date: Tue, 29 Jul 2008 14:12:09 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/15] use the same btree_cur union member for alloc and
 inobt trees
References: <20080723200826.GC7401@lst.de> <488E9497.2090900@sgi.com> <20080729040718.GA30548@lst.de>
In-Reply-To: <20080729040718.GA30548@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Tue, Jul 29, 2008 at 01:55:03PM +1000, Timothy Shimmin wrote:
>> Hi there,
>>
>> This was fine but just one thing which looked odd:
>>
>> Christoph Hellwig wrote:
>>>  
>>> Index: linux-2.6-xfs/fs/xfs/xfs_btree.c
>>> ===================================================================
>>> --- linux-2.6-xfs.orig/fs/xfs/xfs_btree.c	2008-07-16 03:24:18.000000000 +0200
>>> +++ linux-2.6-xfs/fs/xfs/xfs_btree.c	2008-07-16 03:24:19.000000000 +0200
>>> @@ -570,6 +570,13 @@ xfs_btree_init_cursor(
>>>  		cur->bc_private.a.agbp = agbp;
>>>  		cur->bc_private.a.agno = agno;
>>>  		break;
>>> +	case XFS_BTNUM_INO:
>>> +		/*
>>> +		 * Inode allocation btree fields.
>>> +		 */
>>> +		cur->bc_private.a.agbp = agbp;
>>> +		cur->bc_private.a.agno = agno;
>>> +		break;
>>>  	case XFS_BTNUM_BMAP:
>>>  		/*
>>>  		 * Bmap btree fields.
>>> @@ -582,13 +589,6 @@ xfs_btree_init_cursor(
>>>  		cur->bc_private.b.flags = 0;
>>>  		cur->bc_private.b.whichfork = whichfork;
>>>  		break;
>>> -	case XFS_BTNUM_INO:
>>> -		/*
>>> -		 * Inode allocation btree fields.
>>> -		 */
>>> -		cur->bc_private.i.agbp = agbp;
>>> -		cur->bc_private.i.agno = agno;
>>> -		break;
>>>  	default:
>> Could probably just add XFS_BNUM_INO to the case below
>> (and modify the comment):
> 
> We could, and in fact that was my plan initially 
I'm not surprised :-)

> but I gave it up
> because later we'd add the method table initialization which
> would be different for the alloc vs inobt trees.  I then later factored
> these out into separate functions, so this whole switch goes away
> a few patches later in the series.
> 
Oh okay, method in the madness ;-)

> Given that it would only cause churn in the series I'd prefer to
> leave the patch as-is.
Yep, fine.

--Tim
