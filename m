Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8CB6Vib251191 for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 06:06:32 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A01C913DED8C
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:11:02 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id Qsv5ggALgTOtBIpf
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:11:02 -0700 (PDT)
Received: by fxh2 with SMTP id 2so1414150fxh.26
	for <xfs@oss.sgi.com>; Mon, 12 Sep 2011 04:06:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADDb1s1fr8fiRMAUTvnSqpKeLGJdUPAbEfLNpwb2-iVd+mjw4w@mail.gmail.com>
References: <CADDb1s2QDk7y+JgMikoje35LviYQwzpgFihndUPuZx2VXYV4Ew@mail.gmail.com>
	<20110910183028.GA23537@infradead.org>
	<CADDb1s1fr8fiRMAUTvnSqpKeLGJdUPAbEfLNpwb2-iVd+mjw4w@mail.gmail.com>
Date: Mon, 12 Sep 2011 16:36:29 +0530
Message-ID: <CADDb1s3WbZr7aqOAs13vu6Z+QOd7f+JtLyHXqhnM7foqUVar9Q@mail.gmail.com>
Subject: Re: XFS: Observed Crash followed by deadlock of khubd/sync/XFS
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Please ignore previous message, there is formatting issue with the
back trace. I will post again.

On Sun, Sep 11, 2011 at 10:16 PM, Amit Sahrawat
<amit.sahrawat83@gmail.com> wrote:
> Yes, the patch is applied and the crash is still appearing easily.
>
> On Sun, Sep 11, 2011 at 12:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> On Thu, Sep 08, 2011 at 04:35:28PM +0530, Amit Sahrawat wrote:
>>> Kernel Version: 2.6.39.4
>>> Target: ARM
>>>
>>> Observed while doing:
>>> Copy some file (any size, I tried with 10MB, 100MB) to XFS partition
>>> After Copy do???sync???
>>> Now immediately, unplug the device.
>>
>> Does this still happen with the patch below applied?
>>
>>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
