Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CF1EE7F6A
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 15:41:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB4D98F806F
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 13:41:28 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WSJ1ud9cBDF0cbwB for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 13:41:27 -0700 (PDT)
Date: Thu, 10 Oct 2013 07:41:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 02/32] libxfs: fix missing filetype updates to xfs_dir2.c
Message-ID: <20131009204123.GH4446@dastard>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-3-git-send-email-david@fromorbit.com>
	<52548CF2.2040000@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52548CF2.2040000@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Tue, Oct 08, 2013 at 05:53:38PM -0500, Eric Sandeen wrote:
> On 9/29/13 10:15 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > They were missed in the original patch that was committed.
> 
> I'm not sure it's required in lookup or remove, at least today
> nothing looks at it on those paths, does it?

Correct, but...

> Anyway, matches kernel, at worst the last 2 are harmless:

... matching the kernel code is more important at this point.

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
