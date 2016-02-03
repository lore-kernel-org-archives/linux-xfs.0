Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C7B7B7CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 20:47:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63304AC001
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 18:47:29 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pi7JkXppOrRwOEFX for <xfs@oss.sgi.com>;
	Tue, 02 Feb 2016 18:47:26 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 9652563C6064
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 20:47:25 -0600 (CST)
Subject: Re: Request for information on bloated writes using Swift
References: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56B16A3C.1030207@sandeen.net>
Date: Tue, 2 Feb 2016 20:47:24 -0600
MIME-Version: 1.0
In-Reply-To: <CAFHL4X1JU02LFYntkqhYg1N++ZU46ML3v5higo1nRsPyoZxL5A@mail.gmail.com>
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
To: xfs@oss.sgi.com



On 2/2/16 4:32 PM, Dilip Simha wrote:
> Hi,
> 
> I have a question regarding speculated preallocation in XFS, w.r.t
> kernel version: 3.16.0-46-generic. I am using Swift version: 1.0 and
> mkfs.xfs version 3.2.1
> 
> When I write a 256KiB file to Swift, I see that the underlying XFS
> uses 3x the amount of space/blocks to write that data. Upon
> performing detailed experiments, I see that when Swift uses fallocate
> (default approach), XFS doesn't reclaim the preallocated blocks that
> XFS allocated. Swift fallocate doesn't exceed the body size(256
> KiB).
> 
> Interestingly, when either allocsize=4k or when swift doesn't use
> fallocate, XFS doesn't consume additional space.
> 
> Can you please let me know if this is a known bug and if its fixed in
> the later versions?

Can you clarify the exact sequence of events?

i.e. -

xfs_io -f -c "fallocate 0 256k" -c "pwrite 0 256k" somefile

leads to unreaclaimed preallocation, while

xfs_io -f -c "pwrite 0 256k" somefile

does not?  Or is it some other sequence?  I don't have a
3.16 handy to test, but if you can describe it in more detail
that'd help.  Some of this is influenced by fs geometry, too
so xfs_info output would be good, along with any mount options
you might be using.

Are you preallocating with or without KEEP_SIZE?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
