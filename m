Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Sep 2007 17:44:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l910iHUW002992
	for <xfs@oss.sgi.com>; Sun, 30 Sep 2007 17:44:20 -0700
Message-ID: <470042DC.2040009@sgi.com>
Date: Mon, 01 Oct 2007 10:44:12 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Creation time in XFS
References: <200709302124.38164.Martin@lichtvoll.de>
In-Reply-To: <200709302124.38164.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

Martin Steigerwald wrote:
> Hi!
> 
> Does XFS support creation time too or are there plans to support it?
> 
> Ext3 seems to do since 2.6.23:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ef7f38359ea8b3e9c7f2cae9a4d4935f55ca9e80
> 
> http://tinyurl.com/3drb65
> 
> Ciao,

Hi Martin,

No XFS does not support creation time. It just has the regular
atime,mtime and ctime.
There are no plans that I've heard to support it.
Not much involved to support it AFAICT but it would either involve
changing the ondisk format of the inode or storing it in an EA.
Storing it in an EA would be yet another one for the EA creation
on inode allocation scenarios (done presently for default ACLs and
and also in other future data).

I wonder how this creation time is being exported currently?

--Tim
