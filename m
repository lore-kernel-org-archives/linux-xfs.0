Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92LDgVV087092 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 16:13:42 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tXJcjAkA1Dbzehcw for
	<xfs@oss.sgi.com>; Tue, 02 Oct 2012 14:15:06 -0700 (PDT)
Message-ID: <506B58F7.1020002@redhat.com>
Date: Tue, 02 Oct 2012 17:13:27 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 06/13] xfs: xfs_sync_data is redundant.
References: <1348807485-20165-1-git-send-email-david@fromorbit.com>
	<1348807485-20165-7-git-send-email-david@fromorbit.com>
	<5069F9B0.50804@redhat.com> <20121002001021.GJ23520@dastard>
	<506A38D1.6090204@redhat.com> <506AE5AD.60509@redhat.com>
	<20121002205124.GS23520@dastard>
In-Reply-To: <20121002205124.GS23520@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 10/02/2012 04:51 PM, Dave Chinner wrote:
> On Tue, Oct 02, 2012 at 09:01:33AM -0400, Brian Foster wrote:
>> On 10/01/2012 08:44 PM, Brian Foster wrote:
>>> On 10/01/2012 08:10 PM, Dave Chinner wrote:
>> ...
>>>
...
> 
> I don't think we can do an unconditional down_read() there, as the
> caller from xfs_create() already holds an i_mutex (the VFS holds the
> directory inode lock) and I'm pretty sure that s_umount is supposed
> to be outside per-inode locks.
> 
> Given that where we are called we are inside a transaction for the
> create case, and inside mnt_want_write() protection for the buffered
> write case, the likelyhood of s_umount being held for write at
> ENOSPC is going to be non-existent at these call sites. Hence a
> down_read_trylock() will avoid lock ordering issues, but will almost
> always succeed and so be equivalent to down_read()....
> 

Ok...

> /me modifies and runs 273 and the enospc xfstests group...
> 
> Seems to work just fine, and no warnings. Patch below.
> 

This passes 273 clean (save the xlog_verify_grant_tail message) for me
as well. Thanks.

Brian

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
