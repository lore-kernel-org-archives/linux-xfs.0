Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95D4629DF8
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 11:12:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 76AC18F8052
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:12:42 -0700 (PDT)
Received: from mail-qa0-f51.google.com (mail-qa0-f51.google.com
	[209.85.216.51]) by cuda.sgi.com with ESMTP id bh7L5u3vC80P3LnY
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:12:41 -0700 (PDT)
Received: by mail-qa0-f51.google.com with SMTP id f11so3071848qae.3
	for <xfs@oss.sgi.com>; Tue, 11 Jun 2013 09:12:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B72D3D.5010206@redhat.com>
References: <loom.20130611T112155-970@post.gmane.org>
	<51B72D3D.5010206@redhat.com>
Date: Tue, 11 Jun 2013 11:12:40 -0500
Message-ID: <CAO9HMNGjdikgX+_434aGVJ2NAJ0hxDNLo+Vsa46GH3psXr4sKQ@mail.gmail.com>
Subject: Re: Questions about XFS
From: Steve Bergman <sbergman27@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ric Wheeler <rwheeler@redhat.com>
Cc: xfs@oss.sgi.com

In #5 I was specifically talking about ext4. After the 2009 brouhaha
over zero-length files in ext4 with delayed allocation turned on, Ted
merged some patches into vanilla kernel 2,6,30 which mitigated the
problem by recognizing certain common idioms and forcing automatically
forcing an fsync. I'd heard the the XFS team modeled a set of XFS
patches from them.

Regarding #4, I have 12 years experience with my workloads on ext3 and
3 yrs on ext4 and know what I have observed. As a practical matter,
there are large differences between filesystem behaviors which aren't
up for debate since I know my workloads' behavior in the real world
far better than anyone else possibly could. (In fact, I'm not sure how
anyone else could presume to know how my workloads and filesystems
interact.) But if I understand correctly, ext4 at default settings
journals metadata and commits it every 5s, while flushing data every
30s. Ext3 journals metadata, and commits it every 5 seconds, while
effectively flushing data, *immediately before the metadata*, every 5
seconds. so the window in which data and metadata are not in sync is
vanishingly small. Are you saying that with XFS there is no periodic
flushing mechanism at all? And that unless there's an
fsync/fdatasync/sync or the memory needs to be reclaimed, that it can
sit in the page cache forever?

One thing is puzzling me. Everyone is telling me that I must ensure
that fsync/fdatasync is used, even in environments where the concept
doesn't exist. So I've gone to find good examples of how it it used.
Since RHEL6 has been shipping with ext4 as the default for over 2.5
years, I figured it would be a great place to find examples. However,
I've been unable to find examples of fsync or fdatasync being used,
when using "strace -o file.out -f" on various system programs which
one would very much expect to use it. We talked about some Python
config utilities the other day. But now I've moved on to C and C++
code. e.g. "cupsd" copy/truncate/writes the config file
"/etc/cups/printers.conf" quite frequently, all day long. But there is
no sign whatsoever of any fsync or fdatasync when I grep the strace
output file for those strings case insensitively. (And indeed, a
complex printers.conf file turned up zero-length on one of my RHEL6.4
boxes last week.)

So I figured that when rpm installs a new vmlinuz, builds a new
initramfs and puts it into place, and modifies grub.conf, that surely
proper sync'ing must be done in this particularly critical case. But
while I do see rpm fsync/fsync'ing its own database files, it never
seems to fsync/fdatasync the critical system files it just installed
and/or modified. Surely, after over 2 - 1/2 years of Red Hat shipping
RHEL6 to customers, I must be mistaken in some way. Could you point me
to an example in RHEL6.4 where I can see clearly how fsync is being
properly used? In the mean time, I'll keep looking.


Thanks,
Steve



On Tue, Jun 11, 2013 at 8:59 AM, Ric Wheeler <rwheeler@redhat.com> wrote:
> On 06/11/2013 05:56 AM, Steve Bergman wrote:
>>
>> 4. From the time I write() a bit of data, what's the maximum time before
>> the
>> data is actually committed to disk?
>>
>> 5. Ext4 provides some automatic fsync'ing to avoid the zero-length file
>> issue for some common cases via the auto_da_alloc feature added in kernel
>> 2.6.30. Does XFS have similar behavior?
>
>
> I think that here you are talking more about ext3 than ext4.
>
> The answer to both of these - even for ext4 or ext3 - is that unless your
> application and storage is all properly configured, you are effectively at
> risk indefinitely. Chris Mason did a study years ago where he was able to
> demonstrate that dirty data could get pinned in a disk cache effectively
> indefinitely.  Only an fsync() would push that out.
>
> Applications need to use the data integrity hooks in order to have a
> reliable promise that application data is crash safe.  Jeff Moyer wrote up a
> really nice overview of this for lwn which you can find here:
>
> http://lwn.net/Articles/457667
>
> That said, if you have applications that do not do any of this, you can roll
> the dice and use a file system like ext3 that will periodically push data
> out of the page cache for you.
>
> Note that without the barrier mount option, that is not sufficient to push
> data to platter, just moves it down the line to the next potentially
> volatile cache :)  Even then, 4 out of every 5 seconds, your application
> will be certain to lose data if the box crashes while it is writing data.
> Lots of applications don't actually use the file system much (or write
> much), so ext3's sync behaviour helped mask poorly written applications
> pretty effectively for quite a while.
>
> There really is no short cut to doing the job right - your applications need
> to use the correct calls and we all need to configure the file and storage
> stack correctly.
>
> Thanks!
>
> Ric
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
