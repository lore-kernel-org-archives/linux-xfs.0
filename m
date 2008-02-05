Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Feb 2008 07:35:24 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m15FZHLt003688
	for <xfs@oss.sgi.com>; Tue, 5 Feb 2008 07:35:21 -0800
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01C7A5A0DE4
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2008 07:34:21 -0800 (PST)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by cuda.sgi.com with ESMTP id PAGFjQeGzFFkIYOj for <xfs@oss.sgi.com>; Tue, 05 Feb 2008 07:34:21 -0800 (PST)
Date: Tue, 5 Feb 2008 16:33:37 +0100
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: mkfs.xfs doesn't detect size of storage correctly
Message-ID: <20080205153337.GA9915@citd.de>
References: <20080129093201.GA16203@citd.de> <47A87877.1050106@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A87877.1050106@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On 05.02.2008 08:53, Eric Sandeen wrote:
> Matthias Schniedermeyer wrote:
> 
> > There is roughly 1/3 missing.
> 
> SGI, have you settled on a fix for this?  Latest released xfsprogs,
> 2.9.5 has this problem, and I've put it in rawhide; it's also in the F9
> alpha spin.  Should I revert to 2.9.4 if you don't have plans to fix it
> soon?
> 
> Nothing indicates to the user that their fs was misformatted, and there
> will be a growing number fileystems missing a substantial portion of
> their space out there....

The big question here is if you can grow the filesystem to fix it.

Before i found the workaround with the agcount i tested to grow the fs, 
but it didn't work.

So: A correctly(tm) fixed package i think it must include a xfs_grows 
that can fix a damaged(tm) fs, otherwise people who use such a 
filesystem (and can't backup/restore) are stuck with missing a large 
chunk of space.




Bis denn

-- 
Real Programmers consider "what you see is what you get" to be just as 
bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, 
cryptic, powerful, unforgiving, dangerous.
