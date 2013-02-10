Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5CB6E7F37
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2013 20:05:10 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BE758F8033
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2013 18:05:07 -0800 (PST)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id BQr2xbGhda1LlCos (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 09 Feb 2013 18:05:02 -0800 (PST)
Message-ID: <51170044.1090707@tlinx.org>
Date: Sat, 09 Feb 2013 18:04:52 -0800
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: xfs deadlock on buffer semaphore while reading directory
References: <20130202192007.GS30577@one.firstfloor.org>
	<510D6EDE.1080409@sgi.com> <510E054B.2070500@tlinx.org>
	<20130206004442.GS2667@dastard>
In-Reply-To: <20130206004442.GS2667@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave Chinner wrote:
>> I can't get the buffers to 'free' no matter what
>> echo 3> /proc/sys/vm/drop_caches does nothing.
> 
> What buffers are you talking about? The deadlock is in metadata
> buffer handling, which you can't directly see, and will never be
> able to entirely free via drop caches.
> 
> if you are talking about what is reported by the "free" command,
> then that number can be ignored as it is mostly meaningless for XFS
> filesystems....
----
	Actually was talking 'cache', not buffers... sorry,
which I thought was mostly fs-data that was "freeable" (mostly).
whereas because of the error in xfs_dump, I was concerned about
it taking up all free memory (whereas normally, it doesn't
matter).

but I was trying to use echo 3>/proc/sys/vm/drop_caches, but that
seemed to pretty much be ignored...

But after boot and new kernel w/new and different problems,
xfs_dump (the new version) works fine... ;)
Sorry for any confusion.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
