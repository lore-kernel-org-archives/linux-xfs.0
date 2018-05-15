Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38982 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752009AbeEODOW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 May 2018 23:14:22 -0400
Subject: Re: [PATCH] xfs_db: add blockget -L option
References: <20180510213636.GA5045@deer-run.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3ae25107-7242-a645-c0f7-784f35ed3e79@sandeen.net>
Date: Mon, 14 May 2018 22:14:20 -0500
MIME-Version: 1.0
In-Reply-To: <20180510213636.GA5045@deer-run.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hal@deer-run.com, linux-xfs@vger.kernel.org



On 5/10/18 4:36 PM, hal@deer-run.com wrote:
> From: Hal Pomeranz <hal@deer-run.com>
> 
> Allow blockget on a mounted file system or "dirty" file system image
> with pending log entries-- by simply ignoring the log.  This makes
> xfs_db more useful for forensics where we are often dealing with these
> types of images.  Flushing log entries to disk by mounting/unmounting
> the file system would allow us to use blockget, but would make changes
> to the file system state which are not desirable in forensics contexts.
> 
> Signed-off-by: Hal Pomeranz <hal@deer-run.com>

Well, I'm back on the fence about this one; I know I steered you in
this direction, but after talking to dchinner a bit, he raised some valid
concerns about adding an option which essentially makes the tool behave
in unpredictable ways (by trying to traverse an inconsistent filesystem).

I had jumped to the conclusion that the usecase was for examining an
offline filesystem image without needing to perturb it by replaying the
log; Dave pointed out that you're talking about using this on a live
filesystem, and even baking this behavior into other higher level tools.
That kind of opened my eyes to all the ways this can go wrong.  :(

Thus spake Dave:

> IMO, the only thing worse than not having a forensic tool for a
> specific job is having a forensic tool provided by a trusted toolkit
> whose results are unreliable and cannot be trusted....

...

> I'd suggest, in that case, that you limit it's use to off-line or
> read-only snapshots of online filesystems? This would mean that the
> results of xfs_db operations (while eceedingly slow) will be
> reliable.

And in both of those cases, you won't need to ignore a dirty log.
Especially with teh express stated purpose of examining live
filesystems, I really hate to give you this much rope.

Stuff like parent pointers and fsmap are (eventually) going to give
you a much better way to achieve what (I think) you want, here.

-Eric
