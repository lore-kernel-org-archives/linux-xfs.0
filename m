Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 31 Oct 2008 07:56:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9VEuGsw009566
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 07:56:17 -0700
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1D1756543A
	for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 07:56:15 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com with ESMTP id gaj7NbfRRJ5esC22 for <xfs@oss.sgi.com>; Fri, 31 Oct 2008 07:56:15 -0700 (PDT)
Message-ID: <490B1C8B.7010607@sandeen.net>
Date: Fri, 31 Oct 2008 09:56:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Which FileSystem do you use on your postfix server?
References: <20081031121002.D94A11F3E98@spike.porcupine.org> <alpine.DEB.1.10.0810310810520.468@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0810310810520.468@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Postfix users <postfix-users@postfix.org>, xfs@oss.sgi.com, wietse@porcupine.org

(Please bear with me; quoting a previous postfix-users email, but I'm
not on that list.  Feel free to put this back on the postfix-users list
if it'd otherwise bounce)

> Nikita Kipriyanov:
>> DULMANDAKH Sukhbaatar ?????:
>> > For me XFS seemed very fast. But usually I use ext3, which is
>> > proven to be stable enough for most situations.
>> >
>> >
>> >
>> I feel also that xfs if much faster than ext3 and reiserfs, especially
>> when it deals with metadata. In some bulk operation (bulk changing
>> attributes of ~100000 files) it was approx. 15 times faster than ext3
>> (20 sec xfs, 5 min ext3).
>>
>> xfs's journal covers only metadata, so you probally lose some lastest
>> not-synched data on power loss, but you will stay with consistent fs.
>
> Does XFS still overwrite existing files with zeros, when those
> files were open for write at the time of unclean shutdown?

XFS has never done this.  (explicitly overwrite with zeros, that is).
There was a time in the past when after a truncate + size update +
crash, the log would replay these metadata operations (truncate+size
update) but the data blocks had never hit the disk (this is assuming
there was no fsync complete), so there were no data blocks (extents)
associated with the file - you wound up with a sparse file as a result.
 Reading this led to zeros, of course.

This is NOT the same as "overwriting existing files with zeros" which
xfs has *never* done.

This particular behavior has been fixed in 2 ways, though.  One, if a
file has been truncated down, it will be synced on close:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7d4fb40ad7efe4586d1341d4731377fb4530836f
[XFS] Start writeout earlier (on last close) in the case where we have a
truncate down followed by delayed allocation (buffered writes) - worst
case scenario for the notorious NULL files problem.  This reduces the
window where we are exposed to that problem significantly.

Two, a separate in-memory vs. on-disk size is now tracked:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ba87ea699ebd9dd577bf055ebc4a98200e337542
[XFS] Fix to prevent the notorious 'NULL files' problem after a crash.

The problem that has been addressed is that of synchronising updates of
the file size with writes that extend a file. Without the fix the update
of a file's size, as a result of a write beyond eof, is independent of
when the cached data is flushed to disk. Often the file size update
would be written to the filesystem log before the data is flushed to
disk. When a system crashes between these two events and the filesystem
log is replayed on mount the file's size will be set but since the
contents never made it to disk the file is full of holes. If some of the
cached data was flushed to disk then it may just be a section of the
file at the end that has holes.

There are existing fixes to help alleviate this problem, particularly in
the case where a file has been truncated, that force cached data to be
flushed to disk when the file is closed. If the system crashes while the
file(s) are still open then this flushing will never occur.

The fix that we have implemented is to introduce a second file size,
called the in-memory file size, that represents the current file size as
viewed by the user. The existing file size, called the on-disk file
size, is the one that get's written to the filesystem log and we only
update it when it is safe to do so. When we write to a file beyond eof
we only update the in- memory file size in the write operation. Later
when the I/O operation, that flushes the cached data to disk completes,
an I/O completion routine will update the on-disk file size. The on-disk
file size will be updated to the maximum offset of the I/O or to the
value of the in-memory file size if the I/O includes eof.

========

> This
> would violate a basic requirement of Postfix (don't lose data after
> fsync).  Postfix updates existing files all the time: it updates
> queue files as it marks recipients as done, and it updates mailbox
> files as it appends mail.

As long as postfix is looking after data properly with fsyncs etc, xfs
should be perfectly safe w.r.t. data integrity on a crash.  If you see
any other behavior, it's a *bug* which should be reported, and I'm sure
it would be fixed.  As far as I know, though, there is no issue here.

> 	Wietse
>
> To: Private List <evals@tux.org>
> From: "Theodore Ts'o" <tytso@mit.edu>
> Date: Sun, 19 Dec 2004 23:10:09 -0500
> Subject: Re: [evals] ext3 vs reiser with quotas
>
> [...]

This email has been quoted too many times, and it's just not accurate.

> This issue is completely different from the XFS issue of zero'ing
> all open files on an unclean shutdown, of course.

As stated above, this does not happen, at least not in the active
zeroing sense.

>  [..] The reason
> why it is done is to avoid a potential security problem, where a
> file could be left with someone else's data.

No.  The file simply did not have extents on it, because the crash
happened before the data was flushed.

> Ext3 solves this
> problem by delaying the journal commit until the data blocks are
> written, as opposed to trashing all open files.  Again, it's a
> solution which can impact performance, but at least in my opinion,
> for a filesystem, performace is Job #2.  Making sure you don't lose
> data is Job #1.

And it's equally the job of the application; if an application uses the
proper calls to sync data on xfs, xfs will not lose that data on a crash.

Thanks,
-Eric (a happy postfix+xfs user for years) :)
