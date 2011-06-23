Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5NHT08P202154 for <xfs@oss.sgi.com>; Thu, 23 Jun 2011 12:29:00 -0500
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
Date: Thu, 23 Jun 2011 10:27:26 -0700
In-Reply-To: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
	(Maarten Lankhorst's message of "Thu, 23 Jun 2011 18:55:29 +0200")
Message-ID: <m2boxocvb5.fsf@firstfloor.org>
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
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alex Elder <aelder@sgi.com>

Maarten Lankhorst <m.b.lankhorst@gmail.com> writes:

> gcc with -Warray-bounds generates a false positive on this
> since xfs defines the struct with u8 name[1]; to be able to
> add a tag at the end.

A better way would be to define it as name[0]. Then the compiler
would know it's a VLA. You may need to check noone relies on
the one byte though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
