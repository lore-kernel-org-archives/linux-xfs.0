Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8SHbpYq121750 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 12:37:51 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66B8A1426E48
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 10:43:54 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id fVdpgI1RcxVuKogC
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 10:43:54 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 938916C09D
	for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 12:37:49 -0500 (CDT)
Message-ID: <4E835B6F.5040500@hardwarefreak.com>
Date: Wed, 28 Sep 2011 12:37:51 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: 64-bit inodes and back again
References: <4E825C25.6050804@cchtml.com> <20110928011020.GE3159@dastard>
	<4E8278D8.9060309@cchtml.com> <4E828BE1.8030003@cchtml.com>
	<20110928053539.GF3159@dastard> <4E82C5AF.8040203@cchtml.com>
	<20110928110726.GG3159@dastard> <4E831D81.6070102@cchtml.com>
In-Reply-To: <4E831D81.6070102@cchtml.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 9/28/2011 8:13 AM, Michael Cronenworth wrote:
> Dave Chinner on 09/28/2011 06:07 AM wrote:
>> It's failing trying to copy the attributes on a directory. What are
>> the attributes on the specific directory?
>
> That particular directory was
>
> drwxrwsr-x root:mock
>
> However, I tried it on a number of other directories that had plain
> attributes like:
>
> drwxr-xr-x root:root
>
> It failed the same way on those directories.
>
> # ls -lid /usr/share/doc/xfsdump-3.0.4
> 4295007717 drwxr-xr-x. 2 root root 4096 Sep 28 02:58
> /usr/share/doc/xfsdump-3.0.4
> # xfs_reno -vv /usr/share/doc/xfsdump-3.0.4
> Scanning directory tree...
> Processing 1 directory...
> xfs_reno: directory: 4295007717 1 /usr/share/doc/xfsdump-3.0.4
> xfs_reno: unable to duplicate directory attributes:
> /usr/share/doc/xfsdump-3.0.4
> 0 seconds elapsed
> Done.
> # ls -lid /usr/share/doc/xfsdump-3.0.4
> 4295007717 drwxr-xr-x. 2 root root 4096 Sep 28 09:12
> /usr/share/doc/xfsdump-3.0.4

When you removed the inode64 mount option in fstab, did you change any 
other mount options on this filesystem?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
