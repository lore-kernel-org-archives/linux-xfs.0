Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D42D47F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 07:13:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3F85304032
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 05:13:31 -0700 (PDT)
Received: from mail-la0-f48.google.com (mail-la0-f48.google.com
	[209.85.215.48]) by cuda.sgi.com with ESMTP id ceXaElQM9wJzHMn5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 May 2013 05:13:30 -0700 (PDT)
Received: by mail-la0-f48.google.com with SMTP id fs12so5065951lab.21
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 05:13:29 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH] xfstests: test data integrity under disk failure
In-Reply-To: <20130516233153.GI24635@dastard>
References: <1368706052-24391-1-git-send-email-dmonakhov@openvz.org>
	<20130516233153.GI24635@dastard>
Date: Sat, 18 May 2013 16:13:25 +0400
Message-ID: <878v3cv63e.fsf@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Fri, 17 May 2013 09:31:53 +1000, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, May 16, 2013 at 04:07:32PM +0400, Dmitry Monakhov wrote:
> > Parallels team have old good tool called hwflush-check which is server/client
> > application for testing data integrity under system/disk failure conditions.
> > Usually we run hwflush-check on two different hosts and use PMU to trigger real
> > power failure of the client as a whole unit. This tests may be used for
> > SSD checking (some of them are known to have probelms with hwflush).
> > I hope it will be good to share it with community.
> > 
> > This tests simulate just one disk failure while client system should
> > survive this failure. This test extend idea of shared/305.
> > 1) Run hwflush-check server and client on same host as usual
> > 2) Simulare disk failure via blkdev failt injection API aka 'make-it-fail'
> > 3) Umount failed device
> > 4) Makes disk operatable again
> > 5) Mount filesystem
> > 3) Check data integrity
> 
> So, for local disk failure, why do we need a client/server network
> architecture? That just complicates the code, and AFAICT
> 
> all the client does is send report report packets to server which
> contain an id number that is kept in memory. If on restart of the
> client after failure the ID in the report packet doesn't match what
> the server wants, then it fails the test.
> 
> So, why is the server needed here? Just dump the IDs the client
> writes to the file on a device not being tested, and either diff
> them against a golden image or run a check to see all the IDs are
> monotonically increasing. That removes all the networking code from
> the test, the need for a client/server architecture, etc, and makes
> the test far easier to review
In fact the reason is quite simple. Initially the this tool was designed
for real disk cache testing under power failure conditions. And want to
share it with community. Off course it is possible to simplify things 
for 'one hose' case but it is not too big. Let's review it one and keep
it simple but useful not just for local but also for real power failure
tests.
Fairly to say that initial idea was to add persistent state to FIO.
But logic starts to getting too complex so we write hwflush-check.

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
