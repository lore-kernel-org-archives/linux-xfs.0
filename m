Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0JIbnUE032603 for <xfs@oss.sgi.com>; Thu, 19 Jan 2012 12:37:50 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id fA7BG7KBHUSgYvrU for <xfs@oss.sgi.com>;
	Thu, 19 Jan 2012 10:37:49 -0800 (PST)
Message-ID: <4F1862FC.1050401@sandeen.net>
Date: Thu, 19 Jan 2012 12:37:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: mount other filesystems with selinux context
	as well
References: <4ECD3262.105@redhat.com> <20111128110228.GC13766@infradead.org>
In-Reply-To: <20111128110228.GC13766@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 11/28/11 5:02 AM, Christoph Hellwig wrote:
> On Wed, Nov 23, 2011 at 11:50:26AM -0600, Eric Sandeen wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> For some reason, non-xfs filesystems aren't getting mounted with
>> the selinux context; perhaps because none of the xattr tests used
>> to work on anything but xfs?
>>
>> Anyway, 062 fails for extN unless we mount with the fs-wide
>> context.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> - ---
>>
>> diff --git a/common.rc b/common.rc
>> index cab0b64..5998ff2 100644
>> - --- a/common.rc
>> +++ b/common.rc
>> @@ -86,14 +86,17 @@ _mount_opts()
>>  	export MOUNT_OPTIONS=$NFS_MOUNT_OPTIONS
>>  	;;
>>      ext2|ext3|ext4|ext4dev)
>> - -	# acls & xattrs aren't turned on by default on ext$FOO
>> +	export SELINUX_MOUNT_OPTIONS
>> +	# acls & xattrs aren't turned on by default on ext$FOO in old kernels
>>  	export MOUNT_OPTIONS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
>>  	;;
>>      reiserfs)
>> +	export SELINUX_MOUNT_OPTIONS
>>  	# acls & xattrs aren't turned on by default on reiserfs
>>  	export MOUNT_OPTIONS="-o acl,user_xattr $REISERFS_MOUNT_OPTIONS"
>>  	;;
>>      gfs2)
>> +	export SELINUX_MOUNT_OPTIONS
>>  	# acls aren't turned on by default on gfs2
>>  	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
>>  	;;
> 
> shouldn't the "export SELINUX_MOUNT_OPTIONS" simply move to common code?

I wasn't sure if nfs would grok it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
