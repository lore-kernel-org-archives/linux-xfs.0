Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0LG3Bhn063103 for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 10:03:11 -0600
Received: from sycorax.lbl.gov (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E3F9148D05A
	for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 08:05:24 -0800 (PST)
Received: from sycorax.lbl.gov (sycorax.lbl.gov [128.3.11.121]) by
	cuda.sgi.com with ESMTP id D9kPMigTp6CHTtG7 for
	<xfs@oss.sgi.com>; Fri, 21 Jan 2011 08:05:24 -0800 (PST)
From: Alex Romosan <romosan@sycorax.lbl.gov>
Subject: Re: xfs used disk space bug in 2.6.38-rc1 (commit
	6e857567dbbfe14dd6cc3f7414671b047b1ff5c7)
References: <87zkqvtet2.fsf@sycorax.lbl.gov> <20110121034208.GZ16267@dastard>
Date: Fri, 21 Jan 2011 08:05:16 -0800
In-Reply-To: <20110121034208.GZ16267@dastard> (message from Dave Chinner on
	Fri, 21 Jan 2011 14:42:08 +1100)
Message-ID: <87bp3a8coz.fsf@sycorax.lbl.gov>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Dave Chinner <david@fromorbit.com> writes:

> When you quote a commit, can you please include the name of the
> commit. e.g:
>
> 6e85756 ("xfs: don't truncate prealloc from frequently accessed inodes")
>

sorry.

> Is the one with the known bug that causes excessive preallocation
> when files are zero sized. The candidate fix is here:
>
> http://oss.sgi.com/archives/xfs/2011-01/msg00281.html
>
> Can you see if that solves your problem?

i've tried it and disk usage is back to normal. thanks.

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
