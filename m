Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 676CB7CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 17:38:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 270DF8F8040
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 15:38:20 -0800 (PST)
Received: from mail-yk0-f178.google.com (mail-yk0-f178.google.com
	[209.85.160.178]) by cuda.sgi.com with ESMTP id
	KImdqcXA29wq0YXP (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 15:38:18 -0800 (PST)
Received: by mail-yk0-f178.google.com with SMTP id z7so4340712yka.3
	for <xfs@oss.sgi.com>; Tue, 02 Feb 2016 15:38:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160202231931.GR17997@ZenIV.linux.org.uk>
References: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
	<20160202231931.GR17997@ZenIV.linux.org.uk>
Date: Tue, 2 Feb 2016 15:38:17 -0800
Message-ID: <CAPcyv4gtcL_WwZpmiAUhO5h4q3YyXinkpz9SwKm5SBA9-1kE9Q@mail.gmail.com>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@poochiereds.net>, linux-nvdimm <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, "J. Bruce Fields" <bfields@fieldses.org>, inux-btrfs@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>

[ adding btrfs ]

On Tue, Feb 2, 2016 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Feb 02, 2016 at 04:11:42PM -0700, Ross Zwisler wrote:
>
>> However, for raw block devices and for XFS with a real-time device, the
>> value in inode->i_sb->s_bdev is not correct.  With the code as it is
>> currently written, an fsync or msync to a DAX enabled raw block device will
>> cause a NULL pointer dereference kernel BUG.  For this to work correctly we
>> need to ask the block device or filesystem what struct block_device is
>> appropriate for our inode.
>>
>> To that end, add a get_bdev(struct inode *) entry point to struct
>> super_operations.  If this function pointer is non-NULL, this notifies DAX
>> that it needs to use it to look up the correct block_device.  If
>> i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.
>
> Umm...  It assumes that bdev will stay pinned for as long as inode is
> referenced, presumably?  If so, that needs to be documented (and verified
> for existing fs instances).  In principle, multi-disk fs might want to
> support things like "silently move the inodes backed by that disk to other
> ones"...

I assume btrfs is the only fs we have that might reassign the bdev for
a given inode on the fly?  Hopefully we don't need anything stronger
than rcu_read_lock() to pin the result as valid.

At least in this case the initial user is dax-fsync where the
->get_bdev() answer should be static for the life of the inode, and
btrfs does not currently interface with dax.  But yes, we need to get
the expected semantics clear.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
