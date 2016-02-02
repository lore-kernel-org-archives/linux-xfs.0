Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30B117CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 17:41:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C85488F8040
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 15:41:39 -0800 (PST)
Received: from mail-yk0-f172.google.com (mail-yk0-f172.google.com
	[209.85.160.172]) by cuda.sgi.com with ESMTP id
	NzTHFt4LEwc25wDY (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 15:41:38 -0800 (PST)
Received: by mail-yk0-f172.google.com with SMTP id r207so4463435ykd.2
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2016 15:41:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+ZsKJ5Xd1VyMD4KCTw4GLYn_stAUZX0OcQVju72+FPgYsGR6w@mail.gmail.com>
References: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160202231931.GR17997@ZenIV.linux.org.uk>
	<CA+ZsKJ5Xd1VyMD4KCTw4GLYn_stAUZX0OcQVju72+FPgYsGR6w@mail.gmail.com>
Date: Tue, 2 Feb 2016 15:41:37 -0800
Message-ID: <CAPcyv4h4Xk-=TeC_wz2Kemy-OzayyU9gP_cxe7S4aU_8VoV_Yw@mail.gmail.com>
Subject: Re: [PATCH] dax: allow DAX to look up an inode's block device
From: Dan Williams <dan.j.williams@intel.com>
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
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Tue, Feb 2, 2016 at 3:36 PM, Jared Hulbert <jaredeh@gmail.com> wrote:
> On Tue, Feb 2, 2016 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> On Tue, Feb 02, 2016 at 04:11:42PM -0700, Ross Zwisler wrote:
>>
>> > However, for raw block devices and for XFS with a real-time device, the
>> > value in inode->i_sb->s_bdev is not correct.  With the code as it is
>> > currently written, an fsync or msync to a DAX enabled raw block device will
>> > cause a NULL pointer dereference kernel BUG.  For this to work correctly we
>> > need to ask the block device or filesystem what struct block_device is
>> > appropriate for our inode.
>> >
>> > To that end, add a get_bdev(struct inode *) entry point to struct
>> > super_operations.  If this function pointer is non-NULL, this notifies DAX
>> > that it needs to use it to look up the correct block_device.  If
>> > i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.
>>
>> Umm...  It assumes that bdev will stay pinned for as long as inode is
>> referenced, presumably?  If so, that needs to be documented (and verified
>> for existing fs instances).  In principle, multi-disk fs might want to
>> support things like "silently move the inodes backed by that disk to other
>> ones"...
>
> Dan, This is exactly the kind of thing I'm taking about WRT the
> weirder device models and directly calling bdev_direct_access().
> Filesystems don't have the monogamous relationship with a device that
> is implicitly assumed in DAX, you have to ask the filesystem what the
> relationship is and is migrating to, and allow the filesystem to
> update DAX when the relationship is changing.

That's precisely what ->get_bdev() does.  When the answer
inode->i_sb->s_bdev lookup is invalid, use ->get_bdev().

> As we start to see many
> DIMM's and 10s TiB pmem systems this is going be an even bigger deal
> as load balancing, wear leveling, and fault tolerance concerned are
> inevitably driven by the filesystem.

No, there are no plans on the horizon for an fs to manage these media
specific concerns for persistent memory.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
