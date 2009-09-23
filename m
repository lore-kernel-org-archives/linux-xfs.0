Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8NIfdOO027561 for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 13:41:39 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67F1947729F
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 11:42:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 15ETrDM7cmGlrou6 for
	<xfs@oss.sgi.com>; Wed, 23 Sep 2009 11:42:56 -0700 (PDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8NIgus8015721
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:42:56 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8NIgsrG028544
	for <xfs@oss.sgi.com>; Wed, 23 Sep 2009 14:42:54 -0400
Message-ID: <4ABA6C2E.2080104@sandeen.net>
Date: Wed, 23 Sep 2009 13:42:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix readahead calculations in xfs_dir2_leaf_getdents()
References: <4ABA5192.80509@sandeen.net>
In-Reply-To: <4ABA5192.80509@sandeen.net>
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
To: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> This is for bug #850,
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=850
> XFS file system segfaults , repeatedly and 100% reproducable in 2.6.30 , 2.6.31


Grr well this slowed things down a little, on about 200,000 entries in a
~10MB directory on a single sata spindle.

stracing /bin/ls (no color/stats, output to /dev/null) 4x in a row with
cache drops in between shows:

stock:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.241378         414       583           getdents
100.00    0.231012         396       583           getdents
100.00    0.244977         420       583           getdents
100.00    0.258624         444       583           getdents

patched:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.285928         769       372           getdents
100.00    0.273747         736       372           getdents
100.00    0.271060         729       372           getdents
100.00    0.251360         676       372           getdents

so that's slowed down a bit.  Weird that more calls, originally, made it
faster overall...?

But one thing I noticed is that we choose readahead based on a guess at
the readdir buffer size, and at least for glibc's readdir it has this:

const size_t default_allocation =
  (4 * BUFSIZ < sizeof (struct dirent64) ?
	sizeof (struct dirent64) : 4 * BUFSIZ);

where BUFSIZ is a magical 8192.

But we do at max PAGE_SIZE which gives us almost no readahead ...

So bumping our "bufsize" up to 32k, things speed up nicely.  Wonder if
the stock broken bufsize method led to more inadvertent readahead....

32k:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.176826         475       372           getdents
100.00    0.177491         477       372           getdents
100.00    0.176548         475       372           getdents
100.00    0.139812         376       372           getdents

Think it's worth it?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
