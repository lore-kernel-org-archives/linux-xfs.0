Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25FiZUP217091 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 09:44:35 -0600
Received: from xwis.net (xwis.net [88.198.24.17]) by cuda.sgi.com with ESMTP
	id CqEkorJrgwwHWpyz (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 05 Mar 2012 07:44:33 -0800 (PST)
Message-ID: <4F54DF5A.4090301@xwis.net>
Date: Mon, 05 Mar 2012 16:44:26 +0100
From: Olaf van der Spek <olaf@xwis.net>
MIME-Version: 1.0
Subject: Re: fsync, rename, O_ATOMIC/O_PONIES
References: <4F50BF89.7020909@xwis.net> <20120302131240.GA14186@infradead.org>
	<4F53A2FF.3000305@xwis.net> <20120305010203.GK5091@dastard>
In-Reply-To: <20120305010203.GK5091@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 5-3-2012 2:02, Dave Chinner wrote:
>> Argh, come on.
>> That's not real and it's not complete. tmpfile is undefined, errors
>> aren't handled and you have lots of unlisted assumptions or
>> regressions.
>
> The above is perfectly reasonable psuedo code for quickly describing
> how to safely overwriting a file. If you want to know about error
> handling and assumptions, read the man pages for operation.

But I don't have a psuedo code compiler. Using psuedo code hides 
complexity and bugs. Even the code from Jeff Moyer in the article you're 
refering too contained bugs.

Don't you think it's quite strange there's no real code available to 
handle this widespread problem?

> To make it easy for you, I'll just point out this has already been
> dealt with early in in the LWN thread for that article, here's the
> link to the comment and the relevant LWN article providing you with
> all the information you want:
>
> http://lwn.net/Articles/476606/
> https://lwn.net/Articles/457667/

It also doesn't handle the assumptions / regressions: 
http://lwn.net/Articles/485182/
Assuming the target is not a symlink to a different volume
Assuming you are allowed to create the tmp file
Assuming you are allowed to overwrite an existing file having the same 
name as your tmp file
Assuming it's ok to reset meta-data, like file owner, permissions, acls, 
creation timestamp, etc.
Assuming the performance regression due to fsync is ok (request was for 
atomic, not durable)

> And that my stance on this atomic rename subject is simply this: If
> we want to change reanme behaviour, then the filesystem is not the
> right place to do it - atomic rename semantics need to be defined
> and enforced at the VFS.  See here:
>
> http://lwn.net/Articles/479152/

I don't think rename is part of the solution.

Olaf

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
