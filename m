Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 306C97CA1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 14:38:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA4F2304053
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:38:43 -0700 (PDT)
Received: from mail-ob0-f169.google.com (mail-ob0-f169.google.com
	[209.85.214.169]) by cuda.sgi.com with ESMTP id
	CrFjg0ANZCZ8EIqR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:38:41 -0700 (PDT)
Received: by mail-ob0-f169.google.com with SMTP id kf9so23816189obc.1
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 12:38:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1459277829.6412.3.camel@intel.com>
References: <1458861450-17705-1-git-send-email-vishal.l.verma@intel.com>
	<1458861450-17705-5-git-send-email-vishal.l.verma@intel.com>
	<CAPcyv4iKK=1Nhz4QqEkhc4gum+UvUS4a=+Sza2zSa1Kyrth41w@mail.gmail.com>
	<1458939796.5501.8.camel@intel.com>
	<CAPcyv4jWqVcav7dQPh7WHpqB6QDrCezO5jbd9QW9xH3zsU4C1w@mail.gmail.com>
	<1459195288.15523.3.camel@intel.com>
	<CAPcyv4jFwh679arTNoUzLZpJCSoR+KhMdEmwqddCU1RWOrjD=Q@mail.gmail.com>
	<1459277829.6412.3.camel@intel.com>
Date: Tue, 29 Mar 2016 12:37:14 -0700
Message-ID: <CAPcyv4hcSz7zKXzW3ZtdFbgBLbe0J2oNR-QC2L83adsvU3siFw@mail.gmail.com>
Subject: Re: [PATCH 4/5] dax: use sb_issue_zerout instead of calling
	dax_clear_sectors
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
Cc: "axboe@fb.com" <axboe@fb.com>, "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Tue, Mar 29, 2016 at 11:57 AM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Mon, 2016-03-28 at 16:34 -0700, Dan Williams wrote:
>
> <>
>
>> Seems kind of sad to fail the fault due to a bad block when we were
>> going to zero it anyway, right?  I'm not seeing a compelling reason to
>> keep any zeroing in fs/dax.c.
>
> Agreed - but how do we do this? clear_pmem needs to be able to clear an
> arbitrary number of bytes, but to go through the driver, we'd need to
> send down a bio? If only the driver had an rw_bytes like interface that
> could be used by anyone... :)

I think we're ok because clear_pmem() will always happen on PAGE_SIZE,
or HPAGE_SIZE boundaries.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
