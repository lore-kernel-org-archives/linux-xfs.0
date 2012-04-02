Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32IaKBO236608 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 13:36:20 -0500
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id tUFAFxAC9nlWAl7j (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Apr 2012 11:36:19 -0700 (PDT)
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 2 Apr 2012 14:36:18 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id A6D7238C8054
	for <xfs@oss.sgi.com>; Mon,  2 Apr 2012 14:36:15 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q32IaFhx306798 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 14:36:15 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q32IaFCu014264 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 14:36:15 -0400
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a
	directory if it was not enabled.
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120402163903.GA6425@infradead.org>
References: <4F77DFDB.1040802@oracle.com> <20120402163903.GA6425@infradead.org>
Date: Mon, 02 Apr 2012 13:36:13 -0500
Message-ID: <1333391773.21996.13.camel@chandra-lucid.austin.ibm.com>
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

Will look into it, and report back.

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
