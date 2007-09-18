Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 10:27:30 -0700 (PDT)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JHRMuw023613
	for <linux-xfs@oss.sgi.com>; Wed, 19 Sep 2007 10:27:25 -0700
Received: from teal.hq.k1024.org (k1024.vpn.cable.simleu.ro [10.1.2.8])
	by astra.simleu.ro (Postfix) with ESMTP id DFD754D
	for <linux-xfs@oss.sgi.com>; Tue, 18 Sep 2007 21:33:23 +0300 (EEST)
Date: Tue, 18 Sep 2007 20:33:08 +0200
From: Iustin Pop <iusty@k1024.org>
Subject: possible bug with non-default extent sizes
Message-ID: <20070918183308.GB10782@teal.hq.k1024.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hi,

I've seen a strange behaviour related to sparse files with non-default
extent sizes and I'm not sure if it's a bug or expected behaviour
(certainly I was not expecting it).

cd $TMPDIR
/usr/sbin/xfs_io -c "extsize 16k" .
python <<EOF
f = open("test", "w+")
f.truncate(1024*64)
f.write("A")
f.close()
EOF

what I see if I look at the file now with od for example, is that the
first filesystem block contains "A" and then zeroes, but after the 4k
offset the file contains stale data from the disk.

This doesn't happen for all values of extsize and the file size. What
I've seen that for an extent size N, file size bigger than 2*N very
often result in stale data. Many times, even a file bigger than two
blocks (8k) will show stale data too.

I haven't found any bug related to this, and I would not expect stale
data (since this is doable even by normal users, and maybe could leak
old data).

Is this a known issue?

thanks,
iustin
