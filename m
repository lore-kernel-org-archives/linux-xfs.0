Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC38D29DF7
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 16:36:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49CD6AC001
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2014 14:36:13 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	BahZo2vruZcCFvFa for <xfs@oss.sgi.com>;
	Mon, 22 Dec 2014 14:36:11 -0800 (PST)
Date: Tue, 23 Dec 2014 09:35:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: weird quota issue
Message-ID: <20141222223540.GS15665@dastard>
References: <3BD1EE39-8C26-4C5B-94B5-492422EECEDA@mail.nih.gov>
	<20141222204857.GK24183@dastard>
	<6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6F43BF63-A44E-43F6-A184-9AAC10DDDFDF@grc.nia.nih.gov>
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
To: "Weber, Charles (NIH/NIA/IRP) [C]" <weberc@grc.nia.nih.gov>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 22, 2014 at 05:13:06PM -0500, Weber, Charles (NIH/NIA/IRP) [C] wrote:
> Thanks for replying. The project part is a red herring and I have
> abandoned it. The only reason project quotas even came up was the
> winbind/quota issue. UID is fine.  The more interesting part is
> the way the /proc/self/mounts and mtab/fstab are not coherent.

If /etc/mtab is not linked to /proc/mounts, then userspace maintains
it and it does not reflect the mount options the kernel have active.
YOU can put any amount of crap in invalid mount options that mount
will just dump in /etc/mtab even though the kernel ignores them.

We generally expect that systems are set up like this:

$ ls -l /etc/mtab
lrwxrwxrwx 1 root root 12 Jan  9  2012 /etc/mtab -> /proc/mounts
$

> 
> dmesg output
> SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
> SGI XFS Quota Management subsystem
> XFS (dm-7): delaylog is the default now, option is deprecated.
> XFS (dm-7): Mounting Filesystem
> XFS (dm-7): Ending clean mount
> XFS (dm-7): Failed to initialize disk quotas.

Which indicates that there's problems reading or allocating the
quota inodes. What is the output of 'xfs_db -c "sb 0" -c p
/dev/dm-7'?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
