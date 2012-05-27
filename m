Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4RJNjp6001703 for <xfs@OSS.SGI.com>; Sun, 27 May 2012 14:23:45 -0500
Received: from ukmrpl001.it.hutchison3g.net (ukmrpl001.threembb.net
	[217.171.136.35]) by cuda.sgi.com with SMTP id bIB69v6VqqDiuCwD
	for <xfs@OSS.SGI.com>; Sun, 27 May 2012 12:23:43 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.76 #1) id 1SYj5B-00037c-9w
	for <xfs@OSS.SGI.com>; Sun, 27 May 2012 20:24:29 +0100
MIME-Version: 1.0
Message-ID: <20418.32645.163950.842794@tree.ty.sabi.co.UK>
Date: Sun, 27 May 2012 20:24:29 +0100
Subject: Re: very slow file deletion on an SSD
In-Reply-To: <4FC26101.2050003@gmail.com>
References: <4FBF60D1.80104@gmail.com> <20120526231838.GR25351@dastard>
	<4FC16683.9060800@gmail.com> <20120527000701.GS25351@dastard>
	<4FC18845.6030301@gmail.com> <4FC19408.5020502@sandeen.net>
	<CAAxjCEzX4dmm6YuR__1_a6mw+D=vizV0VrCLqCC-d5GSgkbE6g@mail.gmail.com>
	<1338124504.28212.255.camel@oxygen.netxsys.com>
	<5856C5F0-C13E-415D-907B-491C1BBCC0C2@gmail.com>
	<4FC25126.7070002@sandeen.net> <4FC26101.2050003@gmail.com>
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

[ ... 2s CPU time to delete a file ... ]

> [root@siFlash test]# filefrag  1.r.48.0
> 1.r.48.0: 1364 extents found

>> It's not addressing the exact issue, but why are the files so
>> fragmented?  Are they very hole-y or is it just an issue with
>> how they are written?  Perhaps preallocation would help you
>> here?

That's not that fragmented, and I am a bit surprised that it
takes 2s of CPU time to delete a bit over 1,000 extents (unless
there is a repeated linear search). I have seen over 800,000
extents in a file created on XFS by someone who thought it was a
fine idea to have sparse virtual disk images, especially for a
rapidly growing Maildir archive...

[ ... ]

> So to summarize, the delete performance will be (at least) in
> part a function of the fragmentation? [ ... ] A directory
> full of massively fragmented files will take longer to delete
> than a directory of contiguous and larger extents?

The list of extents is part of filesystem metadata. It's also
what happens with traditional designs with block-tree based
filesystem, deleting a large 3 level tree of blocks can take a
very long time (but mostly seeks, not CPU).

> And I did some experimentation using xfs_repair, and it seems to
> be the case there as well ... the higher level of fragmentation,
> the longer the repair seems to take.

That's expected too: more metadata to verify.

In some way a file over many extents behaves like a non-extent
based file.

The special detail about many extents and XFS is that XFS loads
and keeps in memory the entire extent table on filen open. This to
me seems a reasonable design choice, as XFS tries pretty hard to
ensure that files have few extents or offers applications ways
(that probably few applications use) to improve the chances of
that happening.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
