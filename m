Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A12CE7CA0
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 11:32:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 483CB304048
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2016 09:32:50 -0700 (PDT)
Received: from mx0a-000cda01.pphosted.com (mx0a-00003501.pphosted.com
	[67.231.144.15]) by cuda.sgi.com with ESMTP id wbCcxXCCisCRzlSx
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2016 09:32:48 -0700 (PDT)
Received: from pps.filterd (m0075550.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id
	u74GHPTu003400 for <xfs@oss.sgi.com>; Thu, 4 Aug 2016 12:32:48 -0400
Received: from mail-ua0-f197.google.com (mail-ua0-f197.google.com
	[209.85.217.197])
	by mx0a-00003501.pphosted.com with ESMTP id 24m7axrtcf-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NOT) for <xfs@oss.sgi.com>; Thu, 04 Aug 2016 12:32:47 -0400
Received: by mail-ua0-f197.google.com with SMTP id r91so343230939uar.2
	for <xfs@oss.sgi.com>; Thu, 04 Aug 2016 09:32:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160804154622.GB15656@infradead.org>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
	<1465155145-10812-38-git-send-email-mchristi@redhat.com>
	<CAOxpaSUMsgfTYsL0bL6VCnwxz7bpgpKO-ZfC5J8dFG9PN-hzvg@mail.gmail.com>
	<87fbe31f-27b3-ff7a-e381-34fc1aad337e@redhat.com>
	<CAJVOszAd9Eu88P2=QoNVArd0jwDH7KRe=OB82tCNMpjfv9B4KA@mail.gmail.com>
	<20160804154622.GB15656@infradead.org>
From: Shaun Tancheff <shaun.tancheff@seagate.com>
Date: Thu, 4 Aug 2016 11:32:16 -0500
Message-ID: <CAJVOszAqEw3UK6HV4bPvYfHeO6jvP0d-OtfXxRuve=5-Kmaokw@mail.gmail.com>
Subject: Re: [PATCH 37/45] drivers: use req op accessor
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
To: Christoph Hellwig <hch@infradead.org>
Cc: philipp.reisner@linbit.com, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, drbd-dev@lists.linbit.com, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, konrad.wilk@oracle.com, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, osd-dev@open-osd.org, Ross Zwisler <zwisler@gmail.com>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-btrfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, lars.ellenberg@linbit.com, ocfs2-devel@oss.oracle.com

On Thu, Aug 4, 2016 at 10:46 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Aug 03, 2016 at 07:30:29PM -0500, Shaun Tancheff wrote:
>> I think the translation in loop.c is suspicious here:
>>
>>     "if use DIO && not (a flush_flag or discard_flag)"
>> should translate to:
>>     "if use DIO && not ((a flush_flag) || op == discard)"
>>
>> But in the patch I read:
>>     "if use DIO && ((not a flush_flag) || op == discard)
>>
>> Which would have DIO && discards follow the AIO path?
>
> Indeed.  Sorry for missing out on your patch, I just sent a fix
> in reply to Dave's other report earlier which is pretty similar to
> yours.

No worries. I prefer your switch to a an if conditional here.

-- 
Shaun Tancheff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
