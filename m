Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 393E47F58
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:43:23 -0500 (CDT)
Message-ID: <522A4C79.1030200@sgi.com>
Date: Fri, 06 Sep 2013 16:43:21 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 31/55] libxfs: switch over to xfs_sb.c and remove
	xfs_mount.c
References: <1378332359-14737-1-git-send-email-david@fromorbit.com>
	<1378332359-14737-32-git-send-email-david@fromorbit.com>
	<522A1BCA.6010500@sgi.com> <20130906214021.GD12541@dastard>
In-Reply-To: <20130906214021.GD12541@dastard>
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
Cc: xfs@oss.sgi.com

On 09/06/13 16:40, Dave Chinner wrote:
> On Fri, Sep 06, 2013 at 01:15:38PM -0500, Mark Tinguely wrote:
>> On 09/04/13 17:05, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Now that the kernel code has split the superblock specific code out
>>> of xfs_mount.c, we don't need xfs_mount.c anymore. Copy in xfs_sb.c
>>> and remove xfs_mount.c
>>>
>>> Signed-off-by: Dave Chinner<dchinner@redhat.com>
>>> ---
>>
>> user equivalent of the for Linux 3.12 kernel patch 20/49.
>> This patch leaves xfs_sb.c/xfs_sb.h difference.
>>
>> For example in xfs_sb.h the user header is missing the project inode
>> test in xfs_is_quota_inode().
>>
>> Shouldn't xfs_sb.[ch] synced to the kernel files at this point?
>
> No, they don't end up perfectly synced because of the different
> error messages in the code and some of the checks aren't relevant to
> userspace. Looks like there's some new whitespace differences, and
> that I missed a pquota change as well. I'll send a new version later
> today.
>
> Cheers,
>
> Dave.

Okay. Thanks for the work. We can bring that series in early next week.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
