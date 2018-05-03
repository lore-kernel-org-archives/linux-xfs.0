Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:41130 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751074AbeECVgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 May 2018 17:36:00 -0400
Date: Thu, 3 May 2018 14:35:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/9] libfrog: refactor fs geometry printing function
Message-ID: <20180503213539.GA26569@magnolia>
References: <152401952391.13048.15040850425873030425.stgit@magnolia>
 <152401953658.13048.467837665188564402.stgit@magnolia>
 <557aeadb-c8ea-1b63-9acd-71157e10c91c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <557aeadb-c8ea-1b63-9acd-71157e10c91c@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, May 03, 2018 at 04:27:28PM -0500, Eric Sandeen wrote:
> On 4/17/18 9:45 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the fs geometry printing function to libfrog so that mkfs and others
> > can share.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> 
> > +	printf(_(
> > +"meta-data=%-22s isize=%-6d agcount=%u, agsize=%u blks\n"
> > +"         =%-22s sectsz=%-5u attr=%u, projid32bit=%u\n"
> > +"         =%-22s crc=%-8u finobt=%u, sparse=%u, rmapbt=%u\n"
> > +"         =%-22s reflink=%u\n"
> > +"data     =%-22s bsize=%-6u blocks=%llu, imaxpct=%u\n"
> > +"         =%-22s sunit=%-6u swidth=%u blks\n"
> > +"naming   =version %-14u bsize=%-6u ascii-ci=%d, ftype=%d\n"
> > +"log      =%-22s bsize=%-6d blocks=%u, version=%d\n"
> > +"         =%-22s sectsz=%-5u sunit=%d blks, lazy-count=%d\n"
> > +"realtime =%-22s extsz=%-6d blocks=%lld, rtextents=%lld\n"),
> 
> Actually, I'd like to put a whitespace break here as there was in old code,
> as this is a giant, dense blob of code that's pretty hard to grok visually.
> 
> Any objection? :)

None here.

--D

> -Eric
> 
> > +		mntpoint, geo->inodesize, geo->agcount, geo->agblocks,
> > +		"", geo->sectsize, attrversion, projid32bit,
> > +		"", crcs_enabled, finobt_enabled, spinodes, rmapbt_enabled,
> > +		"", reflink_enabled,
> > +		"", geo->blocksize, (unsigned long long)geo->datablocks,
> > +			geo->imaxpct,
> > +		"", geo->sunit, geo->swidth,
> > +		dirversion, geo->dirblocksize, cimode, ftype_enabled,
> > +		isint ? _("internal log") : logname ? logname : _("external"),
> > +			geo->blocksize, geo->logblocks, logversion,
> > +		"", geo->logsectsize, geo->logsunit / geo->blocksize, lazycount,
> > +		!geo->rtblocks ? _("none") : rtname ? rtname : _("external"),
> > +		geo->rtextsize * geo->blocksize, (unsigned long long)geo->rtblocks,
> > +			(unsigned long long)geo->rtextents);
> > +}
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
