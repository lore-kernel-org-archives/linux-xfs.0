Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Oct 2007 14:25:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9HLOd97016928
	for <linux-xfs@oss.sgi.com>; Wed, 17 Oct 2007 14:24:42 -0700
Received: from snort.melbourne.sgi.com (snort.melbourne.sgi.com [134.14.54.149]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id HAA27422 for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 07:24:41 +1000
Received: from snort.melbourne.sgi.com (localhost [127.0.0.1])
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id l9HLOedD68989844
	for <linux-xfs@oss.sgi.com>; Thu, 18 Oct 2007 07:24:41 +1000 (AEST)
Received: (from dgc@localhost)
	by snort.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id l9HLOdOp68939488
	for linux-xfs@oss.sgi.com; Thu, 18 Oct 2007 07:24:39 +1000 (AEST)
Date: Thu, 18 Oct 2007 07:24:39 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: can't remove dir
Message-ID: <20071017212434.GB995458@sgi.com>
References: <20070914080926.GA30150@apartia.fr> <46EA9741.6060303@sandeen.net> <20071017161504.GA13077@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017161504.GA13077@apartia.fr>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

On Wed, Oct 17, 2007 at 06:15:04PM +0200, Louis-David Mitterrand wrote:
> Using a 2.6.23 kernel and after a clean xfs_repair-2.9.4 run I can't 
> remove that file:
> 
> sylla:/# rm /lost+found/3912672557
> rm: cannot remove `/lost+found/3912672557': Operation not permitted
> 
> sylla:/# ls -li /lost+found/3912672557                                 
> 3912672557 lrwxrwxrwx 1 root root 9 2006-04-09 19:10 /lost+found/3912672557 -> unix.7.gz

Can you post the output of:

# xfs_db -r -c "inode 3912672557" -c "p" <device>

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
