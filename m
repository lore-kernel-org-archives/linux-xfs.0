Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7EVlfi061915 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 08:31:47 -0600
Received: from mail-qw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2604D16D049B
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 06:31:45 -0800 (PST)
Received: from mail-qw0-f53.google.com (mail-qw0-f53.google.com
	[209.85.216.53]) by cuda.sgi.com with ESMTP id IX69CaWX9rNjl2oO
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 06:31:45 -0800 (PST)
Received: by qadz32 with SMTP id z32so626677qad.26
	for <xfs@oss.sgi.com>; Mon, 07 Nov 2011 06:31:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111107102121.GA2891@infradead.org>
References: <CAMYYbY7=tRU1bmHkeBMesSC1jgXXz7J8-eUFm5VenVam3g1+nA@mail.gmail.com>
	<20111107102121.GA2891@infradead.org>
Date: Mon, 7 Nov 2011 15:31:44 +0100
Message-ID: <CAMYYbY4oFhp-vF2TJUPSqoHJfJW_VBcotOBucDs94gYEUCvOMg@mail.gmail.com>
Subject: Re: Online TRIM/discard performance impact
From: Martin Rusko <martin.rusko@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Nov 7, 2011 at 11:21 AM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Sat, Nov 05, 2011 at 09:07:05PM +0100, Martin Rusko wrote:
>> SSD drive in question is one of the latest with SF-2281 chipset. I
>> expected, that TRIM function will just schedule sectors for garbage
>> collection, which happens some time later (during which drive can be
>> potentially slower). Trying the same tests with ext4 filesystem, it
>> got following numbers.
>
> That's unfortunately not how it works - the TRIM command always drains
> the whole queue of outstanding requests, and thus has a fairly severe
> impact on performance. =A0We could reduce it a bit by using vectored
> trims like Windows does, but the Linux blocklayer doesn't have the
> infrastructure for that yet.
>
> Your workload will remove a lot of inode clusters on XFS, while ext4
> never deletes inodes. Using the ikeep mount option for XFS (can't be
> set during remount) should speed the performance with discard for
> your workload up a lot. =A0I would still recommand to do a periodic
> fstrim run instead, though.
>

As per man page ...

ikeep|noikeep
       When inode clusters are emptied of inodes, keep them around on
the disk (ikeep) - this is the traditional XFS behaviour and is still
the
       default for now.  Using the noikeep option, inode clusters are
returned to the free space pool.

... which would imply, that it should be actually rather fast by
default. Even if I had set this explicitly, it didn't really help ...

# mount -o noatime,discard,ikeep /dev/data/test-xfs /mnt/disk

/dev/mapper/data-test--xfs on /mnt/disk type xfs (rw,noatime,discard,ikeep)

# time rm -rf linux-3.0.8

real	4m47.897s
user	0m0.032s
sys	0m0.992s

... normally it would be deleted in a second or even faster.

I'm fine to use periodic fstrim, let say once a day. But this is such
a big difference, that it makes me curious if it is expected behavior
or if I'm doing something terribly wrong. Any idea? Thanks!

Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
