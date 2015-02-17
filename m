Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 542807F63
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 19:43:57 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 419C58F8039
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 17:43:57 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id E9RCUEudKSKIs0W5 (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 17:43:55 -0800 (PST)
Received: from epcpsbgr3.samsung.com
	(u143.gpu120.samsung.co.kr [203.254.230.143])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NJW00MZ57H4YCC0@mailout1.samsung.com> for
	xfs@oss.sgi.com; Tue, 17 Feb 2015 10:43:52 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
	<1424101680-3301-12-git-send-email-linkinjeon@gmail.com>
	<20150217010033.GG4251@dastard>
In-reply-to: <20150217010033.GG4251@dastard>
Subject: RE: [PATCH RESEND 11/12] xfstests: fsx: Add fallocate insert range
	operation
Date: Tue, 17 Feb 2015 10:43:52 +0900
Message-id: <001101d04a53$2ed730a0$8c8591e0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: 'Dave Chinner' <david@fromorbit.com>, 'Namjae Jeon' <linkinjeon@gmail.com>
Cc: linux-man@vger.kernel.org, tytso@mit.edu, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

> 
> On Tue, Feb 17, 2015 at 12:47:58AM +0900, Namjae Jeon wrote:
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> >
> > This commit adds fallocate FALLOC_FL_INSERT_RANGE support for fsx.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > Reviewed-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  ltp/fsx.c |  124 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 114 insertions(+), 10 deletions(-)
> .....
> > @@ -339,6 +341,14 @@ logdump(void)
> >  						     lp->args[0] + lp->args[1])
> >  				prt("\t******CCCC");
> >  			break;
> > +		case OP_INSERT_RANGE:
> > +			prt("INSERT 0x%x thru 0x%x\t(0x%x bytes)",
> > +			    lp->args[0], lp->args[0] + lp->args[1] - 1,
> > +			    lp->args[1]);
> > +			if (badoff >= lp->args[0] && badoff <
> > +						     lp->args[0] + lp->args[1])
> > +				prt("\t******CCCC");
> 
Hi Dave,
> Probably should output "*****IIII" so we can distinguish it from
> collapse operations easily.
Right. I will change it.
> 
> > @@ -1307,6 +1403,9 @@ usage(void)
> >  #ifdef FALLOC_FL_COLLAPSE_RANGE
> >  "	-C: Do not use collapse range calls\n"
> >  #endif
> > +#ifdef FALLOC_FL_INSERT_RANGE
> > +"	-i: Do not use insert range calls\n"
> > +#endif
> 
> I'd make that "-I" rather than "-i" so it matches with the "-C" of
> collapse range.
Okay.

Thanks for your review!
> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
