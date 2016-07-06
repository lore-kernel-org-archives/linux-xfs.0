Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 181647D0B
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 07:43:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 640FAAC005
	for <xfs@oss.sgi.com>; Wed,  6 Jul 2016 05:43:28 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id zVQS0431nrqmQH75 for <xfs@oss.sgi.com>;
	Wed, 06 Jul 2016 05:43:27 -0700 (PDT)
Date: Wed, 6 Jul 2016 08:43:26 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] nfsd: allow SCSI layout support without Block layout
Message-ID: <20160706124326.GA18856@fieldses.org>
References: <74871b1ce0d09b21fb67c1b2176695cc1c19169e.1467624319.git.bcodding@redhat.com>
	<20160706091953.GD12670@dastard>
	<73B22D64-6A0B-4B8B-8A4D-6AA7AC26F30D@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <73B22D64-6A0B-4B8B-8A4D-6AA7AC26F30D@redhat.com>
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
To: Benjamin Coddington <bcodding@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 06, 2016 at 05:58:09AM -0400, Benjamin Coddington wrote:
> On 6 Jul 2016, at 5:19, Dave Chinner wrote:
> 
> >On Tue, Jul 05, 2016 at 09:48:47PM -0400, Benjamin Coddington wrote:
> >>We shouldn't have to configure both NFSD_BLOCKLAYOUT and
> >>NFSD_SCSILAYOUT if
> >>all we want are SCSI layouts on the server, so define the xfs export
> >>operations for either configuration.
> >>
> >>Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
> >
> >I don't really like exploding config option dependencies into
> >subsystems that aren't actually related to the config options.
> >It's confusing enough laready that we've got XFS code dependent on
> >PNFSD config options without adding more to it. Instead, I'd
> >suggest this should be resolved in the kconfig files. i.e. make
> >CONFIG_NFSD_SCSILAYOUT=y select CONFIG_NFSD_BLOCKLAYOUT to resolve
> >the config dependency at config time.
> 
> But the point is to leave CONFIG_NFSD_BLOCKLAYOUT undefined
> otherwise knfsd
> will advertise block layouts to clients -- which we don't want.
> 
> Would a third define specific for xfs_export_operations that gets
> set in kconfig files work for you?  Something like XFS_PNFS_EXPORT_OPS.

That makes sense to me....

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
