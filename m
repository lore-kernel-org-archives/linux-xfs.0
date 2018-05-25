Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49456 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753116AbeEYDi5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 24 May 2018 23:38:57 -0400
Date: Fri, 25 May 2018 05:38:55 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v3 2/4] mkfs: move shared config structs and into their
 own headers
Message-ID: <20180525033855.GK4511@wotan.suse.de>
References: <20180525031943.29440-1-mcgrof@kernel.org>
 <20180525031943.29440-3-mcgrof@kernel.org>
 <20180525033548.GQ14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525033548.GQ14384@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, sandeen@sandeen.net, linux-xfs@vger.kernel.org, jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, jtulak@redhat.com

On Thu, May 24, 2018 at 08:35:48PM -0700, Darrick J. Wong wrote:
> On Thu, May 24, 2018 at 08:19:41PM -0700, Luis R. Rodriguez wrote:
> > diff --git a/mkfs/config.h b/mkfs/config.h
> > new file mode 100644
> > index 000000000000..e5ea968e2d65
> > --- /dev/null
> > +++ b/mkfs/config.h
> > +struct mkfs_default_params {
> > +	char	*source;	/* where the defaults came from */
> > +
> > +	int	sectorsize;
> > +	int	blocksize;
> 
> Indentation ^^^ is uneven with the rest of the struct, but otherwise:

Bug-compatible :P -- ie it was in the old code IIRC, as all I did was
copy and paste on my editor between the two.

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

  Luis
