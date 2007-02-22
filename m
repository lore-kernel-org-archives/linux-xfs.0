Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Feb 2007 05:02:18 -0800 (PST)
Received: from zeus.office.navi.pl (ip-83-238-212-180.netia.com.pl [83.238.212.180])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1MD2Bm7026734
	for <xfs@oss.sgi.com>; Thu, 22 Feb 2007 05:02:12 -0800
Subject: Re: xfsdump/xfsrestore question
From: Olaf =?iso-8859-2?Q?Fr=B1czyk?= <olaf@cbk.poznan.pl>
In-Reply-To: <80FFF742E8A3FFB101CF1455@timothy-shimmins-power-mac-g5.local>
References: <20070220142114.2B52C1C9C6@mail.edu.haifa.ac.il>
	 <80FFF742E8A3FFB101CF1455@timothy-shimmins-power-mac-g5.local>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 Feb 2007 13:48:17 +0100
Message-Id: <1172148497.4634.36.camel@venus.local.navi.pl>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Leon Kolchinsky <leonk@construct.haifa.ac.il>, xfs@oss.sgi.com

On Wed, 2007-02-21 at 11:07 +1100, Timothy Shimmin wrote:
> Hi,
> 
> --On 20 February 2007 4:16:31 PM +0200 Leon Kolchinsky <leonk@construct.haifa.ac.il> wrote:
> 
> > Hello All,
> >
> > I have a question about xfsdump/xfsrestore usage on Linux.
> >
> > Now the questions:
> >
> > 1) If I get the xfsdump synax correctly I just have to do:
> >
> ># cd /
> ># xfsdump -f /data/backup.file /
> >
> > Is it right?
> > What about opened and "currently in use by the system" files? Are they
> > backuped in a proper way? What about tmpfs like /proc, are they been
> > ignored?
> >
(...)
> Yes it is meant to handle a changing filesystem - you do see warning msgs sometimes because
> it can't see a particular inode anymore, which can happen as we do multiple
> scans of the inodes and if they get deleted then it obviously can't do anything
> with it anymore or if the inode is reused as a dir instead of a reg-file etc...
Hmm,
I suppose he asked about something else:
Unless you use lvm snapshots (or something alike) you may get incorrect
files that are in use. Consider having 20GB file:
1. Dump starts reading the file
2. Dump is at 18th GB
3. You change the data in 1-5 GB region.
4. You have inconsistent data.

So after dump you get consistent filesystem but not necessairly
consistent data.

Regards,

Olaf

-- 
Olaf Frączyk <olaf@cbk.poznan.pl>
