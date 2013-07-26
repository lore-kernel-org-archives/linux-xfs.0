Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 38D5029E11
	for <xfs@oss.sgi.com>; Fri, 26 Jul 2013 16:42:42 -0500 (CDT)
Date: Fri, 26 Jul 2013 16:42:38 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: understanding speculative preallocation
Message-ID: <20130726214238.GM1681@sgi.com>
References: <1374823420041-35002.post@n7.nabble.com>
	<20130726115021.GO13468@dastard>
	<CAA+BczQesNL2VmFmrcBNKXcM-Sfx0bXkXPRP5xMx6=Bv+NWrUA@mail.gmail.com>
	<51F2CD8B.8080207@hardwarefreak.com>
	<CAA+BczQGYoJVL0twvz2GRhH30teFPSJOsKWtofbXBrom4_Q6hg@mail.gmail.com>
	<20130726205018.GM3111@sgi.com>
	<CAA+BczSpn7Cu2rZWJ9Q2b1-Xh0365R9ykGxKHHymtRm2Q7xCuA@mail.gmail.com>
	<CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA+BczTt-ZN7DU8gpWAY0SdL0KWL2Z_y8qKvmxMn7b+T9frK4Q@mail.gmail.com>
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
To: Jason Rosenberg <jbr@squareup.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Hi Jason,

On Fri, Jul 26, 2013 at 05:11:55PM -0400, Jason Rosenberg wrote:
> Is it safe to say that speculative preallocation will not be used if a file
> is opened read-only?

The blocks will only be reserved on an appending write.

> It turns out that the kafka server does indeed write lots of log files, and
> rotate them after they reach a max size, but never closes the files until
> the app exits, or until it deletes the files.  This is because it needs to
> make them available for reading, etc.   So, an obvious change for kafka
> might be to close each log file after rotating, and then re-open it
> read-only for consumers of the data.  Does that sound like a solution that
> would pro-actively release pre-allocated storage?

An interesting idea, and I'm not quite sure.  The blocks past EOF are freed in
xfs_release on close in some circumstances, and it looks like you have a chance
to call xfs_free_eofblocks (at least in the most uptodate codebase) if you did
not use explicit preallocation (e.g. fallocate or an xfs ioctl) and did not
open it append-only.  You could reopen with read-write flags and it wouldn't
make a difference vs read-only, so long as you don't do an appending write.

Seems like it's worth a try.  Another possibility is to look into what would
happen if you do a truncate up to i_size when you're ready to stop appending to
the file.  I haven't checked that out though.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
