Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B4DAF7F3F
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 16:26:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A29058F8039
	for <xfs@oss.sgi.com>; Wed, 29 Oct 2014 14:26:01 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZCrG9er4qs1lnKkt for <xfs@oss.sgi.com>;
	Wed, 29 Oct 2014 14:25:59 -0700 (PDT)
Date: Thu, 30 Oct 2014 08:25:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsrestore report SUCCESS but not restore all files in kernel 3.17
Message-ID: <20141029212556.GH13323@dastard>
References: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAGdb-8cnmCs=L0RPvE8+5jn3nmZoviiZtQBbo9S-BThA+3cBKg@mail.gmail.com>
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
To: Tommy Wu <wu.tommy@gmail.com>
Cc: xfs <xfs@oss.sgi.com>

On Wed, Oct 29, 2014 at 12:06:10PM +0800, Tommy Wu wrote:
> /sbin/xfsrestore: session id: 6f114712-6fb6-4f35-a2f3-30ca1a0af5bb
> /sbin/xfsrestore: media id: 2eb2ff54-1838-47b2-a8d5-5f520deaf5f5
> /sbin/xfsrestore: searching media for directory dump
> /sbin/xfsrestore: reading directories
> /sbin/xfsrestore: 2035 directories and 33045 entries processed
> /sbin/xfsrestore: directory post-processing
> /sbin/xfsrestore: reading non-directory files
> /sbin/xfsrestore: NOTE: ino 144 salvaging file, placing in
> orphanage/143.0/Makefile
> /sbin/xfsrestore: NOTE: ino 145 salvaging file, placing in
> orphanage/143.0/bayer.png.b64
.....
> .... skip it....
> /sbin/xfsrestore: NOTE: ino 50363235 gen 1622742662 not referenced: placing
> in orphanage

FWIW, this can be expected behaviour if you run xfsdump on a live
filesystem. From the DIAGNOSTICS section of the xfsdump man page:

	The message ``xfsdump: WARNING: unable to open directory:
	ino N: Invalid argument'' can occur with filesystems which
	are actively being modified while xfsdump is running.
	This can happen to either directory or regular file inodes -
	affected files will not end up in the dump, files below
	affected directories will be placed in the orphanage
	directory by xfsrestore.

This is exactly what you are seeing - files being placed in the
orphanage on restore because they appear to have no parent directory
inode referencing them.

IOWs, you're likely seeing the effect of the filesystem changing
while you are running xfsdump, not a bug in xfsdump or xfs_restore.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
