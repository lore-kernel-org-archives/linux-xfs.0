Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JGhiLq212779 for <xfs@OSS.SGI.com>; Tue, 19 Oct 2010 11:43:45 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FFD21518FDA
	for <xfs@OSS.SGI.com>; Tue, 19 Oct 2010 09:59:52 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 3Wv6nycwjBax1TSU
	for <xfs@OSS.SGI.com>; Tue, 19 Oct 2010 09:59:52 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1P8FI6-00014w-RP
	for <xfs@OSS.SGI.com>; Tue, 19 Oct 2010 17:43:58 +0100
Resent-Message-ID: <19645.51913.855447.116358@tree.ty.sabi.co.uk>
Message-ID: <19645.51908.711783.100399@tree.ty.sabi.co.uk>
Date: Tue, 19 Oct 2010 17:43:48 +0100
Resent-To: xfs@oss.sgi.com
Subject: Re: Performance degeneration issues
MIME-Version: 1.0
From: pg@xfs2.to.sabi.co.UK (Peter Grandi)
References: <2a05-4cbc6280-f8f-3364a400@207442557>
In-Reply-To: <2a05-4cbc6280-f8f-3364a400@207442557>
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
To: Linux XFS <xfs@oss.sgi.com>

> Hello, I'm running a Centos 5.4 x64 Server with Raid0 HDDs and
> XFS.

> Extracting a tar archive with 6.1 million files (avg. Size
> just below 2KiB)

Ah, one of the "the file system is an optimal small record DBMS"
sort of delusions.

> is blazingly fast after the fs has been generated. But after
> some time while doing deletes/moves (need to sort those files
> by their contents) the fs performance degenerates quite badly

Very funny. "the file system is an optimal small record DBMS"
sort of delusion, only squared/cubed.

It may be amusing to hear some explanation of what "sort those
files by their contents" actually is thought to mean here, as I
have the peculiar feeling that "sort" here actually means "sort
the directory entries" (as in "deletes/moves") instead of the
inodes or the file data, as if they were the same thing.

> 8k file writes/sec to about 200).

Why is this surprising?

> Is there any way I can find out what the issue is and how I
> can help it?

Some entry level tutorial on storage systems? Some introductory
book on DBMSes?

What most amuses or depresses me is that this question or a very
similar variants gets asked quite regularly in this (and other
filesystems oriented) mailing list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
