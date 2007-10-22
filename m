Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 21 Oct 2007 18:17:42 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9M1HZ8e024212
	for <linux-xfs@oss.sgi.com>; Sun, 21 Oct 2007 18:17:38 -0700
Date: Mon, 22 Oct 2007 11:17:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: can't remove dir
Message-ID: <20071022011729.GY995458@sgi.com>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr> <20071017212434.GB995458@sgi.com> <20071018131116.GA11957@apartia.fr> <20071018220714.GM995458@sgi.com> <20071019101008.GA28175@apartia.fr> <20071021235052.GV995458@sgi.com> <op.t0kpkzft3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t0kpkzft3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: David Chinner <dgc@sgi.com>, linux-xfs@oss.sgi.com, Louis-David Mitterrand <vindex+lists-xfs@apartia.org>

On Mon, Oct 22, 2007 at 10:42:25AM +1000, Barry Naujok wrote:
> On Mon, 22 Oct 2007 09:50:52 +1000, David Chinner <dgc@sgi.com> wrote:
> >On Fri, Oct 19, 2007 at 12:10:08PM +0200, Louis-David Mitterrand wrote:
> >>sylla:~# xfs_io -r -c "chattr -i" /lost+found/3912672557
> >>/lost+found/3912672557: No such file or directory
> >
> >Strange. This implies that lookup can't find inode # 3912672557.
> >We know it is there...
> >
> >How many other files in the directory? Can you get the inode number
> >for the lost+found directory and dump that with xfs_db (as per above)?
> >
> >Also, what happens if you "touch /lost+found/unix.7.gz" and try again?
> 
> Being a symbolic link, xfs_io follows them rather than operates on
> them directory.

Actually, I tested that before posting. If the symlink is dangling,
then the symlink gets the attributes attached to it:

# ls -l /mnt/scratch/
total 0
lrwxrwxrwx 1 root root 22 Oct 22 11:09 foo -> /mnt/scratch/unix.7.gz
# ls -l /mnt/scratch/unix.7.gz
/bin/ls: /mnt/scratch/unix.7.gz: No such file or directory
# xfs_io -f -r -c "lsattr" /mnt/scratch/foo
-------------- /mnt/scratch/foo
# xfs_io -f -c "chattr +i" /mnt/scratch/foo
# xfs_io -f -r -c "lsattr" /mnt/scratch/foo
--i----------- /mnt/scratch/foo
# umount /mnt/scratch
# mount !$
mount /mnt/scratch
# xfs_io -f -r -c "lsattr" /mnt/scratch/foo
--i----------- /mnt/scratch/foo
# xfs_io -f -c "chattr -i" /mnt/scratch/foo -r
# xfs_io -f -r -c "lsattr" /mnt/scratch/foo
-------------- /mnt/scratch/foo
#

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
