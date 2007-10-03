Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Oct 2007 01:11:55 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l938BnJq006459
	for <xfs@oss.sgi.com>; Wed, 3 Oct 2007 01:11:52 -0700
Date: Wed, 3 Oct 2007 04:11:50 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [GIT PULL] XFS update for 2.6.23 - revert a commit
In-Reply-To: <4702F517.3040502@sgi.com>
Message-ID: <Pine.LNX.4.64.0710030411250.3650@p34.internal.lan>
References: <20071001072350.DF61C58C4C0A@chook.melbourne.sgi.com>
 <4700EE2A.1020304@sandeen.net> <4701A1D0.5010709@sgi.com> <4701ED51.8050706@sgi.com>
 <Pine.LNX.4.64.0710020442540.24427@p34.internal.lan> <4702F517.3040502@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com



On Wed, 3 Oct 2007, Timothy Shimmin wrote:

> Hi Justin,
>
> Justin Piszcz wrote:
>> 
>> 
>> On Tue, 2 Oct 2007, Lachlan McIlroy wrote:
>> 
>>> Yeah that about sums it up.  In an attempt to prevent log replay of inodes
>>> in cases when we shouldn't replay we also prevented log replay of inodes 
>>> in
>>> cases when we should replay.  We end up with directories that refer to 
>>> inodes
>>> that were not replayed and we read existing data off disk.  That existing
>>> data is usually previous instances of inodes.  We had cases of regular 
>>> files
>>> turning into directories and inode version mismatches.
>>> 
>>> Lachlan
>>> 
>> In 2.6.23-rc8?
>> 
> The bad change went into rc7 and was still there in rc8.
> It was backed out for rc9.
>
> --Tim
>

If one with was running 2.6.23-rc8 with XFS, does that mean we should run 
xfs_repair on our filesystems after upgrading to -rc9?

Justin.
