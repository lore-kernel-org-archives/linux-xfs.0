Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q355IqUd005481 for <xfs@oss.sgi.com>; Thu, 5 Apr 2012 00:18:53 -0500
Message-ID: <4F7D2AC3.50204@oracle.com>
Date: Thu, 05 Apr 2012 13:16:51 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: don't fill statvfs with project quota for a directory
	if it was not enabled.
References: <4F77DFDB.1040802@oracle.com>	
	<20120402163903.GA6425@infradead.org>
	<1333558102.21996.117.camel@chandra-lucid.austin.ibm.com>
In-Reply-To: <1333558102.21996.117.camel@chandra-lucid.austin.ibm.com>
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
To: sekharan@us.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

Hi Chandra, 
On 04/05/2012 12:48 AM, Chandra Seetharaman wrote:

> I tried the steps in latest xfs tree and on mainline 3.3.0. Unable to
> reproduce the problem.
> 
> Jeff, how big was the FS and how full was it ?

Sorry, I have missed one major step to reproduce this issue previously.
Could you try to create a file under the project directory before setting it up?

Steps:
1. echo "1:/xfs" > /etc/projects; echo "project1:1" > /etc/projid
2. echo "test" > /xfs/testme
3. xfs_quota -x -c 'project -s project1' /xfs
4. du -sh /xfs

I have posted a test to xfstest at below link, it can help reproducing this issue.
http://www.spinics.net/lists/xfs/msg10744.html

Thanks,
-Jeff

> 
> Christoph, BTW, 3.3.0 does not have my changes. Ben pushed it for
> 3.4-rc1
> 
> Here is my results with 3.3.0
> -------------------
> -bash-4.1$ uname -r
> 3.3.0 
> bash-4.1$  mount | grep xfs
> /dev/sdb1 on /xfs type xfs (rw)
> bash-4.1$ cat /etc/projects
> 1:/xfs
> bash-4.1$ cat /etc/projid
> project1:1
> bash-4.1$ sudo xfs_quota -x -c 'project -s project1' /xfs
> [sudo] password for chandra: 
> Setting up project project1 (path /xfs)...
> Processed 1 (/etc/projects and cmdline) paths for project project1 with
> recursion depth infinite (-1).
> bash-4.1$ du -sh /xfs
> 0       /xfs
> bash-4.1$ exit
> ------------------
> 
> Chandra
> 
> On Mon, 2012-04-02 at 12:39 -0400, Christoph Hellwig wrote:
>> On Sun, Apr 01, 2012 at 12:55:55PM +0800, Jeff Liu wrote:
>>> Hello,
>>>
>>> I can trigger a BUG() at fs/xfs/xfs_dquot.c on vanilla kernel 3.3.0 by the following steps:
>>>
>>> 1. mount a XFS partition without 'pquota' option.
>>>    /dev/sda7 on /xfs type xfs (rw)
>>>
>>> 2. setup project1 on it.
>>>    $ cat /etc/projects 
>>>    1:/xfs
>>>    $ cat /etc/projid
>>>    project1:1
>>>    $ sudo xfs_quota -x -c 'project -s project1' /xfs
>>>
>>> 3. du -sh /xfs
>>
>> Can you wire this up as a test case for xfstests?
>>
>>> +		    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD))) ==
>>> +		     (XFS_PQUOTA_ACCT|XFS_OQUOTA_ENFD)) {
>>
>> This check is supposed to return false.  I guess Chandras separate
>> project quota inode preparations somehow broke it.
>>
>> Chandra, can you look into this issue?
>>
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
