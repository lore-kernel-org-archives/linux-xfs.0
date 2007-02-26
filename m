Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Feb 2007 05:14:48 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1QDEbm7004509
	for <xfs@oss.sgi.com>; Mon, 26 Feb 2007 05:14:40 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: xfsdump/xfsrestore question
Date: Mon, 26 Feb 2007 15:14:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070224151026.GA16887@teal.hq.k1024.org>
Message-Id: <20070226131930.477521FDCF@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Iustin Pop' <iusty@k1024.org>
Cc: 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>, 'Timothy Shimmin' <tes@sgi.com>, xfs@oss.sgi.com

> On Sat, Feb 24, 2007 at 05:04:33PM +0200, Leon Kolchinsky wrote:
> > Now, when I've tried to make non-interactive xfsdump I'vo got > prompt
> with
> > no action, like this
> > # xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
> > >
> > #
> >
> > So, I've got to Ctrl+C the process.
> >
> > Questions:
> > 1) What could be the syntax problem in the above command?
> > 2) Any examples for incremental xfsdump (non-interactive, i.e. run from
> > cronjob) would be very welcome (and also comments about xfsrestore from
> > these backups).
> 
> My non-interactive backup is (fragment from a script):
> 
> xfsdump -e -l $level -L "dump $lv at $day" - /$lv | gzip -v9 > $dest_file
> 
> and it works without prompts. Combining this with LVM snapshots also
> makes consistent backups.
> 

Thanks Iustin. It's very usefull.

So for non-interactive dumps I can use something like:
# xfsdump -e -l 0 -L "dump hda1 of `uname -n` at `date +%F`" -M "file" -f
/data/backup0.file /
# xfsdump -e -l 1 -L "dump hda1 of `uname -n` at `date +%F`" -M "file" -f
/data/backup1.file /
# xfsdump -e -l 2 -L "dump hda1 of `uname -n` at `date +%F`" -M "file" -f
/data/backup2.file /
etc.

The above is clear :)

The question now is how to maintain these dumps accordingly to
the inventory database in /var/lib/xfsdump/inventory.
I believe that if I just delete dump file, the inventory database won't be
updated, right?

Lets say, I did level 0 dump on Sunday and a 1,2,3,4,5,6 level backups on
the following days (all with different filenames o fcourse). So at the end
of the week I end up with 7 dump files.

I want this automatic procedure to continue to the next week with the same
filenames, so no additional files would be added and no disk space would be
wasted.

I came up with this:
--------------------
To remove the dump session in the inventory which is identified by the mount
point, was created prior to the specified date, and media_lable
Syntax:
xfsinvutil -n -m media_label -M mount_point mm/dd/yyyy

# DATE=`date +%m/%d/%Y`; xfsinvutil -n -m file0 -M vod:/ $DATE
# rm /data/backup0.file

I'll run the above 2 commands prior to xfsdump cronjobs. :)

This is my solution. If you have any comments/suggestion you are very
welcome.


Best Regards,
Leon Kolchinsky
