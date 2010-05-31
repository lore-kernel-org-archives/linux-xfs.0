Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4VI2Oo3190029 for <xfs@oss.sgi.com>; Mon, 31 May 2010 13:02:25 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D479E9D300E
	for <xfs@oss.sgi.com>; Mon, 31 May 2010 11:07:03 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id rqWtGjRdoNQdYSpE for
	<xfs@oss.sgi.com>; Mon, 31 May 2010 11:07:03 -0700 (PDT)
Subject: Re: xfs_buf and buffercache/pagecache connection
From: Andi Kleen <andi@firstfloor.org>
References: <4C03E46B.9040407@ics.forth.gr>
Date: Mon, 31 May 2010 20:04:46 +0200
In-Reply-To: <4C03E46B.9040407@ics.forth.gr> (Yannis Klonatos's message of
	"Mon\, 31 May 2010 19\:31\:39 +0300")
Message-ID: <87aargt0ap.fsf@basil.nowhere.org>
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
To: Yannis Klonatos <klonatos@ics.forth.gr>
Cc: xfs@oss.sgi.com

Yannis Klonatos <klonatos@ics.forth.gr> writes:

>         I was looking to add a kernel hook to my system in order to
> monitor buffer-cache hit and misses. Initially I was
> planning to add my modifications to the __getblk(). However, i noticed
> that XFS does not directly use the buffer-cache
> for its pages but it seems to implement its own buffer.
>         What I am now looking for is 1) the place where XFS checks
> whether a page exists in its buffer or not and 2)
> what are the possible interactions between xfs_buf and the Linux
> kernel buffer-cache.
>         I would appreciate any information regarding the above issues.

The kernel does not track all accesses, e.g. through mmap.
So you can only get misses (which is essentially IO rate and already
accounted), but not hits.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
