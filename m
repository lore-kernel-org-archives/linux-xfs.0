Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6EC6D7F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:51:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0A2F3AC007
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 13:51:12 -0700 (PDT)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id 48ZklnqCBBGPeqzR for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 13:51:08 -0700 (PDT)
Message-ID: <514B72B9.1010005@jan-o-sch.net>
Date: Thu, 21 Mar 2013 21:51:05 +0100
From: Jan Schmidt <list.xfs@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add execution of a custom command to fsstress
	(-x and -X options)
References: <1363863585-25598-1-git-send-email-list.xfs@jan-o-sch.net>
	<20130321195054.GO17758@dastard>
In-Reply-To: <20130321195054.GO17758@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com



On 21.03.2013 20:50, Dave Chinner wrote:
> On Thu, Mar 21, 2013 at 11:59:45AM +0100, Jan Schmidt wrote:
>> From: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>
>> This patch adds execution of a custom command in the middle of all fsstress
>> operations. Its intended use is the creation of snapshots in the middle of a
>> test run.
> 
> Why do you need fsstress to do this? Why can't you just run fsstress
> in the background and run a loop creating periodic snapshots in the
> control script?

Because I want reproducible results. Same random seed should result in
the very same snapshots being created.

> Also, did you intend that every process creates a snapshot? i.e. it
> looks lik eif you run a 1000 processes, they'll all run a snapshot
> operation at X operations? i.e. this will generate nproc * X
> snapshots in a single run. This doesn't seem very wise to me....

Agreed, I haven't thought of running more than one process. For the sake
of reproducibility, I wouldn't want multiple processes for my test case
either.

I'm not sure if there are other applications than snapshot creation for
such a feature, so I cannot argue whether to have each process execute
such a command or not.

Thanks,
-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
