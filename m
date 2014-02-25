Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 776457F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 17:42:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C17A304048
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:42:08 -0800 (PST)
Received: from mail-pb0-f54.google.com (mail-pb0-f54.google.com
	[209.85.160.54]) by cuda.sgi.com with ESMTP id ljT2HEazvnW8rxKG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:42:07 -0800 (PST)
Received: by mail-pb0-f54.google.com with SMTP id uo5so130763pbc.27
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 15:42:07 -0800 (PST)
Date: Tue, 25 Feb 2014 15:41:20 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v5 1/10] fs: Add new flag(FALLOC_FL_COLLAPSE_RANGE) for
	fallocate
In-Reply-To: <20140223213606.GE4317@dastard>
Message-ID: <alpine.LSU.2.11.1402251525370.2380@eggly.anvils>
References: <1392741464-20029-1-git-send-email-linkinjeon@gmail.com>
	<20140222140625.GD26637@thunk.org> <20140223213606.GE4317@dastard>
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, Ashish Sangwan <a.sangwan@samsung.com>, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Mon, 24 Feb 2014, Dave Chinner wrote:
> On Sat, Feb 22, 2014 at 09:06:25AM -0500, Theodore Ts'o wrote:
> > On Wed, Feb 19, 2014 at 01:37:43AM +0900, Namjae Jeon wrote:
> > > +	/*
> > > +	 * There is no need to overlap collapse range with EOF, in which case
> > > +	 * it is effectively a truncate operation
> > > +	 */
> > > +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) &&
> > > +	    (offset + len >= i_size_read(inode)))
> > > +		return -EINVAL;
> > > +
> > 
> > I wonder if we should just translate a collapse range that is
> > equivalent to a truncate operation to, in fact, be a truncate
> > operation?
> 
> Trying to collapse a range that extends beyond EOF, IMO, is likely
> to only happen if the DVR/NLE application is buggy. Hence I think
> that telling the application it is doing something that is likely to
> be wrong is better than silently truncating the file....

I do agree with Ted on this point.  This is not an xfs ioctl added
for one DVR/NLE application, it's a mode of a Linux system call.

We do not usually reject with an error when one system call happens
to ask for something which can already be accomplished another way;
nor nanny our callers.

It seems natural to me that COLLAPSE_RANGE should support beyond EOF;
unless that adds significantly to implementation difficulties?

Actually, is it even correct to fail at EOF?  What if fallocation
with FALLOC_FL_KEEP_SIZE was used earlier, to allocate beyond EOF:
shouldn't it be possible to shift that allocation down, along with
the EOF, rather than leave it behind as a stranded island?

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
