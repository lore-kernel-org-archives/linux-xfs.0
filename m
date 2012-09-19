Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JEAwZT207737 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 09:10:58 -0500
Received: from vwp1161.webpack.hosteurope.de (vwp1161.webpack.hosteurope.de
	[87.230.104.173]) by cuda.sgi.com with ESMTP id
	HQrtSq2GnhONi1V8 for <xfs@oss.sgi.com>;
	Wed, 19 Sep 2012 07:12:08 -0700 (PDT)
Message-ID: <5059D2B4.8010300@blafoo.org>
Date: Wed, 19 Sep 2012 16:12:04 +0200
From: blafoo <mail@blafoo.org>
MIME-Version: 1.0
Subject: OOM on quotacheck (again?)
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

Hi all,

for the last couple of days i've been trying to compile a new kernel for
our webserver-platform which is based on debian-squeeze.

Hardware: a mix of Dell PE2850, 2950, R710
- raid-10 with 4 disks (old setup, PE2850)
- raid-1 system, raid-10 content (current setup)
- currently running linux-2.6.37 custom built, vmalloc set to default
(128MB)

All systems have an xfs-filesystem as their content-partition and have
group-quota enabled (no other xfs-settings active). the
content-partition varies in size between 250GB and 1TB and contains
between 3 and 10 million files.

Every time i try to mount the xfs-file-system and a quota-check is
needed, the server goes out of memory (oom). I can easily reproduce this
by rebooting the server, resetting the quota-flags with

xfs_db -x -c 'sb 0' -c 'write qflags 0'

and rerun the quota-check.

This is true for various kernels but not all. What i've tried so far:

2.6.37.x - fails with OOM
2.6.39.4 - suprisingly works (see below why)
3.2.29 - fails with OOM
3.4.10 - fails with OOM
3.6.0rc5 - fails with vmalloc error (XFS (sda7): xfs_buf_get_map: failed
to map pages), with vmalloc=256 the systems hangs on mount infitly.

Some more infos from my test-system are available here:

http://pastebin.com/2DkDyH4R

I found a couple of references regarding this problem but no final
solution so far.

Please correct the following if i misunderstood anything:

1. There was an OOM problem with quota-checks which was fixed in
2.6.39.4 which is mentioned here:

a) http://permalink.gmane.org/gmane.comp.file-systems.xfs.general/43565

and fixed here:

b) http://patchwork.xfs.org/patch/3337/

That is why 2.6.39.4 works for me.


2. That fix was later replaced (not extended) with a nicer patch which
is mentioned/published here:

c) http://oss.sgi.com/archives/xfs/2011-03/msg00240.html


I checked all kernel-versions above for the patch mentioned in 2. and
can confirm its presence in each kernel-tree. Still our servers fail to
check quota successfully.

Am i missing something here?


PS: As a side-note: we've been running xfs for years without any
problems. But after we activated the gquota-feature, we've been having
problems in a couple of places. One is the OOM on quota-check, another
is xfs-errors on high-io volumes with gquota enabled. But since the
high-io-problem problem might be connected to the OOM-problem, we'll try
to fix the latter first :-)

best regards
Volker

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
