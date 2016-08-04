Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 58F227CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 22:00:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D05A5AC002
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 20:00:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id FBqEv4iRvrGTa2fB for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 20:00:10 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 132849A
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 22:00:10 -0500 (CDT)
Subject: Re: xfstests xfs fuzzers fail with DAX
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <a23e895c-7d3e-bed2-9bc9-66e306df485e@sandeen.net>
Date: Wed, 3 Aug 2016 22:00:09 -0500
MIME-Version: 1.0
In-Reply-To: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
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

On 8/3/16 9:45 PM, Xiong Zhou wrote:
> Hi,
> 
> A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
> They are xfs/086 xfs/088 xfs/089 xfs/091.
> 
> xfstests to commit 4470ad4c7e  (Jul 26)
> kernel   to commit dd95069545  (Jul 24)
> 
> + ./check xfs/091
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> 
> xfs/091	 104s
> Ran: xfs/091
> Passed all 1 tests
> 
> + echo 'MOUNT_OPTIONS="-o dax"'
> + ./check xfs/091
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
> 
> xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
>     --- tests/xfs/091.out	2016-07-18 02:57:47.670000000 -0400
>     +++ /root/xfstests/results//xfs/091.out.bad	2016-08-03 22:38:14.948000000 -0400
>     @@ -6,6 +6,70 @@
>      + corrupt image
>      + mount image
>      + modify files
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning

This means the filesystem has shut down, most likely, and more information about
the error is in dmesg.

Further, if the filesystem is corrupt, xfs_repair output would be interesting.

Can you provide that information?

This can probably be reproduced, but when reporting a bug it's always good to provide
as many details as you can.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
