Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 15 Sep 2007 03:23:16 -0700 (PDT)
Received: from stlx01.stz-softwaretechnik.com (stz-softwaretechnik.de [217.160.223.211])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8FAN94p028358
	for <xfs@oss.sgi.com>; Sat, 15 Sep 2007 03:23:11 -0700
Date: Sat, 15 Sep 2007 12:05:11 +0200
From: Ralf Gross <Ralf-Lists@ralfgross.de>
Subject: Re: compression
Message-ID: <20070915100511.GA8183@p15145560.pureserver.info>
References: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <654e62180709111643k4700c2bdibec2a16eb5446e76@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jordan Mendler <jmendler@ucla.edu>
Cc: xfs@oss.sgi.com

Jordan Mendler schrieb:
> 
> I searched the mailing list archive and could not find an answer. We are
> currently using XFS on Linux for a 17TB Volume used for backups. We are
> running out of space, so rather than order another array, I would like to
> try to implement filesystem-level compression. Does XFS support any type of
> compression? If not, are there any other ways to optimize for more space
> storage? We are doing extensive rsyncs as our method of backups, so gzipping
> on top of the filesystem is not really an option.

A very nice tool for backups is backuppc which stores all backed up
files in a pool and uses hardlinks to map these files to the real
backup. There is only one copy of each file in the pool regardless of
on how may clients this file exist (De-duplication). You can use
backuppc with tar/rsync/smb and with compression.

Ralf
