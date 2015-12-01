Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD6587F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 13:50:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4D6ABAC004
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 11:50:43 -0800 (PST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com
	[74.125.82.47]) by cuda.sgi.com with ESMTP id OyNCo0RCrt3FJUO6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 11:50:41 -0800 (PST)
Received: by wmuu63 with SMTP id u63so187697699wmu.0
	for <xfs@oss.sgi.com>; Tue, 01 Dec 2015 11:50:40 -0800 (PST)
Subject: Re: sleeps and waits during io_submit
References: <20151201131114.GA26129@bfoster.bfoster>
	<565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com> <20151201194139.GA19035@infradead.org>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <565DFA0E.6070608@scylladb.com>
Date: Tue, 1 Dec 2015 21:50:38 +0200
MIME-Version: 1.0
In-Reply-To: <20151201194139.GA19035@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On 12/01/2015 09:41 PM, Christoph Hellwig wrote:
> On Tue, Dec 01, 2015 at 09:26:42PM +0200, Avi Kivity wrote:
>> It's basically the same thing.  To to this, we'd have get_block either
>> return the block's address (if it was in some metadata cache), or, if it was
>> not, issue an I/O that fills (part of) that cache, and as its completion
>> function, a continuation that reruns __blockdev_direct_IO from the point it
>> was stopped so it can submit the data I/O (if the metadata cache was
>> completely updated) or issue the next I/O aiming to fill that metadata
>> cache, if it was not.
> We did something this for blocking reads with great results, and it could be
> done similarly for direct I/O I think:
>
> 	https://lwn.net/Articles/612483/
>
> Unfortunately Andrew shut it down for odd reasons so it didn't get in.

How would this work?  io_submit() returns -ENOTALLMETADATAISINCACHE, 
user calls io_submit() again from a worker thread, where he doesn't mind 
blocking?

In fact sys_io_submit() could catch this error and resubmit the I/O on 
its own using a work item, and io_submit() would become non-blocking, at 
least on I/O (lock contention may still be a problem, but a smaller one).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
