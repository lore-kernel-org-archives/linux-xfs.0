Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5C6907CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 19:16:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6080AC001
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 17:16:45 -0700 (PDT)
Received: from mail-oi0-f44.google.com (mail-oi0-f44.google.com
	[209.85.218.44]) by cuda.sgi.com with ESMTP id Jbn6NGv0KIS1OZdT
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2016 17:16:43 -0700 (PDT)
Received: by mail-oi0-f44.google.com with SMTP id q188so92890838oia.3
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 17:16:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160915230748.GS30497@dastard>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
	<147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160915082615.GA9772@lst.de>
	<CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
	<20160915230748.GS30497@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Sep 2016 17:16:42 -0700
Message-ID: <CAPcyv4jvcWEc2TkRh6-MoKb_-1VbFoiKUJEB=svQO+BVN8s-Sg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm, dax: add VM_DAX flag for DAX VMAs
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
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 15, 2016 at 4:07 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Sep 15, 2016 at 10:01:03AM -0700, Dan Williams wrote:
>> On Thu, Sep 15, 2016 at 1:26 AM, Christoph Hellwig <hch@lst.de> wrote:
>> > On Wed, Sep 14, 2016 at 11:54:38PM -0700, Dan Williams wrote:
>> >> The DAX property, page cache bypass, of a VMA is only detectable via the
>> >> vma_is_dax() helper to check the S_DAX inode flag.  However, this is
>> >> only available internal to the kernel and is a property that userspace
>> >> applications would like to interrogate.
>> >
>> > They have absolutely no business knowing such an implementation detail.
>>
>> Hasn't that train already left the station with FS_XFLAG_DAX?
>
> No, that's an admin flag, not a runtime hint for applications. Just
> because that flag is set on an inode, it does not mean that DAX is
> actually in use - it will be ignored if the backing dev is not dax
> capable.
>

What's the point of an admin flag if an admin can't do cat /proc/<pid
of interest>/smaps, or some other mechanism, to validate that the
setting the admin cares about is in effect?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
