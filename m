Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 08:00:20 -0700 (PDT)
Received: from smtp104.sbc.mail.mud.yahoo.com (smtp104.sbc.mail.mud.yahoo.com [68.142.198.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7EExxDW011823
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 08:00:05 -0700
Date: Mon, 14 Aug 2006 07:59:27 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Message-ID: <20060814145927.GA28940@tuatara.stupidest.org>
References: <20060810164222.GA16332@wurtel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060810164222.GA16332@wurtel.net>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Paul Slootman <paul@wurtel.net>
Cc: xfs@oss.sgi.com

On Thu, Aug 10, 2006 at 06:42:22PM +0200, Paul Slootman wrote:

> empty data block 10 in directory inode 1343747104: junking block
> empty data block 11 in directory inode 1343747104: junking block
> empty data block 12 in directory inode 1343747104: junking block
> free block 16777216 entry 10 for directory ino 1343747104 bad
> rebuilding directory inode 1343747104

do subsequent xfs_repair runs go silent?  if not then you've probably
hit a case where it's leaving something icky behind and you have to
manually poke it using xfs_db (i had this myself)
