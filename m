Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q34GnVDF184243 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 11:49:32 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id tWe6tEVYFlN8B9vg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Apr 2012 09:49:30 -0700 (PDT)
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 4 Apr 2012 10:49:29 -0600
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 7DCE3C9005C
	for <xfs@oss.sgi.com>; Wed,  4 Apr 2012 12:48:27 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q34GmRaJ3371162 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 12:48:28 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q34GmOGc014396 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 12:48:24 -0400
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a
	directory if it was not enabled.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120402163903.GA6425@infradead.org>
References: <4F77DFDB.1040802@oracle.com> <20120402163903.GA6425@infradead.org>
Date: Wed, 04 Apr 2012 11:48:22 -0500
Message-ID: <1333558102.21996.117.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Liu <jeff.liu@oracle.com>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

I tried the steps in latest xfs tree and on mainline 3.3.0. Unable to
reproduce the problem.

Jeff, how big was the FS and how full was it ?

Christoph, BTW, 3.3.0 does not have my changes. Ben pushed it for
3.4-rc1

Here is my results with 3.3.0
-------------------
-bash-4.1$ uname -r
3.3.0 
bash-4.1$  mount | grep xfs
/dev/sdb1 on /xfs type xfs (rw)
bash-4.1$ cat /etc/projects
1:/xfs
bash-4.1$ cat /etc/projid
project1:1
bash-4.1$ sudo xfs_quota -x -c 'project -s project1' /xfs
[sudo] password for chandra: 
Setting up project project1 (path /xfs)...
Processed 1 (/etc/projects and cmdline) paths for project project1 with
recursion depth infinite (-1).
bash-4.1$ du -sh /xfs
0       /xfs
bash-4.1$ exit
------------------

Chandra

On Mon, 2012-04-02 at 12:39 -0400, Christoph Hellwig wrote:
> On Sun, Apr 01, 2012 at 12:55:55PM +0800, Jeff Liu wrote:
> > Hello,
> > 
> > I can trigger a BUG() at fs/xfs/xfs_dquot.c on vanilla kernel 3.3.0 by the following steps:
> > 
> > 1. mount a XFS partition without 'pquota' option.
> >    /dev/sda7 on /xfs type xfs (rw)
> > 
> > 2. setup project1 on it.
> >    $ cat /etc/projects 
> >    1:/xfs
> >    $ cat /etc/projid
> >    project1:1
> >    $ sudo xfs_quota -x -c 'project -s project1' /xfs
> > 
> > 3. du -sh /xfs
> 
> Can you wire this up as a test case for xfstests?
> 
> > +		    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
> > +		     (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD)) {
> 
> This check is supposed to return false.  I guess Chandras separate
> project quota inode preparations somehow broke it.
> 
> Chandra, can you look into this issue?
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
