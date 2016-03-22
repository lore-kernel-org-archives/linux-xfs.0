Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 13A057CAF
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 07:19:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D5DE88F8040
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2016 05:19:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tncNv8plVYEogHj0 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2016 05:19:25 -0700 (PDT)
Date: Tue, 22 Mar 2016 08:19:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS hung task in xfs_ail_push_all_sync() when unmounting FS
	after disk failure/recovery
Message-ID: <20160322121922.GA53693@bfoster.bfoster>
References: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f049419a2ab10f8e3c4fef0e4f4ca1ba@mail.gmail.com>
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
To: Shyam Kaushik <shyam@zadarastorage.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Tue, Mar 22, 2016 at 04:51:39PM +0530, Shyam Kaushik wrote:
> Hi XFS developers,
> 
> We are seeing the following issue with XFS on kernel 3.18.19.
> 
> We have XFS mounted over a raw disk. Disk was pulled out manually. There
> were async writes on files that were errored like this
> 
...
> 
> And XFS hit metadata & Log IO errors that it decides to shutdown:
> 
> Mar 16 16:03:22 host0 kernel: [ 4637.351841] XFS (dm-29): metadata I/O
> error: block 0x3a27fbd0 ("xlog_iodone") error 5 numblks 64
> Mar 16 16:03:22 host0 kernel: [ 4637.352820] XFS(dm-29): SHUTDOWN!!!
> old_flags=0x0 new_flags=0x2
> Mar 16 16:03:22 host0 kernel: [ 4637.353187] XFS (dm-29): Log I/O Error
> Detected.  Shutting down filesystem
...
> Later the drive was re-inserted back. After the drive was re-inserted, XFS
> was attempted to be unmounted
> 
> Mar 16 16:16:53 host0 controld: [2557] [     ] umount[202]
> : umount(/sdisk/vol5b0, xfs)
> 
> But nothing happens except for the 30-secs xfs_log_force errors that keeps
> repeating
> 
...
> 
> This problem doesn't happen consistently, but happens periodically with a
> drive failure/recovery followed by XFS unmount. I couldn't find this issue
> fixed in later kernels. Can you please suggest how I can debug this issue
> further?
> 

Similar problems have been reproduced due to racy/incorrect EFI/EFD
object tracking, which are internal data structures associated with
freeing extents.

What happens if you enable tracepoints while the fs is in this hung
unmount state? 

# trace-cmd start -e "xfs:*"
# cat /sys/kernel/debug/tracing/trace_pipe

Brian

> Thanks!
> 
> --Shyam
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
