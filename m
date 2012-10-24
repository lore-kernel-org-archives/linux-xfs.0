Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9OKdp19053595 for <xfs@oss.sgi.com>; Wed, 24 Oct 2012 15:39:51 -0500
Message-ID: <508852D8.6060100@sgi.com>
Date: Wed, 24 Oct 2012 15:43:04 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] 251: Do not allow step to be zero
References: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
	<1350380494-17482-2-git-send-email-lczerner@redhat.com>
	<20121016201829.GK2739@dastard>
In-Reply-To: <20121016201829.GK2739@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Lukas,

On 10/16/2012 03:18 PM, Dave Chinner wrote:
> On Tue, Oct 16, 2012 at 11:41:34AM +0200, Lukas Czerner wrote:
>> Currently 'step' variable which is used as length of the range to
>> discard can be zero. However it would result in error returned by the
>> fstrim.
>>
>> Fix this by forcing 'step' to be at least 4KB.
>>
>> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
>
> Looks fine. It may not be perfect for large block filesystems (e.g.
> on ppc or ia64) but it's better than nothing right now.
>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
>

This has been committed to git://oss.sgi.com/xfs/cmds/xfstests, master 
and for-next branches.

Regards
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
