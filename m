Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C8EEC7F37
	for <xfs@oss.sgi.com>; Sat, 11 May 2013 19:40:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8937D8F8037
	for <xfs@oss.sgi.com>; Sat, 11 May 2013 17:40:34 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SM9WhSj5idyMYGys for <xfs@oss.sgi.com>;
	Sat, 11 May 2013 17:40:32 -0700 (PDT)
Date: Sun, 12 May 2013 10:40:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_efi_item slab corruption. (v3.9-10936-g51a26ae)
Message-ID: <20130512004031.GE32675@dastard>
References: <20130507133707.GA18301@redhat.com>
 <87k3n5en0b.fsf@openvz.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87k3n5en0b.fsf@openvz.org>
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
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sat, May 11, 2013 at 04:09:40PM +0400, Dmitry Monakhov wrote:
> On Tue, 7 May 2013 09:37:07 -0400, Dave Jones <davej@redhat.com> wrote:
> > started compiling a kernel, and then...
> > 
> I've bisected this one.
> commit 666d644cd72a9ec58b353209ff191d7430f3b357
> Author: Dave Chinner <dchinner@redhat.com>
> Date:   Wed Apr 3 14:09:21 2013 +1100
> 
>     xfs: don't free EFIs before the EFDs are committed
> 
> #xfstests  ./check generic/007 generic/007 generic/007

Yuo, we already have a candidate fix for it. Thanks for another
independent confirmation of the cause, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
