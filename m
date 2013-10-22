Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B3807F3F
	for <xfs@oss.sgi.com>; Tue, 22 Oct 2013 13:06:59 -0500 (CDT)
Message-ID: <5266BEE9.2000907@sgi.com>
Date: Tue, 22 Oct 2013 13:07:37 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/32] xfs: create a shared header file for format-related
	information
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-9-git-send-email-david@fromorbit.com>
	<526168EB.1080403@sgi.com> <20131018224041.GW4446@dastard>
In-Reply-To: <20131018224041.GW4446@dastard>
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

On 10/18/2013 05:40 PM, Dave Chinner wrote:
> On Fri, Oct 18, 2013 at 11:59:23AM -0500, Rich Johnston wrote:
>> This has been committed.
>>
>> Thanks
>> --Rich
>>
>> commit dd297fd6d366f62ca2f579e510e6287699d0bd5d
>> Author: Dave Chinner <david@fromorbit.com>
>> Date:   Mon Sep 30 03:15:20 2013 +0000
>>
>>      xfs: create a shared header file for format-related information
>
> Rich, none of the kernel patches for this rework have been committed
> yet. I appreciate you catching up on outstanding patches, but lets
> not jump the gun completely by commit stuff to userspace that isn't
> yet in the kernel tree.
>
> As it is, the last version of the kernel patch for this change was
> slightly modified due to review comments, which is why we should be
> waiting for the kernel commits to shared files before finalising
> and committing the userspace patches...
>
> Cheers,
>
> Dave.
>
commit 77d8143bd059f6da43b46cadaa6a96c3d4573d9c
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Oct 22 13:04:53 2013 -0500

     Revert "xfs: create a shared header file for format-related 
information"

     This reverts commit dd297fd6d366f62ca2f579e510e6287699d0bd5d.

     Wait for the kernel commits to shared files before finalising
     and committing the userspace patches.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
