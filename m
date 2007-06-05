Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 07:49:59 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l55EnsWt015560
	for <linux-xfs@oss.sgi.com>; Tue, 5 Jun 2007 07:49:55 -0700
Received: by wa-out-1112.google.com with SMTP id k22so2207115waf
        for <linux-xfs@oss.sgi.com>; Tue, 05 Jun 2007 07:49:54 -0700 (PDT)
Message-ID: <5d96567b0706050749o74bc7701g154e836c43a511be@mail.gmail.com>
Date: Tue, 5 Jun 2007 16:49:54 +0200
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: building xfstests
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Hello
I have downloaded from the web the cvs repository of the
module xfs-cmds.

I failing to build it.  the bellow is the "make" output.

...
== dist, log is Logs/dist
Wrote: /d1/rt/raz/downloads/xfs-cmds/xfsprogs/build/xfsprogs-2.9.0.src.tar.gz
Wrote: /d1/rt/raz/downloads/xfs-cmds/xfsprogs/build/tar/xfsprogs-2.9.0.tar.gz
== Building dmapi
== clean, log is Logs/clean

== configure, log is Logs/configure

== default, log is Logs/default

== dist, log is Logs/dist
Wrote: /d1/rt/raz/downloads/xfs-cmds/dmapi/build/dmapi-2.2.8.src.tar.gz
Wrote: /d1/rt/raz/downloads/xfs-cmds/dmapi/build/tar/dmapi-2.2.8.tar.gz
== Building xfsdump
== clean, log is Logs/clean

== configure, log is Logs/configure

== default, log is Logs/default

= dist, log is Logs/dist
Wrote: /d1/rt/raz/downloads/xfs-cmds/xfsdump/build/xfsdump-2.2.45.src.tar.gz
Wrote: /d1/rt/raz/downloads/xfs-cmds/xfsdump/build/tar/xfsdump-2.2.45.tar.gz
for d in attr acl xfsprogs dmapi xfsdump; do \
        ( cd /d1/rt/raz/downloads/xfs-cmds && /bin/cp
$d/build/rpm/*.src.rpm /d1/rt/raz/downloads/xfs-cmds/SRPMS ) \
done
/bin/cp: cannot stat `attr/build/rpm/*.src.rpm': No such file or directory
/bin/cp: cannot stat `acl/build/rpm/*.src.rpm': No such file or directory
/bin/cp: cannot stat `xfsprogs/build/rpm/*.src.rpm': No such file or directory
/bin/cp: cannot stat `dmapi/build/rpm/*.src.rpm': No such file or directory
/bin/cp: cannot stat `xfsdump/build/rpm/*.src.rpm': No such file or directory
make: *** [cmds] Error 1

anyone ?


-- 
Raz
