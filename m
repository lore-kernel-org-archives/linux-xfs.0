Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 09:39:36 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7GGdADW029863
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 09:39:20 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k7GGcUnx024727
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 11:38:31 -0500
Message-ID: <44E349EE.6080905@sgi.com>
Date: Wed, 16 Aug 2006 11:38:06 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsdump -s unacceptable performances
References: <200608161515.00543.daniele@interline.it>
In-Reply-To: <200608161515.00543.daniele@interline.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Daniele P." <daniele@interline.it>
Cc: xfs@oss.sgi.com

On 08/16/06 08:15, Daniele P. wrote:
> Hi all,
> I'm new to the list. I have a problem with xfsdump using the -s option.
> I'm aware that the latest version (2.2.38) skip the scan and prune of
> the entire filesystem (see the test below), but there are other places
> where xfsdump performs an entire scan of the filesystem, slowing down
> the backup process.
> 
> For example in:
>  * dump/inomap.c after "phase 3" there is a function call to
>    bigstat_iter that scan the entire filesystem

This scan stops after determining start points for all streams.
On Linux there's always one dump stream, so it returns after
reading one buffer full of inodes.

>  * dump/content.c the function dump_dirs again scan the entire
>    filesystem

And of course there's another scan for dumping the non-dir inodes.
Keep in mind these are inode scans, which are substantially faster
than recursing through the directories doing individual stat(2) calls.

Nonetheless, these scans could be optimized by seeking the scan to
the next inode of interest, which could be found using xfsdump's inomap
(created in the first scan). This would be beneficial to -s and
incremental dumps.

> 
> Are all there scan really necessary?

A lot of this stuff could be done in a single scan in a disk-to-disk
backup approach. But in the current scheme, they are necessary.

> Could we expect a performance fix?
> Is there a workaround?

Nothing is planned, but patches are always welcome.

Regards,
Bill
