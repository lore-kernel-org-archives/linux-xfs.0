Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECFF07CB4
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 02:49:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF4178F8039
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 00:49:03 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id aHqB0nZA2lipOXSE (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 00:48:58 -0700 (PDT)
Date: Wed, 30 Mar 2016 09:49:26 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
Message-ID: <20160330074926.GC12776@quack.suse.cz>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
	<CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
	<1458939796.5501.8.camel@intel.com>
	<CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
	<1459195288.15523.3.camel@intel.com>
	<CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
	<1459277829.6412.3.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459277829.6412.3.camel@intel.com>
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
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Wilcox,
	Matthew R" <matthew.r.wilcox@intel.com>

On Tue 29-03-16 18:57:16, Verma, Vishal L wrote:
> On Mon, 2016-03-28 at 16:34 -0700, Dan Williams wrote:
> =

> <>
> =

> > Seems kind of sad to fail the fault due to a bad block when we were
> > going to zero it anyway, right?=A0=A0I'm not seeing a compelling reason=
 to
> > keep any zeroing in fs/dax.c.
> =

> Agreed - but how do we do this? clear_pmem needs to be able to clear an
> arbitrary number of bytes, but to go through the driver, we'd need to
> send down a bio? If only the driver had an rw_bytes like interface that
> could be used by anyone... :)

Actually, my patches for page fault locking remove zeroing from
dax_insert_mapping() and __dax_pmd_fault() - the zeroing now happens from
the filesystem only and the zeroing in those two functions is just a dead
code...

								Honza
-- =

Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
