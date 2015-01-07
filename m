Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A1BD57F88
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 04:30:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EBD68F8035
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 02:30:29 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id Hr8yEuZmHOndDD7t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 02:30:28 -0800 (PST)
Date: Wed, 7 Jan 2015 11:30:26 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/18] fs: add FL_LAYOUT lease type
Message-ID: <20150107103026.GB28783@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-3-git-send-email-hch@lst.de>
	<20150106104652.49078615@synchrony.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106104652.49078615@synchrony.poochiereds.net>
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
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 10:46:52AM -0800, Jeff Layton wrote:
> So with the current code, layouts are always whole-file?

layouts aren't whole-file, but layout recalls are.

> Tracking layouts as a lease-like object seems reasonable, but I'm not
> 100% thrilled with overloading all of the lease code with this. Perhaps
> it should be its own sort of object with a separate API to manage them?
> That would also make it easier to support layouts that are not for the
> entire file.
> 
> To that end, it might be nice to hold off on taking this until we
> deprecate the i_flock list as we can then give layouts their own
> list_head in the file_lock_context. It would also make it easier to use
> a new sort of object to represent layouts.
> 
> I just cleaned up that patchset last week, and will re-post it soon
> once I give it a bit of testing this week.

I'm happy to add support to your reworked locks/leases/etc handling
for this.  As for which one gets merged first I'd say which one
is in a mergeable shape earlier.  If you're confident to get your
rework in ASAP I'm happy to rebase it on top, otherwise doing it
the other way around sounds easier.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
