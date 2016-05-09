Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 92E7A7CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 09:55:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1811DAC004
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 07:55:29 -0700 (PDT)
Received: from mga01.intel.com ([192.55.52.88]) by cuda.sgi.com with ESMTP id
	YPeDBtVo2iHJHXxd for <xfs@oss.sgi.com>;
	Mon, 09 May 2016 07:55:29 -0700 (PDT)
Date: Mon, 9 May 2016 08:55:27 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v5 3/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
Message-ID: <20160509145527.GA31079@linux.intel.com>
References: <1462571591-3361-1-git-send-email-vishal.l.verma@intel.com>
	<1462571591-3361-4-git-send-email-vishal.l.verma@intel.com>
	<20160508085203.GA10160@infradead.org>
	<1462733173.3006.7.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1462733173.3006.7.camel@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "boaz@plexistor.com" <boaz@plexistor.com>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>

On Sun, May 08, 2016 at 06:46:13PM +0000, Verma, Vishal L wrote:
> On Sun, 2016-05-08 at 01:52 -0700, Christoph Hellwig wrote:
> > On Fri, May 06, 2016 at 03:53:09PM -0600, Vishal Verma wrote:
> > > =

> > > From: Matthew Wilcox <matthew.r.wilcox@intel.com>
> > > =

> > > dax_clear_sectors() cannot handle poisoned blocks.=A0=A0These must be
> > > zeroed using the BIO interface instead.=A0=A0Convert ext2 and XFS to
> > > use
> > > only sb_issue_zerout().
> > > =

> > > Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
> > > [vishal: Also remove the dax_clear_sectors function entirely]
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > Just to make sure:=A0=A0the existing sb_issue_zerout as in 4.6-rc
> > is already doing the right thing for DAX?=A0=A0I've got a pending
> > patchset
> > for XFS that introduces another dax_clear_sectors users, but if it's
> > already safe to use blkdev_issue_zeroout I can switch to that and
> > avoid
> > the merge conflict.
> =

> I believe so - Jan has moved all unwritten extent conversions out of
> DAX with his patch set, and I believe zeroing through the driver is
> always fine. Ross or Jan could confirm though.=A0

Yep, I believe that the existing sb_issue_zeroout() as of v4.6-rc* does the
right thing.  We'll end up calling sb_issue_zeroout() =3D> blkdev_issue_zer=
oout()
=3D> __blkdev_issue_zeroout() because we don't have support for discard or
write_same in PMEM.  This will send zero page BIOs to the PMEM driver, which
will do the zeroing as normal writes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
