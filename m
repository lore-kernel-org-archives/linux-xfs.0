Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 15B057F37
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 05:17:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 037F58F8033
	for <xfs@oss.sgi.com>; Thu,  9 Jul 2015 03:17:20 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id vLcVgOH3Ksi3AL3b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 09 Jul 2015 03:17:17 -0700 (PDT)
Date: Thu, 9 Jul 2015 12:17:11 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: take XFS_IOLOCK_EXCL if suid removal is required
Message-ID: <20150709101711.GC2900@quack.suse.cz>
References: <54F9DBAE.2070002@redhat.com> <20150306210927.GA13958@dastard>
	<557EEEAD.8000701@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <557EEEAD.8000701@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>, xfs-oss <xfs@oss.sgi.com>

On Mon 15-06-15 10:26:37, Eric Sandeen wrote:
> On 3/6/15 3:09 PM, Dave Chinner wrote:
> > On Fri, Mar 06, 2015 at 10:54:06AM -0600, Eric Sandeen wrote:
> >> This sequence:
> >>
> >> # rm -f sparsefile
> >> # truncate --size=1m sparsefile
> >> # chmod ugo+rws sparsefile
> >> # ls -l sparsefile
> >> -rwSrwSrw-. 1 root root 1048576 Mar  6 10:29 sparsefile
> >> # su tester
> >>
> >> $ xfs_io -d -c "pwrite 0 4096" sparsefile
> >> wrote 4096/4096 bytes at offset 0
> >> 4 KiB, 1 ops; 0.0000 sec (21.505 KiB/sec and 5.3763 ops/sec)
> >> $ exit
> >>
> >> will lead to a WARN_ON() in notify change, because i_mutex is
> >> not held, and we get to notify_change via suid removal with
> >> only XFS_IOLOCK_SHARED held, i.e. no i_mutex.
> >>
> >> Upgrade the lock to XFS_IOLOCK_EXCL in this case.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > 
> > I believe Jan Kara has already addressed this problem in
> > this patchset:
> > 
> > http://oss.sgi.com/archives/xfs/2015-03/msg00051.html
> 
> Seems like that patchset never made it anywhere, though, so this
> is still an outstanding problem.  :(

Al just merged the patch set during this merge window. Hurray!

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
