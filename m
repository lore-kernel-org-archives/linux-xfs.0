Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1A19829DF8
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 05:43:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 96219AC006
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 03:43:50 -0700 (PDT)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33]) by
	cuda.sgi.com with ESMTP id xwA9EpFHRGvqhaar (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Apr 2014 03:43:48 -0700 (PDT)
Received: from epcpsbgr4.samsung.com
	(u144.gpu120.samsung.co.kr [203.254.230.144])
	by mailout3.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N4U00ASHB4YAV00@mailout3.samsung.com> for
	xfs@oss.sgi.com; Wed, 30 Apr 2014 19:43:46 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
References: <004401cf645c$8f874710$ae95d530$@samsung.com>
	<alpine.LFD.2.00.1404301223160.2100@localhost.localdomain>
In-reply-to: <alpine.LFD.2.00.1404301223160.2100@localhost.localdomain>
Subject: RE: [PATCH] xfstests: fsstress: fix incorrect if condition check for
	collapse range mode
Date: Wed, 30 Apr 2014 19:43:45 +0900
Message-id: <004701cf6461$0fdab330$2f901990$@samsung.com>
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
To: =?iso-8859-2?Q?'Luk=E1=B9_Czerner'?= <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, 'Ashish Sangwan' <a.sangwan@samsung.com>, xfs@oss.sgi.com

> On Wed, 30 Apr 2014, Namjae Jeon wrote:
> 
> > Date: Wed, 30 Apr 2014 19:11:32 +0900
> > From: Namjae Jeon <namjae.jeon@samsung.com>
> > To: Dave Chinner <david@fromorbit.com>
> > Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
> >     Ashish Sangwan <a.sangwan@samsung.com>
> > Subject: [PATCH] xfstests: fsstress: fix incorrect if condition check for
> >     collapse range mode
> >
> > There is if condition to be block aligned for off and len of Collapse range.
> > But off and len for all fallocate opearion can be aligned by incorrect
> > if condition check.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  ltp/fsstress.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> > index 29fc250..ff9ed12 100644
> > --- a/ltp/fsstress.c
> > +++ b/ltp/fsstress.c
> > @@ -2230,7 +2230,7 @@ do_fallocate(int opno, long r, int mode)
> >  	 * Collapse range requires off and len to be block aligned, make it
> >  	 * more likely to be the case.
> >  	 */
> > -	if (FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
> > +	if (mode & FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
> >  		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
> >  	}
> 
> oops :). Thanks for fixing it. Even though it would be better to use
> parentheses
Hi Lukas.
Okay, I will send v2 patch.
Thanks for review!
> 
> +	if ((mode & FALLOC_FL_COLLAPSE_RANGE) && (opno % 2)) {
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
