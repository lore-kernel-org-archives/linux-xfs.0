Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29Hfw2i007792 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 11:41:59 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id MxV8BcX7jnhzQO2M for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 09:41:57 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 6FD6A49434E1
	for <xfs@oss.sgi.com>; Fri,  9 Mar 2012 11:41:57 -0600 (CST)
Message-ID: <4F5A40E5.8080609@sandeen.net>
Date: Fri, 09 Mar 2012 11:41:57 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfstests - unchecked mount failures
References: <20120309132828.GI4334@twin.jikos.cz>
In-Reply-To: <20120309132828.GI4334@twin.jikos.cz>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 3/9/12 7:28 AM, David Sterba wrote:
> Hi,
> 
> I've encountered a bad situation when a failed mount in test 269 did not stop
> the test and continued to use the mount point and exhausted space on the root
> partition. A quick grep revealed that there are more tests with unchecked
> _scratch_mount calls.
> 
> The underlying problem with failed mount was observed when the mount comes in a
> quick sequence after mount, I saw it with btrfs, and don't know if it affects
> other filesystems.
> 
> So, either all callers should check the return value or _scratch_mount
> calls _fail. I'd go for the latter as it will make it more resilient
> against unintentional ommision of checking the retval in new tests and
> reviewer does not have keep that in mind.

Sounds good to me; _test_mount() should probably do the same?

I guess it'd be worth investigating exactly why it failed, though.

Still, if you'd like to send a patch to _fail in the mount helpers
if they fail, that sounds reasonable to me.

Thanks,
-Eric

> 
> david
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
