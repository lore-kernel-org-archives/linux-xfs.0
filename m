Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Feb 2008 22:13:56 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1K6DnHY021612
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 22:13:53 -0800
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B14AE6CF52
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 22:14:14 -0800 (PST)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id ceIHLCrBxl4iy17y for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 22:14:14 -0800 (PST)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1JRZiu-0000QG-DW
	for <xfs@OSS.SGI.com>; Tue, 19 Feb 2008 21:09:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18363.17828.203778.110497@tree.ty.sabi.co.UK>
Date: Tue, 19 Feb 2008 21:09:56 +0000
Subject: Re: is xfs good if I have millions of files and thousands of hardlinks?
In-Reply-To: <47BADF75.2070004@wpkg.org>
References: <47BADF75.2070004@wpkg.org>
From: pg_xfs2@xfs2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

>>> On Tue, 19 Feb 2008 14:53:57 +0100, Tomasz Chmielewski
>>> <mangoo@wpkg.org> said:

mangoo> I have a ext3 filesystem with almost 200 million files
mangoo> (1.2 TB fs, ~65% full); most of the files are hardlinked
mangoo> multiple times, some of them are hardlinked thousands of
mangoo> times.

Lucky numbers! :-)

mangoo> In general, because new files and hardlinks are being
mangoo> added all the time and the old ones are being removed,
mangoo> this leads to a very, very poor performance.

That is not the cause of the poor performance. The ultimate
cause is rather different.

mangoo> When I want to remove a lot of directories/files (which
mangoo> will be hardlinks, mostly), I see disk write speed is
mangoo> down to 50 kB/s - 200 kB/s (fifty - two hundred
mangoo> kilobytes/s) - this is the "bandwidth" used during the
mangoo> deletion.

How is bandwidth relevant for that? OK that there are quotes,
but it seems very very stranget regardless.

mangoo> Also, the filesystem is very fragmented ("dd
mangoo> if=/dev/zero of=some_file bs=64k" writes only about 1
mangoo> MB/s).

Then more the merrier.

mangoo> Will xfs handle a large number of files, including lots
mangoo> of hardlinks, any better than ext3?

It shows consideration to consult the archives of a mailing list
before aking a question. It may be a good idea to do it even
after posting a question :-).
