Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF28A7CA0
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 16:42:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 719D0AC002
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 14:42:40 -0700 (PDT)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	7PeU5TJUbVNnigod (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 25 Mar 2016 14:42:38 -0700 (PDT)
Received: by mail-ob0-f181.google.com with SMTP id fp4so65090164obb.2
	for <xfs@oss.sgi.com>; Fri, 25 Mar 2016 14:42:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458939566.5501.5.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-6-git-send-email-vishal.l.verma@intel.com>
	<20160325104549.GB10525@infradead.org>
	<1458939566.5501.5.camel@intel.com>
Date: Fri, 25 Mar 2016 14:42:37 -0700
Message-ID: <CAPcyv4jFPYYP=eL72V6MmW2fcXFP3PfQfcO+zYV4NN7rdu1ksg@mail.gmail.com>
Subject: Re: [PATCH 5/5] dax: handle media errors in dax_do_io
From: Dan Williams <dan.j.williams@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Fri, Mar 25, 2016 at 1:59 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Fri, 2016-03-25 at 03:45 -0700, Christoph Hellwig wrote:
>> On Thu, Mar 24, 2016 at 05:17:30PM -0600, Vishal Verma wrote:
>> >
>> > dax_do_io (called for read() or write() for a dax file system) may
>> > fail
>> > in the presence of bad blocks or media errors. Since we expect that
>> > a
>> > write should clear media errors on nvdimms, make dax_do_io fall
>> > back to
>> > the direct_IO path, which will send down a bio to the driver, which
>> > can
>> > then attempt to clear the error.
>> Leave the fallback on -EIO to the callers please.  They generally
>> call
>> __blockdev_direct_IO anyway, so it should actually become simpler
>> that
>> way.
>
> I thought of this, but made the retrying happen in the wrapper so that
> it can be centralized. If the callers were to become responsible for
> the retry, then any new callers of dax_do_io might not realize they are
> responsible for retrying, and hit problems.

That's their prerogative otherwise you are precluding an alternate
handling of a dax_do_io() failure.  Maybe a fs or upper layer can
recover in a different manner than re-submit the I/O to the
__blockdev_direct_IO path.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
