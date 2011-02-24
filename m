Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OAWkNP129672 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:32:46 -0600
Received: from mail-gx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5310512E4759
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:35:30 -0800 (PST)
Received: from mail-gx0-f181.google.com (mail-gx0-f181.google.com
	[209.85.161.181]) by cuda.sgi.com with ESMTP id
	68LCm46I9RFHQqlV for <xfs@oss.sgi.com>;
	Thu, 24 Feb 2011 02:35:30 -0800 (PST)
Received: by gxk3 with SMTP id 3so231972gxk.26
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 02:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
Date: Thu, 24 Feb 2011 11:35:30 +0100
Message-ID: <AANLkTi=ERpJLUUGWO_0xjecTPV3=w1GmXKBk0-uCch1L@mail.gmail.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
From: Erik Gulliksson <erik@gulliksson.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

Hi again Justin,

> This would seem to be the problem, you should go with Hiatchi next time.
> You can use regular non-enterprise drives (Hiatchi) and they just work.
> Seagate is a question
> Samsung is a question
> WD needs TLER.

This is valuable information, we might consider Hitatchi-disks next
time if we want to play cheap again.


> As far as the problem at hand, I do not know of a good way to fix it unle=
ss
> you had ls -lRi /raid_array output so you could map the inodes to their
> original locations. =A0Sorry don't have a better answer..

No, I don't have full filename-inode mappings from before the
corruption. I guess such a list from the filesystem mounted with -o
"ro,norecovery" won't help here?

If the journal is corrupt, is there anyway to salvage only that part
so that the log replay will proceed further (ie "xfs_log_repair")? I'm
not nearly expert enough to parse the stacktrace triggered by mounting
the filesystem, but it seems some calls to xlog_recover_-functions are
involved, which make me think that the log is corrupt.

Best regards
Erik Gulliksson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
