Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 06 Oct 2006 06:18:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k96DI6aG005963
	for <xfs@oss.sgi.com>; Fri, 6 Oct 2006 06:18:06 -0700
Date: Fri, 6 Oct 2006 09:03:03 -0400 (EDT)
From: Stephane Doyon <sdoyon@max-t.com>
In-Reply-To: <20061005232935.GE19345@melbourne.sgi.com>
Message-ID: <Pine.LNX.4.64.0610060859270.31641@madrid.max-t.internal>
References: <Pine.LNX.4.64.0609191533240.25914@madrid.max-t.internal>
 <451A618B.5080901@agami.com> <Pine.LNX.4.64.0610020939450.5072@madrid.max-t.internal>
 <20061002223056.GN4695059@melbourne.sgi.com> <Pine.LNX.4.64.0610030917060.31738@madrid.max-t.internal>
 <20061005083015.GC19345@melbourne.sgi.com> <Pine.LNX.4.64.0610051139540.31641@madrid.max-t.internal>
 <20061005232935.GE19345@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: several messages
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, xfs@oss.sgi.com, nfs@lists.sourceforge.net, Shailendra Tripathi <stripathi@agami.com>

On Fri, 6 Oct 2006, David Chinner wrote:

>> The backtrace looked like this:
>>
>> ... nfsd_write nfsd_vfs_write vfs_writev do_readv_writev xfs_file_writev
>> xfs_write generic_file_buffered_write xfs_get_blocks __xfs_get_blocks
>> xfs_bmap xfs_iomap xfs_iomap_write_delay xfs_flush_space xfs_flush_device
>> schedule_timeout_uninterruptible.
>
> Ahhh, this gets hit on the ->prepare_write path (xfs_iomap_write_delay()),

Yes.

> not the allocate path (xfs_iomap_write_allocate()). Sorry - I got myself
> (and probably everyone else) confused there which why I suspected sync
> writes - they trigger the allocate path in the write call. I don't think
> 2.6.18 will change anything.
>
> FWIW, I don't think we can avoid this sleep when we first hit ENOSPC
> conditions, but perhaps once we are certain of the ENOSPC status
> we can tag the filesystem with this state (say an xfs_mount flag)
> and only clear that tag when something is freed. We could then
> use the tag to avoid continually trying extremely hard to allocate
> space when we know there is none available....

Yes! That's what I was trying to suggest :-). Thank you.

Is that hard to do?
