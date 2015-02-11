Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C97607F50
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 07:10:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 491A8AC008
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 05:10:51 -0800 (PST)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id 14CESkfgTkuh64Cq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Feb 2015 05:10:48 -0800 (PST)
Received: by mail-wg0-f53.google.com with SMTP id x13so3294732wgg.12
	for <xfs@oss.sgi.com>; Wed, 11 Feb 2015 05:10:46 -0800 (PST)
Message-ID: <54DB54D4.7010602@plexistor.com>
Date: Wed, 11 Feb 2015 15:10:44 +0200
From: Boaz Harrosh <boaz@plexistor.com>
MIME-Version: 1.0
Subject: Re: shared/032 is broken on Fedora
References: <54DB35F0.1010203@plexistor.com>
In-Reply-To: <54DB35F0.1010203@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On 02/11/2015 12:58 PM, Boaz Harrosh wrote:
> 
> This is not the proper patch just to show a working version for Fedora. But I think
> it now breaks the other ARCHs.
> 
> What happens is that the output of ${MKFS_PROG}.* is:
> 	/usr/sbin/mkfs.bfs /usr/sbin/mkfs.btrfs /usr/sbin/mkfs.cramfs /usr/sbin/mkfs.ext2 /usr/sbin/mkfs.ext3 /usr/sbin/mkfs.ext4 ...
> 
> So in Fedora sbin has moved to /usr/... and therefor the sed below fails.
> My sed foo is not good enough. How to support both places for sbin?
> 
> Also why the "_supported_fs xfs btrfs"? So if all those other mkfs.* that are destructive to
> foreign filesystem, should the test not fail instead of skipped?
> Maybe if the maintainers of all these filesystems day in and day out running xfstests and
> see shared/032 failing, they might decide to fix their evil ways. Instead of skipping the
> test and the said maintainer just ignores it?
> 

I was thinking about fixing this test, say for ext4. And came to the conclusion.

Should I not hack and fix the mount command? This problem is common to all
filesystems. Why do we want to force all mkfs.* maintainers to link with some
global library that checks all registered FSs and see existence of an FS, something
like blkid.

Why not link that library to the driver "mount" command, and not call the
mkfs.$type in question at all unless say --force flag is supplied.

This way I fix this test for all FSs past and future.
(Should I send a patch?)

Thanks
Boaz

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
