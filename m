Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9E8197CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 15:53:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F132304043
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 13:53:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jZoOfH8Hmk95h88E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 13:53:07 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: vfs/xfs: directio updates to ease COW handling V2
References: <1454524816-11392-1-git-send-email-hch@lst.de>
	<x49zivhy3zt.fsf@segfault.boston.devel.redhat.com>
	<20160203200159.GK20038@birch.djwong.org>
Date: Wed, 03 Feb 2016 16:53:04 -0500
In-Reply-To: <20160203200159.GK20038@birch.djwong.org> (Darrick J. Wong's
	message of "Wed, 3 Feb 2016 12:01:59 -0800")
Message-ID: <x49twlpxxz3.fsf@segfault.boston.devel.redhat.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> On Wed, Feb 03, 2016 at 02:43:02PM -0500, Jeff Moyer wrote:
>> Hi, Christoph,
>> 
>> Can you explain a bit what you mean by easing COW handling?  Whenever I
>> see COW referenced near DIO, my mind always turns to g_u_p vs. fork.
>
> Just to clarify, I'm talking about copy on write for disk blocks, not for
> memory pages.
>
> Basically, XFS implements (disk block) copy on write for (perfectly block
> aligned) directio writes by allocating a set of replacement blocks, mapping the
> dio writes to the new blocks, and playing a punch/remap trick to map the new
> blocks into the file at the appropriate offset.
>
> If the write fails then we don't want do the remap, so the dio_complete handler
> has to know whether or not the IO succeeded, hence the new parameter.
> Furthermore, if the write succeeds but the remap fails, we also want to be able
> to report that to userspace, hence the change of return value from void to int.
>
> (If the dio write isn't block aligned, we fall back to the page cache.)
>
> Hope that helps,

Eric said the magic word: reflink.  I think I've got it now.

Thanks!
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
