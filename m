Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 573B07F56
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 18:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34BD4304032
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 16:13:42 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OSVhsUzMmAXxxyjD (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 16:13:40 -0700 (PDT)
Date: Tue, 26 May 2015 16:13:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs_db: enable blockget for v5 filesystems
Message-ID: <20150526231335.GC31848@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225153.26434.96347.stgit@birch.djwong.org>
	<5564FCB4.6070603@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5564FCB4.6070603@sandeen.net>
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

On Tue, May 26, 2015 at 06:07:32PM -0500, Eric Sandeen wrote:
> On 5/26/15 5:51 PM, Darrick J. Wong wrote:
> > Plumb in the necessary magic number checks and other fixups required
> > to handle v5 filesystems.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> > @@ -799,8 +803,6 @@ blockget_f(
> >  	 * filters out, or we need to actually do the work to make check support
> >  	 * crc enabled filesystems.
> >  	 */
> > -	if (xfs_sb_version_hascrc(&mp->m_sb))
> > -		return 0;
> 
> Hm, the comment above these lines says:
> 
>         /*
>          * XXX: check does not support CRC enabled filesystems. Return
>          * immediately, silently, with success but  without doing anything here
>          * initially so that xfstests can run without modification on metadata
>          * enabled filesystems.
>          *
>          * XXX: ultimately we need to dump an error message here that xfstests
>          * filters out, or we need to actually do the work to make check support
>          * crc enabled filesystems.
>          */
> 
> but now we don't.  So I guess the comment should go too?
> 
> I guess check is deprecated now, so the comment is stale anyway...

Doh.  Forgot to remove that.  Will resend.

--D

>   
> -Eric
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
