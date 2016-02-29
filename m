Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F03007CA0
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 12:08:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C2C588F8033
	for <xfs@oss.sgi.com>; Mon, 29 Feb 2016 10:08:06 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VeA3tawdcLXs2B1q (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Feb 2016 10:08:05 -0800 (PST)
Date: Mon, 29 Feb 2016 13:08:03 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS: false "torn write" errors (preventing mount)
Message-ID: <20160229180803.GC47880@bfoster.bfoster>
References: <56D471E002000078000D76C2@prv-mh.provo.novell.com>
	<20160229155752.GB47880@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160229155752.GB47880@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Beulich <JBeulich@suse.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 29, 2016 at 10:57:52AM -0500, Brian Foster wrote:
> On Mon, Feb 29, 2016 at 08:29:20AM -0700, Jan Beulich wrote:
> > Brian,
> > 
> > on a system where I routinely run both a 32-bit and a 64-bit x86
> > kernel (underneath the same 32-bit distro) I'm observing the
> > newly added message being issued, along with the mounts
> > subsequently failing when running the 32-bit kernel. Without
> > doing anything to the FS, running an older 32-bit kernel or a
> > 4.5-rc6 64-bit one have everything work fine (and silently), so
> > I can only assume the detection logic doesn't work right in a
> > 32-bit kernel. I've looked over commits 6528250b71 and
> > 7088c4136f without being able to spot any obvious word size
> > dependency, but then again I know nothing about the inner
> > workings of the XFS code.
> > 
> > I'm now hoping that you have an idea what's going on here.
> > 
> 
> There was one follow on fix related to byte order: 8e0bd4925bf6 ("xfs:
> fix endianness error when checking log block crc on big endian
> platforms"), but I don't think that would have any effect on an x86
> kernel.
> 
> Is the 32-bit kernel problematic on its own, or must the 64-bit kernel
> be involved somehow before the 32-bit kernel reproduces a problem? For
> example, can you mkfs, mount and remount (perhaps multiple times) on the
> 32-bit kernel without a problem? If so, what happens if you transition
> to the 64-bit kernel, remount a few times, and then go back to 32-bit?
> In general, anything that narrows down the reproducer is helpful.
> 
> I don't appear to have a 32-bit env. handy so I'll kick off an install
> in the meantime and take a closer look from there...
> 

Just a heads up that I've been able to reproduce. What I think might be
going on is that the log is clean, but the log recovery pass looks back
behind the latest unmount record, runs into some records/data written by
the alternate architecture from that which is running, and then fails
due to crc mismatch. The problem doesn't seem to manifest right away,
however, so I could still be missing something here.

Anyways, I'll dig into it and try to come up with a fix. Thanks for the
report!

Brian

> Brian
> 
> > Thanks, Jan
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
