Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2A5P8oW104547 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 23:25:09 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	OV95K2M5mHEnLX6K (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 21:25:07 -0800 (PST)
Received: by iaoo28 with SMTP id o28so3605210iao.26
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 21:25:07 -0800 (PST)
Received: by iaoo28 with SMTP id o28so3605199iao.26
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 21:25:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F5ADFCB.9010602@sandeen.net>
References: <CAEm1Pvny7Q2rrsCLURvo5kQM3vt+yMg17WxoSYGKVWm7Lgp8MA@mail.gmail.com>
	<4F5ADFCB.9010602@sandeen.net>
Date: Fri, 9 Mar 2012 21:25:06 -0800
Message-ID: <CAEm1PvmTCaw_eSNPPvQLvwu5X7ywseOBbALxMkSLnOT9iQd6fQ@mail.gmail.com>
Subject: Re: 1B files, slow file creation, only AG0 used
From: Michael Spiegle <mike@nauticaltech.com>
Reply-To: mike@nauticaltech.com
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Fri, Mar 9, 2012 at 8:59 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> on centos please be sure you're not using the old xfs kmod package, just FYI.
> The module shipped with the kernel is what you should use.

We're definitely using the XFS module that came with the kernel.  In
any case, we're seeing problems with the 3.2.9 kernel as well, but
maybe this is due to running mkfs.xfs from CentOS 5.6

>
> If anything this is testament to xfs scalability, if it can make the billion-and-first inode in a single dir in "only" 300ms ;)
>
> You might want to read up on the available docs, i.e.
>
> http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/xfs-allocators.html
>
> probably covers a lot of what you are wondering about.
>
> When you make a new dir, in general xfs will put inodes & files in that dir into a new
> AG.
>
> But another thing you are likely running into is the inode32 allocation behavior, also explained in the doc above.
> In that case inodes are kept in the lower ags, and data is sprinkled around the higher AGs.
>

Our "1B" files are spread out evenly into a tree of 65536 directories.
 I've read the docs, and they seem explicit about new directories
being created in new AGs, however we are not seeing that on our
system.  All 1B files (despite being spread out across more than 64K
dirs) are in the first AG.  I have tried remounting the filesystem
with inode64 (and on 3.2.9), but this behavior does not seem to change
even if I add more files afterwards.

>
> If you mount with -o inode64, inodes may be allocated anywhere on the fs, in any AG. New subdirs go to new AGs, activity will be distributed across the filesystem. As long as your applications can properly handle 64-bit inode numbers, this is probably the way to go.
>
> You would be better off not creating all billion in a single dir, as well.
>

As mentioned above, the inode64 mount option doesn't seem to affect
anything.  Can you think of anything else I should check that would
prevent this from working?

>
> I wonder why you have attr=0 and 32 ags; pretty old xfsprogs maybe.
>

Yep, the filesystem was created with the xfsprogs that came with
CentOS 5.6.  Unfortunately, it took us a long time to copy all of the
files to this filesystem, so we're looking for a way to fix this
without having to reformat.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
