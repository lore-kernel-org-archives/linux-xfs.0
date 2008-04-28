Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 27 Apr 2008 20:25:21 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3S3Ovil026455
	for <xfs@oss.sgi.com>; Sun, 27 Apr 2008 20:24:58 -0700
Message-ID: <48154364.3070208@melbourne.sgi.com>
Date: Mon, 28 Apr 2008 13:24:20 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Don't initialise new inode generation numbers to zero
 V2
References: <20080422015806.GU108924158@sgi.com> <480D641B.8060301@melbourne.sgi.com> <20080422050447.GV103491721@sgi.com> <20080425085750.GA6395@infradead.org>
In-Reply-To: <20080425085750.GA6395@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Tue, Apr 22, 2008 at 03:04:48PM +1000, David Chinner wrote:
>   
>>
>> Christoph, care to explain how and why this is a problem to everyone?
>>     
>
> XFS has some heuristics for inode placement and of course for removing
> the inode cluster and re-allocting it.  I have a gut feeling that there
> is a small chance to trigger a re-use via nfs operations.  
Dave's initial patch -- please correct me if I misunderstood it -- kept
a per-AG counter which was used to initialise the generation number of
new inodes.  This counter incremented every time an inode was created in
that AG, i.e. every mknod() mkdir() or creat() bumps the counter for the
appropriate AG. So it served as a per-AG inode generation number, which
given the fixed mapping between AG and inode# means it's just like a
per-inode generation number but sparser.  Thus the only way you could
cause a re-use of an (inode,gen) tuple would be by cycling through
2^32-1 inode creations anywhere in the same AG before destroying and
re-creating the original inode.  That's as good a protection as 32bits
is going to buy.  So if Dave's first patch works the way I think it
works, it should be just fine for NFS' purposes.  Am I missing something?

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
The cake is *not* a lie.
I don't speak for SGI.
