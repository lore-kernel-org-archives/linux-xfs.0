Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 24D647CA1
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 21:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9028304032
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2016 19:52:56 -0700 (PDT)
Received: from mail-oi0-f49.google.com (mail-oi0-f49.google.com
	[209.85.218.49]) by cuda.sgi.com with ESMTP id kPMLKJyV47zLujEM
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2016 19:52:55 -0700 (PDT)
Received: by mail-oi0-f49.google.com with SMTP id f189so31973425oig.3
	for <xfs@oss.sgi.com>; Wed, 03 Aug 2016 19:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160803231655.GY16044@dastard>
References: <20160803003354.GP16044@dastard>
	<20160803171127.GA15876@linux.intel.com>
	<20160803223713.GA22364@linux.intel.com>
	<20160803231655.GY16044@dastard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 3 Aug 2016 19:52:53 -0700
Message-ID: <CAPcyv4hsMSG6S=BaOyCYnwmhu1uUWkryoA2SqoLff4nuK5dysA@mail.gmail.com>
Subject: Re: [4.8 hang] xfstests generic/361 hangs on dax enabled filesystems
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
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>

On Wed, Aug 3, 2016 at 4:16 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Aug 03, 2016 at 04:37:13PM -0600, Ross Zwisler wrote:
>> On Wed, Aug 03, 2016 at 11:11:27AM -0600, Ross Zwisler wrote:
>> > On Wed, Aug 03, 2016 at 10:33:54AM +1000, Dave Chinner wrote:
>> > > Hi folks,
>> > >
>> > > Just hit a reproducable hang in generic/361. Essentially this on
>> > > a 8GB pmem device:
>> > >
>> > > mkfs.xfs -f /dev/pmem1
>> > > mount -o dax /dev/pmem1 /mnt/scratch
>> > > xfs_io -f -c "truncate 1g" test.img
>> > > losetup -f --show /mnt/scratch/test.img
>> > > mkfs.xfs -f /dev/loop0
>> > >
>> > > And the mkfs.xfs command hangs with a discard that never completes:
> ....
>> > > This only reproduces when the underlying filesystem is mounted with
>> > > -o dax, so there is a bad interaction with loop devices and DAX
>> > > occurring somewhere. generic/361 is a recent test (committed june 14)
>> > > so this probably hasn't actually been tested until now.
>> > >
>> > > I haven't got time to look at this right now, hence the report.
>> >
>> > Cool, thanks for the report.  I've reproduced this with linux/master, and the
>> > test passes with v4.7.
>> >
>> > Running a bisect...
>>
>> This bisected to a commit to the block layer code.  I've sent a bug report to
>> the author of the commit.
>
> And the commit id is ...?

c2df40dfb8c0 drivers: use req op accessor

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
