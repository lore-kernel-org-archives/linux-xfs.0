Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBMJ1ImQ016190 for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 13:01:18 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E2A31477540
	for <xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:03:14 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id cOqA8UK4M0xNjzuG for
	<xfs@oss.sgi.com>; Wed, 22 Dec 2010 11:03:14 -0800 (PST)
Message-ID: <4D124B71.9030401@sandeen.net>
Date: Wed, 22 Dec 2010 13:03:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Anyone using XFS in production on > 20TiB volumes?
References: <alpine.DEB.2.00.1012221128440.5245@p34.internal.lan>
	<20101222175611.1c7d5190@harpe.intellique.com>
In-Reply-To: <20101222175611.1c7d5190@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On 12/22/10 10:56 AM, Emmanuel Florac wrote:
> Le Wed, 22 Dec 2010 11:30:05 -0500 (EST)
> Justin Piszcz <jpiszcz@lucidpixels.com> =E9crivait:
> =

>> Is there anyone currently using this in production?
> =

> Yup, lots of people do. Currently supporting 28 such systems (from 20
> to 76 TiB, most are 39.7 TiB).
> =

>> How much ram is needed when you fsck with a many files on such a
>> volume? Dave Chinner reported 5.5g or so is needed for ~43TB with no
>> inodes. Any recent issues/bugs one needs to be aware of?
> =

> I never had any trouble running xfs_repair on 39.7 TB+ systems with 8 GB
> of RAM.
> =

>> Is inode64 recommended on a 64-bit system?
> =

> Sure, however 32 bits clients may scoff sometimes, though it's limited
> to some weird programs.
> =

>> Any specific 64-bit tweaks/etc for a large 43TiB FS?
>>
> =

> Nothing unusual (inode64,noatime, mkfs with lazy-count enabled, etc). It
> should just works.

yes, inode64 is recommended for such a large filesystem; lazy-count
has been default in mkfs for quite some time.  noatime if you really
need it, I guess.

See also

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.=
3Csomething.3E

which mentions getting your geometry right if it's hardware raid
that can't be detected automatically.

(maybe we should add inode64 usecases to that too...)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
