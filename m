Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751527AbdGYQ43 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Jul 2017 12:56:29 -0400
Subject: Re: [PATCH] xfs_db: fix metadump redirection (again)
References: <20170725162740.GP4352@magnolia>
 <917a7bd4-fe2d-3839-f20e-ec44b8291044@sandeen.net>
 <20170725164422.GQ4352@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6eaef6d8-66df-8997-f4d6-8bb26c6511d8@sandeen.net>
Date: Tue, 25 Jul 2017 11:56:28 -0500
MIME-Version: 1.0
In-Reply-To: <20170725164422.GQ4352@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>, anarchy@gentoo.org

On 07/25/2017 11:44 AM, Darrick J. Wong wrote:
> On Tue, Jul 25, 2017 at 11:32:23AM -0500, Eric Sandeen wrote:
>> On 07/25/2017 11:27 AM, Darrick J. Wong wrote:
>>> In patch 4944defad4 ("xfs_db: redirect printfs when metadumping to
>>> stdout"), we solved the problem of xfs_db printfs ending up in the
>>> metadump stream by reassigning stdout for the duration of a stdout
>>> metadump.  Unfortunately, musl doesn't allow stdout to be reassigned (in
>>> their view "extern FILE *stdout" means "extern FILE * const stdout"), so
>>> we abandon the old approach in favor of playing games with dup() to
>>> switch the raw file descriptors.
>>>
>>> While we're at it, fix a regression where an unconverted outf test
>>> allows progress info to end up in the metadump stream.
>>
>> "while we're at it" usually indicates the need for a separate patch ;)
> 
> Ok, though the "while we're at it" fix is only necessary if we keep the
> stdout redirection stuff.

It's just that that is a fix for the last patch, and the rest is a new approach
which is still under debate. </pedantic>
 
>> So what if we just converted dbprintf to do fprintf, with the destination
>> held in some global variable that metadump can change?   Seems like that
>> might be less tricksy, and xfs_db is no stranger to globals.
>>
>> there are about 5 bare printfs in xfs_db, but none should be encountered
>> during a metadump (well ... maybe the one in set_cur).
> 
> Less tricksy, but more of a maintenance burden for us, because now we
> can't ever allow printf() or fprintf(stdout) in any code path that gets
> called from metadump.  The reviewers will have to remember (and document
> for future reviewers).

Well, history shows that this isn't much of a problem.  There are over 500 calls
to dbprintf, and 6 to printf - including some which are probably appropriate,
i.e. to print version number and exit.

> OTOH, if we let printfs slip in to something that isn't called by
> metadump and then a later patch moves it into the metadump call graph,
> now we have a logic bomb that will manifest itself in silently corrupted
> metadumps again.
> 
> So that's why I went with playing games making stdout (or now just fd 1)
> dump to stderr -- the buffoonery required to make metadumping to stdout
> work properly is contained in db/metadump.c.

yeah, I can see that POV too.  I'll see if anyone else really cares one way
or another.

-Eric
