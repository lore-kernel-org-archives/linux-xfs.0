Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 851797CD7
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 12:53:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEE85AC002
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 10:53:28 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id PjWAuY4gCUIPnHw6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 10:53:26 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id x201so199989214oif.3
	for <xfs@oss.sgi.com>; Mon, 02 May 2016 10:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard>
	<1461628381.1421.24.camel@intel.com>
	<20160426004155.GF18496@dastard>
	<x49pot4ebeb.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 2 May 2016 10:53:25 -0700
Message-ID: <CAPcyv4jfUVXoge5D+cBY1Ph=t60165sp6sF_QFZUbFv+cNcdHg@mail.gmail.com>
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
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "Verma,
	Vishal L" <vishal.l.verma@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Mon, May 2, 2016 at 8:18 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dave Chinner <david@fromorbit.com> writes:
[..]
>> We need some form of redundancy and correction in the PMEM stack to
>> prevent single sector errors from taking down services until an
>> administrator can correct the problem. I'm trying to understand
>> where this is supposed to fit into the picture - at this point I
>> really don't think userspace applications are going to be able to do
>> this reliably....
>
> Not all storage is configured into a RAID volume, and in some instances,
> the application is better positioned to recover the data (gluster/ceph,
> for example).  It really comes down to whether applications or libraries
> will want to implement redundancy themselves in order to get a bump in
> performance by not going through the kernel.  And I think I know what
> your opinion is on that front.  :-)
>
> Speaking of which, did you see the numbers Dan shared at LSF on how much
> overhead there is in calling into the kernel for syncing?  Dan, can/did
> you publish that spreadsheet somewhere?

Here it is:

https://docs.google.com/spreadsheets/d/1pwr9psy6vtB9DOsc2bUdXevJRz5Guf6laZ4DaZlkhoo/edit?usp=sharing

On the "Filtered" tab I have some of the comparisons where:

noop => don't call msync and don't flush caches in userspace

persist => cache flushing only in userspace and only on individual cache lines

persist_4k => cache flushing only in userspace, but flushing is
performed in 4K aligned units

msync => same granularity flushing as the 'persist' case, but the
kernel internally promotes this to a 4K sized / aligned flush

msync_0 => synthetic case where msync() returns immediately and does
no other work

The takeaway is that msync() is 9-10x slower than userspace cache management.

Let me know if there are any questions and I can add an NVML developer
to this thread...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
