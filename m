Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 24 Feb 2007 07:10:51 -0800 (PST)
Received: from astra.simleu.ro (astra.simleu.ro [80.97.18.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1OFAcm7021581
	for <xfs@oss.sgi.com>; Sat, 24 Feb 2007 07:10:43 -0800
Date: Sat, 24 Feb 2007 16:10:26 +0100
From: Iustin Pop <iusty@k1024.org>
Subject: Re: xfsdump/xfsrestore question
Message-ID: <20070224151026.GA16887@teal.hq.k1024.org>
References: <1172148497.4634.36.camel@venus.local.navi.pl> <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>, 'Timothy Shimmin' <tes@sgi.com>, xfs@oss.sgi.com

On Sat, Feb 24, 2007 at 05:04:33PM +0200, Leon Kolchinsky wrote:
> Now, when I've tried to make non-interactive xfsdump I'vo got > prompt with
> no action, like this
> # xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
> >
> #
> 
> So, I've got to Ctrl+C the process.
> 
> Questions:
> 1) What could be the syntax problem in the above command?
> 2) Any examples for incremental xfsdump (non-interactive, i.e. run from
> cronjob) would be very welcome (and also comments about xfsrestore from
> these backups).

My non-interactive backup is (fragment from a script):

xfsdump -e -l $level -L "dump $lv at $day" - /$lv | gzip -v9 > $dest_file

and it works without prompts. Combining this with LVM snapshots also
makes consistent backups.

Regards,
Iustin
