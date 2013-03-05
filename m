Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5DC1C805A
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 13:31:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 429FE8F8071
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 11:31:49 -0800 (PST)
Received: from mail-qe0-f52.google.com (mail-qe0-f52.google.com
	[209.85.128.52]) by cuda.sgi.com with ESMTP id 9xuJ5HG0lVKFmkEZ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Mar 2013 11:31:48 -0800 (PST)
Received: by mail-qe0-f52.google.com with SMTP id s14so4496225qeb.39
	for <xfs@oss.sgi.com>; Tue, 05 Mar 2013 11:31:47 -0800 (PST)
Date: Tue, 5 Mar 2013 14:31:43 -0500
From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH V2] xfstests: don't remove trailing zeros from integers
Message-ID: <20130305193143.GA13545@wallace>
References: <20130301180158.GC6449@wallace> <20130301203026.GC23616@dastard>
	<5136458D.4070803@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5136458D.4070803@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Eric Whitney <enwlinux@gmail.com>

* Rich Johnston <rjohnston@sgi.com>:
> On 03/01/2013 02:30 PM, Dave Chinner wrote:
> >On Fri, Mar 01, 2013 at 01:01:58PM -0500, Eric Whitney wrote:
> >>_within_tolerance strips trailing zeros from the min and max range
> >>values it outputs.  This leads to damage if the min or max value is
> >>an integer containing trailing zeros rather than a real number with
> >>a fractional part containing trailing zeros. Xfstest 289 can exhibit
> >>this problem when its input is out of range.  Modify the code so it
> >>will only remove trailing zeros found after a decimal point, and
> >>remove decimal points not followed by digits.
> >>
> >>Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> >>---
> >>  common.filter |    7 +++++--
> >>  1 file changed, 5 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/common.filter b/common.filter
> >>index 9e4c90c..bfc800b 100644
> >>--- a/common.filter
> >>+++ b/common.filter
> >>@@ -106,8 +106,11 @@ EOF
> >>
> >>    # fix up min, max precision for output
> >>    # can vary for 5.3, 6.2
> >>-  _min=`echo $_min | sed -e 's/0*$//'` # get rid of trailling zeroes
> >>-  _max=`echo $_max | sed -e 's/0*$//'` # get rid of trailling zeroes
> >>+
> >>+  # remove any trailing zeroes from min, max if they have fractional parts
> >>+  # and then remove any decimal points not followed by digits
> >>+  _min=`echo $_min | sed -e '/\./s/0*$//' | sed -e 's/\.$//'`
> >>+  _max=`echo $_max | sed -e '/\./s/0*$//' | sed -e 's/\.$//'`
> 
> I like Dave's suggestion to change it to the following, what do you
> think Eric?

I just posted a V3 containing Dave's simplification.  I'd hoped there
would be something like that, and much appreciate the suggestion.

Thanks,
Eric


> 
> +  _min=`echo $_min | sed -e '/\./s/0*$//' -e 's/\.$//'` # get rid
> of trailing zeros
> +  _max=`echo $_max | sed -e '/\./s/0*$//' -e 's/\.$//'` # get rid
> of trailing zeros
> 
> Regards
> --Rich
> 
> >
> >You can do this with a single sed invocation via multiple
> >expressions:
> >
> >$ echo 200.00 | sed -e '/\./s/0*$//' -e 's/\.$//'
> >200
> >$
> >
> >Cheers,
> >
> >Dave.
> >
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
