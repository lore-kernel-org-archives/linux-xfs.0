Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FESCXX016873 for <xfs@OSS.SGI.com>; Sun, 15 Mar 2009 09:28:32 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A11919A3B2
	for <xfs@OSS.SGI.com>; Sun, 15 Mar 2009 07:27:24 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id 3okBKNFRvUw3BCSd
	for <xfs@OSS.SGI.com>; Sun, 15 Mar 2009 07:27:24 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1) id 1LirIZ-0006le-Ah
	for <xfs@OSS.SGI.com>; Sun, 15 Mar 2009 14:26:43 +0000
MIME-Version: 1.0
Message-ID: <18877.4130.99779.929416@tree.ty.sabi.co.uk>
Date: Sun, 15 Mar 2009 14:26:42 +0000
Subject: Re: LWN article: ext4 and data loss
In-Reply-To: <200903142042.51574.Martin@lichtvoll.de>
References: <200903121239.35442@zmi.at>
	<200903121514.12732.Martin@lichtvoll.de>
	<49B92423.4020708@sandeen.net>
	<200903142042.51574.Martin@lichtvoll.de>
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
To: Linux XFS <xfs@oss.sgi.com>

[ ... usual misunderstanding about caching and transactions ... ]

>>>> ext4 is taking its hints from XFS in this regard, not the
>>>> other way around.  XFS dealt with this long ago.

>>> Hmmm, I remember having had similar issues with XFS not to
>>> long ago,

>> depends on what you mean by not too long ago, I think.  Yes,
>> kde had this issue on xfs too, and xfs gave up on teaching
>> apps to fsync, and implemented the same sorts of things ext4
>> has done (or will do) to mitigate this quite some time ago.

> Well 2.6.28 and 2.6.27.7. See
> http://oss.sgi.com/archives/xfs/2008-12/msg00540.html

>>> [ ... ] applications will have to get rid of behavioral
>>> assumptions regation filesystem and use safe writing via
>>> fsync and whatever else for configuration and other
>>> important files.

>> It's simple.  Want your data safe on disk?  fsync. There's
>> not a lot more to it than that. (and if fsync hurts perf too
>> much, re-think how you are storing your data)

>> Filesystems can hack around some heuristics to try to make
>> unsafe apps safer, but in the end, it's the app's job to make
>> sure a buffered write hits permanent storage when it matters.

This discussion is partially misguided, but then how many people
study storage system semantics...

The goal is to do atomic transactions: within a transaction
there are no guarantees, but at the end of transaction things
get stored permanently.

Unfortunately as described 'ext3' has historically done
''rolling'' auto-saving, so many people and application
developers have not appreciated the need for transaction
semantics (common attitude, for example how many programmers for
example check the return code of 'close'?).

Now under Linux and POSIX it is essentially impossible to do
atomic, persistent transactions, because:

* 'fsync' does NOT guarantee persistency. Only that *RAM*
  buffers are flushed; therefore host adapter and disk buffers
  are not required to be flushed.

* Linux write barriers also only guaranteeq ordering and not
  persistence, and there is a number of misguided people who
  think that this is how things should be.

> Hmmm, okay. So here is:
> http://bugs.kde.org/187172

In practice, for systems without caching host adapters, and with
'ext3', most of the time informal ''rolling'' transactions every
5s fool most people/work as if they were right, and as asserted
this has lulled developers into thinking that transactions don't
matter. Too bad this kills performance and/or reliability on
anything else.

This is just another example of how much userspace sucks

  http://lwn.net/Articles/192214/
  http://kernelslacker.livejournal.com/81262.html
  http://mirror.linux.org.au/pub/linux.conf.au/2007/video/talks/38.pdf

Note that in a proper design where 'fsync' would guarantee
persistence, like in every transactional systems, lots of small
transactions have very sharp performance implications. People
who earn a living doing transactional systems therefore spend a
great deal of money and effort designing them to perform well
despite lots of small transactions, with 15k drives, vast
parallel RAID, bettery backed logs, etc.

You cannot have all of these:

* Reliable transactions.
* Fast with lots of small transactions.
* With cheap hardware.

In the end one must decided whether to follow the Microsoft
strategy (f*ck doing the right thing, cultivate bugs that users
are relying on) or the UNIX one (try to do the right thing).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
