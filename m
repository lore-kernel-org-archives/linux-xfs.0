Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 306227CA3
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 16:09:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 031FB304039
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 14:09:21 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id AtFBa2NfWYupsxhd (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 14:09:16 -0800 (PST)
Date: Tue, 26 Jan 2016 14:09:12 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/5] xfs_io: detect the '-R' option in getopt
Message-ID: <20160126220912.GB5852@birch.djwong.org>
References: <20160123003502.2475.99558.stgit@birch.djwong.org>
	<56A307D8.60202@sandeen.net>
	<20160123061811.GC5500@birch.djwong.org>
	<56A3C054.4000804@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A3C054.4000804@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sat, Jan 23, 2016 at 12:03:00PM -0600, Eric Sandeen wrote:
> 
> 
> On 1/23/16 12:18 AM, Darrick J. Wong wrote:
> > On Fri, Jan 22, 2016 at 10:55:52PM -0600, Eric Sandeen wrote:
> >> On 1/22/16 6:35 PM, Darrick J. Wong wrote:
> >>> Configure getopt to accept the -R argument to pwrite.
> >>
> >> Did you have anything against "F" and "B"? :)
> >>
> >> (They're missing too but in the case statements & help)
> > 
> > No, but I /was/ wondering if the omission was deliberate?
> 
> I don't think so; the commit that added it (8fb2237)
> seemed to do everything but add the getopt chars.
> 
> Oh, and however much gets fixed up, probably needs a man page
> update too.

The manpage already has -F/-B/-R, but you're right that I should add
-F and -B to getopt.

--D

> 
> Thanks,
> -Eric
> 
> > --D
> > 
> >>
> >> -Eric
> >>
> >>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >>> ---
> >>>  io/pwrite.c |    2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>>
> >>> diff --git a/io/pwrite.c b/io/pwrite.c
> >>> index fd9114d..c6efee9 100644
> >>> --- a/io/pwrite.c
> >>> +++ b/io/pwrite.c
> >>> @@ -259,7 +259,7 @@ pwrite_f(
> >>>  	init_cvtnum(&fsblocksize, &fssectsize);
> >>>  	bsize = fsblocksize;
> >>>  
> >>> -	while ((c = getopt(argc, argv, "b:Cdf:i:qs:S:uV:wWZ:")) != EOF) {
> >>> +	while ((c = getopt(argc, argv, "b:Cdf:i:qRs:S:uV:wWZ:")) != EOF) {
> >>>  		switch (c) {
> >>>  		case 'b':
> >>>  			tmp = cvtnum(fsblocksize, fssectsize, optarg);
> >>>
> >>> _______________________________________________
> >>> xfs mailing list
> >>> xfs@oss.sgi.com
> >>> http://oss.sgi.com/mailman/listinfo/xfs
> >>>
> >>
> >> _______________________________________________
> >> xfs mailing list
> >> xfs@oss.sgi.com
> >> http://oss.sgi.com/mailman/listinfo/xfs
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
