Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1D0I73A218651 for <xfs@OSS.SGI.com>; Sun, 12 Feb 2012 18:18:07 -0600
Received: from honeysuckle.london.02.net (honeysuckle.london.02.net
	[87.194.255.144]) by cuda.sgi.com with ESMTP id
	wxg4UB2VwHIOofXp for <xfs@OSS.SGI.com>;
	Sun, 12 Feb 2012 16:18:04 -0800 (PST)
Received: from ty.sabi.co.UK (87.194.99.40) by honeysuckle.london.02.net
	(8.5.140)
	id 4EEF52D201019F25 for xfs@OSS.SGI.com; Mon, 13 Feb 2012 00:18:02 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.71 #1) id 1RwjcB-0007Mt-T5
	for <xfs@OSS.SGI.com>; Mon, 13 Feb 2012 00:17:55 +0000
MIME-Version: 1.0
Message-ID: <20280.22195.757724.368356@tree.ty.sabi.co.UK>
Date: Mon, 13 Feb 2012 00:17:55 +0000
Subject: Re: quotacheck speed
In-Reply-To: <20120212234425.GA23625@infradead.org>
References: <201202122201.07649.arekm@maven.pl>
	<20120212234425.GA23625@infradead.org>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
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
To: Linux fs XFS <xfs@oss.sgi.com>

>> When mounting 800GB filesystem (after repair for example)
>> here quotacheck takes 10 minutes. Quite long time that adds
>> to whole time of filesystem downtime (repair + quotacheck).

For tight downtime minimization requirements wishful thinking is
not a strategy: whole filetree metadata scans are not cheap. If
you require fast scan of metadata of the whole filetree, ensure
filetrees don't have a lot of metadata (or fund the development
of a parallel whole tree metadata scanner).

Also 10 minutes is not that long; file system checks/repairs can
take days or weeks.

>> I wonder if quotacheck can be somehow improved or done
>> differently like doing it in parallel with normal fs usage
>> (so there will be no downtime) ?

>From 'man 8 quotacheck':

 "It is strongly recommended to run quotacheck with quotas turned off for  the  filesys-
  tem.  Otherwise, possible damage or loss to data in the quota files can result.  It is
  also unwise to run quotacheck on a live filesystem as actual usage may  change  during
  the  scan.   To  prevent  this,  quotacheck  tries to remount the filesystem read-only
  before starting the scan.  After the scan is done it  remounts  the  filesystem  read-
  write.  You  can disable this with option -m.  You can also make quotacheck ignore the
  failure to remount the filesystem read-only with option -M."

Accoridng to this the only consequence of parallel running of
'quotacheck' is a somewhat inaccurate accounting of quotas.

> I think the best idea to improve the performance in case you
> did a repair is to integrate the quotacheck code into repair.

Probably this should be 'xfs_check' more than 'xfs_repair'...

[ ... ]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
