Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 21:38:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9Q4cKlD009025
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 21:38:20 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 749691480CB4
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 21:38:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id akht3aQt5e9yh3Ex for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 21:38:18 -0700 (PDT)
Message-ID: <4903F439.1070605@sandeen.net>
Date: Sat, 25 Oct 2008 23:38:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 v2] hook up fiemap & associated formatter
References: <49031E81.7040807@sandeen.net> <4903207B.6030009@sandeen.net> <20081025202657.GG28002@infradead.org>
In-Reply-To: <20081025202657.GG28002@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
>> +#define XFS_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
> 
> Why do we need FIEMAP_FLAG_SYNC in here?  That flag is implemented in
> the VFS and should be handled there.  (Probably more a question for
> the generic implementation than your patch)

well, sorta, it calls filemap_write_and_wait but no lock is held to keep
that consistent when the filesystem gets to it... IMHO it *should*
probably be up to the fs to handle the sync flag.  But anyway, for it
all to hang together I think we need to tell it that we understand this
flag.

-Eric

>> +
>> +STATIC int xfs_fiemap_format(
> 
> STATIC int
> xfs_fiemap_format(
> 
> 
> 
> Buit the meat of the patch looks good to me.
> 
> 
