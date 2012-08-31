Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7V6HYtt112394 for <xfs@oss.sgi.com>; Fri, 31 Aug 2012 01:17:34 -0500
Received: from mail.ud10.udmedia.de (ud10.udmedia.de [194.117.254.50]) by
	cuda.sgi.com with ESMTP id WTosLpZWSryDDaFS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Aug 2012 23:18:27 -0700 (PDT)
Date: Fri, 31 Aug 2012 08:18:25 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH V2 00/13] xfs: remove the xfssyncd mess
Message-ID: <20120831061825.GA7143@x4>
References: <1346328017-2795-1-git-send-email-david@fromorbit.com>
	<20120830121516.GA285@x4> <20120830225108.GF15292@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120830225108.GF15292@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 2012.08.31 at 08:51 +1000, Dave Chinner wrote:
> On Thu, Aug 30, 2012 at 02:15:16PM +0200, Markus Trippelsdorf wrote:
> > On 2012.08.30 at 22:00 +1000, Dave Chinner wrote:
> > > Version 2 of the patchset I described here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2012-06/msg00064.html
> > > 
> > > This version has run through xfstests completely once, so it's
> > > less likely to let smoke out....
> > 
> > Is there a publicly accessible git tree available where one could pull
> > from? (This would be way easier than saving and hand-applying 13
> > patches.)
> 
> No.
> 
> Instead, save all the patches to a single mbox format file, then run:
> 
> $ git checkout -b umount-fix-test
> $ git am <mbox file>
> 
> And it will apply all the patches as separate commits to the
> umount-fix-test branch. This is how I take patch sets from my inbox
> to git. You can build and testing them from there.

Yeah. That works if you're using mbox format files. But if you're are a
Maildir user like myself you're basically screwed, because 
 $ git am <Maildir> 
expects the Maildir to be *sorted* and because mails normally don't
arrive in the right order, git-am will therefore try to apply the
patches in the wrong order. (Maybe this should be reported to the git
mailing-list)

So if there are mutt users out there who use "mbox_type=Maildir" and
know how to save a thread to a single mbox file, then please let me
know.
Thanks.

-- 
Markus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
