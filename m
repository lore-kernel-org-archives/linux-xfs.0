Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2OIZvlg092055 for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 13:35:58 -0500
Received: from april.london.02.net (april.london.02.net [87.194.255.143]) by
	cuda.sgi.com with ESMTP id YnqgAII91F2XmAkK for
	<xfs@oss.sgi.com>; Sat, 24 Mar 2012 11:35:54 -0700 (PDT)
Received: from ty.sabi.co.UK (87.194.99.40) by april.london.02.net (8.5.140)
	id 4F6C7F97000C8AAF for xfs@oss.sgi.com; Sat, 24 Mar 2012 18:35:54 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1SBVoY-0002Ql-Vv
	for <xfs@oss.sgi.com>; Sat, 24 Mar 2012 18:35:47 +0000
MIME-Version: 1.0
Message-ID: <20334.5122.852478.206217@tree.ty.sabi.co.UK>
Date: Sat, 24 Mar 2012 18:35:46 +0000
Subject: Re: GNU 'tar', Schilling's 'tar', write-cache/barrier
In-Reply-To: <20120324171150.GA69366@nsrc.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F6624A3.5010206@hardwarefreak.com>
	<20331.39194.377610.888636@tree.ty.sabi.co.UK>
	<201203232348.09158.Martin@lichtvoll.de>
	<20333.8944.573177.821944@tree.ty.sabi.co.UK>
	<20333.62951.784434.92213@tree.ty.sabi.co.UK>
	<20120324171150.GA69366@nsrc.org>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux fs XFS <xfs@oss.sgi.com>

[ ... ]

>> #  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -no-fsync -x -f /=
tmp/linux-2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
>> real    0m1.204s
>> Dirty:          419456 kB
>> real    0m5.012s

>> #  (cd /tmp/ext4; rm -rf linux-2.6.32; sync; time star -x -f /tmp/linux-=
2.6.32.tar; egrep 'Dirty|Writeback' /proc/meminfo; time sync)
>> real    23m29.346s
>> Dirty:             108 kB
>> real    0m0.236s

> But as a user, what guarantees do I *want* from tar?

Ahhhh, but that depends *a lot* on the application, that may or
may not be 'tar', and what you are using 'tar' for. Consider for
example restoring a backup using RSYNC instead of 'tar'.

> I think the only meaningful guarantee I might want is: "if the
> tar returns successfully, I want to know that all the files
> are persisted to disk".

Perhaps in some cases, but perhaps in others not. For example if
you are restoring 20TB, having to redo the whole 20TB or a
significant fraction may be undesirable, and you would like to
change the guarantee as tyou write later:

  > On the flip side, does fsync()ing each individual file [
  > ... ] you could safely restart an aborted untar [ ... ] the
  > last file which was unpacked may only have been partially
  > written to disk [ ... ]

to add "if the tar does not return successfully, I want to know
that most or or all the files are persisted, except the last one
that was only partially written, which I want to disappear, so I
can rerun 'tar -x -k' and only restore the rest of the files".

> And of course that's what your final "sync" does, although
> with the unfortunate side-effect of syncing all other dirty
> blocks in the system too.

Just to be sure: that was on a quiescent system, so in the
particular case of my tests it was just on the 'tar'.

[ ... ]

> I think what's needed is a group fsync which says "please
> ensure this set of files is all persisted to disk", which is
> done at the end, or after every N files.  If such an API
> exists I don't know of it.

That's in part what mentioned here:

[ ... ]

> If the above benchmark is typical, it suggests that fsyncing
> after every file is 4 times slower than untar followed by
> sync.

Depends on how often the flusher runs and how aggressively and
how much memory you get. In the comparison quoted above, GNU
'tar' on 'ext4' dumps 410MB into RAM in just over 1 second plus
5 seconds for 'sync', and Schilling's 'tar' persists the lot to
disk, incrementally, in 1409 seconds. The ratio is 227 times.

Because that's a typical disk drive that can either do around
100MB/s with bulk sequential IO (thus the 5 seconds 'sync') or
around 0.5-4MB/s with small random IO.

> So I reckon you would be better off using the fast/unsafe
> version, and simply restarting it from the beginning if the
> system crashed while you were running it. [ ... ]

That's in one very specific example with one application in one
context. As to this, for a better discussion, let's go back to
your original and very appropriate question:

  > But as a user, what guarantees do I *want* from tar?

The question is very sensible as far as it goes, but it does not
go far enough, because =ABfrom tar=BB and small 'tar' archives is
just happenstance: what you should ask yourself is:

  But as a user, what guarantees do I *want* from filesystems
  and the applications that use them?

That's in essence the O_PONIES question.

That question can have many answers each of them addressing a
different aspect of normative and positive situation, and I'll
try to list some.

The first answer is that you want to be able to choose different
guarantees and costs, and know which they are. In this respect
'delaylog' log, properly described as an improvement in both
unsafety and speed, is a good thing to have, because it is often
a useful option. So are 'sync', 'nobarrier', and 'eatmydata'.

The second answer is that as a rule users don't have the
knowledge or the desire to understand the tradeoffs offered by
filesystems and how they relate to the behavior of the programs
(including 'tar') that they use, so there needs to be a default
guarantee that most users would have chosen if they could, and
this should be about more safety rather than the more speed, and
this was what =ABXFS @ 2009-2010=BB was doing.

More to follow...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
