Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7400E7F3F
	for <xfs@oss.sgi.com>; Fri, 18 Oct 2013 17:45:30 -0500 (CDT)
Message-ID: <5261BA02.9050808@sgi.com>
Date: Fri, 18 Oct 2013 17:45:22 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support
	FALLOC_FL_COLLAPSE_RANGE for fallocate
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
	<52616EC6.7030400@sgi.com> <20131018224404.GX4446@dastard>
In-Reply-To: <20131018224404.GX4446@dastard>
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
Cc: Namjae Jeon <linkinjeon@gmail.com>, elder@kernel.org, tytso@mit.edu, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

Sorry if there are others please let me know.

On 10/18/2013 05:44 PM, Dave Chinner wrote:
> On Fri, Oct 18, 2013 at 12:24:22PM -0500, Rich Johnston wrote:
>> This has been committed.
>>
>> Thanks
>> --Rich
>>
>> commit e64190f8440286a815060524777b435e06a7b364
>> Author: Namjae Jeon <namjae.jeon@samsung.com>
>> Date:   Sun Oct 6 20:13:38 2013 +0000
>>
>>      [RESEND, 4/7] xfsprogs: xfsio: add support
>> FALLOC_FL_COLLAPSE_RANGE for fallocate
>
> Hi Rich,
>
> This isn't ready for being committed into xfsprogs. The kernel code
> is still under review, and until we actually have it in a tree to be
> merged int eh kernel, we shoul d't be making any userspace changes
> at all. Indeed, there's a chance (unlikely, but still there) that
> this code may still not end up in the kernel at all...
>
> So, it's probably best right now to revert this patch until we have
> the fallocate API support merged into the kernel...
>
> Cheers,
>
> Dave.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
