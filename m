Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EEbrlu141312 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 09:37:53 -0500
Subject: Re: [PATCH 4/4 v3] XFS TESTS: Fix 252 Failure: Add Generic FS
	Punch Hole Test 255
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <4E1E1E41.30106@linux.vnet.ibm.com>
References: <1309411441-2491-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309411441-2491-5-git-send-email-achender@linux.vnet.ibm.com>
	<1310574716.1998.25.camel@doink>  <4E1E1E41.30106@linux.vnet.ibm.com>
Date: Thu, 14 Jul 2011 09:37:48 -0500
Message-ID: <1310654268.2067.5.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2011-07-13 at 15:37 -0700, Allison Henderson wrote:
> On 07/13/2011 09:31 AM, Alex Elder wrote:
> > On Wed, 2011-06-29 at 22:24 -0700, Allison Henderson wrote:
> >> This patch adds a new test 255 that tests fallocate punch hole,
> >> but is for use by generic filesystems.  It is similar to 252,
> >> but uses a weaker fiemap filter that only displays the location
> >> of the hole, and not the extent types.
> >>
> >> Signed-off-by: Allison Henderson<achender@linux.vnet.ibm.com>
> >
> > I realize Christoph already committed this but I
> > spotted something so I thought I might as well
> > mention it.  I haven't tested any of this, so
> > it may be OK after all, but if it's not then
> > the filter_hole_fiemap() function ought to be
> > updated.
> >
> > 					-Alex
> >
> > . . .
> >
> >> diff --git a/common.punch b/common.punch
> >> index c18f88a..a48b7ae 100644
> >> --- a/common.punch
> >> +++ b/common.punch
> >> @@ -218,6 +218,23 @@ _filter_fiemap()
> >>   	_coalesce_extents
> >>   }
> >>
> >> +# Filters fiemap output to only print the
> >> +# file offset column and whether or not
> >> +# it is an extent or a hole
> >> +_filter_hole_fiemap()
> >> +{
> >> +	awk --posix '
> >> +		$3 ~ /hole/ {
> >> +			print $1, $2, $3;
> >> +			next;
> >> +		}
> >> +		$5 ~ /0x[[:digit:]]+/ {
> >
> > I believe this should be:
> >                   $5 ~ /0x[[:xdigit:]]+/ {
> >
> > (I.e., hex digits, not just decimals.)
> >
> 
> Hi Alex,
> 
> I think you are right.  The extent flags are printed in hex, so it 
> should be xdigit.  The existing _filter_fiemap routine that I modeled 
> this code from is also only parsing decimal digits.  Even though the 
> tests are not showing any problems right now, it should probably be 
> fixed.  Should I submit a patch to correct it?


Please, yes--to fix both.  And please verify the problem
while you're at it if possible.  Thank you.

					-Alex

> Allison Henderson
> 
> >> +			print $1, $2, "extent";
> >> +		}' |
> >> +	_coalesce_extents
> >> +}
> >> +
> >> +
> >>   # Prints the md5 checksum of a given file
> >>   _md5_checksum()
> >>   {
> >
> > . . .
> >
> 



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
