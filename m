Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2E4257F86
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 20:25:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 052CE304039
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 18:25:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HCNe7hvGLV0Yxuuj for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 18:25:10 -0700 (PDT)
Date: Thu, 16 Jul 2015 11:25:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] OS X partial support
Message-ID: <20150716012508.GU3902@dastard>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
	<1436964412-12093-3-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436964412-12093-3-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 15, 2015 at 02:46:52PM +0200, Jan Tulak wrote:
> This patch introduces changes to support current OS X (10.10 Yosemite).
> The previous OS X code base is about 4 years old and both OS X and
> XFS changed, so there had to be done some work to make it compilable.
> 
> - Because some missing APIs in OS X (like fstab/mtab) and the
>   unability to mount XFS, not all tools are compiled.

hmmmm. We should still try to compile them, otherwise anyone
doing dev work on OS X is going to make changes that aren't
complete (i.e. cause compile errors on other platforms).

> - fls (find last bit) calls were moved to platform headers,
>   as OS X has a native implementation.

I think that's the wrong way to do this - this is what autoconf is
for. i.e. create a "HAVE_FLS" check, and surround the fls code
in bitops.h with "#ifndef HAVE_FLS"....

> - xfs_db currently has only a dummy timer implementation

xfs_repair, actually ;)

> - Various other edits  - some API translations, some, missing
>   defines.
> 
> The code compiles using Apple's clang, although it throws some
> warnings. Some of them are complaints about deprecated calls, some
> are false-positives and there are also some incompatible type
> assignments/comparisons, so there is a place for further patches.

Let's try and keep the changes within the darwin and autoconf code
as much as possible. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
