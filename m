Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 10:29:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FHTjWt022119
	for <linux-xfs@oss.sgi.com>; Fri, 15 Jun 2007 10:29:46 -0700
Message-ID: <4672C531.9020802@sandeen.net>
Date: Fri, 15 Jun 2007 11:58:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr - problem with open files possible?
References: <200706151804.43067.Martin@lichtvoll.de>
In-Reply-To: <200706151804.43067.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com

Martin Steigerwald wrote:

> Could data loss happen when running xfs_fsr on files that are opened by an 
> application?

It should not; fsr performs a lot of safety checks and aborts under
problematic circumstances.  It will skip files if:

 * mandatory locks are present
 * file is marked immutable, append-only, or nodefrag
 * filesystem is shut down
 * change/modify times have been altered since defrag started
 * original file is mmapped

If you can clearly recreate it with xfs_fsr, it would be interesting to
compare the good & bad index files to see how they differ, it might
offer a clue as to what/why/how it changed.

> I did not came across any other corrupted files except a Mercurial 
> repository. I can not pinpoint this problem to XFS at all and have no 
> idea how and when it got corrupted. At least in my backup from some weeks 
> ago the repository has been okay. Unfortunately I do not know anymore 
> whether I made a commit to that repository while xfs_fsr was running or 
> not. But I think I didn't.
> 
> The filesystem itself was okay after fragmentation, I checked it via 
> xfs_check!
> 
> I can try to reproduce the problem. Would be handy tough to have an 
> xfs_fsr that can be limited only to operate on a certain directory and 
> its files and sub directories. This way I could create a new mailfolder, 
> copy some mails in there, have it opened so that KMail accesses the index 
> file and let xfs_fsr only run on this mailfolder.

>From the man page:

 Files marked as no-defrag will be skipped. The xfs_io(8) chattr command
 with the f attribute can be used to set or clear this flag.  Files  and
 directories created in a directory with the no-defrag flag will inherit
 the attribute.

so you can flag your mail directory or index files as no-defrag if you
like.  (I know this is the converse of what you wanted... but maybe helpful)

-Eric

> I can also open a bug report, but I first wanted to ask here.
> 
> Regards,
