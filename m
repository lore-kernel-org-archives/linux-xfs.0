Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 Feb 2007 16:32:22 -0800 (PST)
Received: from talk.nabble.com (www.nabble.com [72.21.53.35])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l1L0WHm7031904
	for <linux-xfs@oss.sgi.com>; Tue, 20 Feb 2007 16:32:18 -0800
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1HJfP7-00087L-5X
	for linux-xfs@oss.sgi.com; Tue, 20 Feb 2007 16:32:17 -0800
Message-ID: <9073464.post@talk.nabble.com>
Date: Tue, 20 Feb 2007 16:32:17 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
Subject: Re: [PATCH] mkfs.xfs, lvm, multi-terrabyte hardware array and luks
In-Reply-To: <9069238.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
References: <9068053.post@talk.nabble.com> <45DB4CE1.3040302@sandeen.net> <9069238.post@talk.nabble.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Eric thanks for the help.  It seems that you are likely correct in regard to
the LUKS 2gb threshold.  I am in the process of urandoming (via dd) a large
[20gb] LUKS based ext3 partition to see if the writes fail while less than
20gb... I haven't gotten the results yet... because it takes forever.  If
this fails to fill the 20gb ext3 with random data then it would be fair to
conclude that LUKS has a problem with large partitions [and ext3 has a
problem verifying the underlying partition size], right?

In the meantime I have executed a few trial and error tests (by creating
various sized lv/LUKS partitions and then mkfs.xfs on them); the results
overwhelming suggest that there is a 2gb xfs limitation on LUKS partitions
(probably more politically correct to say it the other way around).  Besides
relying on LUKS forums are there any other resources that you know of
that/who would/could provide a quick solution?

Is there anyway that lvm2 could be contributing to this problem?  Are there
any mkfs.xfs commands that I must issue in this [lvm2/LUKS/Large hardware
raid6 array] environment?  Are there certain properties that must remain
congruent in regard to the raid array, the lvm2 environment, LUKS and/or
XFS?

Again, thanks for your time and help.



pgf111000 wrote:
> 
> Thank you for the quick response.  I have posted on a few luks forums to
> try to delve into this issue a little deeper; if they are aware of a
> resolution I'll make sure to post it.  The interesting thing is that when
> I mkfs.ext3 on luks partitions above 2-3gb all is fine; I wish xfs and
> luks would play nice.....
> 
> 
> Eric Sandeen-3 wrote:
>> 
>> pgf111000 wrote:
>>> When I try to format partitions above 2-3gb my opteron experiences heavy
>>> io
>>> wait; the mkfs.xfs fails, and I receive the following....
>>> 
>>>  "mkfs.xfs: libxfs_device_zero write failed: Input/output error"
>>> 
>>> When I format partions below 2-3gb, there is no problem whatsoever.  I
>>> can
>>> mkfs.xfs on a +2-3GB non-luks formated partition without a problem...
>>> any
>>> thoughts?
>> 
>> Sounds like a LUKS problem, maybe it can't do those large offsets?  xfs
>> certainly can...
>> 
>> I bet you'll find that the 2GB size is the threshold... xfs is just
>> trying a write():
>> 
>>         if ((bytes = write(fd, z, bytes)) < 0) {
>>                 fprintf(stderr, _("%s: %s write failed: %s\n"),
>>                         progname, __FUNCTION__, strerror(errno));
>> 
>> maybe try a simple dd write at the end of your large luks device, see
>> how that goes.
>> 
>> -Eric
>> 
>> 
>> 
>> 
> 
> 

-- 
View this message in context: http://www.nabble.com/mkfs.xfs%2C-lvm%2C-multi-terrabyte-hardware-array-and-luks-tf3262532.html#a9073464
Sent from the linux-xfs mailing list archive at Nabble.com.
