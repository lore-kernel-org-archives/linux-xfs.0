Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C97587F63
	for <xfs@oss.sgi.com>; Fri, 22 Mar 2013 12:27:47 -0500 (CDT)
Date: Fri, 22 Mar 2013 12:27:47 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Error 117 - help please
Message-ID: <20130322172747.GO22182@sgi.com>
References: <1D4217FF-BCB8-42A2-B30A-C362E0941FCD@cam.ac.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1D4217FF-BCB8-42A2-B30A-C362E0941FCD@cam.ac.uk>
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
To: Graham Eliff <ge217@cam.ac.uk>
Cc: xfs@oss.sgi.com

Hey Graham,

On Fri, Mar 22, 2013 at 09:52:44AM +0000, Graham Eliff wrote:
> Dear XFS Support
> I have this error and seem unable to resolve it.
> Do you have any advice please?
> Many Thanks
> Graham
> 
> 
> Machine running Linux version 2.6.18-194.32.1.el5.centos.plus
> CentOS release 5.5 (Final)
> 
> This is from fdisk -l
> 
> Disk /dev/sda: 3999.9 GB, 3999999721472 bytes
> 255 heads, 63 sectors/track, 486305 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> Device Boot Start End Blocks Id System
> /dev/sda1 1 267350 2147483647+ ee EFI GPT
> 
> 
> After running xfs_repair -L /dev/sda1 this is the tail end.
> 
> disconnected inode 2691081530, moving to lost+found
> disconnected inode 2691081531, moving to lost+found
> disconnected inode 2691081532, moving to lost+found
> disconnected inode 2691081533, moving to lost+found
> corrupt dinode 2691081533, extent total = 1, nblocks = 0.  This is a bug.
> Please capture the filesystem metadata with xfs_metadump and
> report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x2aaac5862840)
> 
> fatal error -- 117 - couldn't iget disconnected inode

I suspect this is fixed in 
commit e1f43b4c701b24d9b5bc85df858a8c36f0f0723b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Feb 2 07:39:10 2012 -0500

    repair: update extent count after zapping duplicate blocks

    When we find a duplicate extent in an extern format inode we do not zap
    the whole inode, but just truncate it to the point where the duplicate
    extent was found.  But the current code only updates di_nblocks for the
    new size, but no di_nextents/di_anextents.  In most cases this isn't noticed,
    but when moving such an inode to the lost+found directoy the consistency
    check in xfs_iformat trips over it.  Fix this by updating the on-disk
    extent count as part of the inode repair.

    Note that we zap btree format inodes with duplicate block completely
    at this point, so this fix doesn't apply to them.

    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
    Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

Could you try with a more recent version of xfsprogs?  Preferably the latest
but v3.1.8 at a minimum?

Get the sources here:
git://oss.sgi.com/xfs/cmds/xfsprogs.git

or here:
ftp://oss.sgi.com/projects/xfs/cmd_tars/

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
