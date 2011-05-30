Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4U1PeAi211792 for <xfs@oss.sgi.com>; Sun, 29 May 2011 20:25:41 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA103D4B7C6
	for <xfs@oss.sgi.com>; Sun, 29 May 2011 18:25:38 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3mNM11Ciunay3cfV for <xfs@oss.sgi.com>;
	Sun, 29 May 2011 18:25:38 -0700 (PDT)
Date: Mon, 30 May 2011 11:25:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsprogs: Fix for xfstest 252 hang on ext4
Message-ID: <20110530012534.GB561@dastard>
References: <4DDAC4EF.1050702@linux.vnet.ibm.com>
	<4DDE9CD9.3010300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4DDE9CD9.3010300@linux.vnet.ibm.com>
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
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 26, 2011 at 11:32:57AM -0700, Allison Henderson wrote:
> On 5/23/2011 1:34 PM, Allison Henderson wrote:
> >Hi all,
> >
> >While trying to add more punch hole tests to xfstest, I found
> >that test 252 hangs on ext4 due to a loop in xfsprogs that does
> >not exit.  XFS gets out of this loop because there is logic in
> >the loop that looks for the last extent flag and breaks out.  But
> >it looks like ext4 does not return a last extent when the file
> >has a hole at the end.  I am not sure if this is the correct
> >behavior or not, so I will copy the ext4 folks on this too.
> >Below is a copy of the fix for xfsprogs:
> >
> >diff --git a/io/fiemap.c b/io/fiemap.c
> >index fa990cc..81fc92c 100644
> >--- a/io/fiemap.c
> >+++ b/io/fiemap.c
> >@@ -246,7 +246,7 @@ fiemap_f(
> >  		       flg_w, _("FLAGS"));
> >  	}
> >
> >-	while (!last&&  ((cur_extent + 1) != max_extents)) {
> >+	while (!last&&  (cur_extent<= max_extents)) {
> >  		if (max_extents)
> >  			num_extents = min(num_extents,
> >  					  max_extents - (cur_extent + 1));
> >
> >
> >It looks like the loop enters with last=0, cur_extents=0, and
> >max_extents = 0, and on the first iteration cur_extents get set
> >to 2, so we dont see ((cur_extent + 1) == max_extents for a very
> >long time.  I doubt the logic was meant to work that way, so this
> >patch should fix it, but I wanted to make sure that the fiemap
> >for ext4 is working as intended too.  Feed back appreciated!  Thx
> >all!
> >
> >Allison Henderson
> >
> Hi all,
> 
> I haven't heard much back on this patch, so Im just poking this
> thread to make sure it doesn't get forgotten. I have some patches
> out there for punch hole, and I'm currently looking at fixing up
> some older punch hole tests in the dmapi code, but they wont do much
> good for ext4 with out this fix.  If I could get a quick peek from
> some one on the xfs list for this patch, that would be much
> appreciated.  Thx all!

If ext4 is not setting the last extent flag on the last extent then
that's an ext4 bug that the test has detected, right? And so you
should be fixing ext4 rather than modifying the test to hide the
different behaviour?

Cheer
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
