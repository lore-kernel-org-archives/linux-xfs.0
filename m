Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHQfFg098656 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:26:41 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	e0STUCKUoDlKUC9U (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:26:40 -0800 (PST)
Date: Fri, 17 Feb 2012 12:26:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_fsr: Get the last mount on a specific mount point
Message-ID: <20120217172639.GA21796@infradead.org>
References: <1328640076-12645-1-git-send-email-cmaiolino@redhat.com>
	<20120213174240.GA3474@infradead.org>
	<20120215123143.GA22051@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215123143.GA22051@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Feb 15, 2012 at 10:31:43AM -0200, Carlos Maiolino wrote:
> I would change a little this sentence, looks a little confusing at least for me.
> How about:
> 
> 		/* If we found an entry based on the device name, make sure we
> 		 * stat the mount point given by mtab and ensure it's accessible
> 		 * before using it.
> 		 */

Agreed, I'll redo it.

> > +			if (S_ISLNK(sb.st_mode)) {
> > +				struct stat64 sb2;
> 
> Particularly, I don't like variable declarations between statements, but I'm not
> too experienced to say what's good or not :)

The idea is to keep variable declarations as local as possible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
