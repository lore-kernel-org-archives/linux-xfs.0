Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98D337F3F
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 08:09:04 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 87F17304048
	for <xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:09:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Owpx0q1UyJcfKzwr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Dec 2015 06:09:00 -0800 (PST)
Date: Thu, 17 Dec 2015 15:08:58 +0100
From: Karel Zak <kzak@redhat.com>
Subject: Re: Ideas on unified real-ro mount option across all filesystems
Message-ID: <20151217140858.GD13224@ws.net.home>
References: <567212DA.8050808@cn.fujitsu.com>
 <567228EF.80007@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <567228EF.80007@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: fsdevel <linux-fsdevel@vger.kernel.org>, Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-ext4@vger.kernel.org, btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On Wed, Dec 16, 2015 at 09:15:59PM -0600, Eric Sandeen wrote:
> I have always interpreted it as simply "no user changes to the filesystem,"
> and that is clearly what the vfs does with the flag...

Yep,

> Given that nothing in the documentation implies that the block device itself
> must remain unchanged on a read-only mount, I don't see any problem which
> needs fixing.  MS_RDONLY rejects user IO; that's all.

I agree, it's FS specific business to interpret the 'ro'.

And it's already enough complicated, we have three levels of "read-only":

 - read-only device (blockdev --setro ioctl)
 - read-only filesystem (mount -o ro)
 - read-only VFS node (mount -o remount,ro,bind /src /dst)

and for example in /proc/self/mountinfo we distinguish between FS "ro"
and VFS "ro" flag:

# grep test /proc/self/mountinfo
185 59 8:5 / /mnt/test ro,relatime shared:32 - ext4 /dev/sda5 rw,data=ordered
                       ^^                                     ^^


BTW, util-linux 2.27 mount(8) man page:

   -r, --read-only
       Mount the filesystem read-only.  A synonym is -o ro.

       Note  that,  depending  on the filesystem type, state and
       kernel behavior, the system may still write to the device.  For
       example, ext3 and ext4 will replay the journal if the
       filesystem is dirty.  To prevent this kind of write access, you
       may want to mount an ext3 or ext4 filesystem with the ro,noload
       mount options or set the  block  device itself to read-only
       mode, see the blockdev(8) command.


 (maybe we need to copy this note to "ro" description too and add hint
 about btrfs too :-)

     Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
