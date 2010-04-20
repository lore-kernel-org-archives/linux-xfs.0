Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3K5Kg9F004961 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 00:20:43 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 093DC2D63D1
	for <xfs@oss.sgi.com>; Mon, 19 Apr 2010 22:22:41 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id pVKC0x1H7Y6zesq3 for
	<xfs@oss.sgi.com>; Mon, 19 Apr 2010 22:22:41 -0700 (PDT)
Date: Tue, 20 Apr 2010 13:20:28 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: [PATCH] xfsprogs: mkfs: make strict check on -ialign option
Message-ID: <20100420052028.GC2494@laptop.oracle.com>
References: <201004190942.o3J7aqh5003810@rcsinet13.oracle.com>
	<20100420034533.GB15130@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100420034533.GB15130@dastard>
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
Cc: xfs@oss.sgi.com, greg.marsden@oracle.com, joe.jin@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-20 13:45, Dave Chinner wrote:
> On Mon, Apr 19, 2010 at 05:41:36PM +0800, Wengang Wang wrote:
> > Though it's clearly said in mkfs.xfs man page that for -ialign option only 1 or
> > 0 are valid values, I would like to make a strict check on it in code.
> > 
> > If a user specified -ialign=y(but he meant -ialign=1 actually), mkfs treats "y"
> > as "0"(simply by atoi()) thus acts wrongly without complaint. I think we'd better
> > prevent that from happening, so I made the patch. The patch fails the operation
> > on values for -ialign option, like "yes", "no", "y", "n".
> > 
> > Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>
> > ---
> >  mkfs/xfs_mkfs.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 2d09e36..d7e9eb3 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -1180,14 +1180,17 @@ main(
> >  			p = optarg;
> >  			while (*p != '\0') {
> >  				char	*value;
> > +				int len;
> >  
> >  				switch (getsubopt(&p, (constpp)iopts, &value)) {
> >  				case I_ALIGN:
> >  					if (!value)
> >  						value = "1";
> > -					iaflag = atoi(value);
> > -					if (iaflag < 0 || iaflag > 1)
> > +					len = strlen(value);
> > +					if (len != 1 || value[0] < '0' ||
> > +					    value[0] > '1')
> >  						illegal(value, "i align");
> > +					iaflag = value[0] - '0';
> 
> Wouldn't this be better changing atoi() to strtol() and then checking
> errno along with the bounds?
Hi Dave,

I tested strtol() with some cases, result is like the following:

<str> -- <result> errno: <errno>

"12" -- 12 errno: 0
"yes" -- 0 errno: 0
"no" -- 0 errno: 0
"y" -- 0 errno: 0
"" -- 0 errno: 0
"0" -- 0 errno: 0
"1" -- 1 errno: 0

It can't tell the original string is "yes", "no", "y", "" or "0" for
returning zero with errno being "OK". That is not the result I want.

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
