Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35E367CA2
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 13:56:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7F7E3AC001
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:56:23 -0700 (PDT)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com
	[209.85.218.41]) by cuda.sgi.com with ESMTP id 8Q38gvsP70bCdeQu
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Apr 2016 11:56:21 -0700 (PDT)
Received: by mail-oi0-f41.google.com with SMTP id r78so1213959oie.0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 11:56:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x494mb2ivcl.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<1460739288.3012.3.camel@intel.com>
	<x49potq6bm2.fsf@segfault.boston.devel.redhat.com>
	<1460741821.3012.11.camel@intel.com>
	<CAPcyv4hemNM4uQYCPBXyH+DWTOLvyBNBeMYstKbPdad_Cw48HQ@mail.gmail.com>
	<x49lh4e6928.fsf@segfault.boston.devel.redhat.com>
	<CAPcyv4hRQj2ZsFj7Xa_=OwcHrzP9_5yUpt3LQ+bPH4PcLe7UCQ@mail.gmail.com>
	<x494mb2ivcl.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 15 Apr 2016 11:56:20 -0700
Message-ID: <CAPcyv4jcPDDcru1ySJLY7SzDQQWFXbfHm493N0twa1vHBEc6aQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Fri, Apr 15, 2016 at 11:24 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Moreover, we're going to do the full badblocks lookup anyway when we
>> call ->direct_access().  If we had that information earlier we can
>> avoid this fallback dance.
>
> None of the proposed approaches looks clean to me.  I'll go along with
> whatever you guys think is best.  I am in favor of wrapping up all that
> duplicated code, though.

Christoph originally pushed for open coding this fallback decision
per-filesystem.  I agree with you on the "none the above" options are
clean.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
