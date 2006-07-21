Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 20 Jul 2006 22:16:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6L5GJDW022284
	for <linux-xfs@oss.sgi.com>; Thu, 20 Jul 2006 22:16:33 -0700
Message-ID: <44C062A3.1090206@sgi.com>
Date: Fri, 21 Jul 2006 15:14:11 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Question on the WriteCache / WriteBarrier FAQ entry
References: <200607201205.34750.Martin@lichtvoll.de>
In-Reply-To: <200607201205.34750.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hello,
> 
> I try to fully understand this entry:
> 
> "Many drives use a write back cache in order to speed up the performance 
> of writes. However, there are conditions such as power failure when the 
> write cache memory is never flushed to the actual disk. This causes 
> problems for XFS and journaled filesystems in general because they rely 
> on knowing when a write has completed to the disk. They need to know that 
> the log information has made it to disk before allowing metadata to go to 
> disk. When the metadata makes it to disk then the tail of the log can 
> move. So if the writes never make it to the physical disk, then the 
> ordering is violated and the log and metadata can be lost, resulting in 
> filesystem corruption."
> 
> I have problems with: "When the metadata makes it to disk then the tail of 
> the log can move". What does that mean exactly?
> 
Too vague for you, was it? ;-))
http://oss.sgi.com/projects/xfs/design_docs/xfsdocs93_pdf/trans.pdf
has a good description in its 7 steps of a transaction.

> What I imagine is this: XFS write transaction to its log and the log 
> grows. When writing the meta data changes of a complete transaction XFS 
> removes it from the log. 
Pretty much.
The log is a fixed size and it wraps around with each basic block
(512 bytes) having an embedded wrap# (or cycle#).
We consider the head of the log as the point where a new transaction
can go and the tail of the log as the last transaction whose metadata
is still outstanding.
Between the tail and the head are the active items which need to be
replayed on log recovery.
When we get an io callback for a metadata write, we remove the
metadata items from a list of active items (AIL) and the tail
pointer is based on the minimum entry (by log sequence #) in the AIL.
So the tail is effectively moved on so that we know we can write
over these inactive items in the ondisk log and
can reclaim some space for the new ones to come.
Also we know that on recovery we will not look at this old
transaction.


> Now when the metadata changes of a transaction 
> has been written completely but the transaction itself has not, 
Which should not happen as we don't allow metadata to be written
until the associated transaction has made it to disk (see the 7 steps).
But if something went wrong and it did happen...

> it may 
> happen that a transaction is removed from the on disk log before it has 
> been written. 
Things would get confused.
I guess it might try to find the item which is not in the AIL as the
AIL gets updated on transaction callback.

> But even when this does not happen there are metadata 
> changes on disk that the log doesn't know about.
Yep, it's not good when we expect log replay to do the right thing.

> 
> So there are two situations where unordered writes can make a journalling 
> filesystem corrupt:
> 
> 1) Metadata make it to disk before the transaction that belongs to them => 
> There are metadata changes that XFS doesn't know about.
Well, that aren't reflected in the log.

> 
> 2) A transaction might be deleted from the log before it has been written 
> => This leads to a corrupted log.
A transaction deleted before its metadata has made it to disk, yes.
A transaction might be deleted (tail# moved on) because we believe
it's metadata has made it to disk when it really hasn't
(was in the write cache) in which case we need the transaction if
recovery is required and we don't have it.

I don't know if I want to try to go thru all the bad things that can 
happen and see how the code would handle it.

Cheers,
Tim.
