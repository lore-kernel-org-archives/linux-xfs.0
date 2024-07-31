Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43AA10A3E
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 02:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722394317; cv=none; b=Luv08XD9gZdC0Kp9gziEBGpV3mN32lzndb1M1zofNI9HB2zwGxfQ6WPigD6vT3caSw6qRrnshTsIJboLu8heXXCze9IgQwXUQrFB0kzIE3vQ8aogwb7o8eBHNEpXwUVf3U1vgX1IMDBxzMUvRGBZQtLvocXjzgbh7Kc1elk8wZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722394317; c=relaxed/simple;
	bh=0xc3A7wA73HjxFlY+AfVQaELZfgAGVqa7YK1j0NaSxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lJ9fEexMaXJ3vSX+O3MvapXmiSIJN4AUqhKeNFZnG9aZNKQ6OJwC5G4a5SqBBOn/aNE0b4zcmyEApgyZyqLmeDKXgHykx4lo0RtSB4JetklEE2h9oAym4y4JFH9tIBkKrz5NoklZ44C1343Yiy7z0V3A1RAh1T27k6EN5I92HrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=HrvmfpSW; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="HrvmfpSW"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-7a263f6439eso3007197a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 19:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722394314; x=1722999114; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5eZuxbIYKIFfgh8xbTw7rQxJgUnJAki4q1J1u03NWFs=;
        b=HrvmfpSWtAXdGW5d0A3SXpbe/HcDXqxVFZyqT2L27liWlxGGBoIHvCtAK8+qxbOEhb
         RWquHNGupOkUwvNZRGbijhBvy7qZ63C85O6MnSwvkeRnlgm6RhoVD3ahHRj6l+joYg6z
         7cdYR5c3A4jbtvhylegp9w0Fao+gt32uCisIMn6monYQ3fm+3RK6jL5bYlGFiuPEOxNr
         7/mlkaivSFzJjap2ivuKgQFacCpEwLboHgR+cFFL97VMdvPf6mXtHQqUrioNYqEoSeeV
         Ab+NUYObI2raUzfi+uUnrbA6526cGSYrwgnuk398R+wei9jPc14FSZ3KUNvI6+/+C0LQ
         odcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722394314; x=1722999114;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5eZuxbIYKIFfgh8xbTw7rQxJgUnJAki4q1J1u03NWFs=;
        b=UWm0vxaH++qFyrNHQWV+N2I9xFV/QfNX9vo7ST3sxFsTLtVAJeaIbtnJ6WIyiWwlE6
         OFkeVeV8m1vqNEtsD0OGVcPhpJEOcV2KgvKKXnKd9ObzuNBDojTPb9UzZIsJqOSuosqJ
         Iljd5Mk8K1DWZefZG0io95dXs9oY4E0HfugFYqc26bYkjqmQull7kyMFnIVbPbWq5IzB
         mXvjdj98he3V/3bdUFl5mOUmDUxpkIzgpnCekHEufkIu10h3byQU4YgGY/wsDvExIuFr
         zUy/V5To5j8ZCdBOvHOY62Ipub+7mSleKfJz7oM5/z7IGICtI1WM3F1OzTRBoiezqGpW
         eqFw==
X-Gm-Message-State: AOJu0YzVhX9n7gKtRFTF9tazfzm5IVi5WwBoBoE8OPeMcq1ZuosvU3TY
	r2MWoDiLg5RZmJHf0BxiNOrHOD/FKoBhnXgJrwWqscLvH1Q80MW2rcIHsdy/DkYaJgGAxiID9KR
	U
X-Google-Smtp-Source: AGHT+IG3oFkN+bizPyCbnoTZbknxvH3fCyMtjwZgB6GX9pM8Fsrx/iQvvVCqbCYccLMGhKvocGRoDA==
X-Received: by 2002:a05:6a20:7347:b0:1c4:b8a1:6db1 with SMTP id adf61e73a8af0-1c4b8a17075mr9286129637.38.1722394313786;
        Tue, 30 Jul 2024 19:51:53 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8749c2sm9086345b3a.155.2024.07.30.19.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 19:51:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sYzRO-00HQXr-0q;
	Wed, 31 Jul 2024 12:51:50 +1000
Date: Wed, 31 Jul 2024 12:51:50 +1000
From: Dave Chinner <david@fromorbit.com>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 0/9] introduce defrag to xfs_spaceman
Message-ID: <Zqmmxhyf6FcB1fWQ@dread.disaster.area>
References: <20240709191028.2329-1-wen.gang.wang@oracle.com>
 <ZpWqzsiU01mNKHC9@dread.disaster.area>
 <EBF1D37C-B89A-4281-83B2-3DD8B865B10C@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EBF1D37C-B89A-4281-83B2-3DD8B865B10C@oracle.com>

On Tue, Jul 16, 2024 at 07:45:37PM +0000, Wengang Wang wrote:
> 
> 
> > On Jul 15, 2024, at 4:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > [ Please keep documentation text to 80 columns. ] 
> > 
> 
> Yes. This is not a patch. I copied it from the man 8 output.
> It will be limited to 80 columns when sent as a patch.
> 
> > [ Please run documentation through a spell checker - there are too
> > many typos in this document to point them all out... ]
> 
> OK.
> 
> > 
> > On Tue, Jul 09, 2024 at 12:10:19PM -0700, Wengang Wang wrote:
> >> This patch set introduces defrag to xfs_spaceman command. It has the functionality and
> >> features below (also subject to be added to man page, so please review):
> > 
> > What's the use case for this?
> 
> This is the user space defrag as you suggested previously.
> 
> Please see the previous conversation for your reference: 
> https://patchwork.kernel.org/project/xfs/cover/20231214170530.8664-1-wen.gang.wang@oracle.com/

That's exactly what you should have put in the cover letter!

The cover letter is not for documenting the user interface of a new
tool - that's what the patch in the patch set for the new man page
should be doing.

The cover letter should contain references to past patch sets and
discussions on the topic. The cover letter shoudl also contain a
changelog that documents what is different in this new version of
the patch set so reviewers know what you've changed since they last
looked at it.

IOWs, the cover letter for explaining the use case, why the
functionality is needed, important design/implementation decisions
and the history of the patchset. It's meant to inform and remind
readers of what has already happened to get to this point.

> COPY STARTS —————————————> 
> I am copying your last comment there:
> 
> On Tue, Dec 19, 2023 at 09:17:31PM +0000, Wengang Wang wrote:
> > Hi Dave,
> > Yes, the user space defrag works and satisfies my requirement (almost no change from your example code).
> 
> That's good to know :)
> 
> > Let me know if you want it in xfsprog.
> 
> Yes, i think adding it as an xfs_spaceman command would be a good
> way for this defrag feature to be maintained for anyone who has need
> for it.

Sure, I might have said that 6 months ago. When presented with a
completely new implementation in a new context months later, I might
see things differently.  Everyone is allowed to change their mind,
opinions and theories as circumstances, evidence and contexts
change.

Indeed when I look at this:

> >>       defrag [-f free_space] [-i idle_time] [-s segment_size] [-n] [-a]
> >>              defrag defragments the specified XFS file online non-exclusively. The target XFS

I didn't expect anything nearly as complex and baroque as this. All
I was expecting was something like this to defrag a single range of
a file:

	xfs_spaceman -c "defrag <offset> <length>" <file>

As the control command, and then functionality for
automated/periodic scanning and defrag would still end up being
co-ordinated by the existing xfs_fsr code.

> > What's "non-exclusively" mean? How is this different to what xfs_fsr
> > does?
> > 
> 
> I think you have seen the difference when you reviewing more of this set.
> Well, if I read xfs_fsr code correctly, though xfs_fsr allow parallel writes, it looks have a problem(?)
> As I read the code, Xfs_fsr do the followings to defrag one file:
> 1) preallocating blocks to a temporary file hoping the temporary get same number of blocks as the
>     file under defrag with with less extents.
> 2) copy data blocks from the file under defrag to the temporary file.
> 3) switch the extents between the two files.
> 
> For stage 2, it’s NOT copying data blocks in atomic manner. Take an example: there need two
> Read->write pair to complete the data copy, that is
>     Copy range 1 (read range 1 from the file under defrag to the temporary file)
>     Copy range 2

I wasn't asking you to explain to me how the xfs_fsr algorithm
works. What I was asking for was a definition of what
"non-exclusively" means.

What xfs_fsr currently does meets my definition of "non-exclusive" - it does
not rely on or require exclusive access to the file being
defragmented except for the atomic extent swap at the end. However,
using FICLONE/UNSHARE does require exclusive access to the file be
defragmented for the entirity of those operations, so I don't have
any real idea of why this new algorithm is explicitly described as
"non-exclusive".

Defining terms so everyone has a common understanding is important.

Indeed, Given that we now have XFS_IOC_EXCHANGE_RANGE, I'm
definitely starting to wonder if clone/unshare is actually the best
way to do this now.  I think we could make xfs_fsr do iterative
small file region defrag using XFS_IOC_EXCHANGE_RANGE instead of
'whole file at once' as it does now. If we were also to make fsr
aware of shared extents 

> > 
> >>              Defragmentation and file IOs
> >> 
> >>              The target file is virtually devided into many small segments. Segments are the
> >>              smallest units for defragmentation. Each segment is defragmented one by one in a
> >>              lock->defragment->unlock->idle manner.
> > 
> > Userspace can't easily lock the file to prevent concurrent access.
> > So I'mnot sure what you are refering to here.
> 
> The manner is not simply meant what is done at user space, but a whole thing in both user space
> and kernel space.  The tool defrag a file segment by segment. The lock->defragment->unlock
> Is done by kernel in responding to the FALLOC_FL_UNSHARE_RANGE request from user space.

I'm still not sure what locking you are trying to describe. There
are multiple layers of locking in the kernel, and we use them
differently. Indeed, the algorithm you have described is actually

	FICLONERANGE
	IOLOCK shared
	ILOCK exclusive
	remap_file_range()
	IUNLOCK exclusive
	IOUNLOCK shared

	.....

	UNSHARE_RANGE
	IOLOCK exclusive
	MMAPLOCK exclusive
	<drain DIO in flight>
	ILOCK exclusive
	unshare_range()
	IUNLOCK exclusive
	MMAPUNLOCK exclusive
	IOUNLOCK shared

And so there isn't a single "lock -> defrag -> unlock" context
occurring - there are multiple independent operations that have
different kernel side locking contexts and there are no userspace
side file locking contexts, either.

> > 
> >>              File IOs are blocked when the target file is locked and are served during the
> >>              defragmentation idle time (file is unlocked).
> > 
> > What file IOs are being served in parallel? The defragmentation IO?
> > something else?
> 
> Here the file IOs means the IOs request from user space applications including virtual machine
> Engine.
> 
> > 
> >>              Though
> >>              the file IOs can't really go in parallel, they are not blocked long. The locking time
> >>              basically depends on the segment size. Smaller segments usually take less locking time
> >>              and thus IOs are blocked shorterly, bigger segments usually need more locking time and
> >>              IOs are blocked longer. Check -s and -i options to balance the defragmentation and IO
> >>              service.
> > 
> > How is a user supposed to know what the correct values are for their
> > storage, files, and workload? Algorithms should auto tune, not
> > require users and administrators to use trial and error to find the
> > best numbers to feed a given operation.
> 
> In my option, user would need a way to control this according to their use case.
> Any algorithms will restrict what user want to do.
> Say, user want the defrag done as quick as possible regardless the resources it takes (CPU, IO and so on)
> when the production system is in a maintenance window. But when the production system is busy
> User want the defrag use less resources.

That's not for the defrag program to implement That's what we use
resource control groups for. Things like memcgs, block IO cgroups,
scheduler cgroups, etc. Administrators are used to restricting the
resources used by applications with generic admin tools; asking them
to learn how some random admin tool does it's own resrouce
utilisation restriction that requires careful hand tuning for -one
off admin events- is not the right way to solve this problem.

We should be making the admin tool go as fast as possible and
consume as much resources as are available. This makes it fast out
of the box, and lets the admins restrict the IO rate, CPU and memory
usage to bring it down to an acceptible resource usage level for
admin tasks on their systems.

> Another example, kernel (algorithms) never knows the maximum IO latency the user applications tolerate.
> But if you have some algorithms, please share.

As I said - make it as fast and low latency as reasonably possible.
If you have less than 10ms IO latency SLAs, the application isn't
going to be running on sparse, software defined storage that may
require hundreds of milliseconds of IO pauses during admin tasks.
Hence design to a max fixed IO latency (say 100ms) and make the
funcitonality run as fast as possible within that latency window.

If people need lower latency SLAs, then they shouldn't be running
that application on sparse, COW based VM images. This is not a
problem a defrag utility should be trying to solve.

> >>              Free blocks consumption
> >> 
> >>              Defragmenation works by (trying) allocating new (contiguous) blocks, copying data and
> >>              then freeing old (non-contig) blocks. Usually the number of old blocks to free equals
> >>              to the number the newly allocated blocks. As a finally result, defragmentation doesn't
> >>              consume free blocks.  Well, that is true if the target file is not sharing blocks with
> >>              other files.
> > 
> > This is really hard to read. Defragmentation will -always- consume
> > free space while it is progress. It will always release the
> > temporary space it consumes when it completes.
> 
> I don’t think it’s always free blocks when it releases the temporary file. When the blocks were
> Original shared before defrag, the blocks won’t be freed.

I didn't make myself clear. If the blocks shared to the temp file
are owned exclusively by the source file (i.e. they were COW'd from
shared extents at some time in the past), then that is space
that is temporarily required by the defragmentation process. UNSHARE
creates a second, permanent copy of those blocks in the source file
and closing of the temp file them makes the original exclusively
owned blocks go away.

IOWs, defrag can temporarily consume an entire extra file's worth of
space between the UNSHARE starting and the freeing of the temporary
file when we are done with it. Freeing the temp file -always-
releases this extra space, though I note that the implementation is
to hole-punch it away after each segment has been processed.

> > 
> >>              In case the target file contains shared blocks, those shared blocks won't
> >>              be freed back to filesystem as they are still owned by other files. So defragmenation
> >>              allocates more blocks than it frees.
> > 
> > So this is doing an unshare operation as well as defrag? That seems
> > ... suboptimal. The whole point of sharing blocks is to minimise
> > disk usage for duplicated data.
> 
> That depends on user's need. If users think defrag is the first
> priority, it is.  If users don’t think the disk
> saving is the most important, it is not. No matter what developers think.
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

That's pretty ... dismissive.

I mean, you're flat out wrong. You make the assumption that a user
knows exactly how every file that every application in their system
has been created and knows exactly how best to defragment it.

That's just .... wrong.

Users and admins do not have intimate knowledge of how their
applications do their stuff, and a lot of them don't even know
that their systems are using file clones (i.e. reflink copies)
instead of data copies extensively these days.

That is completely the wrong way to approach administration
tools. 

Our defragmentation policy for xfs_fsr is to leave the structure of
the file as intact as possible. That means we replicate unwritten
regions in the defragmented file. We actually -defragment unwritten
extents- in xfs_fsr, not just written extents, and we do that
because we have to assume that the unwritten extents exist for a
good reason.

We don't expect the admin to make a decision as to whether unwritten
extents should be replicated or defragged - we make the assumption
that either the application or the admin has asked for them to exist
in the first place.

It is similar for defragmenting files that are largely made up of shared
extents. That layout exists for a reason, and it's not the place of
the defragmentation operation to unilaterally decide layout policies
for the admin and/or application that is using files with shared
extents.

Hence the defrag operation must preserve the *observed intent* of
the source file layout as much as possible and not require the admin
or user to be sufficiently informed to make the right decision one
way or another. We must attempt to preserve the status quo.

Hence if the file is largely shared, we must not unshare the entire
file to defragment it unless that is the only way to reduce the
fragmentation (e.g. resolve small interleaved shared and unshared
extents). If there are reasonable sized shared extents, we should be
leaving them alone and not unsharing them just to reduce the extent
count by a handful of extents.

> What’s more, reflink (or sharing blocks) is not only used to minimize disk usage. Sometimes it’s
> Used as way to take snapshots. And those snapshots might won’t stay long.

Yes, I know this. It doesn't change anything to do with how we
defragment a file that contains shared blocks.

If you don't want the snapshot(s) to affect defragmentation, then
don't run defrag while the snapshots are present. Otherwise, we
want defrag to retain as much sharing between the snapshots and
the source file because *minimising the space used by snapshots* is
the whole point of using file clones for snapshots in the first
place!

> And what’s more is that, the unshare operation is what you suggested :D   

I suggested it as a mechanism to defrag regions of shared files with
excessive fragmentation. I was not suggesting that "defrag ==
unshare".

> >>              For existing XFS, free blocks might be over-
> >>              committed when reflink snapshots were created. To avoid causing the XFS running into
> >>              low free blocks state, this defragmentation excludes (partially) shared segments when
> >>              the file system free blocks reaches a shreshold. Check the -f option.
> > 
> > Again, how is the user supposed to know when they need to do this?
> > If the answer is "they should always avoid defrag on low free
> > space", then why is this an option?
> 
> I didn’t say "they should always avoid defrag on low free space”. And even we can’t say how low is
> Not tolerated by user, that depends on user use case. Though it’s an option, it has the default value
> Of 1GB. If users don’t set this option, that is "always avoid defrag on low free space”.

You didn't answer my question: how is the user supposed to know
when they should set this?

And, again, the followup question is: why does this need to be
built into the defrag tool?

From a policy perspective, caring about the amount of free space in
the filesystem isn't the job of a defragmentation operation. It
should simply abort if it gets an ENOSPC error or fails to improve
the layout of the file in question. Indeed, if it is obvious that
there may not be enough free space in the filesystem to begin with
thendon't run the defrag operation at all.

This is how xfs_fsr works - it tries to preallocate all the space it
will need before it starts moving data. If it fails to preallocate
all the space, it aborts. If it fails to find large enough
contiguous free spaces to improve the layout of the file, it aborts.

IOWs, xfs_fsr policy is that it doesn't care about the amount of
free space in the filesystem, it just cares if the result will
improve the layout of the file.  That's basically how any online
background defrag operation should work - if the new
layout is worse than the existing layout, or there isn't space for
the new layout to be allocated, just abort.


> >>              Safty and consistency
> >> 
> >>              The defragmentation file is guanrantted safe and data consistent for ctrl-c and kernel
> >>              crash.
> > 
> > Which file is the "defragmentation file"? The source or the temp
> > file?
> 
> I don’t think there is "source concept" here. There is no data copy between files.
> “The defragmentation file” means the file under defrag, I will change it to “The file under defrag”.
> I don’t think users care about the temporary file at all.

Define the terms you use rather than assuming the reader
understands both the terminology you are using and the context in
which you are using them.

.....

> > 
> >>              The command takes the following options:
> >>                 -f free_space
> >>                     The shreshold of XFS free blocks in MiB. When free blocks are less than this
> >>                     number, (partially) shared segments are excluded from defragmentation. Default
> >>                     number is 1024
> > 
> > When you are down to 4MB of free space in the filesystem, you
> > shouldn't even be trying to run defrag because all the free space
> > that will be left in the filesystem is single blocks. I would have
> > expected this sort of number to be in a percentage of capacity,
> > defaulting to something like 5% (which is where we start running low
> > space algorithms in the kernel).
> 
> I would like leave this to user.

Again: How is the user going to know what to set this to? What
problem is this avoiding that requires the user to change this in
any way.

> When user is doing defrag on low free space system, it won’t cause
> Problem to file system its self. At most the defrag fails during unshare when allocating blocks.

Why would we even allow a user to run defrag near ENOSPC? It is a
well known problem that finding contiguous free space when we are close
to ENOSPC is difficult and so defrag often is unable to improve the
situation when we are within a few percent of the filesysetm being
full.

It is also a well known problem that defragmentation at low free
space trades off contiguous free space for fragmented free space.
Hence when we are at low free space, defrag makes the free space
fragmetnation worse, which then results in all allocation in the
filesystem getting worse and more fragmented. This is something we
absolutely should be trying to avoid.

This is one of the reasons xfs_fsr tries to layout the entire
file before doing any IO - when about 95% full, it's common for the
new layout to be worse than the original file's layout because there
isn't sufficient contiguous free space to improve the layout.

IOWs, running defragmentation when we are above 95% full is actively
harmful to the longevity of the filesystem. Hence, on a fundamental
level, having a low space threshold in a defragmentation tool is
simply wrong - defragmentation should simply not be run when the
filesystem is anywhere near full.

.....

> >> 
> >>                 -s segment_size
> >>                     The size limitation in bytes of segments. Minimium number is 4MiB, default
> >>                     number is 16MiB.
> > 
> > Why were these numbers chosen? What happens if the file has ~32MB
> > sized extents and the user wants the file to be returned to a single
> > large contiguous extent it possible? i.e. how is the user supposed
> > to know how to set this for any given file without first having
> > examined the exact pattern of fragmentations in the file?
> 
> Why customer want the file to be returned to a single large contiguous extent?
> A 32MB extent is pretty good to me.  I didn’t here any customer
> complain about 32MB extents…

There's a much wider world out there than just Oracle customers.
Just because you aren't aware of other use cases that exist, it
doesn't mean they don't exist. I know they exist, hence my question.

For example, extent size hints are used to guarantee that the data
is aligned to the underlying storage correctly, and very large
contiguous extents are required to avoid excessive seeks during
sequential reads that result in critical SLA failures. Hence if a
file is poorly laid out in this situation, defrag needs to return it
to as few, maximally sized extents as it can. How does a user know
what they'd need to set this segment size field to and so acheive
the result they need?

> And you know, whether we can defrag extents to a large one depends on not only the tool it’s self.
> It’s depends on the status of the filesystem, say if the filesystem is very fragmented too, say the AG size..
> 
> The 16MB is selected according our tests basing on a customer metadump. With 16MB segment size,
> The the defrag result is very good and the IO latency is acceptable too.  With the default 16MB segment
> Size, 32MB extent is excluded from defrag.

Exactly my point: you have written a solution that works for a
single filesystem in a single environment.  However, the solution is
so specific to the single problem you need to solve that it is not
clear whether that functionality or defaults are valid outside of
the specific problem case you've written it for and tested it on.

> If you have better default size, we can use that.

I'm not convinced that fixed size "segments" is even the right way
to approach this problem. What needs to be done is dependent on the
extent layout of the file, not how extents fit over some arbitrary
fixed segment map....

> >> We tested with real customer metadump with some different 'idle_time's and found 250ms is good pratice
> >> sleep time. Here comes some number of the test:
> >> 
> >> Test: running of defrag on the image file which is used for the back end of a block device in a
> >>      virtual machine. At the same time, fio is running at the same time inside virtual machine
> >>      on that block device.
> >> block device type:   NVME
> >> File size:           200GiB
> >> paramters to defrag: free_space: 1024 idle_time: 250 First_extent_share: enabled readahead: disabled
> >> Defrag run time:     223 minutes
> >> Number of extents:   6745489(before) -> 203571(after)
> > 
> > So and average extent size of ~32kB before, 100MB after? How much of
> > these are shared extents?
> 
> Zero shared extents, but there are some unwritten ones.
> A similar run stats is like this:
> Pre-defrag 6654460 extents detected, 112228 are "unwritten",0 are "shared” 
> Tried to defragment 6393352 extents (181000359936 bytes) in 26032 segments Time stats(ms): max clone: 31, max unshare: 300, max punch_hole: 66
> Post-defrag 282659 extents detected
> 
> > 
> > Runtime is 13380secs, so if we copied 200GiB in that time, the
> > defrag ran at 16MB/s. That's not very fast.
> > 
> 
> We are chasing the balance of defrag and parallel IO latency.

My point is that stuff like CLONE and UNSHARE should be able to run
much, much faster than this, even if some of the time is left idle
for other IO.

i.e. we can clone extents at about 100,000/s. We can copy data
through the page cache at 7-8GB/s on NVMe devices.

A full clone of the 6.6 million extents should only take about
a minute.

A full page cache copy of the 200GB cloned file (i.e. via read/write
syscalls) should easily run at >1GB/s, and so only take a couple of
minutes to run.

IOWs, the actual IO and metadata modification side of things is
really only about 5 minutes worth of CPU and IO.

Hence this defrag operation is roughly 100x slower than we should be
able to run it at.  We should be able to run it at close to those
speeds whilst still allowing concurrent read access to the file.

If an admin then wants it to run at 16MB/s, it can be throttled
to that speed using cgroups, ionice, etc.

i.e. I think you are trying to solve too many unnecessary problems
here and not addressing the one thing it should do: defrag a file as
fast and efficiently as possible.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
