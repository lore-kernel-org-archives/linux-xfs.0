Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 16:06:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1L06Mm7022159
	for <xfs@oss.sgi.com>; Tue, 20 Feb 2007 16:06:24 -0800
Date: Wed, 21 Feb 2007 11:07:01 +1100
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: xfsdump/xfsrestore question
Message-ID: <80FFF742E8A3FFB101CF1455@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
References: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>, xfs@oss.sgi.com

Hi,

--On 20 February 2007 4:16:31 PM +0200 Leon Kolchinsky <leonk@construct.haifa.ac.il> wrote:

> Hello All,
>
> I have a question about xfsdump/xfsrestore usage on Linux.
>
> Now the questions:
>
> 1) If I get the xfsdump synax correctly I just have to do:
>
># cd /
># xfsdump -f /data/backup.file /
>
> Is it right?
> What about opened and "currently in use by the system" files? Are they
> backuped in a proper way? What about tmpfs like /proc, are they been
> ignored?
>

Yes, the dump line looks reasonable (since /data is a different filesystem).
As Justin mentioned the dump wants a couple of ids (session-id, media-id) which
will be prompted for or you can specify then as command arguments.
>From the file xfsdump/doc/README.xfsdump:
  1. Dumping a filesystem to a dump file:
     xfsdump -f dump_file -L session_label -M media_label file_system
     e.g. xfsdump -f ./mydump -L 'session1' -M 'media1" /mnt/xfs0
Yes it is meant to handle a changing filesystem - you do see warning msgs sometimes because
it can't see a particular inode anymore, which can happen as we do multiple
scans of the inodes and if they get deleted then it obviously can't do anything
with it anymore or if the inode is reused as a dir instead of a reg-file etc...
It won't dump out foreign filesystems mounted under / because it doesn't
actually do a directory walk to dump data but actually iterates through
all the inodes of the filesystem (using an xfs ioctl called bulkstat) (and
for a directory inode it will just dump out the dirents).
It won't dump out /var/lib/xfsdump which contains the dump inventory which is
used for info for incremental dumps and resumed dumps.

> 2) If I'd have to restore my system from the dump, how would you recommend
> to do it? Booting from LiveCD and making # xfsrestore -f / data/backup.file
> / ?
>
Booting from a filesystem other than the one your are restoring to - yes:)

> Would it be a bootable/operational system?
Should be.
(Try it out:)

--Tim
