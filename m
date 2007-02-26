Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 26 Feb 2007 05:16:55 -0800 (PST)
Received: from mail.edu.haifa.ac.il (mail.edu.haifa.ac.il [132.74.40.10])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1QDGom7005075
	for <xfs@oss.sgi.com>; Mon, 26 Feb 2007 05:16:52 -0800
From: "Leon Kolchinsky" <leonk@construct.haifa.ac.il>
Subject: RE: xfsdump/xfsrestore question
Date: Mon, 26 Feb 2007 15:16:49 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	charset="windows-1255"
Content-Transfer-Encoding: 7bit
In-Reply-To: <3D67095B5C9E951BA3DB9BD5@timothy-shimmins-power-mac-g5.local>
Message-Id: <20070226132145.12C281FF44@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Timothy Shimmin' <tes@sgi.com>, 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>
Cc: xfs@oss.sgi.com


> > Yep, consistent FS is what I care about in the case of disaster.
> >
> I'm not sure I know exactly what you are getting at.
> After the restore you should have a consistent FS because it is _not_
> a low level filesystem dumper. It is mostly a high lever dump/restore
> program and to the extent that it can generally restore to a foreign
> filesystem e.g. ext2.
> (For example, it does know about file extents but it only uses this info
> on restore to
> preserve holes by seeking and writing.)
> So as it is just doing standard system calls on restore, it can't really
> violate filesystem consistency.
> 
> 
> > Now, when I've tried to make non-interactive xfsdump I'vo got > prompt
> with
> > no action, like this
> ># xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
> >>
> Presumably quoting problem as Donald pointed out - it definitely works
> otherwise
> without extra input.
> 


Thanks Donald, Timothy

It was indeed quotes problem :)
It's running OK now.


Best Regards,
Leon Kolchinsky
