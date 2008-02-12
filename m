Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Feb 2008 16:03:45 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1C03chj021156
	for <xfs@oss.sgi.com>; Mon, 11 Feb 2008 16:03:40 -0800
Message-ID: <47B0E26D.7070807@sgi.com>
Date: Tue, 12 Feb 2008 11:03:57 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Restoring damaged incremental XFS dump?
References: <1202769551.16458.1236311973@webmail.messagingengine.com>
In-Reply-To: <1202769551.16458.1236311973@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Felix E. Klee" <felix.klee@inka.de>
Cc: xfs@oss.sgi.com

Felix E. Klee wrote:
> I wonder whether I should use xfsdump as a replacement for a more
> traditional incremental backup solution centered around the TAR archiver
> STAR.  The advantage of STAR seems to be that files can also be
> recovered even if, for example, the level 0 dump is damaged.  After all,
> one is dealing with TAR, a pretty transparent archive format. The
> advantage of xfsdump is that it creates true snapshots.
>
I'm not sure what you mean by "true snapshots".
I wouldn't really call it snapshots as in what you could get if you
froze the filesystem etc..
But I presume you are meaning how it tries to store all the xfs
supported information including extended attributes, extended inode attributes,
holes, etc...

> So, what happens when the level 0 dump created with xfsdump becomes
> damaged.  Will I still be able to recover some files?  What about files
> from >0 dumps?
> 
Yes you will still be able to restore stuff.
However, it is in its own format so only xfsrestore will be able to do your
restoring.
Dumps are separated into what it calls media files which are meant to
be self containing. So damage to 1 theoretically shouldn't prevent restoring
from another media file.
Multiple media files are normally only used for tape (only 1 used for a dump
to a file).
And an incremental dump should also be able to be restored in isolation
and there are some QA tests (in xfs-cmds/xfstests) that test this.

--Tim
