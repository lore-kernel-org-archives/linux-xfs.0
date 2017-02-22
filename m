Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58884 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754269AbdBVNlp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 08:41:45 -0500
Subject: Re: Consider these for the XFS FAQ wiki
References: <CADWLRhrkA6pa_OeddSf281Lr+53JyEp5dxaHc+KTJPRLShWvkQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5222e5f0-feee-2416-c91a-af12775fafd2@sandeen.net>
Date: Wed, 22 Feb 2017 07:41:43 -0600
MIME-Version: 1.0
In-Reply-To: <CADWLRhrkA6pa_OeddSf281Lr+53JyEp5dxaHc+KTJPRLShWvkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vaibhaw Pandey <vaibhaw@scalegrid.io>, linux-xfs@vger.kernel.org

On 2/22/17 5:55 AM, Vaibhaw Pandey wrote:
> Hey,
> 
> I had recently run into the ext4 auto_da_alloc delayed allocation type
> behavior with XFS i.e. replace by rename leaving an empty file behind.
> It took me forever to debug it cause I couldn't find answers to some
> simple questions right away.

So I'm curious - what happened, and how did you resolve it?

> You guys are the experts but I would like to suggest adding some
> questions (& answers) to the XFS FAQ doc for the clueless folks like
> me.
> 
> I would suggest the following questions:
> 
> 0. Does XFS support a mount option equivalent to ext4's auto_da_alloc?
> i.e. Does XFS have the workarounds to support the replace by truncate
> and replace by rename?
> Ans:
> Answered exactly in http://oss.sgi.com/archives/xfs/2015-12/msg00553.html

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_see_binary_NULLS_in_some_files_after_recovery_when_I_unplugged_the_power.3F'
alludes to this, but I suppose a better explanation of the existing
heuristic might be nice for those who want the details.  The "binary NULLs"
thing is ancient history.

I agree with Carlos that direct comparisons to other filesystems are
less useful, if nothing else because other filesystems may change.

Documenting what XFS does should be the goal of the FAQ.
 
> 1. Does XFS support a mount option equivalent to ext4's commit? i.e.
> How do I control how often does XFS sync to disk? Or Does XFS never
> sync to disk until a sync/fsync is called?

ext4's commit= doesn't control how often it "syncs to disk", exactly.
(that's a bit vague).

It controls the journal commit time, which may or may not (depending on
other options) control data vs. metadata, etc.  Again, we'd need to
document ext4 in the faq before we started making comparisons to it.  :)

> Ans:
> Answered here: http://article.gmane.org/gmane.comp.file-systems.xfs.general/53376
> Reproducing from source:
> <snip>
> By and large, buffered IO in a filesystem is flushed out by the vm,
> due to either age or memory pressure.  The filesystem then responds
> to these requests by the VM, writing data as requested.

So that's about dirty data flushing, whereas ext4's commit= is more related
to metadata flushing, which may or may not lead to data flushing for some files.
We do document a sysctl:

  fs.xfs.xfssyncd_centisecs     (Min: 100  Default: 3000  Max: 720000)
        The interval at which the filesystem flushes metadata
        out to disk and runs internal cache cleanup routines.

which is different from:

> You can read all about it in
> https://www.kernel.org/doc/Documentation/sysctl/vm.txt See
> dirty_expire_centisecs and dirty_writeback_centisecs - flushers wake
> up every 30s and push on data more than 5s old, by default.
> </snip>

which controls data flushing.  Some of this is filesystems 101; some of
it is specific to xfs...

> 2. What is the maximum size of the XFS journal?
> Ans: Not sure. But this is the closest answer I could find:
> https://serverfault.com/questions/367973/xfs-maximum-log-size-sw-raid-10-mdadm-sles-11-sp1
> I could read through the code and find a better answer in case you
> folks wouldn't have the time.

As you can see from the URL there, the answer is "it's complicated"
and depends on filesystem geometry.  I think it's probably best answered by:

http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

;) IOWs, why were you messing with the log size in the first place?  :)

-Eric



> 
> Lemme know what you think.
> 
> Thanks,
> Vaibhaw
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
