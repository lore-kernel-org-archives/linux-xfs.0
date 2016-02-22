Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BDF917F67
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 11:53:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CA948F80B9
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 09:53:26 -0800 (PST)
Received: from vern.gendns.com (vern.gendns.com [206.190.152.46]) by
	cuda.sgi.com with ESMTP id wuTlkIp2Z07aC5Dj (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 09:53:24 -0800 (PST)
Subject: Re: recovering corrupt filesystem after raid failure
References: <56CA6492.7000407@lechnology.com> <20160222022439.GE14668@dastard>
From: David Lechner <david@lechnology.com>
Message-ID: <56CB4B16.8010101@lechnology.com>
Date: Mon, 22 Feb 2016 11:53:26 -0600
MIME-Version: 1.0
In-Reply-To: <20160222022439.GE14668@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 02/21/2016 08:24 PM, Dave Chinner wrote:
> On Sun, Feb 21, 2016 at 07:29:54PM -0600, David Lechner wrote:
>> Long story short, I had a dual disk failure in a raid 5. I've managed to
>> get the raid back up and salvaged what I could. However, the xfs is
>> seriously damaged. I've tried running xfs_repair, but it is failing and
>> it recommended to send a message to this mailing list. This is an Ubuntu
>> 12.04 machine, so xfs_repair version 3.1.7.
> 
> So the first thing to do is get a more recent xfsprogs package and
> try that. There's not a lot of point in us looking at problems with
> a 4 and half year old package that we've probably already fixed.
> 
>> The file system won't mount. Fails with "mount: Structure needs
>> cleaning". So I tried xfs_repair. I had to resort to xfs_repair -L
>> because the first 500MB or so of the filesystem was wiped out.
> 
> Oh, so even if you can repair the filesystem, your data is likely to
> be irretreivably corrupted.
> 
>> Now,
>> xfs_repair /dev/md127 gets stuck, so I am running xfs_repair -P
>> /dev/md127. This gets much farther, but it is failing too. It gives an
>> error message like this:
>>
>>
>> ...
>> disconnected inode 2101958, moving to lost+found
>> corrupt dinode 2101958, extent total = 1, nblocks = 0.  This is a bug.
>> Please capture the filesystem metadata with xfs_metadump and
>> report it to xfs@oss.sgi.com.
>> cache_node_purge: refcount was 1, not zero (node=0x7f2c57e1b120)
>>
>> fatal error -- 117 - couldn't iget disconnected inode
>>
>>
>>
>> However, nblocks = 0 does not seem to be true...
> 
> Probably because it got cleared in memory before this problem was
> tripped over.
> 
>> If I re-run xfs_repair -P /dev/md127, it will fail on different
>> seemingly random inode with the same error message.
> 
> Yup, you definitely need to run a current xfs_repair on this
> filesystem before going any further.
> 
> Cheers,
> 
> Dave.
> 

Thanks for the advice. The newer version was able to complete
successfully. I can now mount the file system and I ended up with 1.5TB
in lost+found, so at least there is still something there.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
