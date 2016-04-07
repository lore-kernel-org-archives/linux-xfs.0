Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 250A77CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 22:37:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ECB4B304032
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 20:37:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wM0zrVdTExDaIahH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 20:37:15 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id CE51281F03
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 03:37:14 +0000 (UTC)
Date: Thu, 7 Apr 2016 11:37:13 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: Re: [PATCH] xfs_quota: print quota id number if the name can't be
	found
Message-ID: <20160407033713.GA2947@dhcp12-237.nay.redhat.com>
References: <1459964353-25151-1-git-send-email-zlang@redhat.com>
	<570556AE.7080306@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <570556AE.7080306@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 01:34:22PM -0500, Eric Sandeen wrote:
> On 4/6/16 12:39 PM, Zorro Lang wrote:
> > When use GETNEXTQUOTA ioctl to report project quota, it always
> > report an unexpected quota:
> > 
> >   (null) 0 0 0 00 [--------]
> > 
> > The ID 0 store the default quota, even if no one set default quota,
> > it still have quota accounting, but not enforced. So GETNEXTQUOTA
> > can find and report this undefined quota.
> > 
> > From this problem, I thought if others' quota name miss, (null) will
> > be printed too. e.g.
> > 
> >   # xfs_quota -xc "limit -u bsoft=300m bhard=400m test" $mnt
> >   # xfs_quota -xc "report -u" $mnt
> >   User ID          Used       Soft       Hard    Warn/Grace
> >   ---------- --------------------------------------------------
> >   root                0          0          0     00 [--------]
> >   test                0     307200     409600     00 [--------]
> >   # userdel -r test
> >   # xfs_quota -xc "report -u" $mnt
> >   User ID          Used       Soft       Hard    Warn/Grace
> >   ---------- --------------------------------------------------
> >   root                0          0          0     00 [--------]
> >   (null)              0     307200     409600     00 [--------]
> > 
> > So this problem same with above id 0's problem. For deal with this,
> > this patch will print id number if the name can't be found.
> > 
> > But if use old GETQUOTA ioctl, it won't print project id 0 quota
> > information(if it's not defined). That's different with GETNEXTQUOTA.
> > For keep consistent, this patch also print project id 0 when use old
> > GETQUOTA.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks, I think this makes sense; so this solves 2 problems.
> 
> 1) always print the id # if there is no name mapping during quota report, and
> 2) always print default project quota information, even if no PRID 0 in in the projects map.
> 
> UID & GID always (?) have an ID 0 defined (if the system has no root user or group,
> something is very odd, but it is normal to have no PRID 0 defined)
> 
> other comments below.
> 
> > ---
> > 
> > Hi,
> > 
> > This's a problem from GETNEXTQUOTA feature. The original disscussion
> > is as below:
> > 
> > http://thread.gmane.org/gmane.comp.file-systems.fstests/1852/focus=1968
> > 
> > Then Eryu send a patch to xfstests, try to fix the test failure bring
> > by this bug. The disscussion is as below:
> > 
> > http://oss.sgi.com/archives/xfs/2016-04/msg00002.html
> > 
> > Finally we decided to fix this problem in xfsprogs. After talked with
> > Eric Sandeen, I wrote this patch. At first, Eric thought we shouldn't
> > print project id 0 quota information, if no one set limit for it.
> > 
> > Then he change his mind to always print "root" as project id 0's name,
> > if no one define a name for it. But there's another problem, if we
> > print "root" for project id 0, but we can't run:
> > 
> >   xfs_quota -xc "limit -p xxx xxx root" $mnt
> > 
> > Because the "root" is a fake name. Then I suggest to print id number,
> > if the name can't be found. This method not only used for project id
> > 0, it used for all user/group/project IDs which no name defined.
> > 
> > So this patch should be the V3 patch. We can't sure which one is the
> > best idea. If anyone have better idea, please tell me.
> > 
> > Thanks,
> > Zorro
> > 
> >  quota/report.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/quota/report.c b/quota/report.c
> > index 48a3f29..557d667 100644
> > --- a/quota/report.c
> > +++ b/quota/report.c
> > @@ -389,7 +389,10 @@ report_mount(
> >  					name = p->pr_name;
> >  			}
> >  		}
> > -		fprintf(fp, "%-10s", name);
> 
> Could use a comment:
> 
> +		/* If no name is found, print the id # instead of (null) */
> 
> > +		if (name != NULL)
> > +			fprintf(fp, "%-10s", name);
> > +		else
> > +			fprintf(fp, "#%-10u", d.d_id);

There's one more problem. When we print id number we print #%-10u, but
for name we print %-10s. There's one more "#" be printed for number.
So if we print name and number both, the output will like this:

User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root           512000          0          0     00 [--------]
#1000                0     307200     409600     00 [--------]

You can find the line of #1000 is not align at the line of "root".
Because the name print 10 characters, but the number print 10
characters + #.

Should we fix this problem?
If fix it, should we make name print %-11s, or make number print
#%-9u?

Thanks,
Zorro

> >  	}
> >  
> >  	if (form & XFS_BLOCK_QUOTA) {
> > @@ -571,6 +574,12 @@ report_project_mount(
> >  			id = oid + 1;
> >  		}
> >  	} else {
> 
> Comment:
> 
> +		/* Print default project quota even if PRID 0 isn't defined */
> 
> > +		if (!getprprid(0)) {
> > +			report_mount(fp, 0, "#0", NULL, form, XFS_PROJ_QUOTA,
> 
> If you pass in NULL instead of "#0" does report_mount do the right thing?
> If so, better to not hard-code "#0" here.
> 
> -Eric
> 
> > +			             mount, flags);
> > +			flags |= NO_HEADER_FLAG;
> > +		}
> > +
> >  		setprent();
> >  		while ((p = getprent()) != NULL) {
> >  			if (report_mount(fp, p->pr_prid, p->pr_name, NULL,
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
