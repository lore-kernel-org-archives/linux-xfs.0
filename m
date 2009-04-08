Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n38HXJKt107706 for <xfs@oss.sgi.com>; Wed, 8 Apr 2009 12:33:29 -0500
Received: from sj-iport-3.cisco.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D65C2140656D
	for <xfs@oss.sgi.com>; Wed,  8 Apr 2009 10:34:10 -0700 (PDT)
Received: from sj-iport-3.cisco.com (sj-iport-3.cisco.com [171.71.176.72]) by
	cuda.sgi.com with ESMTP id ZSEDhQXTUjirZgm0 for
	<xfs@oss.sgi.com>; Wed, 08 Apr 2009 10:34:10 -0700 (PDT)
From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 4/6] xfs: use memdup_user()
References: <49DC4CC0.9050805@cn.fujitsu.com> <49DC4D54.3020001@cn.fujitsu.com>
	<20090408132254.GA5957@infradead.org>
Date: Wed, 08 Apr 2009 10:31:25 -0700
In-Reply-To: <20090408132254.GA5957@infradead.org> (Christoph Hellwig's
	message of "Wed, 8 Apr 2009 09:22:54 -0400")
Message-ID: <adabpr76oia.fsf@cisco.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

 > wouldn't NULL be a better error return for this kind of interface,
 > matching kmalloc?

I guess returning an error code from memdup_user() lets callers
distinguish between ENOMEM and EFAULT.  Not sure if that's important or
not but there probably are at least some sites that care.

 - R.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
