Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Feb 2007 13:03:00 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1LL2rm7028458
	for <xfs@oss.sgi.com>; Wed, 21 Feb 2007 13:02:56 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: xfsdump/xfsrestore question
Date: Wed, 21 Feb 2007 23:02:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <80FFF742E8A3FFB101CF1455@timothy-shimmins-power-mac-g5.local>
Message-Id: <20070221210735.0585114B0E7@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Timothy Shimmin' <tes@sgi.com>, xfs@oss.sgi.com

>
> ># xfsdump -f /data/backup.file /
> >
> > Is it right?
> > What about opened and "currently in use by the system" files? Are they
> > backuped in a proper way? What about tmpfs like /proc, are they been
> > ignored?
> >
> 
> Yes, the dump line looks reasonable (since /data is a different
> filesystem).
> As Justin mentioned the dump wants a couple of ids (session-id, media-id)
> which
> will be prompted for or you can specify then as command arguments.
> >From the file xfsdump/doc/README.xfsdump:
>   1. Dumping a filesystem to a dump file:
>      xfsdump -f dump_file -L session_label -M media_label file_system
>      e.g. xfsdump -f ./mydump -L 'session1' -M 'media1" /mnt/xfs0
> Yes it is meant to handle a changing filesystem - you do see warning msgs
> sometimes because
> it can't see a particular inode anymore, which can happen as we do
> multiple
> scans of the inodes and if they get deleted then it obviously can't do
> anything
> with it anymore or if the inode is reused as a dir instead of a reg-file
> etc...
> It won't dump out foreign filesystems mounted under / because it doesn't
> actually do a directory walk to dump data but actually iterates through
> all the inodes of the filesystem (using an xfs ioctl called bulkstat) (and
> for a directory inode it will just dump out the dirents).
> It won't dump out /var/lib/xfsdump which contains the dump inventory which
> is
> used for info for incremental dumps and resumed dumps.
> 
> > 2) If I'd have to restore my system from the dump, how would you
> recommend
> > to do it? Booting from LiveCD and making # xfsrestore -f /
> data/backup.file
> > / ?
> >
> Booting from a filesystem other than the one your are restoring to - yes:)
> 
> > Would it be a bootable/operational system?
> Should be.
> (Try it out:)
> 
> --Tim
> 

Thanks Justin,Timothy,

It's clearing things out :)

You right, man pages say that xfsdump can only dump XFS filesystems, so I
don't worry about procfs now :)

So,my backup command would look like this:
xfsdump -L 'session1' -M 'media1" -f /data/sysbackup.file / 

But if I want to make an incremental backup now, should I use this command?
xfsdump -l 1 -f /data/sysbackup.file /

What incremental filename would be created in this case?
Is the syntax right?

Sorry, but man pages a little unclear for me on this issue and there is
almost no examples showing xfsdump usage on the net :(


Best Regards,
Leon Kolchinsky
