Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 50DCA7F4E
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 18:28:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1997AC003
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 16:28:50 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id enaqLZ2skBMoLRxm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 16:28:48 -0800 (PST)
Date: Mon, 16 Nov 2015 16:28:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: clone ioctl return values
Message-ID: <20151117002822.GA32467@birch.djwong.org>
References: <20151116120431.GA2860@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151116120431.GA2860@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 16, 2015 at 04:04:31AM -0800, Christoph Hellwig wrote:
> Hi Darrick,
> 
> your new generic/157 xfs test brings up an interesting issue:  error
> returns forthe various clone failure cases.  It seems like this case
> was written fo the XFS case which differs a lot from the error chosen
> by btrfs and mostly followed by NFS.  I'd say it might be a better idea
> to follow the btrfs example as the btrfs ioctls have been in use for
> a while.  The only shortcoming I see in btrfs is that id doesn't
> explicitly check for non-directory, non-regular file items as the
> source.  I have to admit I'm kinda surprised that it doesn't blow up,
> given that NFS instantly did when I removed those checks.
> 
> FYI, output from the test on btrfs below:
> 
> 
> --- tests/generic/157.out	2015-11-14 07:56:31.000000000 +0000
> +++ /root/xfstests/results//generic/157.out.bad	2015-11-16 11:58:52.879078894 +0000
> @@ -2,24 +2,24 @@
>  Format and mount
>  Create the original files
>  Try cross-device reflink
> -XFS_IOC_CLONE_RANGE: Invalid cross-device link
> +reflink: Invalid cross-device link

Hmm, I think you're running an older version of xfsprogs for-next.  The
"reflink:" perror prefix was changed to the ioctl name (for all three ioctls)
per the comment in:
http://oss.sgi.com/archives/xfs/2015-09/msg00338.html

>  Try unaligned reflink
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +reflink: Invalid argument
>  Try overlapping reflink
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +reflink: Invalid argument
>  Try reflink past EOF
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +reflink: Invalid argument
>  Try to reflink a dir
> -XFS_IOC_CLONE_RANGE: Is a directory
> +reflink: Is a directory

>  Try to reflink a device
> -XFS_IOC_CLONE_RANGE: Invalid argument
> +/mnt/test/test-157/dev1: No such device or address

Huh.  How did you get -ENODEV here?  I ran this on 4.3 and got -EINVAL.

>  Try to reflink to a dir
> -/mnt/test-157/dir1: Is a directory
> +/mnt/test/test-157/dir1: Is a directory

Drat, will fix.

>  Try to reflink to a device
> -XFS_IOC_CLONE_RANGE: Operation not supported
> +/mnt/test/test-157/dev1: No such device or address

Same here as the other device case.

>  Try to reflink to a fifo
> -XFS_IOC_CLONE_RANGE: Operation not supported
> +reflink: Inappropriate ioctl for device

Errrgh, the golden output of this test reflects the changes to the input
checking in Anna/Peng's copy_file_range/clone_file_range patches.

So, I guess the question is, should I reset the golden output to whatever
btrfs spits out before that patchset, and we'll consider the alterations
to be bugs/regressions/whatever that ought to be fixed in their patches?

>  Try to reflink an append-only file
> -XFS_IOC_CLONE_RANGE: Bad file descriptor
> +reflink: Invalid argument

Same as above.

--D

>  Reflink two files
>  Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
