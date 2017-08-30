Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751318AbdH3Mey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Aug 2017 08:34:54 -0400
Date: Wed, 30 Aug 2017 05:34:50 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170830123450.GA14976@infradead.org>
References: <20170824182057.amdirlrbugezrahy@thunk.org>
 <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
 <20170828073853.GA23262@infradead.org>
 <20170828101014.GD17782@dastard>
 <20170829154922.GA24592@quack2.suse.cz>
 <20170829225717.GG10621@dastard>
 <20170830100059.GC28354@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830100059.GC28354@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Aug 30, 2017 at 12:00:59PM +0200, Jan Kara wrote:
> /dev/ram0 /mnt xfs rw,relatime,attr2,dax,inode64,noquota 0 0
> 
> marvin5:~/:[0]# ls /mnt/
> fsxfile  fsxfile.fsxgood  fsxfile.fsxlog
> 
> marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'lsattr' /mnt/fsxfile
> -p-------------- /mnt/fsxfile 
> 
> marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'chattr +x' /mnt/fsxfile
> 
> marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'lsattr' /mnt/fsxfile
> -p-------------- /mnt/fsxfile 
> 
> No DAX flag set and no error... What am I doing wrong?

Odd.  Even on a non-DAX device the flag sticks for me:

root@testvm:~# mount /dev/sda /mnt/
root@testvm:~# touch foo
root@testvm:~# cd /mnt/
root@testvm:/mnt# xfs_io -c 'chattr +x' foo
root@testvm:/mnt# xfs_io -c 'lsattr' foo
--------------x- foo

