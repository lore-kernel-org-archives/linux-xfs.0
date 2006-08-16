Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 17:24:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G0NXDW028372
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 17:23:44 -0700
Date: Wed, 16 Aug 2006 10:22:24 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [PATCH 0/2] Use 64-bit inode numbers internally in the kernel [try #2]
Message-ID: <20060816102224.F2740551@wobbly.melbourne.sgi.com>
References: <20060815152627.29222.71414.stgit@warthog.cambridge.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060815152627.29222.71414.stgit@warthog.cambridge.redhat.com>; from dhowells@redhat.com on Tue, Aug 15, 2006 at 04:26:27PM +0100
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, trond.myklebust@fys.uio.no, aviro@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, nfsv4@linux-nfs.org, xfs@oss.sgi.com

On Tue, Aug 15, 2006 at 04:26:27PM +0100, David Howells wrote:
> 
> These patches make the kernel pass 64-bit inode numbers internally when
> communicating to userspace, even on a 32-bit system.  They are required
> because some filesystems have intrinsic 64-bit inode numbers: NFS3+ and XFS
> for example.  The 64-bit inode numbers are then propagated to userspace
> automatically where the arch supports it.

Thanks for doing this, David.  FWIW, for XFS its not directly a problem
today, we simply block attempts to mount filesystems on 32 bit systems
where the inums could get into the problematic ranges.  With several XFS
changes (main change will be switching to use iget5_locked) we will be
able to allow those mounts to go ahead - so, thanks again!

cheers.

-- 
Nathan
