Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9A8oAfr248536 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 03:50:10 -0500
Received: from mail-out3.booking.com (mail-out3.booking.com [91.195.237.20])
	by cuda.sgi.com with ESMTP id tcfGWwfj0YYkRy8w (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Oct 2012 01:51:39 -0700 (PDT)
Received: from corpds-101.ams4.corp.booking.com ([10.196.68.22]:59621)
	by mtx-101.ams4.prod.booking.com with esmtps (TLSv1:AES256-SHA:256)
	(Exim 4.76) (envelope-from <marcin.deranek@booking.com>)
	id 1TLs0w-0006Oa-Ad
	for xfs@oss.sgi.com; Wed, 10 Oct 2012 10:51:38 +0200
Received: from [10.155.73.76] (port=35202 helo=localhost)
	by corpds-101.ams4.corp.booking.com with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.76) (envelope-from <marcin.deranek@booking.com>)
	id 1TLs0w-0004y6-98
	for xfs@oss.sgi.com; Wed, 10 Oct 2012 10:51:38 +0200
Date: Wed, 10 Oct 2012 10:51:42 +0200
From: Marcin Deranek <marcin.deranek@booking.com>
Subject: Performance degradation over time
Message-ID: <20121010105142.148519ca@booking.com>
Mime-Version: 1.0
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

Hi,

We are running XFS filesystem on one of out machines which is a big
store (~3TB) of different data files (mostly images). Quite recently we
experienced some performance problems - machine wasn't able to keep up
with updates. After some investigation it turned out that open()
syscalls (open for writing) were taking significantly more time than
they should eg. 15-20ms vs 100-150us.
Some more info about our workload as I think it's important here:
our XFS filesystem is exclusively used as data store, so we only
read and write our data (we mostly write). When new update comes it's
written to a temporary file eg.

/mountpoint/some/path/.tmp/file

When file is completely stored we move it to final location eg.

/mountpoint/some/path/different/subdir/newname

That means that we create lots of files in /mountpoint/some/path/.tmp
directory, but directory is empty as they are moved (rename() syscall)
shortly after file creation to a different directory on the same
filesystem.
The workaround which I found so far is to remove that directory
(/mountpoint/some/path/.tmp in our case) with its content and re-create
it. After this operation open() syscall goes down to 100-150us again.
Is this a known problem ?
Information regarding our system:
CentOS 5.8 / kernel 2.6.18-308.el5 / kmod-xfs-0.4-2
Let me know if you need to know anything more.
Cheers,

Marcin

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
