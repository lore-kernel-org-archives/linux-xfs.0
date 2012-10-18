Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9IFidHI198712 for <xfs@oss.sgi.com>; Thu, 18 Oct 2012 10:44:39 -0500
Date: Thu, 18 Oct 2012 10:46:15 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v5 06/10] xfs: add XFS_IOC_FREE_EOFBLOCKS ioctl
Message-ID: <20121018154615.GH1377@sgi.com>
References: <1349446636-8611-1-git-send-email-bfoster@redhat.com>
	<1349446636-8611-7-git-send-email-bfoster@redhat.com>
	<20121011141335.GY13214@sgi.com> <507749A2.4020206@redhat.com>
	<20121015224626.GU24986@sgi.com> <20121015234902.GH2739@dastard>
	<20121016013901.GI2739@dastard> <20121017224004.GG1377@sgi.com>
	<507FF339.8020208@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <507FF339.8020208@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: tinguely@sgi.com, xfs@oss.sgi.com

Hey Brian,

On Thu, Oct 18, 2012 at 08:16:57AM -0400, Brian Foster wrote:
> On 10/17/2012 06:40 PM, Ben Myers wrote:
> > On Tue, Oct 16, 2012 at 12:39:01PM +1100, Dave Chinner wrote:
> >> On Tue, Oct 16, 2012 at 10:49:02AM +1100, Dave Chinner wrote:
> >>> On Mon, Oct 15, 2012 at 05:46:26PM -0500, Ben Myers wrote:
> >>>> Hey Brian,
> >>>>
> ...
> >>>> I do think it is preferable to have a test case go in with the code where
> >>>> possible.  Since you don't mind waiting a bit, that seems to be the way to go.
> >>>> The other option could be to look for a volunteer to work on the test.  ;)
> >>>
> >>> FWIW, given the background cleanup code can be trivially verified to
> >>> work (open, apend, close, repeat, wait 5 minutes) and is the
> >>> functionality that is needed in mainline, having something to test
> >>> the ioctls should not stop the patchset from being merged.
> > 
> > Can we be assured that we'll get an xfstest for it eventually?
> > 
> 
> Absolutely. Getting a command into xfs_io to support such a test is now
> the top of my todo list with regard to XFS. :)

Excellent!

> > I think we can pull this in if Brian is willing post his test code.  Initially
> > it needn't be posted as an xfstest, that's fine.  As it stands today it appears
> > that Brian is the only one to ever use the ioctl and there is no way for anyone
> > else to test it.  Not an ideal situation.
> > 
> 
> The impetus for this work was some prototype quota work for the gluster
> distributed filesystem.

Now I'm curious where you're coming from.  Is gluster your primary project?

> Beyond testing via that, I just had a very
> simple/stupid program with the command and data structure bits
> copy/pasted in to open a file and invoke an xfsctl() with hardcoded
> parameters. I don't consider it post-worthy or very useful, but attached
> nonetheless since I have a couple things to deal with before I get a
> chance to play with xfs_io.

Thanks for posting it anyway.  That's enough for an interested party to do a
little fooling.  I believe Mark is finishing up a review of this series, so
we'll get it in soon.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
