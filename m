Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA6HoCM0005625 for <xfs@oss.sgi.com>; Sat, 6 Nov 2010 12:50:12 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B51A1C1FCFE
	for <xfs@oss.sgi.com>; Sat,  6 Nov 2010 10:51:37 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id K7mDowoQWwqFcxY3 for
	<xfs@oss.sgi.com>; Sat, 06 Nov 2010 10:51:37 -0700 (PDT)
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/3] xfs: fix a few compiler warnings with
	CONFIG_XFS_QUOTA=n
References: <20101106114226.GA25395@infradead.org>
	<20101106114256.GC25395@infradead.org>
Date: Sat, 06 Nov 2010 18:51:29 +0100
In-Reply-To: <20101106114256.GC25395@infradead.org> (Christoph Hellwig's
	message of "Sat, 6 Nov 2010 07:42:56 -0400")
Message-ID: <87aalmtk66.fsf@basil.nowhere.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@infradead.org> writes:

> Andi Kleen reported that gcc-4.5 gives lots of warnings for him inside the
> XFS code.  It turned out most of them are due to the quota stubs beeing
> macros, and gcc now complaining about macros evaluating to 0 that are not
> assigned to variables.

Thanks. BTW I believe this was already fixed in my big warning patchkit
from some time ago, unfortunately that didn't make it in :-/

A gcc 4.6 build is also still incredibly noisy.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
