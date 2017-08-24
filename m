Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52210 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753428AbdHXXfC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 Aug 2017 19:35:02 -0400
Date: Thu, 24 Aug 2017 19:34:53 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Filesystem configuration parsers - (was: Re: [RESEND][PATCH]
 xfs: add online uevent for mount operation)
Message-ID: <20170824233453.eqxxlckkelp334yi@thunk.org>
References: <1503582115-37220-1-git-send-email-houtao1@huawei.com>
 <20170824171028.GF4796@magnolia>
 <20170824180441.GL27873@wotan.suse.de>
 <87a82ok45i.fsf@notabene.neil.brown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a82ok45i.fsf@notabene.neil.brown.name>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: NeilBrown <neilb@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, linux-fsdevel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>, Dmitri Pal <dpal@redhat.com>

On Fri, Aug 25, 2017 at 08:11:05AM +1000, NeilBrown wrote:
> 
> Just to provide contrast, NFS has a config file which can provide
> certain defaults for mounted filesystems.  However it doesn't require a
> udev event to achieve this.

I think we're mixing multiple things, and that may be confusing the
discussion.  A config file parser is a technology.  *How* you use the
config file parser can be quite different even if it is using the same
config file parser or config file format.

>From what I've seen in this e-mail thread, there are at least three
different use cases:

1)  How mkfs uses to create the file system
2)  How the file system should be configured when/while it is mounted
3)  Message marshalling and unmarshalling when communicating with the
    kernel via uevents

> Instead, it provides "/sbin/mount.nfs" which imposes the defaults at
> mount time, rather than just after mount time.
> 
> There could, conceivably, be an "/sbin/mount.xfs" which read the config
> file and set all the defaults concurrently with the mount operation.

For nfs there are a large number of knobs that are of interest at
mount time, such that specifying them all as mount options on the
command line, or in /etc/fstab, gets spectacularly painful.  Which is
why /etc/nfsmount.conf makes sense.

For ext4 and nfs we have many more knobs that come into play when the
file system is created, and so for ext4 that's why I have
/etc/mke2fs.conf, where I might have some complex stanzas such as:

    hugefile = {
        features = extent,huge_file,bigalloc,flex_bg,uninit_bg,dir_nlink,extra_isize,^resize_inode,sparse_super2
        cluster_size = 32768
        hash_alg = half_md4
        reserved_ratio = 0.0
        num_backup_sb = 0
        packed_meta_blocks = 1
        make_hugefiles = 1
        inode_ratio = 4194304
        hugefiles_dir = /huge-dir
        hugefiles_name = huge-data
        hugefiles_digits = 0
        hugefiles_size = 0
        hugefiles_align = 256M
        hugefiles_align_disk = true
        num_hugefiles = 1
        zero_hugefiles = false
	flex_bg_size = 262144
    }

...and then the sysadmin only has to type "mke2fs -T hugefile
/dev/sdc3" (for example).

The question of using the same parser for uevents is yet another can
of worms.  And there, I think we need to be careful about what the
requirements are for these uevents.  Uevents is just the technology.
There are many use cases for that technology; are you using them to
signal mounts/unmounts?  And at the file system level or at the mount
namespace level?

Are you using them to single file system corruption problems?  And if
so, are you trying to trying to send a single bit of information ---
"the file system is corrupted"?  Or are you trying to send much more
information --- for example, sending each inode that file system found
that was corrupted, and each block number where the SCSI device found
a media error?  (We have a solution that does this inside Google, and
it uses a netlink socket to do the delievery.  I'm pretty sure that if
you used uevents, udev could melt down if there are a large number of
errors reported.)

And then the final question here is how much does standardization
help?  Are there use cases where progams really want to use the same
format when updating /etc/mke2fs.conf versus /etc/nfsmount.conf versus
/etc/mkfs.xfs.conf?  Or is this more of, "let's try to make life
slightly easier for the user by keeping things mostly the same as we
can"?  Or is this just a matter of file system developers sharing
their experiences of various different designs, just so that they are
aware of what libaries or code bases are available for them to use?

Cheers,

						- Ted
