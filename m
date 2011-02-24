Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1OAwws0131156 for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 04:58:58 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C7CD12E3733
	for <xfs@oss.sgi.com>; Thu, 24 Feb 2011 03:01:43 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id MIczi01nIoWPbLzG for
	<xfs@oss.sgi.com>; Thu, 24 Feb 2011 03:01:43 -0800 (PST)
Date: Thu, 24 Feb 2011 06:01:42 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS corruption on 3ware RAID6-volume
In-Reply-To: <AANLkTi=ERpJLUUGWO_0xjecTPV3=w1GmXKBk0-uCch1L@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1102240601020.24142@p34.internal.lan>
References: <AANLkTinWByYooMnPL7BryPowDexBeiHJdh3aVh+fdm-a@mail.gmail.com>
	<20110223154651.54f0a8dc@harpe.intellique.com>
	<AANLkTinsfwr5E7KkffwWOweWJLCmaLnLdtYA4g_m--b0@mail.gmail.com>
	<alpine.DEB.2.02.1102231022470.15181@p34.internal.lan>
	<AANLkTi=ERpJLUUGWO_0xjecTPV3=w1GmXKBk0-uCch1L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1713342328-1298545302=:24142"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Erik Gulliksson <erik@gulliksson.org>
Cc: xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1713342328-1298545302=:24142
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Thu, 24 Feb 2011, Erik Gulliksson wrote:

> Hi again Justin,
>
>> This would seem to be the problem, you should go with Hiatchi next time.
>> You can use regular non-enterprise drives (Hiatchi) and they just work.
>> Seagate is a question
>> Samsung is a question
>> WD needs TLER.
>
> This is valuable information, we might consider Hitatchi-disks next
> time if we want to play cheap again.
>
>
>> As far as the problem at hand, I do not know of a good way to fix it unl=
ess
>> you had ls -lRi /raid_array output so you could map the inodes to their
>> original locations. =A0Sorry don't have a better answer..
>
> No, I don't have full filename-inode mappings from before the
> corruption. I guess such a list from the filesystem mounted with -o
> "ro,norecovery" won't help here?
>
> If the journal is corrupt, is there anyway to salvage only that part
> so that the log replay will proceed further (ie "xfs_log_repair")? I'm
> not nearly expert enough to parse the stacktrace triggered by mounting
> the filesystem, but it seems some calls to xlog_recover_-functions are
> involved, which make me think that the log is corrupt.

This is probably best answered by an XFS expert.

Could you also show tw_cli /c0 show diag ?

Justin.

--655872-1713342328-1298545302=:24142
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1713342328-1298545302=:24142--
