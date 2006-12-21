Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 22:37:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBL6bNqw028637
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 22:37:25 -0800
Date: Thu, 21 Dec 2006 17:36:21 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: adding more redundancy in XFS?
Message-ID: <20061221063621.GI33919298@melbourne.sgi.com>
References: <200612210442.33706.microchip@chello.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200612210442.33706.microchip@chello.be>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Grozdan Nikolov <microchip@chello.be>
Cc: xfs@oss.sgi.com

On Thu, Dec 21, 2006 at 04:42:32AM +0100, Grozdan Nikolov wrote:
> Hi,
> 
> I have a simple question regarding XFS. A while back ago I read a research 
> paper about the IRON (Internal Robustness) of file systems that tests and 
> compares various Linux file systems on how they handle data-integrity in case 
> of a unclean unmount or power failure or even a disk failure. Though I'm not 
> a file system guru like you guys I learned that XFS does a fairly good job 
> but fails bad in specific areas, like, and I quote from the paper: "when an 
> ordered data block write fails, XFS continues to log the failed transaction 
> to the journal resulting in data corruption"

XFS doesn't have an ordered journaling mode and I think their
idea of a transaction is different to what XFS calls a transaction.

> The paper can be downloaded here: http://www.cs.wisc.edu/adsl/Publications/
> (just click on the IRON file systems link for a PDF)

Ok, I remember reading the preliminary paper that had the filesystem
analysis about a year ago. I don't recall whether there was anything
about XFS in it then.

Quote section 3.1.4:

"XFS supports only ordered journalling mode and data/writeback journaling
modes are not present."

According to the paper's definition of writeback/ordered/data journalling,
XFS uses writeback journalling. i.e. there is no synchronisation between
metadata logging and the data being written. That's a pretty bad mistake....

Also it is stated that the XFS analysis is only preliminary because
XFS wasn't fully instrumented and so coverage of the fileystem
was only partial. Hence it doesn't have the same error detection/recovery
maps as the other filesystems so we've got no clear idea what tests
those conclusions are based on.

That being said, there's a lot of good stuff in that paper. Now all
they've got to do is open source the tools they wrote and we can
go and find and fix the problems their tool found....

> My question is, is it possible to add to XFS more sanity checking (maybe even 
> CRC checks?) on things like inodes, bitmaps, indirect pointers, etc to 
> further improve the integrity of XFS?

Yes.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
