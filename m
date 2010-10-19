Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9JN3OBo253678 for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 18:03:24 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 38FCD1E7E7A3
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 16:04:36 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 5dMyWa2Pf7Dk55k3
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 16:04:36 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 16F1E6C033
	for <xfs@oss.sgi.com>; Tue, 19 Oct 2010 18:04:36 -0500 (CDT)
Message-ID: <4CBE2403.8070108@hardwarefreak.com>
Date: Tue, 19 Oct 2010 18:04:35 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: avoid mbox file fragmentation
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
To: xfs@oss.sgi.com

In an effort to maximize mbox performance and minimize fragmentation I'm
using these mount options in fstab.  This is on a Debian Lenny box but
with vanilla 2.6.34.1 rolled from kernel.org source (Lenny ships with
2.6.26).  xfsprogs is 2.9.8.

/dev/sda6  /home   xfs   defaults,logbufs=8,logbsize=256k,allocsize=1m

Since the actual XFS mount defaults aren't consistently published
anywhere that I can find I'm manually specifying logbufs and logbsize.

I added allocsize=1m as my read of the man page suggests this will
preallocate an additional 1MB of extent space at the end of each mbox
file each time it is written, which I would think should eliminate
fragmentation of these files.  However, this doesn't seem to be
eliminating the fragmentation.  I added allocsize=1m at a date after all
of the mbox files in question already existed.  Does allocsize=1m only
affect new files or does it preallocate at the end of existing files?

I've probably totally misread what allocsize= actually does.  Please
educate me.  If allocsize= doesn't help prevent fragmentation of mbox
files, what can I do to mitigate this, other than regularly running xfs_fsr?

Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/sda6      xfs     94G  1.3G   92G   2% /home

Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
/dev/sda6      xfs       94M    1.1K     94M    1% /home

actual 1096, ideal 1011, fragmentation factor 7.76%

I've recently run xfs_fsr thus the low 7% figure.  Every couple of weeks
the fragmentation reaches ~30%.  I save a lot of list mail, dozens to
hundreds per day for each of about 7 foss mailing lists.  As I say, in
just a couple of weeks, these mbox files become fragmented, on the order
of a dozen to a few dozen extents per mbox file.  With so much free
space available on this filesystem, why aren't/weren't these files being
spread out with sufficient space between them to prevent fragmentation?

P.S.

(Dave or someone has suggested on list that with newer kernels the
defaults for these two (and other) mount options do not match those
suggested in the man pages.  I requested a feature some time ago that
would actually put these default values in /proc files to eliminate any
doubt as to what the actual defaults being used are.  I don't recall if
anything came of this.  I've seen many an OP get "scolded" on list for
manually specifying values that were apparently equal to the "default"
values as stated by the responding dev.  This problem would never exist
if the documentation was complete and consistent.  If it already is,
then something is wrong, as myself and hoards of other OPs aren't able
to locate this definitive information regarding mount defaults.)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
