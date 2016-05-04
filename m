Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BF4C7CA2
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 12:52:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06638AC001
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 10:52:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hEUg6ieJcQh7Iyrk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 10:52:05 -0700 (PDT)
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
	bio/request structs
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <572A36BF.3070208@redhat.com>
Date: Wed, 4 May 2016 12:51:59 -0500
MIME-Version: 1.0
In-Reply-To: <x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 05/03/2016 03:44 PM, Jeff Moyer wrote:
> mchristi@redhat.com writes:
> 
>> The following patches begin to cleanup the request->cmd_flags and
>> bio->bi_rw mess. We currently use cmd_flags to specify the operation,
>> attributes and state of the request. For bi_rw we use it for similar
>> info and also the priority but then also have another bi_flags field
>> for state. At some point, we abused them so much we just made cmd_flags
>> 64 bits, so we could add more.
>>
>> The following patches seperate the operation (read, write discard,
>> flush, etc) from cmd_flags/bi_rw.
>>
>> This patchset was made against linux-next from today April 15
>> (git tag next-20160415).
>>
>> I put a git tree here:
>> https://github.com/mikechristie/linux-kernel.git
>> The patches are in the op branch.
> 
> Hi, Mike,
> 
> That git tree doesn't seem to exist.  I did manage to apply your patch
> set on top of next-20160415, though.
> 
> So... what testing did you do? ;-) I ran into the following problems

I normally run xfstests and run it on my daily workstation and laptop. I
did not do this for every FS this time and hit a regression.

What FS were you using?

> - git clone fails
> - yum segfaults


In v7/v6, I missed a new submit_bio call, so I hit issues like the two
above. I have this fixed in the next version.

> - many blktrace/blkparse issues, including incorrect cpu recorded in
>   traces, null task names, and blkparse outputting nothing for a trace
>   file several gigabytes in size.

I will double check for these issues.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
