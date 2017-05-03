Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:32917 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751108AbdECMHI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2017 08:07:08 -0400
Received: by mail-wr0-f181.google.com with SMTP id w50so105008174wrc.0
        for <linux-xfs@vger.kernel.org>; Wed, 03 May 2017 05:07:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170427175714.GA47842@bfoster.bfoster>
References: <CAPeSaCC-Z+atujOq9+uj0tgdkWDNPadiQVDB+23tj=DBH-EKrw@mail.gmail.com>
 <20170426203451.GA44531@bfoster.bfoster> <CAPeSaCAPKicLN=QF=gLHUeV5KPQP7f3DbT9QPGjzyECGqArzRQ@mail.gmail.com>
 <20170427175714.GA47842@bfoster.bfoster>
From: Gareth Clay <gclay@pivotal.io>
Date: Wed, 3 May 2017 13:07:05 +0100
Message-ID: <CAPeSaCB85nnEc9FQ5KoSQy59kV7X1pLgGnPLx3-H3V4-rLFTew@mail.gmail.com>
Subject: Re: Many D state processes on XFS, kernel 4.4
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

Hi Brian,

Thanks again for your thoughts - it's much appreciated. Unfortunately
we can't reproduce this problem on demand yet - we've only seen it on
a very small subset of VMs so far - so we're focusing our efforts on
trying to recreate it in a lab environment. If we get to the point
where we can recreate it reliably, then we can hopefully capture some
traces at the time the issue occurs.

The only new information I have since last time is that we were able
to check the logs since boot of two new VMs which began to exhibit the
issue - there was no occurrence of the 'metadata I/O error' message in
the kernel logs. The first error we saw in the logs - on both machines
- was a JVM instance running inside a container being shot by the
kernel OOM killer, since it hit its cgroup memory limit. This was
followed minutes later by the first process (another JVM instance)
entering D state. At the moment we're not sure if this is coincidental
or not, but we'll investigate that in a test environment.

As far as the kernel version goes, our main environments are set up
using pre-packaged machine images which makes kernel experimentation a
bit difficult, but again if we can reproduce this reliably then we can
certainly investigate rolling custom kernels to see if that improves
things. If it does then we can look at patching our machine images.

If we're able to collect any more useful information, and hopefully
some traces, I'll post it back to the list.

Thanks again,
Gareth

On Thu, Apr 27, 2017 at 6:57 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Thu, Apr 27, 2017 at 05:01:17PM +0100, Gareth Clay wrote:
>> Hi Brian,
>>
>> Thanks very much from the response. Unfortunately we don't have logs
>> going back that far, so all I can say at the moment is that we're not
>> seeing any 'metadata I/O error' lines in the logs that we have whilst
>> the problem has been occurring. We're going to recreate the affected
>> VM and see if the problem recurs - if it does then we'll be sure to
>> grab the logs immediately and check.
>>
>> What we can say is that this problem seems to have recurred 3 times
>> already on fresh VMs and disks. We initially wondered if it could be
>> due to a bad EBS volume or something similar, but this seems less
>> likely given the recurrence.
>>
>
> How frequently do you reproduce this problem? Can you reproduce
> on-demand and/or does it take a while to occur? Is it common across
> multiple systems with a similar xfs->loopback->ext4 configuration and
> workload or only a subset?
>
> When the problem occurs, can you verify whether the underlying ext4 fs
> and storage is still functioning properly?
>
>> In the case of the other possible cause you mentioned, of I/O never
>> completing, is it possible that excessive load could call this, or
>> would this be more indicative of a concurrency issue at the filesystem
>> / kernel level? One quirk of the workload on this machine is that we
>> have a lot of XFS project quotas which we're frequently checking to
>> report disk usage... Could it be that we're causing a starvation
>> problem?
>>
>
> Do you have other I/O going to the underlying fs/device at the time this
> state occurs? If so, I suppose you could try to wind that down and see
> if anything unclogs.
>
> That aside, it's not really clear to me whether this is a filesystem
> issue, a non-fs kernel problem due to the somewhat unique storage
> configuration (e.g., loop doing something strange or getting stuck), or
> something entirely external. I'm just trying to think of and possibly
> rule out any obvious/known causes for this situation. It is known, for
> example, that we get into this state if metadata writeback happens to
> fail for inode or dquot objects.
>
> Beyond that, this most likely is related to quota usage one way or
> another because those are the metadata objects that have pinned the log.
> The question is what has caused those objects to be sitting in the log
> flush locked (which implies the underlying buffers should have been
> submitted for I/O) without completing. I suppose we may be able to glean
> a bit more state if we had a vmcore dump, but then again, you are on a
> distro kernel. Have you considered testing a more recent/upstream
> kernel? A full tracepoint dump may also be interesting if you can induce
> the problem in a reasonable amount of time.
>
> Brian
>
>> Thanks again,
>> Gareth
>>
>> On Wed, Apr 26, 2017 at 9:34 PM Brian Foster <bfoster@redhat.com> wrote:
>> >
>> > On Wed, Apr 26, 2017 at 05:47:15PM +0100, Gareth Clay wrote:
>> > > Hi,
>> > >
>> > > We're trying to diagnose a problem on an AWS virtual machine with two
>> > > XFS filesystems, each on loop devices. The loop files are sitting on
>> > > an EXT4 filesystem on Amazon EBS. The VM is running lots of Linux
>> > > containers - we're using Overlay FS on XFS to provide the root
>> > > filesystems for these containers.
>> > >
>> > > The problem we're seeing is a lot of processes entering D state, stuck
>> > > in the xlog_grant_head_wait function. We're also seeing xfsaild/loop0
>> > > stuck in D state. We're not able to write to the filesystem at all on
>> > > this device, it seems, without the process hitting D state. Once the
>> > > processes enter D state they never recover, and the list of D state
>> > > processes seems to be growing slowly over time.
>> > >
>> > > The filesystem on loop1 seems fine (we can run ls, touch etc)
>> > >
>> > > Would anyone be able to help us to diagnose the underlying problem please?
>> > >
>> > > Following the problem reporting FAQ we've collected the following
>> > > details from the VM:
>> > >
>> > > uname -a:
>> > > Linux 8dd9526f-00ba-4f7b-aa59-a62ec661c060 4.4.0-72-generic
>> > > #93~14.04.1-Ubuntu SMP Fri Mar 31 15:05:15 UTC 2017 x86_64 x86_64
>> > > x86_64 GNU/Linux
>> > >
>> > > xfs_repair version 3.1.9
>> > >
>> > > AWS VM with 8 CPU cores and EBS storage
>> > >
>> > > And we've also collected output from /proc, xfs_info, dmesg and the
>> > > XFS trace tool in the following files:
>> > >
>> > > https://s3.amazonaws.com/grootfs-logs/dmesg
>> > > https://s3.amazonaws.com/grootfs-logs/meminfo
>> > > https://s3.amazonaws.com/grootfs-logs/mounts
>> > > https://s3.amazonaws.com/grootfs-logs/partitions
>> > > https://s3.amazonaws.com/grootfs-logs/trace_report.txt
>> > > https://s3.amazonaws.com/grootfs-logs/xfs_info
>> > >
>> >
>> > It looks like everything is pretty much backed up on the log and the
>> > tail of the log is pinned by some dquot items. The trace output shows
>> > that xfsaild is spinning on flush locked dquots:
>> >
>> > <...>-2737622 [001] 33449671.892834: xfs_ail_flushing:     dev 7:0 lip 0x0xffff88012e655e30 lsn 191/61681 type XFS_LI_DQUOT flags IN_AIL
>> > <...>-2737622 [001] 33449671.892868: xfs_ail_flushing:     dev 7:0 lip 0x0xffff8800110d7bb0 lsn 191/61681 type XFS_LI_DQUOT flags IN_AIL
>> > <...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff88012e655a80 lsn 191/67083 type XFS_LI_DQUOT flags IN_AIL
>> > <...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff8800110d4810 lsn 191/67296 type XFS_LI_DQUOT flags IN_AIL
>> > <...>-2737622 [001] 33449671.892869: xfs_ail_flushing:     dev 7:0 lip 0x0xffff880122210460 lsn 191/67310 type XFS_LI_DQUOT flags IN_AIL
>> >
>> > The cause of that is not immediately clear. One possible reason is it
>> > could be due to I/O failure. Do you have any I/O error messages (i.e.,
>> > "metadata I/O error: block ...") in your logs from before you ended up
>> > in this state?
>> >
>> > If not, I'm wondering if another possibility is an I/O that just never
>> > completes.. is this something you can reliably reproduce?
>> >
>> > Brian
>> >
>> > > Thanks for any help or advice you can offer!
>> > >
>> > > Claudia and Gareth
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> > > the body of a message to majordomo@vger.kernel.org
>> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
