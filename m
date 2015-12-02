Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5120D7F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 14:02:20 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CA129AC001
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 12:02:15 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WbLoRo74llO4rK91 for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 12:02:13 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 5288963C3BC5
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 14:02:13 -0600 (CST)
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
References: <20151202183438.GA1319@linux.intel.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565F4E44.8090200@sandeen.net>
Date: Wed, 2 Dec 2015 14:02:12 -0600
MIME-Version: 1.0
In-Reply-To: <20151202183438.GA1319@linux.intel.com>
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



On 12/2/15 12:34 PM, Ross Zwisler wrote:
> I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> machine.  Here are the failures:

...

> generic/274 7s ... [failed, exit status 1] - output mismatch (see /root/xfstests/results//generic/274.out.bad)
>     --- tests/generic/274.out	2015-10-02 10:19:36.808795907 -0600
>     +++ /root/xfstests/results//generic/274.out.bad	2015-12-02 11:22:37.656868990 -0700
>     @@ -2,4 +2,5 @@
>      ------------------------------
>      preallocation test
>      ------------------------------
>     -done
>     +failed to write to test file
>     +(see /root/xfstests/results//generic/274.full for details)
>     ...
>     (Run 'diff -u tests/generic/274.out /root/xfstests/results//generic/274.out.bad'  to see the entire diff)

I looked at this one a bit last night, and talked to Dave about it; its' different
handling with DAX w.r.t. preallocation; we go down a path which actually tries to
re-reserve the disk blocks it'll be writing to, even though they're already allocated.

If the disk isn't full, I guess it doesn't matter, but this test explicitly tests ENOSPC.

Working on better understanding this path to see if I can fix it (unless Dave beats me
to it ...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
