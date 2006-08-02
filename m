Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 01 Aug 2006 21:34:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k724XMDW018139
	for <xfs@oss.sgi.com>; Tue, 1 Aug 2006 21:33:34 -0700
Date: Wed, 2 Aug 2006 14:32:31 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: FAQ updated (was Re: XFS breakage...)
Message-ID: <20060802143231.D2341636@wobbly.melbourne.sgi.com>
References: <20060718222941.GA3801@stargate.galaxy> <20060719085731.C1935136@wobbly.melbourne.sgi.com> <1153304468.3706.4.camel@localhost> <20060720171310.B1970528@wobbly.melbourne.sgi.com> <20060731162535.GA15555@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060731162535.GA15555@fi.muni.cz>; from kas@fi.muni.cz on Mon, Jul 31, 2006 at 06:25:35PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Mon, Jul 31, 2006 at 06:25:35PM +0200, Jan Kasprzak wrote:
> Nathan Scott wrote:
> : I've captured the state of this issue here, with options and ways
> : to correct the problem:
> : 	http://oss.sgi.com/projects/xfs/faq.html#dir2
> : 
> : Hope this helps.
> 
> 	I have been hit with this bug as well - I tried to clear the
> two corrupted directory inodes with xfs_db (as the FAQ entry says), then ran
> xfs_repair (lots of files ended up in lost+found), but apparently
> the volume is still not OK - when I tried to use it (this volume
> is a public FTP archive), I got the following traces:

There is now a fixed version of xfs_repair available - its in
xfsprogs-2.8.10, source is on oss.sgi.com in the XFS ftp area.
A number of people have reported success with Barry's earlier
patch, noone's reported anything bad, so 2.8.10 is out now with
the fix merged.

cheers.

-- 
Nathan
