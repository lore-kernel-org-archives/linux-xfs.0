Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C79F7CA0
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 13:04:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3DF84304064
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 11:04:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ytEctfr3wC2FDJd2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 11:04:49 -0700 (PDT)
Subject: Re: [PATCH 00/42] v7: separate operations from flags in the
	bio/request structs
References: <1460747777-8479-1-git-send-email-mchristi@redhat.com>
	<x49d1p2c1nx.fsf@segfault.boston.devel.redhat.com>
	<572A36BF.3070208@redhat.com>
	<x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
From: Mike Christie <mchristi@redhat.com>
Message-ID: <572A39BD.8020405@redhat.com>
Date: Wed, 4 May 2016 13:04:45 -0500
MIME-Version: 1.0
In-Reply-To: <x49a8k5aen2.fsf@segfault.boston.devel.redhat.com>
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

On 05/04/2016 12:58 PM, Jeff Moyer wrote:
> Mike Christie <mchristi@redhat.com> writes:
> 
>> On 05/03/2016 03:44 PM, Jeff Moyer wrote:
>>> Hi, Mike,
>>>
>>> That git tree doesn't seem to exist.  I did manage to apply your patch
>>> set on top of next-20160415, though.
>>>
>>> So... what testing did you do? ;-) I ran into the following problems
>>
>> I normally run xfstests and run it on my daily workstation and laptop. I
>> did not do this for every FS this time and hit a regression.
>>
>> What FS were you using?
> 
> I'm using xfs, scsi disk, no blk-mq, no dm.
> 
>>> - git clone fails
>>> - yum segfaults
>>
>> In v7/v6, I missed a new submit_bio call, so I hit issues like the two
>> above. I have this fixed in the next version.
> 
> OK, does this mean you're posting another version, or you already did
> and I somehow missed it?
> 

I did not repost yet. I am still testing. Jens had me add some wrappers
around the operation access, so because of my last screw up and the
wrapper change affected all my patches I am redoing all my testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
