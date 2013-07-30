Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E57B97CBF
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 19:30:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D6001304075
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 17:30:06 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5bukpKR0OCF5R6kO for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 17:30:05 -0700 (PDT)
Date: Tue, 30 Jul 2013 10:30:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
Message-ID: <20130730003000.GI13468@dastard>
References: <1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com> <51F2E011.5020904@gmail.com>
	<51F2E4DD.4020301@sgi.com> <20130727015822.GV13468@dastard>
	<51F41250.9010703@sgi.com> <20130728011255.GY13468@dastard>
	<51F678F4.2020003@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F678F4.2020003@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Mon, Jul 29, 2013 at 09:15:16AM -0500, Mark Tinguely wrote:
> On 07/27/13 20:12, Dave Chinner wrote:
> >On Sat, Jul 27, 2013 at 01:32:48PM -0500, Mark Tinguely wrote:
> >>On 07/26/13 20:58, Dave Chinner wrote:
> >>>On Fri, Jul 26, 2013 at 04:06:37PM -0500, Mark Tinguely wrote:
> >>>>
> >>>>I can reproduce a problem in patch 44 too. It takes my copy test 20
> >>>>minutes to deplete the log space with patch 44, Same test with patch
> >>>>43 has been running a day and a half. I do not think that patch 44
> >>>>is 100 times faster than patch 43 but I will let patch 43 spin all
> >>>>weekend on a couple machines to verify that patch 43 does not hang.
> >>>
> >>>Details, please. What's your "copy test"?
....
> >>Micheal found the problem using a simple copy, so I am using copy-like test.
> 
> BTW, the long term run of the copy.pl from bug 922 with patch 43 results:
>  tail            0x601000055d7
>  grant/reserve   0x60100abb200
>  ctx t_unit_res  0x834
> 
> My log math may be off, tail/reserve diff is 1024, but the CTX holds
> more than that (2100 bytes).
> 
> Looking at patch 44, it is the first time we use the calculation for
> the number of bytes in patch 43. So I am looking at where the new
> calculation in iop_size differs from the previous len calculation in
> xlog_cil_prepare_log_vecs(). So far, I am that inode entry is 140
> bytes larger with the new calculation (former len 164 vrs new nbytes
> 304 type 123b - non-crc filesystem).

Which size calculation is wrong? t~he one used to size the buffer
being allocated - which is intentionally oversized for the inode
forks - or the actual size formatted into the buffer, which was
unchanged?

I mean, 164 bytes is an inode core (96 bytes) plus a inode log
format structure. The increase of 140 bytes indicates that we are
logging roughly the entire 256 byte inode - i.e. both forks.

But are you looking at the size returned by iop_size or iop_format?
iop_size will be new, iop_format is unchanged by this patchset.
indeed, what iop_format returns as vectors is *unchanged* by this
patchset, so I think that you are chasing down the wrong path here.

> I will see if I can substitute the nbytes for len (without
> triggering the ptr being exceeded assert) to see that will cause the
> hang.

I know what the problem is will be, and that won't fix it. Hint: the
buffer is over sized.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
