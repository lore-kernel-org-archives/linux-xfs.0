Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q85N49mV153315 for <xfs@oss.sgi.com>; Wed, 5 Sep 2012 18:04:09 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	dZxix6Ba6SmEWQ6G for <xfs@oss.sgi.com>;
	Wed, 05 Sep 2012 16:05:07 -0700 (PDT)
Date: Thu, 6 Sep 2012 09:04:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/18] xfstests: convert tests to use new results directory
Message-ID: <20120905230431.GK15292@dastard>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
	<1343294892-20991-18-git-send-email-david@fromorbit.com>
	<1346846436.1129.20.camel@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1346846436.1129.20.camel@localhost>
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
To: Boris Ranto <branto@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Sep 05, 2012 at 02:00:35PM +0200, Boris Ranto wrote:
> On Thu, 2012-07-26 at 19:28 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Essentially the change is simply this. Converting:
> > 
> > ... >> $seq.????
> > 
> > to:
> > 
> > .... >> $RESULT_DIR/$seq.????
> > 
> > so that output files are directed to the defined output directory.
> > 
> > sed to the rescue:
> > 
> > $ sed -i -e '/^seq=.*$/a seqres=$RESULT_DIR/$seq' -e 's/seq.full/seqres.full/' tests/*/*
> > 
> > will do most of the work automatically.
.....
> Quite a lot of tests use $here/$seq.full. This results in
> $here/$seqres.full after the sed. $seqres is just a $RESULT_DIR/$seq.
> This would break if RESULT_DIR was set to an absolute path instead of
> relative path.

Yes. As the patch description says it "will do most of the work",
but it doesn't do all of it. Indeed, supporting full paths for
$RESULT_DIR is actually necessary for other reasons, such as
supporting completely external result destinations. To that end, I
have a patch in my current series that does the rest of the
conversion with the appropriate setup changes:

commit 08dbbb1e6a82a4ed04e0622b7ee63957fae7721b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 22 16:09:33 2012 +1000

    xfstests: RESULTS_DIR needs to be an absolute path
    
    
    Some tests 'cd <somedir>' and then direct output to $RESULT_DIR,
    which fails if the current working directory is not $here.
    Regardless, if an external results directory is to be used it needs
    to have a full path specified and the use of $here as the base of
    the results files is completely incorrect.
    
    Hence change all the $here/$seqres* references to simply be
    $seqres*, and instead encode the full path to the results in
    $RESULT_DIR.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
