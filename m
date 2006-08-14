Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Aug 2006 08:56:26 -0700 (PDT)
Received: from mx.wurtel.net (xs.wurtel.net [83.68.3.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7EFuEDW032764
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 08:56:14 -0700
Received: from wurtel ([192.168.1.1] helo=wurtel-ws.wurtel.net)
	by mx.wurtel.net with esmtp (Exim 3.36 #1 (Debian))
	id 1GCemm-00079Z-00
	for <xfs@oss.sgi.com>; Mon, 14 Aug 2006 17:55:28 +0200
Received: from paul by wurtel-ws.wurtel.net with local (Exim 4.62)
	(envelope-from <paul@wurtel-ws.wurtel.net>)
	id 1GCeml-0002oi-Q7
	for xfs@oss.sgi.com; Mon, 14 Aug 2006 17:55:27 +0200
Date: Mon, 14 Aug 2006 17:55:27 +0200
From: Paul Slootman <paul@wurtel.net>
Subject: Re: cache_purge: shake on cache 0x5880a0 left 8 nodes!?
Message-ID: <20060814155527.GA10314@wurtel.net>
References: <20060810164222.GA16332@wurtel.net> <20060814145927.GA28940@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060814145927.GA28940@tuatara.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Mon 14 Aug 2006, Chris Wedgwood wrote:
> On Thu, Aug 10, 2006 at 06:42:22PM +0200, Paul Slootman wrote:
> 
> > empty data block 10 in directory inode 1343747104: junking block
> > empty data block 11 in directory inode 1343747104: junking block
> > empty data block 12 in directory inode 1343747104: junking block
> > free block 16777216 entry 10 for directory ino 1343747104 bad
> > rebuilding directory inode 1343747104
> 
> do subsequent xfs_repair runs go silent?  if not then you've probably
> hit a case where it's leaving something icky behind and you have to
> manually poke it using xfs_db (i had this myself)

No, these particular messages didn't reoccur, although I've been having
a lot of trouble with that filesystem (see my other message today).


Paul Slootman
