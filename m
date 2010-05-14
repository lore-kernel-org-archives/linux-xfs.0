Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4EKXsLB042467 for <xfs@oss.sgi.com>; Fri, 14 May 2010 15:33:55 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01F1113DBB05
	for <xfs@oss.sgi.com>; Fri, 14 May 2010 13:36:08 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id NymFBzQF1BQrwWZZ for
	<xfs@oss.sgi.com>; Fri, 14 May 2010 13:36:08 -0700 (PDT)
Subject: Re: Defrag in shrinkers
From: Andi Kleen <andi@firstfloor.org>
References: <1273821863-29524-1-git-send-email-david@fromorbit.com>
	<alpine.DEB.2.00.1005141244380.9466@router.home>
Date: Fri, 14 May 2010 22:36:03 +0200
In-Reply-To: <alpine.DEB.2.00.1005141244380.9466@router.home> (Christoph
	Lameter's message of "Fri\, 14 May 2010 12\:46\:52 -0500 \(CDT\)")
Message-ID: <87y6fmmdak.fsf@basil.nowhere.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Lameter <cl@linux.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, Pekka Enberg <penberg@cs.helsinki.fi>, linux-fsdevel@vger.kernel.org

Christoph Lameter <cl@linux.com> writes:

> Would it also be possible to add some defragmentation logic when you
> revise the shrinkers? Here is a prototype patch that would allow you to
> determine the other objects sitting in the same page as a given object.
>
> With that I hope that you have enough information to determine if its
> worth to evict the other objects as well to reclaim the slab page.

I like the idea, it would be useful for the hwpoison code too,
when it tries to clean a page.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
