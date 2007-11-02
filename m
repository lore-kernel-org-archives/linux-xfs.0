Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Nov 2007 09:10:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA2GAWvv021419
	for <xfs@oss.sgi.com>; Fri, 2 Nov 2007 09:10:36 -0700
Message-ID: <472B4BF8.2040500@sandeen.net>
Date: Fri, 02 Nov 2007 11:10:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_force_shutdown called from file fs/xfs/xfs_trans_buf.c
References: <06CCEA2EB1B80A4A937ED59005FA855101AED1BE@svits26.main.ad.rit.edu> <472A87FA.7000804@sandeen.net> <9489F071-7966-4230-9DAC-D783B6B9600A@rit.edu> <472A8BB9.7040100@sandeen.net> <20071102090740.GB23263@p15145560.pureserver.info>
In-Reply-To: <20071102090740.GB23263@p15145560.pureserver.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ralf Gross <Ralf-Lists@ralfgross.de>
Cc: xfs@oss.sgi.com

Ralf Gross wrote:
> Eric Sandeen schrieb:
>> ...
>> What controller are you using?  If you say "areca" I might be on to
>> something with some other bugs I've seen...
> 
> I use areca controllers with xfs, but had no problems yet. Can you
> explain what bugs might hit me?

maybe none, it was just a wild guess.  :)  I've seen a bug on ext3,
volumes > 2T corrupted, on an areca controller.  Due to the 2T
threshold, it seems more like a lower layer IO issue (2^32 x 512) than a
filesystem issue... googling a bit I found others with problems on
areca, but then that's what I googled for, so I might have
self-selected.  So, maybe nothing, I was just looking for a 3rd data point.

-Eric
