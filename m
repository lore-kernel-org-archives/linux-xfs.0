Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50200 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdLARED (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Dec 2017 12:04:03 -0500
Date: Fri, 1 Dec 2017 09:03:58 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 4/5] xfs_io: provide an interface to the scrub ioctls
Message-ID: <20171201170358.GR21412@magnolia>
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094862514.27182.4461761345656503324.stgit@magnolia>
 <f35234f7-32ef-9df5-b3c0-4f5d7f671191@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f35234f7-32ef-9df5-b3c0-4f5d7f671191@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Fri, Dec 01, 2017 at 10:06:51AM -0600, Eric Sandeen wrote:
> 
> 
> On 11/17/17 1:57 PM, Darrick J. Wong wrote:
> > +/* Type info and names for the scrub types. */
> > +enum scrub_type {
> > +	ST_NONE,	/* disabled */
> > +	ST_PERAG,	/* per-AG metadata */
> > +	ST_FS,		/* per-FS metadata */
> > +	ST_INODE,	/* per-inode metadata */
> > +};
> 
> Actually, I'm a little confused by this, what is ST_NONE intended
> to be used for?
> 
> You have it for probe, but that sounds more like an ST_FS fs-wide
> action.

It means "things that aren't fs, ag, or inode metadata" which at this
point only encompasses the probe command.

--D

> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
