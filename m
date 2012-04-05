Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q35N7Wl1086729 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 18:07:32 -0500
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	UVUilQBnP8Cq5BrD for <xfs@oss.sgi.com>;
	Thu, 05 Apr 2012 16:07:30 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4F58EC1A00C98A65 for xfs@oss.sgi.com; Fri, 6 Apr 2012 00:07:29 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SFvMT-0006k9-Q6
	for <xfs@oss.sgi.com>; Thu, 05 Apr 2012 23:41:01 +0100
MIME-Version: 1.0
Message-ID: <20350.8061.666667.868017@tree.ty.sabi.co.UK>
Date: Thu, 5 Apr 2012 23:41:01 +0100
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
In-Reply-To: <20349.63706.913104.777446@tree.ty.sabi.co.UK>
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20349.63706.913104.777446@tree.ty.sabi.co.UK>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

> Apparently not many people have figured out in the Linux
> culture that general purpose filesystems cannot handle well
> large groups of small files, and since the beginning of
> computing various forms of "aggregate" files have been used
> for that, like 'ar' ('.a') files from UNIX, which should have
> been used far more commonly than has happened, and never mind
> things like BDB/GDBM databases.

As to this, another filesystem strongly oriented at massive
streaming, Lustre, is sometimes used for small-file workloads,
and one of the suggestions given for that is to put the small
files inside an 'ext2' filesystem in a file, and mount it via
'loop'.  That is to use 'ext2' (or some other filesystem type)
as an archive format. That is less crazy than it seems.

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
