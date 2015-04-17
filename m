Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 94A577F3F
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 02:15:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EA2BAC001
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 00:15:23 -0700 (PDT)
Received: from mail-qk0-f178.google.com (mail-qk0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	mPeDBH27rRNzqB9c (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Apr 2015 00:15:22 -0700 (PDT)
Received: by qkgx75 with SMTP id x75so138569887qkg.1
	for <xfs@oss.sgi.com>; Fri, 17 Apr 2015 00:15:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150417040605.GE15810@dastard>
References: <1429237344-5668-1-git-send-email-xuw2015@gmail.com>
	<20150417040605.GE15810@dastard>
Date: Fri, 17 Apr 2015 15:15:21 +0800
Message-ID: <CAPBX1xK85i8x3h1XmGsYi=0YvRiWqvKhFTOY-QJ3-XDtmm7BVg@mail.gmail.com>
Subject: Re: [PATCH] xfs: use percpu_counter_compare instead of naive comparing
From: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
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

On Fri, Apr 17, 2015 at 12:06 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Apr 17, 2015 at 10:22:24AM +0800, xuw2015@gmail.com wrote:
>> From: George Wang <xuw2015@gmail.com>
>>
>> Function percpu_counter_read just return the current counter, regardless of
>> every cpu's count. This counter can be negative value, which will cause the
>> checking of "allocated inode counts <= m_maxicount" false positive.
>
> Have you actually seen this, or is it just theoretical?

I produced it by running unionmount-testsuites for overlay, based xfs as upper
and lowerdir. I think I can extract the procedure to reproduce it.

>> Commit 501ab3238753 "xfs: use generic percpu counters for inode counter
<snip>
> The correct fix is to use percpu_counter_read_positive(), because in
> the majority of cases args.mp->m_maxicount is orders of magnitude
> larger (20 million inodes per 100GB of fs space for small filesystems)
> than the unaggregated per-cpu counts can cause the sum to go
> negative. Hence if it is negative, it may as well be zero because it
> makes no difference to the default threshold configurations.

Thanks for the explanation, and I agree that totally.
Besides, shall we use the exact count in xfs_fs_counts? Because it's a ioctl
function, not so much sensitive performance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
