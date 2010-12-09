Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB93gSHg166437 for <xfs@oss.sgi.com>; Wed, 8 Dec 2010 21:42:28 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F9B51CA8ED2
	for <xfs@oss.sgi.com>; Wed,  8 Dec 2010 19:44:16 -0800 (PST)
Received: from mail.sandeen.net (64-131-28-21.usfamily.net [64.131.28.21]) by
	cuda.sgi.com with ESMTP id JEutCkHHfi6U8Bhv for
	<xfs@oss.sgi.com>; Wed, 08 Dec 2010 19:44:16 -0800 (PST)
Message-ID: <4D00508E.5040408@sandeen.net>
Date: Wed, 08 Dec 2010 21:44:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: possible xfs corruption
References: <30395558.post@talk.nabble.com> <20101207221009.GA29333@dastard>
In-Reply-To: <20101207221009.GA29333@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: blacknred <leo1783@hotmail.co.uk>, xfs@oss.sgi.com

On 12/7/10 4:10 PM, Dave Chinner wrote:
> On Tue, Dec 07, 2010 at 03:49:49AM -0800, blacknred wrote:
>>
>> Hi...
>>
>> I'm stuck with a storage issue on reboot. Initially doubted the storage, but
>> dmesg throws these errors. Now wondering whether this is a fs issue? Any
>> thoughts as to whats going on here?
>>
>>
>> XFS: failed to locate log tail
>> XFS: log mount/recovery failed: error 117
>> XFS: log mount failed
>> XFS mounting filesystem cciss/c0d0
>> Filesystem "cciss/c0d0": XFS internal error xlog_clear_stale_blocks(2) at
>> line 1237 of file
> 
> Which indicates that the head and/or the tail of the log are not
> valid. Can you provide the output of:
> 
> # xfs_logprint -d /dev/cciss/c0d0
> 
> So we can see what the head/tail values are in the log?
> 
>> /home/buildsvn/rpmbuild/BUILD/xfs-kmod-0.4/_kmod_build_PAE/xfs_log_recover.c. 
> 
> CentOS kernel? How old?

Assuning it's centos5, there's really no need to be using an xfs kmod there
anymore, the module shipped with the kernel in recent versions of the OS
is really the one you want to use.  That kmod is ancient and unmaintained.

Although I suspect the storage is more likely at fault here.  :)

-Eric


> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
