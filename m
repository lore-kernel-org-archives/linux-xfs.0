Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6B46A7F50
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 06:47:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 488738F8033
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 04:47:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kWiJYwoKl9CGbCi7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 04:47:33 -0800 (PST)
Date: Tue, 6 Jan 2015 07:47:27 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS corrupt after RAID failure and resync
Message-ID: <20150106124727.GC5874@bfoster.bfoster>
References: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAOFq7B5PaPCJdAxyYa6feCXgGbkz+1Qs+Gfb2WG=5af=A+WOQg@mail.gmail.com>
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
To: David Raffelt <david.raffelt@florey.edu.au>
Cc: xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 05:12:14PM +1100, David Raffelt wrote:
> Hi again,
> Some more information.... the kernel log show the following errors were
> occurring after the RAID recovery, but before I reset the server.
> 

By after the raid recovery, you mean after the two drives had failed out
and 1 hot spare was activated and resync completed? It certainly seems
like something went wrong in this process. The output below looks like
it's failing to read in some inodes. Is there any stack trace output
that accompanies these error messages to confirm?

I suppose I would try to verify that the array configuration looks sane,
but after the hot spare resync and then one or two other drive
replacements (was the hot spare ultimately replaced?), it's hard to say
whether it might be recoverable.

Brian

> Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 00:00:27 server kernel: XFS (md0): Corruption detected. Unmount and
> run xfs_repair
> Jan 06 00:00:27 server kernel: XFS (md0): metadata I/O error: block
> 0x36b106c00 ("xfs_trans_read_buf_map") error 117 numblks 16
> Jan 06 00:00:27 server kernel: XFS (md0): xfs_imap_to_bp:
> xfs_trans_read_buf() returned error 117.
> 
> 
> Thanks,
> Dave

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
