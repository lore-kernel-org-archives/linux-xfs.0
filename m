Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2AD987FD0
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 17:22:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0AC2C8F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 15:22:26 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	v1UNEsyS9JaWrRMR for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 15:22:25 -0700 (PDT)
Date: Fri, 26 Sep 2014 08:22:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] Adds ioctl interface support for ext4 project
Message-ID: <20140925222221.GI4945@dastard>
References: <1411567470-31799-1-git-send-email-lixi@ddn.com>
	<1411567470-31799-5-git-send-email-lixi@ddn.com>
	<20140924162507.GC27000@quack.suse.cz>
	<20140924162634.GA16886@infradead.org>
	<20140924170105.GE27000@quack.suse.cz>
	<20140925075912.GG4758@dastard> <20140925134136.GE4592@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140925134136.GE4592@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: adilger@dilger.ca, Jan Kara <jack@suse.cz>, linux-api@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, dmonakhov@openvz.org, viro@zeniv.linux.org.uk, Li Xi <pkuelelixi@gmail.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Sep 25, 2014 at 09:41:37AM -0400, Theodore Ts'o wrote:
> On Thu, Sep 25, 2014 at 05:59:12PM +1000, Dave Chinner wrote:
> > > Also I'm afraid we may quickly run out of
> > > 32 available flags in xflags so we'd need to extend that. But all this
> > > seems to be doable.
> > 
> > The struct fsxattr was designed to be extensible - it has unused
> > padding and enough space in the flags field to allow us to
> > conditionally use that padding....
> 
> I agree that it would be useful for ext4 to support as much of the
> XFS_IOC_GETXATTR/XFS_IOC_SETATTR as would make sense for ext4, and to
> use that to set/get the project ID.  (And that we should probably do
> that as a separate set of patches that we could potentially go into
> ext4 ahead of the project quota while it is undergoing testing and
> review.)
> 
> A few questions of Dave and other XFS folks:
> 
> 1) If we only implement a partial set of the flags or other
> functionality, are there going to be tools that get confused?  i.e.,
> are there any userspace programs that will test for whether the ioctl
> is supported, and then assume that some minimal set of functionality
> must be implemented?

No, I don't think they will get confused.

The use of the flags is get/modify/set just like other flag setting
functions. The extsize and projid fields are condition on the
relevant flag being set on return from a get (i.e. projid is only
valid if XFS_XFLAG_PROJID[_INHERIT] is set), and those fields are
only considered valid on set if those flags are set by the
application (or remain set as a result of the getxattr).

Hence the applications that use the getxattr/setxattr interface
correctly shouldn't care what set of flags and values the filesystem
supports other than the specific flags the application needs the
filesystem to understand.

> 2) Unless I'm missing something, there is nothing that enforces that
> fsx_pad must be zero.  I assume that means that the only way you can
> expand use of fields into that space is via a flag bit being consumed?

Yup, that's exactly what I meant by "conditionally use the padding".
Even if the padding was guaranteed to be zero, I'd strongly
recommend a flag bit to indicate the application understands that
the padding region has actual meaning to guard against buggy
applications.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
