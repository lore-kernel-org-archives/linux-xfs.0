Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937301AbdDZUe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Apr 2017 16:34:56 -0400
Date: Wed, 26 Apr 2017 16:34:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Many D state processes on XFS, kernel 4.4
Message-ID: <20170426203451.GA44531@bfoster.bfoster>
References: <CAPeSaCC-Z+atujOq9+uj0tgdkWDNPadiQVDB+23tj=DBH-EKrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPeSaCC-Z+atujOq9+uj0tgdkWDNPadiQVDB+23tj=DBH-EKrw@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gareth Clay <gclay@pivotal.io>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 26, 2017 at 05:47:15PM +0100, Gareth Clay wrote:
> Hi,
> 
> We're trying to diagnose a problem on an AWS virtual machine with two
> XFS filesystems, each on loop devices. The loop files are sitting on
> an EXT4 filesystem on Amazon EBS. The VM is running lots of Linux
> containers - we're using Overlay FS on XFS to provide the root
> filesystems for these containers.
> 
> The problem we're seeing is a lot of processes entering D state, stuck
> in the xlog_grant_head_wait function. We're also seeing xfsaild/loop0
> stuck in D state. We're not able to write to the filesystem at all on
> this device, it seems, without the process hitting D state. Once the
> processes enter D state they never recover, and the list of D state
> processes seems to be growing slowly over time.
> 
> The filesystem on loop1 seems fine (we can run ls, touch etc)
> 
> Would anyone be able to help us to diagnose the underlying problem please?
> 
> Following the problem reporting FAQ we've collected the following
> details from the VM:
> 
> uname -a:
> Linux 8dd9526f-00ba-4f7b-aa59-a62ec661c060 4.4.0-72-generic
> #93~14.04.1-Ubuntu SMP Fri Mar 31 15:05:15 UTC 2017 x86_64 x86_64
> x86_64 GNU/Linux
> 
> xfs_repair version 3.1.9
> 
> AWS VM with 8 CPU cores and EBS storage
> 
> And we've also collected output from /proc, xfs_info, dmesg and the
> XFS trace tool in the following files:
> 
> https://s3.amazonaws.com/grootfs-logs/dmesg
> https://s3.amazonaws.com/grootfs-logs/meminfo
> https://s3.amazonaws.com/grootfs-logs/mounts
> https://s3.amazonaws.com/grootfs-logs/partitions
> https://s3.amazonaws.com/grootfs-logs/trace_report.txt
> https://s3.amazonaws.com/grootfs-logs/xfs_info
> 

It looks like everything is pretty much backed up on the log and the
tail of the log is pinned by some dquot items. The trace output shows
that xfsaild is spinning on flush locked dquots:
 
<...>-2737622 [001] 33449671.892834: xfs_ail_flushing:     dev 7:0 lip 0x0xffff88012e655e30 lsn 191/61681 type XFS_LI_DQUOT flags IN_AIL
<...>-2737622 [001] 33449671.892868: xfs_ail_flushing:     dev 7:0 lip 0x0xffff8800110d7bb0 lsn 191/61681 type XFS_LI_DQUOT flags IN_AIL
<...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff88012e655a80 lsn 191/67083 type XFS_LI_DQUOT flags IN_AIL
<...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff8800110d4810 lsn 191/67296 type XFS_LI_DQUOT flags IN_AIL
<...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff880122210460 lsn 191/67310 type XFS_LI_DQUOT flags IN_AIL

The cause of that is not immediately clear. One possible reason is it
could be due to I/O failure. Do you have any I/O error messages (i.e.,
"metadata I/O error: block ...") in your logs from before you ended up
in this state?

If not, I'm wondering if another possibility is an I/O that just never
completes.. is this something you can reliably reproduce?

Brian

> Thanks for any help or advice you can offer!
> 
> Claudia and Gareth
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
