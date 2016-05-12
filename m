Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 742CB7CA0
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 22:43:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A5ED8F804C
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 20:43:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T8fpvNKK29xEbf2b (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 20:43:09 -0700 (PDT)
Date: Thu, 12 May 2016 11:43:05 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs_quota: check report_mount return value
Message-ID: <20160512034305.GE17859@dhcp12-143.nay.redhat.com>
References: <1e8b9ace-2fa3-bc11-4487-19be60053ef9@sandeen.net>
	<20160512031500.GD17859@dhcp12-143.nay.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160512031500.GD17859@dhcp12-143.nay.redhat.com>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, May 12, 2016 at 11:15:00AM +0800, Zorro Lang wrote:
> On Wed, May 11, 2016 at 09:41:12PM -0500, Eric Sandeen wrote:
> > The new call to report_mount doesn't check the return value
> > like every other caller does...
> > 
> > Returning 1 means it printed something; if the terse flag
> > is used and there is no usage, nothing gets printed.
> > If we set the NO_HEADER_FLAG anyway, then we won't see
> > the header for subsequent entries as we expect.
> > 
> > For example, project ID 0 has no usage in this case:
> > 
> > # xfs_quota -x -c "report -a" /mnt/test
> > Project quota on /mnt/test (/dev/sdb1)
> >                                Blocks                     
> > Project ID       Used       Soft       Hard    Warn/Grace     
> > ---------- -------------------------------------------------- 
> > #0                  0          0          0     00 [--------]
> > project          2048          4          4     00 [--none--]
> > 
> > So using the terse flag results in no header when it prints
> > projects with usage:
> > 
> > # xfs_quota -x -c "report -t -a" /mnt/test
> > project          2048          4          4     00 [--none--]
> > 
> > With this fix it prints the header as expected:
> > 
> > # xfs_quota -x -c "report -t -a" /mnt/test
> > Project quota on /mnt/test (/dev/sdb1)
> >                                Blocks                     
> > Project ID       Used       Soft       Hard    Warn/Grace     
> > ---------- -------------------------------------------------- 
> > project          2048          4          4     00 [--none--]
> > 
> > 
> > Addresses-Coverity-Id: 1361552
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> > 
> > diff --git a/quota/report.c b/quota/report.c
> > index cc422d1..59290e1 100644
> > --- a/quota/report.c
> > +++ b/quota/report.c
> > @@ -580,9 +580,9 @@ report_project_mount(
> >  			 * Print default project quota, even if projid 0
> >  			 * isn't defined
> >  			 */
> > -			report_mount(fp, 0, NULL, NULL, form, XFS_PROJ_QUOTA,
> > -			             mount, flags);
> > -			flags |= NO_HEADER_FLAG;
> > +			if (report_mount(fp, 0, NULL, NULL,
> > +					form, XFS_PROJ_QUOTA, mount, flags))
> > +				flags |= NO_HEADER_FLAG;

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Wow, you're right! TERSE MODE will return 0 if no any quota
> limit:
>         if (flags & TERSE_FLAG) {
>                 count = 0;
>                 if ((form & XFS_BLOCK_QUOTA) && d.d_bcount)
>                         count++;
>                 if ((form & XFS_INODE_QUOTA) && d.d_icount)
>                         count++;
>                 if ((form & XFS_RTBLOCK_QUOTA) && d.d_rtbcount)
>                         count++;
>                 if (!count)
>                         return 0;
>         }
> 
> Thanks for fix my mistake. I can add TERSE report functional
> test into my xfs/106 patch(which you're reviewing). Then it
> can find bugs likes this ASAP.
> 
> Thanks,
> Zorro
> 
> >  		}
> >  
> >  		setprent();
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
