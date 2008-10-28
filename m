Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 27 Oct 2008 19:10:18 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S2AADg032198
	for <linux-xfs@oss.sgi.com>; Mon, 27 Oct 2008 19:10:10 -0700
Message-ID: <49067479.6070604@sgi.com>
Date: Tue, 28 Oct 2008 13:10:01 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Bad day with xfsrestore, what went wrong?
References: <gde1k2$gkp$1@ger.gmane.org> <ge38k5$qf$1@ger.gmane.org> <49063F75.7000604@sgi.com> <ge5kle$ueo$1@ger.gmane.org>
In-Reply-To: <ge5kle$ueo$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mlueck@lueckdatasystems.com
Cc: linux-xfs@oss.sgi.com

Hi Michael,

Michael Lueck wrote:
> xfsrestore -J -E -f /mnt/ext_backup/ldslnx01/20061220/data -s shares/data -i -v verbose /srv 
> Bill Kendall wrote:
> 
>> I tried to reproduce this using the command line you supplied, but
>> everything worked as expected for me.
> 
> Glad to hear that. Seems my tried and true syntax _can_ still work.
> 
>> Perhaps try it without the -i (so that only subtrees given with -s are
>> restored), just to rule out
>> the possibility that you inadvertently added all files to the restore
>> list.
> 
> Enough putzing with a production server I think.
> 
> It was odd that it only put back files present in that old backup set
> and did not overwrite everything... thankfully!
> 
Maybe the -E option helped you out there.

  -E   Prevents  xfsrestore from overwriting newer versions of files.  
  The inode modification time of the on-media file is com‐
  pared to the inode modification time of corresponding file in the dest directory.  
  The file is restored only if the  on-media  version  is newer than the version
  in the dest directory.  The inode modification time of a file can be displayed
  with the ls -lc command.

--Tim
