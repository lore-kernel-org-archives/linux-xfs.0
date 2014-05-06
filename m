Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EABF7FF0
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:01:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5EAC58F8033
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:01:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	fOrKr74IlzvdB0qJ for <xfs@oss.sgi.com>;
	Tue, 06 May 2014 02:01:08 -0700 (PDT)
Date: Tue, 6 May 2014 19:00:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140506090056.GH5421@dastard>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140506083744.GA9976@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506083744.GA9976@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, May 06, 2014 at 01:37:44AM -0700, Christoph Hellwig wrote:
> I like this in general, but one major and one minor issue with
> the include files:
> 
>  - headers that just include other headers are a bad idea in general.
>    Either they are dependent enough that they should be merged, or
>    they are not, in which case they shouldn't.
> 
>    In this case it seems like we should temporarily provide a
>    xfs_mount.h stub in userspace, and just leave all the includes
>    for things in libxfs.h as they were.  That doesn't preclude further
>    merging of the headers into more sensible ones as we've started
>    with the disk formats.

I did this because I'm sick of having to edit 50+ files whenever a
single header dependency changes. There are almost all cookie cutter
duplicates because of the dependencies - if it were code, we'd
factor it in an instant.  I just don't see why we should treat 50
copies of the same header includes any differently....

>  - do we really need the separate include/ dir?  That always annoys
>    me when editing code.  It makes sense for something that is a real
>    public interface, which this is not.

It's for simplicity of updates with the userspace code. Both
userspace and kernel need the same code layout, and userspace
currently has a separate include directory for all the header files
(and they get installed that way, too). If we want to change the
userspace source layout and commingle all the headers with the C
code, then that's a lot more work on the userspace side (i.e. it's
more than just pointing the include/xfs symlink to libxfs/include).

I don't mind which approach we take - it's trivial to rework the
patchset to place all the headers in the libxfs/ directory - I just
took the one that matched the current userspace infrastructure...

> Also is libxfs/ really the right name?  libxfs in userspace has quite
> a bit more code than this, so maybe we should just called this "shared"
> for the shared user/kernel code?

I'd like to have this kernel code define libxfs/, while in userspace
we separate out all the support code (i.e. libxfs/rdwr.c, etc) into
a different directory that builds the userspace libraries. i.e.
libxfs/ is a static object archive that is wrapped by the userspace
infrastructure, just like the kernel wraps it with infrastructure to
make it useful...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
