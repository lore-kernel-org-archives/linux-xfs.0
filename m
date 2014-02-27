Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B436429DF8
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 19:31:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B141AC003
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:31:36 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id vKl25RHEwMoyBTvp
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:31:34 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id kp14so1764958pab.23
	for <xfs@oss.sgi.com>; Wed, 26 Feb 2014 17:31:34 -0800 (PST)
Date: Wed, 26 Feb 2014 17:30:35 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v5 0/10] fs: Introduce new flag(FALLOC_FL_COLLAPSE_RANGE)
	for fallocate
In-Reply-To: <20140227012431.GW13647@dastard>
Message-ID: <alpine.LSU.2.11.1402261729020.29071@eggly.anvils>
References: <1392741436-19995-1-git-send-email-linkinjeon@gmail.com>
	<20140224005710.GH4317@dastard>
	<20140225141601.358f6e3df2660d4af44da876@canb.auug.org.au>
	<20140225041346.GA29907@dastard>
	<alpine.LSU.2.11.1402251217030.2380@eggly.anvils>
	<20140226011347.GL13647@dastard>
	<alpine.LSU.2.11.1402251856060.1114@eggly.anvils>
	<20140226064224.GU13647@dastard>
	<alpine.LSU.2.11.1402261454270.2808@eggly.anvils>
	<20140227012431.GW13647@dastard>
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
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Namjae Jeon <linkinjeon@gmail.com>, Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <matthew@wil.cx>, Namjae Jeon <namjae.jeon@samsung.com>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org, bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk, lczerner@redhat.com, linux-fsdevel@vger.kernel.org, jack@suse.cz, Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org, mtk.manpages@gmail.com

On Thu, 27 Feb 2014, Dave Chinner wrote:
> On Wed, Feb 26, 2014 at 03:08:58PM -0800, Hugh Dickins wrote:
> > 
> > Thanks for explaining more, I was just about to acknowledge what a good
> > example that is.  Indeed, it seems not unreasonable to be editing the
> > earlier part of a file while the later part of it is still streaming in.
> > 
> > But damn, it now occurs to me that there's still a problem at the
> > streaming end: its file write offset won't be updated to reflect
> > the collapse, so there would be a sparse hole at that end.  And
> > collapse returns -EPERM if IS_APPEND(inode).
> 
> Well, we figure that most applications won't be using append only
> inode flags for files that they know they want to edit at random
> offsets later on. ;)
> 
> However, I can see how DVR apps would use open(O_APPEND) to obtain
> the fd they write to because that sets the write position to the EOF
> on every write() call (i.e. in generic_write_checks()). And collapse
> range should behave sanely with this sort of usage.
> 
> e.g. XFS calls generic_write_checks() after it has taken the IO lock
> to set the current write position to EOF. Hence it will be correctly
> serialised against collapse range calls and so O_APPEND writes will
> not leave sparse holes if collapse range calls are interleaved with
> the write stream....

Right, I was getting confused between O_APPEND and APPEND_Only!
Thanks, I'm back to being convinced by your example.

Hugh

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
