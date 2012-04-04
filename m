Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3484cOw106183 for <xfs@oss.sgi.com>; Wed, 4 Apr 2012 03:04:38 -0500
Message-ID: <4F7C0021.8000608@oracle.com>
Date: Wed, 04 Apr 2012 16:02:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a directory
	if it was not enabled.
References: <4F77DFDB.1040802@oracle.com> <20120402163903.GA6425@infradead.org>
In-Reply-To: <20120402163903.GA6425@infradead.org>
Reply-To: jeff.liu@oracle.com
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
Cc: Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On 04/03/2012 12:39 AM, Christoph Hellwig wrote:

> On Sun, Apr 01, 2012 at 12:55:55PM +0800, Jeff Liu wrote:
>> Hello,
>>
>> I can trigger a BUG() at fs/xfs/xfs_dquot.c on vanilla kernel 3.3.0 by the following steps:
>>
>> 1. mount a XFS partition without 'pquota' option.
>>    /dev/sda7 on /xfs type xfs (rw)
>>
>> 2. setup project1 on it.
>>    $ cat /etc/projects 
>>    1:/xfs
>>    $ cat /etc/projid
>>    project1:1
>>    $ sudo xfs_quota -x -c 'project -s project1' /xfs
>>
>> 3. du -sh /xfs
> 
> Can you wire this up as a test case for xfstests?

Ok, I'll work it out.

Thanks,
-Jeff

> 
>> +		    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
>> +		     (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD)) {
> 
> This check is supposed to return false.  I guess Chandras separate
> project quota inode preparations somehow broke it.
> 
> Chandra, can you look into this issue?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
