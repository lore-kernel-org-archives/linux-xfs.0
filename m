Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 01:17:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4H8HkfB016098
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 01:17:48 -0700
Subject: TAKE 960160 960161 960162 960165 960166 960377 - mkfs arg conflicts
Message-Id: <20070517081742.AF8B958CA531@chook.melbourne.sgi.com>
Date: Thu, 17 May 2007 18:17:42 +1000 (EST)
From: ddiss@sgi.com (David Mark Disseldorp)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com, asgqa@sgi.com

Currently there are a few ways mkfs options are specified in XFSQA:
1) suite wide MKFS_OPTIONS are specified before tests are run
	e.g.
	vimes:/home/fsgqa/kali/xfsqa/xfstests # export MKFS_OPTIONS="-l size=100m"

2) test wide MKFS_OPTIONS are specified during a particular test
	e.g. 119
	export MKFS_OPTIONS="-l version=2,size=1200b,su=64k"

3) mkfs options are appended by a test at mkfs time
	e.g.  083
	_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full

(4) Another form of appending is just appending to MKFS_OPTIONS directly
	e.g. 	114:export MKFS_OPTIONS="$MKFS_OPTIONS -i parent=1"
		115:export MKFS_OPTIONS="$MKFS_OPTIONS -i paths=1"

Conflicts between mkfs options specified with method 1 & 3 are common.
960377 	XFSQA 041, 042 - mkfs fails with large log size MKFS_OPTIONS.

This change means if a mkfs fails where mkfs options have been appended by a test (method 3),
The mkfs is retried using only those options defined by the test.

occurances of method 4 (in test 114 & 115) are also changed to use method 3.

$seq.full logs the fact that a mkfs options conflict has occured.


Date:  Thu May 17 18:15:46 AEST 2007
Workarea:  chook.melbourne.sgi.com:/build/ddiss/xfs-cmds
Inspected by:  tes

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/xfs-cmds/master-melb


Modid:  master-melb:xfs-cmds:28601a
xfstests/common.rc - 1.65 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/common.rc.diff?r1=text&tr1=1.65&r2=text&tr2=1.64&f=h
	- if there are conflicts between global and test specified mkfs options,
	  then use only the test specified ones.

xfstests/114 - 1.7 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/114.diff?r1=text&tr1=1.7&r2=text&tr2=1.6&f=h
	- append -i parent mkfs option using _scratch_mkfs_xfs -i parent...
	  rather than export MKFS_OPTIONS="$MKFS_OPTIONS -i parent=1.
	  this avoids mkfs option conflicts

xfstests/115 - 1.4 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/115.diff?r1=text&tr1=1.4&r2=text&tr2=1.3&f=h
	- append -i paths mkfs option using _scratch_mkfs_xfs -i paths...
	  rather than export MKFS_OPTIONS="$MKFS_OPTIONS -i paths=1.
	  this avoids mkfs option conflicts
