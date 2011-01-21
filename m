Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L2Ml3K192558 for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 20:22:48 -0600
Received: from sycorax.lbl.gov (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C910427C0ED
	for <xfs@oss.sgi.com>; Thu, 20 Jan 2011 18:25:06 -0800 (PST)
Received: from sycorax.lbl.gov (sycorax.lbl.gov [128.3.11.121]) by
	cuda.sgi.com with ESMTP id FOkE9HZgyyDgm4FZ for
	<xfs@oss.sgi.com>; Thu, 20 Jan 2011 18:25:06 -0800 (PST)
From: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit
	6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
References: <87zkqvtet2.fsf@sycorax.lbl.gov>
Date: Thu, 20 Jan 2011 18:25:05 -0800
In-Reply-To: <87zkqvtet2.fsf@sycorax.lbl.gov> (message from Alex Romosan on
	Thu, 20 Jan 2011 14:01:45 -0800)
Message-ID: <8739onro1q.fsf@sycorax.lbl.gov>
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
To: linux-kernel@vger.kernel.org
Cc: xfs@oss.sgi.com

Alex Romosan <romosan@sycorax.lbl.gov> writes:

> my home directory is using xfs and i noticed that when i try to compile
> a program or do any kind of disk access (like git pull, etc) the amount
> of space used jumps by tens of gigabytes causing the disk to seemingly
> become full (eventually). on reboot the used disk space goes back to the
> correct value. i did a 'git bisect start -- fs/xfs' and i tracked it
> down to commit 6e857567dbbfe14dd6cc3f7414671b047b1ff5c7. if i revert
> this patch then disk usage doesn't increase unexpectedly (i have 270GB
> free and the disk became full by simply trying to compile wine). i can
> try patches if somebody comes up with one.

actually, even with that patch reverted the disk usage still creeps up
eventually so something else is not quite right.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
