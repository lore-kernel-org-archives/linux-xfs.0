Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A9977F51
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 03:40:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0ED5A8F8050
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 01:40:54 -0800 (PST)
Received: from mail-lb0-f169.google.com (mail-lb0-f169.google.com
	[209.85.217.169]) by cuda.sgi.com with ESMTP id
	ouYlsxG2hrzVAHSa (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 01:40:50 -0800 (PST)
Received: by mail-lb0-f169.google.com with SMTP id q8so2481914lbi.0
	for <xfs@oss.sgi.com>; Fri, 07 Feb 2014 01:40:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140206225132.GE13647@dastard>
References: <20140204172402.380571745@bombadil.infradead.org>
	<CA+QCeVRmDFjF9YMgEOR7UpdQMQU98cR0KeO1HMNoP9k1ZvOzaA@mail.gmail.com>
	<CA+QCeVQxTk=ZNucLG4WPrQC=oHf1sFtJ7nj5dhJg=BUyuVbsOQ@mail.gmail.com>
	<20140206225132.GE13647@dastard>
From: Sergey Meirovich <rathamahata@gmail.com>
Date: Fri, 7 Feb 2014 11:40:29 +0200
Message-ID: <CA+QCeVQBZx0Y_TtwjEY7HQaZTg-fiSnxiyifomk7+PT8xebcqg@mail.gmail.com>
Subject: Re: [PATCH 0/3] support appending AIO writes
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com

On 7 February 2014 00:51, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Feb 06, 2014 at 06:29:11PM +0200, Sergey Meirovich wrote:
>> On 5 February 2014 16:52, Sergey Meirovich <rathamahata@gmail.com> wrote:
>> > Hi Christoph,
>> >
>> > Thanks a lot! Applied your patches on top of 3.13.1 and they indeed
>> > make a huge difference.
>> >
>> >
>> > Append AIO
>> >
>> > chunk size           w/o patches                               with patches
>> > ===================================================
>> > 4k               6.8834 Mb/sec 1762.15 IOps      31.542 Mb/sec 8074.75 IOps
>> > 8k               15.321 Mb/sec 1961.12 IOps      62.873 Mb/sec 8047.71 IOps
>> > 16k             28.257 Mb/sec 1808.46 IOps      139.35 Mb/sec 8918.45 IOps
>>
>> And with simple wrapper around io_submit() difference for 4 k is even
>> more impressive than with sysbench:
>>
>> without patches:
>> =====================
>> bandwidth (MiB/s):    11.89
>> IOps:                    3044.58
>>
>> with patches:
>> =====================
>> bandwidth (MiB/s):    118.16
>> IOps:                   30250.17
>
> Thanks for providing numbers, Sergey. It's clear that we need to
> make this change from them. Can I add a "Tested-by: Sergey Meirovich
> <rathamahata@gmail.com>" to the patches?

Sure, Dave. Please do.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
