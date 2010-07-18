Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKEh5i162616 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:14:44 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 428D445632C
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:17:41 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id AK9ycYuLcEmh52UZ
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:17:41 -0700 (PDT)
Received: by vws15 with SMTP id 15so3976380vws.26
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:17:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTil7lvYW1awXbODVP5r6mXlTrlt4CCncvn5hU4b8@mail.gmail.com>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<20100718045702.GB6282@infradead.org>
	<AANLkTil7lvYW1awXbODVP5r6mXlTrlt4CCncvn5hU4b8@mail.gmail.com>
Date: Sun, 18 Jul 2010 16:17:41 -0400
Message-ID: <AANLkTilDtdOWsrBlx-lqIOI-kdr5yvOPi145bhsjl1Tk@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
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

On Sun, Jul 18, 2010 at 1:28 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Sun, Jul 18, 2010 at 12:57 AM, Christoph Hellwig <hch@infradead.org> w=
rote:
>> On Sun, Jul 18, 2010 at 11:20:33AM +1000, Dave Chinner wrote:
>>> So, back to the situation with the WARN_ON(). You're running
>>> applications that are doing something that:
>>>
>>> =A0 =A0 =A0 a) is not supported;
>>> =A0 =A0 =A0 b) compromises data integrity guarantees;
>>> =A0 =A0 =A0 c) is not reliably reported; and
>>> =A0 =A0 =A0 d) might be causing hangs
>>>
>>> Right now I'm not particularly inclined to dig into this further;
>>> it's obvious the applications are doing something that is not
>>> supported (by XFS or the generic page cache code), so this is the
>>> first thing you really need to care about getting fixed if you value
>>> your backups...
>>
>> While it's slightly crazy it's also a pretty easy way for users to shoot
>> themselve in their feet. =A0Unlike the generic filesystems with their
>> simplistic i_mutex locking we have a way to assure this works properly
>> in XFS with the shared/exclusive iolock, so I'm willing to look into
>> this further.
>>
>> Ilia, would you be willing to test patches for this?
>
> If by "this" you mean the WARN_ON's, no problem. It should be easy to
> repro in a non-critical setup, although I haven't tried. If you mean
> the hang, it will not be so easy to reproduce, as it has only happened
> once so far.
>
> I would also be happy to share the details of our setup, if you'd like
> to be able to play with it directly yourself. With our setup, multiple
> WARN_ON's happen every time we run a backup (last time I checked, it
> was ~50, but I'm sure it varies).
>
> As a last thought on the matter, I'm sure that this is all brought on
> by our use of innodb_flush_method=3DO_DIRECT which tells mysql to use
> direct io. Leaving that at its default which will just open the files
> regularly will probably make all these issues go away. I do not have a
> sufficient understanding of the details of how mysql uses direct io,
> and how it interacts with xtrabackup (which claims to work fine with
> direct io, but who knows) to be able to declare that it's safe, so I'm
> happy to accept Dave's advice to Not Do That.
>

In case you guys are interested, I've also opened a bug at
https://bugs.launchpad.net/percona-xtrabackup/+bug/606981. I never
quite bothered to _really_ understand all of the details of O_DIRECT
vs mmap vs read, so if I've misrepresented reality in the bug, feel
free to correct it there, or let me know and I'll try to straighten
things out.

-- =

Ilia Mirkin
imirkin@alum.mit.edu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
