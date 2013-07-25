Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 241477F37
	for <xfs@oss.sgi.com>; Thu, 25 Jul 2013 10:02:44 -0500 (CDT)
Message-ID: <51F13E10.1010805@sgi.com>
Date: Thu, 25 Jul 2013 10:02:40 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com> <20130725002108.GA11222@dastard>
In-Reply-To: <20130725002108.GA11222@dastard>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On 07/24/13 19:21, Dave Chinner wrote:
> On Wed, Jul 24, 2013 at 08:28:42AM -0500, Mark Tinguely wrote:
>> If you could please redo the test and get the stack traces with
>> /proc/sysrq-trigger and if you kernel works with crash, a core dump.
>> For the stack trace, I mostly want to know if it has several
>> "xlog_grant_head_wait" entries in it, because ...
>>
>> ...I seemed to have triggered a couple log space reservation hangs
>> with fsstress one XFS partition and a mega-copy on another
>> partition, but will have to graft the new XFS tree onto a Linux 3.10
>> kernel to get crash (and one of my sata controllers) to work again.
>
> They are unrelated to this patchset.
>
> Somewhere in the code there
> is a mismatch between what we reserve as the base requirement for an
> actual log write and what the CIL actually steals, and that is, most
> likely, what is leading to log hangs.
>
> This is demonstratable in the fact that generic/070 on 512 byte
> block size filesystems regularly hits a transaction reservation
> exhausted assert failure on transaction commit of the periodic log
> dummy transaction on my test rigs.
>
> Cheers,
>
> Dave.

In testing patch 44, I did not trip over any cil stealing asserts before 
the hang. I think the cil steal assert is a different and a legitimate 
complaint. When I tripped over the ASSERT in with the v3 inode enabled, 
the writeid only reserves space for the sb but there were occasions of 
root btree and attribute fork entry that were also logged.

patch 43 runs for hours without incident. Previous to this series, I ran 
the same tests with parent pointer testing with much higher log 
reservations for day or two and never got a hang.

I tested patch 44 with copy like tests and both times it hung both times 
- not a convincing number of tests. A quick look, I see an empty AIL, 
empty CIL, the CTX is using 0 bytes, doesn't look like there are any cil 
pushes going nor any older ctx, the ctx has an empty ticket reservation. 
The log tail is  0xd000014d7 and reserve/grant is 0xe00204d04. The next 
reservation is for a rename transaction that uses just over the log 
space left. There has to be a log space leak. I will go back patch 43 on 
one machine and patch 44 on another and make sure it is patch 44 is 
causing the problem.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
