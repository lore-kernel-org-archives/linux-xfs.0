Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1EE667CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 20:50:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E203E304043
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:50:08 -0700 (PDT)
Received: from mail-oi0-f48.google.com (mail-oi0-f48.google.com
	[209.85.218.48]) by cuda.sgi.com with ESMTP id viqu2DEr71goAfAs
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Aug 2016 18:50:06 -0700 (PDT)
Received: by mail-oi0-f48.google.com with SMTP id l203so7392582oib.1
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:50:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
References: <20160804024514.GA2906@xzhoul.usersys.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Aug 2016 18:50:05 -0700
Message-ID: <CAPcyv4g1CkMZoq+vHcyPZW3ME7Qr=6pW10BTxg2n+e+28+MFKA@mail.gmail.com>
Subject: Re: xfstests xfs fuzzers fail with DAX
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
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@ml01.01.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

[ Adding Darrick on the off chance that this triggers an "aha, of
course it does!" ]

Darrick these corruption tests you added to xfstests last year all
fail the same way with DAX enabled.  They spew:

    "pwrite64: Structure needs cleaning"

...reports that are cleaned up by running without "-o dax".

Alternatively you could sit back and watch me try to figure it out,
that should be quite entertaining... as a start I'll try to pin down a
stack trace when the error is returned.


On Wed, Aug 3, 2016 at 7:45 PM, Xiong Zhou <xzhou@redhat.com> wrote:
> Hi,
>
> A few xfs fuzzers in xfstests fail with dax mount option, pass without dax.
> They are xfs/086 xfs/088 xfs/089 xfs/091.
>
> xfstests to commit 4470ad4c7e  (Jul 26)
> kernel   to commit dd95069545  (Jul 24)
>
> + ./check xfs/091
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
>
> xfs/091  104s
> Ran: xfs/091
> Passed all 1 tests
>
> + echo 'MOUNT_OPTIONS="-o dax"'
> + ./check xfs/091
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 rhel73 4.7.0+
> MKFS_OPTIONS  -- -f -bsize=4096 /dev/pmem1
> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:nfs_t:s0 /dev/pmem1 /daxsch
>
> xfs/091 104s ...  - output mismatch (see /root/xfstests/results//xfs/091.out.bad)
>     --- tests/xfs/091.out       2016-07-18 02:57:47.670000000 -0400
>     +++ /root/xfstests/results//xfs/091.out.bad 2016-08-03 22:38:14.948000000 -0400
>     @@ -6,6 +6,70 @@
>      + corrupt image
>      + mount image
>      + modify files
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning
>     +pwrite64: Structure needs cleaning
>     ...
>     (Run 'diff -u tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad'  to see the entire diff)
> Ran: xfs/091
> Failures: xfs/091
> Failed 1 of 1 tests
>
> # diff -u xfstests/tests/xfs/091.out /root/xfstests/results//xfs/091.out.bad
> --- xfstests/tests/xfs/091.out  2016-07-18 02:57:47.670000000 -0400
> +++ /root/xfstests/results//xfs/091.out.bad     2016-08-03 22:38:14.948000000 -0400
> @@ -6,6 +6,70 @@
>  + corrupt image
>  + mount image
>  + modify files
> +pwrite64: Structure needs cleaning
> <snip 62 more same lines>
> +pwrite64: Structure needs cleaning
>  + repair fs
>  + mount image
>  + chattr -R -i
>
>
> Thanks,
> Xiong
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
