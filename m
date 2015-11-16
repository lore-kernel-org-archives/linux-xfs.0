Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1823F7CBF
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 13:27:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9C388AC00B
	for <xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:27:47 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id csbLB3JcoBQk84rB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 16 Nov 2015 11:27:46 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: AIO read returns negative number for bytes read
References: <564883BD.8070607@scylladb.com>
Date: Mon, 16 Nov 2015 14:27:43 -0500
In-Reply-To: <564883BD.8070607@scylladb.com> (Avi Kivity's message of "Sun, 15
	Nov 2015 15:08:13 +0200")
Message-ID: <x497flhsq1c.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Avi Kivity <avi@scylladb.com>
Cc: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

Hi Avi,

Avi Kivity <avi@scylladb.com> writes:

> Due to a bug in my program, I initiated a read beyond
> eof. Specifically, the file size is 13002 bytes and the read offset is
> 13312 (0x3400).
>
> I would expect such a read to return 0 bytes read, but io_getevents
> returns -310, which is suspiciously equal to (13002 - 13312).
>
> I attach a reproducer.
>
> 4.2.5-201.fc22.x86_64
>
> Are my expectations incorrect, or is this a bug in aio or xfs?

Your expectations are correct.  The bug was introduced by commit
9fe55eea7e4b4 (Fix race when checking i_size on direct i/o read).  I've
CC'd the patch author and linux-fsdevel.  I'm not sure what the right
fix is, given that the size checks were removed from the vfs to fix some
race condition.  Unfortunately, the commit message doesn't really do a
good job of explaining the race.  In order to save others time, here is
a good explanation of the problem that commit is meant to fix, along
with a reproducer:
  http://marc.info/?l=linux-fsdevel&m=138641356614458&w=2

Thanks for the great bug report, and sorry I have no solution to
proffer.

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
