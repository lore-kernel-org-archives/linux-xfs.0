Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA5K77dn180737 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 15:07:08 -0500
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34BE0222C84
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 13:07:06 -0700 (PDT)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	Y8VaLO6j3FxmuDq3 for <xfs@oss.sgi.com>;
	Sat, 05 Nov 2011 13:07:06 -0700 (PDT)
Received: by ggdk6 with SMTP id k6so920935ggd.26
	for <xfs@oss.sgi.com>; Sat, 05 Nov 2011 13:07:06 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 5 Nov 2011 21:07:05 +0100
Message-ID: <CAMYYbY7=tRU1bmHkeBMesSC1jgXXz7J8-eUFm5VenVam3g1+nA@mail.gmail.com>
Subject: Online TRIM/discard performance impact
From: Martin Rusko <martin.rusko@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I wanted to ask if following performance drop with online discard
enabled for XFS is normal. I went through mailing list archives and
read information from Luk=E1=A8's page
(http://people.redhat.com/lczerner/discard/) so I was prepared for
some performance penalty. But this big?

--> Filesystem is mounted with noatime and discard options ...

/dev/sdb2 on /mnt/test-xfs type xfs (rw,noatime,discard)

--> Deleting freshly unpacked linux kernel sources ...

# time rm -rf linux-3.0.8

real	4m50.155s
user	0m0.012s
sys	0m0.940s

=3D=3D> It took almost 5 minutes!

--> Deleting same freshly unpacked linux kernel sources this time with
filesystem mounted without 'discard' option ...

/dev/sdb2 on /mnt/test-xfs type xfs (rw,noatime)

# time rm -rf linux-3.0.8

real	0m1.023s
user	0m0.024s
sys	0m0.896s

=3D=3D> It took a second and something.

SSD drive in question is one of the latest with SF-2281 chipset. I
expected, that TRIM function will just schedule sectors for garbage
collection, which happens some time later (during which drive can be
potentially slower). Trying the same tests with ext4 filesystem, it
got following numbers.

--> ext4 with 'discard' option ...

/dev/sdb3 on /mnt/test-ext4 type ext4 (rw,noatime,discard)

# time rm -rf linux-3.0.8

real	0m0.486s
user	0m0.012s
sys	0m0.468s

--> ext4 without 'discard' option ...

/dev/sdb3 on /mnt/test-ext4 type ext4 (rw,noatime)

root@layla:/mnt/test-ext4# time rm -rf linux-3.0.8

real	0m0.483s
user	0m0.020s
sys	0m0.460s

Tests were repeated several times and it was consistent. Deleting
files on XFS filesystem mounted with 'discard' option was painfully
slow. Kernel version was ...

   Linux layla 3.0.0-12-generic #20-Ubuntu SMP Fri Oct 7 14:56:25 UTC
2011 x86_64 x86_64 x86_64 GNU/Linux

Is this expected behavior?

Best Regards,
Martin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
