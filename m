Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OHhOCU059048 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 11:43:24 -0600
Date: Tue, 24 Jan 2012 12:43:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LSF/MM TOPIC] [ATTEND] HSM, DMAPI, and external media filesystems
Message-ID: <20120124174319.GA9853@infradead.org>
References: <20120119193947.GA6688@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120119193947.GA6688@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org, xfs@oss.sgi.com

On Thu, Jan 19, 2012 at 01:39:47PM -0600, Ben Myers wrote:
> I would like to discuss how to get DMAPI accepted into the mainline
> kernel.  DMAPI is or was supported by a number of filesystems which are
> included in linux (including XFS) and also is supported by a number of
> proprietary filesystems.  However, the DMAPI implementation has not yet
> been accepted into the main line.
> 
> - What are the barriers to inclusion and how can they be resolved?

The grotty DMAPI interface.  That includes both the high-level ioctl
implementations as well as lower level details.

In the end most of it boils down to three things:

 - a notification API telling the daemon about changes, and allowing
   it to block them.  That's in some ways fairly similar to fanotify,
   which should be reused.  Preferably including the interface, but at
   the very least the underlying implementation.
 - a handle based I/O method.  We now have open by handle at the VFS,
   so it might just need a few additions like the invisible I/O flag.
 - ways to make extents offline in the fs, and set various HSM specific
   flags.  This is the actual filesystem-specific piece of code, but
   we'll need to think about an interface to query and set these bits.
   filesystem-specific piece of code.

> 
> - What FOSS HSM projects are available to use the interface?
> 	* xfstests/dmapi/sample_hsm

That actually seems to be the only one.

> 	* openhsm (opensms)

While that one has HSM in the name it actually seems to work quite
differently from the traditional partially offline HSM model, nevermind
that it seems abandoned.

> 	* tinyhsm (unfinished, unreleased)

pointers?

> In the end I'd like to come up with a plan that seems reasonable toward
> getting DMAPI included mainline.  I know that Alex Elder and others have
> done work in this area and I would like to see it bear fruit.

I'm not really sure discussing this grand highlevel design without
backing code really fits for LSF.  Might be a fine topic for a BOF
if enough interested people are around.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
