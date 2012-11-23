Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAN7LplR040542 for <xfs@oss.sgi.com>; Fri, 23 Nov 2012 01:21:51 -0600
Received: from mailout-de.gmx.net (mailout-de.gmx.net [213.165.64.22]) by
	cuda.sgi.com with SMTP id AHoBAiLGIugqqVj4 for
	<xfs@oss.sgi.com>; Thu, 22 Nov 2012 23:24:02 -0800 (PST)
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH] xfs: fix attr tree double split corruption
Date: Fri, 23 Nov 2012 08:32:44 +0100
References: <1353625175-29479-1-git-send-email-peterhuewe@gmx.de>
	<20121123004937.GC18889@devil.redhat.com>
In-Reply-To: <20121123004937.GC18889@devil.redhat.com>
MIME-Version: 1.0
Message-Id: <201211230832.44881.PeterHuewe@gmx.de>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: Ben Myers <bpm@sgi.com>, stable@vger.kernel.org, xfs@oss.sgi.com

Hi David,

thanks for your response!
Am Freitag, 23. November 2012, 01:49:37 schrieb Dave Chinner:
> [added xfs@oss.sgi.com]
> 
> On Thu, Nov 22, 2012 at 11:59:35PM +0100, Peter Huewe wrote:
> 
> Hi Peter,
> 
> While I appreciate what you are doing here, can you please send
> stable backport patches to the xfs@oss.sgi.com list for review
> before sending them to stable@vger.kernel.org? There may already be
> someone doing this work, and we want to make sure that backports are
> correct, tested and worth the risk of fixing before asking the
> (already overworked) stable kernel maintainers to include it.

Yeah you're right, especially with fs changes we should be more cautious, 
sorry about the noise then.

I'm one of the few people who offered Greg KH a hand after his 'help wanted' 
message/blog post and one of the 'todos' was to look through git-commits@ and 
pick those who look worth of including into stable.

I was probably a bit too eager here, and skimming from top to bottom of git-
commits might also not have been a really good idea either ;)



> As such, how did you test that the fix works on the stable kernels
> you are targetting? AFAIK, I'm the only person who has the
> filesystem images that reproducably triggered this corruption
> problem....

I was mainly looking at:
- does it apply cleanly
- does it still boot
- basic functional test
- short review of the affected code after applying the patch i.e. does it still 
look okay/as intended?

 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > 
> > Cc: <stable@vger.kernel.org> # 3.6.x
> > Cc: <stable@vger.kernel.org> # 3.4.x
> > Cc: <stable@vger.kernel.org> # 3.2.x
> 
> If we are pushing this fix back to stable kernels, then it
> should go back to 3.0.x as well.

3.0.x failed my first test (does it apply cleanly?) so I left it out, as a 
dedicated backport is needed.


Thanks
PeterH



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
