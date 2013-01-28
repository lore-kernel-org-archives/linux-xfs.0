Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6D83E7F4C
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 20:41:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 399AE8F8039
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 18:41:37 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id xkZqUMl0hP2EsG1R for
	<xfs@oss.sgi.com>; Sun, 27 Jan 2013 18:41:36 -0800 (PST)
Subject: Re: [PATCH 2/8] libxfs: initialize xfs_alloc_arg structures
References: <1359240032-11576-1-git-send-email-sandeen@redhat.com>
	<1359240032-11576-3-git-send-email-sandeen@redhat.com>
	<20130128003542.GB16727@disturbed.disaster>
From: Eric Sandeen <esandeen@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20130128003542.GB16727@disturbed.disaster>
Message-Id: <FE50BC18-140F-43E6-848A-EE4C9B79C9FC@redhat.com>
Date: Sun, 27 Jan 2013 21:41:28 -0500 (EST)
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
Cc: Eric Sandeen <sandeen@redhat.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Jan 27, 2013, at 8:38 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Sat, Jan 26, 2013 at 04:40:26PM -0600, Eric Sandeen wrote:
>> This is a merge-to-userspace of kernel commit a0041684
>> xfs: zero allocation_args on the kernel stack
>> 
>> When calling xfs_alloc_vextent args.userdata was uninitialized,
>> and if we had args.type==XFS_ALLOCTYPE_START_BNO, this uninit
>> structure member got tested, leading to some random allocator
>> behavior.
> 
> Got that as part of the kernel-user sync I sent out a couple of
> weeks back.
> 
> BTW, perhaps we want to get that sync sorted out before shovelling
> a bunch of stuff into xfsprogs that will require fixing conflicts in
> that sync up?
> 
I have no problem with this going 2nd, I can fix up as needed.

-Eric

> Chers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
