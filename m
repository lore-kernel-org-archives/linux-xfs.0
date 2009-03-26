Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QG76Vh175665 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 11:07:16 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24C311C8DE5
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 09:06:40 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id ArCDRScAU0XzDZBq for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2009 09:06:40 -0700 (PDT)
Message-ID: <49CBA80A.8010500@sandeen.net>
Date: Thu, 26 Mar 2009 11:06:34 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: accidentally deleted very large file (3.5TB) but still available
	through loop device
References: <49CBA221.2090701@cjx.com>
In-Reply-To: <49CBA221.2090701@cjx.com>
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
To: Chris Allen <chris@cjx.com>
Cc: xfs@oss.sgi.com

Chris Allen wrote:
> Hi,
> 
> In a nutshell, I did the following:
> 
> 1. dd if=some_filesystem_dump of=some_file (where some_file resides on
> an XFS filesystem and is 3.5TB large)
> 
> 2. losetup /dev/loop0 some_file
> 
> 3. mount /dev/loop0 /recovered
> 
> [.... i can now access my recovered filesystem through /recovered ...]
> 
> 4. rm some_file (remotely via an nfs export) (oops!)
> 
> So, I just removed my 3.5TB file even though it is attached to the loop
> device and mounted (XFS did this almost instantly).
> 
> 
> Now it *appears* that the filesystem as attached to /dev/loop0 and
> mounted on /recovered is still OK. I
> can cd around it and copy files off.
> 
> So I have these questions:
> 
> 
> 1. Is there any way I can get back the 1 file that I accidentally
> deleted (nothing else has been written to that partition since)

I thought that maybe an open fd could be found in /proc, but it seems not.

> 2. Am I safe in accessing my filesystem through /dev/loop0 and
> /recovered even though the underlying file has been zapped? If so
> I can quickly copy everything off onto another partition.

The file is still held open by the loop device, so yes, it should be
just fine.  It doesn't really go away until you unmount & unhook the
loopback device.

> 3. Will this command: dd if=/dev/loop0 of=saved_file get my file back?

I'd suggest:

# xfs_freeze -f /recovered
# dd if=/dev/loop0 of=saved_file
# xfs_freeze -u /recovered

to be sure you get a consistent view of the fs.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
