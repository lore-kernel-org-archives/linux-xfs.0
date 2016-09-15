Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D72E7CA0
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 12:44:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1119AC001
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 10:44:56 -0700 (PDT)
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com
	[209.85.218.46]) by cuda.sgi.com with ESMTP id FlG29scpGfh05nrZ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Sep 2016 10:44:55 -0700 (PDT)
Received: by mail-oi0-f46.google.com with SMTP id q188so80400180oia.3
	for <xfs@oss.sgi.com>; Thu, 15 Sep 2016 10:44:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160915170942.GJ9314@birch.djwong.org>
References: <147392246509.9873.17750323049785100997.stgit@dwillia2-desk3.amr.corp.intel.com>
	<147392247875.9873.4205533916442000884.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160915082615.GA9772@lst.de>
	<CAPcyv4jTw3cXpmmJRh7t16Xy2uYofDe+fJ+X_jnz+Q=o0uGneg@mail.gmail.com>
	<20160915170942.GJ9314@birch.djwong.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Sep 2016 10:44:53 -0700
Message-ID: <CAPcyv4h4f468Dt3Uv2YJO18TD2rN=s+xJRWK4QvOvxANSkdesA@mail.gmail.com>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nicholas Piggin <npiggin@gmail.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Thu, Sep 15, 2016 at 10:09 AM, Darrick J. Wong
<darrick.wong@oracle.com> wrote:
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
> Seeing as FS_IOC_FSGETXATTR is a "generic" ioctl now, why not just
> implement it for all the DAX fses and block devices?  Aside from xflags,
> the other fields are probably all zero for non-xfs (aside from project
> quota id I guess).
>
> (Yeah, sort of awkward, I know...)

It would solve the problem at hand, I'll take a look.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
