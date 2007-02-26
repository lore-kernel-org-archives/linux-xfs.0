Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 25 Feb 2007 21:30:23 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l1Q5UDm7014975
	for <xfs@oss.sgi.com>; Sun, 25 Feb 2007 21:30:15 -0800
Message-ID: <45E27050.6080609@sgi.com>
Date: Mon, 26 Feb 2007 16:29:52 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsdump/xfsrestore question
References: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
In-Reply-To: <20070224150933.BFE26200D8@mail.edu.haifa.ac.il>
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Leon Kolchinsky <leonk@construct.haifa.ac.il>
Cc: 'Olaf Fr?czyk' <olaf@cbk.poznan.pl>, 'Timothy Shimmin' <tes@sgi.com>, xfs@oss.sgi.com

Leon Kolchinsky wrote:
> Now, when I've tried to make non-interactive xfsdump I'vo got > prompt with
> no action, like this
> # xfsdump -f /data/backup2.file -L 'session1' -M 'media1" /
> #
> 
> So, I've got to Ctrl+C the process.
> 
> Questions:
> 1) What could be the syntax problem in the above command?

The above command seems to have a typo wrt unbalanced quotes.

I'd say the " at the end of line is making the shell hang around
waiting for you to match the quotes (' and ").

So xfsdump is not actually running.

Try

xfsdump -f /data/backup2.file -L 'session1' -M 'media1' /


> 2) Any examples for incremental xfsdump (non-interactive, i.e. run from
> cronjob) would be very welcome (and also comments about xfsrestore from
> these backups).
> 
> On the other hand, interactive xfsdump went fine:
