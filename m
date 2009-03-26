Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QKPTd8187456 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 15:25:39 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 538861C73CA0
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 13:24:43 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id 4e10GNgfVDH0MEP3 for
	<xfs@oss.sgi.com>; Thu, 26 Mar 2009 13:24:43 -0700 (PDT)
Date: Thu, 26 Mar 2009 21:24:29 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: accidentally deleted very large file (3.5TB) but still
	available through loop device
Message-ID: <20090326202429.GA27234@citd.de>
References: <49CBA221.2090701@cjx.com>
MIME-Version: 1.0
Content-Disposition: inline
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

On 26.03.2009 15:41, Chris Allen wrote:
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

Unfortunatly not directly. You can't create a directory entry for an 
inode. It was discussed a few years back, but rejected for security 
reasons. (I speak for the kernel in general, i don't know if there is a 
XFS specific thing to create a directory entry for an inode.)

> 2. Am I safe in accessing my filesystem through /dev/loop0 and  
> /recovered even though the underlying file has been zapped? If so

Yes. You are saved by the standard unix semantics of "only delete a file 
if it's reference count is 0". A directory entry counts and having a file 
open also counts.

> I can quickly copy everything off onto another partition.

As long as you don't reboot/umount the partition you are in no hurry.

Only Murphy can really ruin your day now. ;-)

> 3. Will this command: dd if=/dev/loop0 of=saved_file get my file back?

Yes, but:
- You should drop the caches before starting the copy:
echo 3 > /proc/sys/vm/drop_caches
- You should not touch the filesystem while copying. Especially you 
shouldn't write anything. The "view" of the upper- and underside 
(Filesystem vs. backing-store) are NOT kept in sync by the kernel. So it 
is best not to touch the filesystem.

You can also:
xfs_freeze the filesystem (see man xfs_freeze)

or umount the filesystem if the entry in "/etc/mtab" does NOT mention 
"loop=/dev/loop<whatever>" or if you delete if before umounting.
Because umount will only free the loop-device if there is a "loop=" or 
with the parameter "-d" (see man umount)




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
