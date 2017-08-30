Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751733AbdH3P3f (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 11:29:35 -0400
Date: Wed, 30 Aug 2017 17:29:31 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: introduce per-inode DAX flag
Message-ID: <20170830152931.GE5920@quack2.suse.cz>
References: <20170825075415.GA748@infradead.org>
 <20170825151445.ycf5xomoxvebgaez@thunk.org>
 <20170825154032.GA1827@infradead.org>
 <20170825233358.GC17782@dastard>
 <20170828073853.GA23262@infradead.org>
 <20170828101014.GD17782@dastard>
 <20170829154922.GA24592@quack2.suse.cz>
 <20170829225717.GG10621@dastard>
 <20170830100059.GC28354@quack2.suse.cz>
 <20170830123450.GA14976@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170830123450.GA14976@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-xfs@vger.kernel.org

On Wed 30-08-17 05:34:50, Christoph Hellwig wrote:
> On Wed, Aug 30, 2017 at 12:00:59PM +0200, Jan Kara wrote:
> > /dev/ram0 /mnt xfs rw,relatime,attr2,dax,inode64,noquota 0 0
> > 
> > marvin5:~/:[0]# ls /mnt/
> > fsxfile  fsxfile.fsxgood  fsxfile.fsxlog
> > 
> > marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'lsattr' /mnt/fsxfile
> > -p-------------- /mnt/fsxfile 
> > 
> > marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'chattr +x' /mnt/fsxfile
> > 
> > marvin5:~/:[0]# ./xfsprogs-dev/io/xfs_io -c 'lsattr' /mnt/fsxfile
> > -p-------------- /mnt/fsxfile 
> > 
> > No DAX flag set and no error... What am I doing wrong?
> 
> Odd.  Even on a non-DAX device the flag sticks for me:
> 
> root@testvm:~# mount /dev/sda /mnt/
> root@testvm:~# touch foo
> root@testvm:~# cd /mnt/
> root@testvm:/mnt# xfs_io -c 'chattr +x' foo
> root@testvm:/mnt# xfs_io -c 'lsattr' foo
> --------------x- foo

OK, tracked this down. I had the XFS filesystem created so that
ip->i_d.di_version < 3 check in xfs_set_diflags() was true and so the flag
got silently ignored. I'd hope to get error in such case but whatever...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
