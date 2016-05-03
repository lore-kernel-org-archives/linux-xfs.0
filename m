Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9C5387CA6
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 15:44:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 629EE8F8033
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 13:44:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gCrUqChFwDttQ6kr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 13:44:08 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
	bio/request structs
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
Date: Tue, 03 May 2016 16:44:02 -0400
In-Reply-To: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	(mchristi@redhat.com's message of "Fri, 15 Apr 2016 14:15:35 -0500")
Message-ID: <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
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
To: mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

mchristi@redhat.com writes:

> The following patches begin to cleanup the request->cmd_flags and
> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
> attributes and state of the request. For bi_rw we use it for similar
> info and also the priority but then also have another bi_flags field
> for state. At some point, we abused them so much we just made cmd_flags
> 64 bits, so we could add more.
>
> The following patches seperate the operation (read, write discard,
> flush, etc) from cmd_flags/bi_rw.
>
> This patchset was made against linux-next from today April 15
> (git tag next-20160415).
>
> I put a git tree here:
> https://github.com/mikechristie/linux-kernel.git
> The patches are in the op branch.

Hi, Mike,

That git tree doesn't seem to exist.  I did manage to apply your patch
set on top of next-20160415, though.

So... what testing did you do? ;-) I ran into the following problems:
- git clone fails
- yum segfaults
- many blktrace/blkparse issues, including incorrect cpu recorded in
  traces, null task names, and blkparse outputting nothing for a trace
  file several gigabytes in size.

After that, I decided to back out your patches and test the base
linux-next kernel.  That kernel has none of those issues.

So, either I'm missing some dependencies, or I think we've got some
issues to iron out before this thing goes in.  Before I dig any further,
am I missing something?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
