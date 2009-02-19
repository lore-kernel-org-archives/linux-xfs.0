Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1JAE6Uo100325 for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 04:14:08 -0600
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7E936133244
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:13:32 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by
	cuda.sgi.com with ESMTP id xyA0fS9kPYnQwlHc for
	<xfs@oss.sgi.com>; Thu, 19 Feb 2009 02:13:32 -0800 (PST)
Message-ID: <499D30B1.30802@aei.mpg.de>
Date: Thu, 19 Feb 2009 11:13:05 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: Re: xfs problems (possibly after upgrading from linux kernel	2.6.27.10
	to .14)
References: <499ACE6C.4060304@aei.mpg.de> <20090218091935.GD8830@disturbed>
	<499BD6BB.2000406@aei.mpg.de> <20090219061925.GE8830@disturbed>
In-Reply-To: <20090219061925.GE8830@disturbed>
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, linux-kernel@vger.kernel.org, npiggin@suse.de

Hi again,

Dave Chinner schrieb:
>> I can try doing that on a few machines, would a metadump help on a
>> machine where this corruption occurred some time ago and is still in
>> this state?
> 
> If you unmount the filesystem, mount it again and then touch a new
> file and it reports the error again, then yes, a metadump woul dbe
> great.
> 
> If the error doesn't show up after a unmount/mount, then I
> can't use a metadump image to reproduce the problem.
> 

I've done it on two nodes so far and the result is not good (metadump wise):
[1344887.778232] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344887.778432] xfs_force_shutdown(sda6,0x1) called from line 420 of
file fs/xfs/xfs_rw.c.  Return address = 0xffffffff8031dd7e
[1344889.579836] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580044] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580257] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.580450] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344889.624774] Filesystem "sda6": xfs_log_force: error 5 returned.
[1344915.783844] XFS mounting filesystem sda6
[1344915.872333] Starting XFS recovery on filesystem: sda6 (logdev:
internal)
[1344917.399834] Ending XFS recovery on filesystem: sda6 (logdev: internal)

After that I can touch/create all files I want on the fs again.

> I suspect so. We've already had XFS trigger one bug in the new
> lockless pagecache code, and the fix for that went in 2.6.27.11 -
> between the good version and the version that you've been seeing
> these memory corruptions on. I'm wondering if that fix exposed or
> introduced another bug that you've hit....
> 
> Nick?

If it was triggered by a user job, it might have been in the kernel for
longer and the user just did not run it for a few weeks.

I'll try to gather more information.

Cheers

Carsten

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
