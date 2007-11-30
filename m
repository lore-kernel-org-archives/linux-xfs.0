Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 15:03:10 -0800 (PST)
Received: from mail.integraonline.com (relay4.integra.net [204.130.255.183])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAUN3599031854
	for <linux-xfs@oss.sgi.com>; Fri, 30 Nov 2007 15:03:06 -0800
In-Reply-To: <474FBA21.4070201@sgi.com>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org>
Content-Transfer-Encoding: 7bit
From: Stephen Lord <lord@xfs.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Date: Fri, 30 Nov 2007 16:36:25 -0600
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>



Wow, was it really that long ago!

Looks like the readdir is in the bowels of the btree code when  
filldir gets called
here, there are probably locks on several buffers in the btree at  
this point. This
will only show up for large directories I bet.

The xfs readdir code has the complete xfs inode number in its hands  
at this point
(filldir is not necessarily getting all the bits of it). All we are  
doing the lookup
for really is to get the inode number back again so we can get the inode
and get the attributes. Rather dumb really. There has got to be a way of
doing a callout structure here so that the inode number can be pushed
through filldir and back into an fs specific call. The fs then can do  
a lookup
by id - which is what it does most of the time for resolving nfs handles
anyway. Should be more efficient than the current scheme.

Just rambling, not a single line of code was consulted in writing  
this message.

You want to make a big fat btree directory for testing this stuff.  
Make sure it gets
at least a couple of layers of node blocks.

Steve

On Nov 30, 2007, at 1:22 AM, Timothy Shimmin wrote:

> Christoph Hellwig wrote:
>> The current readdir implementation deadlocks on a btree buffers locks
>> because nfsd calls back into ->lookup from the filldir callback.  The
>> only short-term fix for this is to revert to the old inefficient
>> double-buffering scheme.
>
> Probably why Steve did this: :)
>
> xfs_file.c
> ----------------------------
> revision 1.40
> date: 2001/03/15 23:33:20;  author: lord;  state: Exp;  lines: +54 -17
> modid: 2.4.x-xfs:slinx:90125a
> Change linvfs_readdir to allocate a buffer, call xfs to fill it, and
> then call the filldir function on each entry. This is instead of  
> doing the
> filldir deep in the bowels of xfs which causes locking problems.
> ----------------------------
>
