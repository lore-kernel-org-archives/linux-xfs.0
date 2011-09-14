Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8E9MA4t131069 for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 04:22:10 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFA1C152726A
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 02:26:52 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id B2vdGG60dYqZtNfK
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 02:26:52 -0700 (PDT)
Received: by fxh2 with SMTP id 2so1464991fxh.26
	for <xfs@oss.sgi.com>; Wed, 14 Sep 2011 02:22:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913160454.GA27569@infradead.org>
References: <CADDb1s0HwQtno3qWJd5CDriGD+m1EJ3fKihrRXuGmqayzwb_Pw@mail.gmail.com>
	<20110913152706.GB21460@infradead.org>
	<CADDb1s2=jHyef=5S6WNV+eLZKD1C3yJX4LzcPJhUAA1ohpAfqQ@mail.gmail.com>
	<20110913160454.GA27569@infradead.org>
Date: Wed, 14 Sep 2011 14:52:08 +0530
Message-ID: <CADDb1s3tHU-KcU0HntiqgYObFpDHUKYnE3E5fnOj70QDyZw-PQ@mail.gmail.com>
Subject: Re: Code Changes [Review Request]: xfs_trans_ail_delete() gets
	invoked with corrupted values ? Causing Crash and Deadlock.
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

The patch is working fine.No issues observed.
Thanks.

Regards,
Amit Sahrawat

On Tue, Sep 13, 2011 at 9:34 PM, Christoph Hellwig <hch@infradead.org> wrot=
e:
> On Tue, Sep 13, 2011 at 09:28:40PM +0530, Amit Sahrawat wrote:
>> Yes, that was not the correct fix. But since I am getting that
>> regularly I had to first get over that to avoid crash.
>
> No problem. =A0I'm more than happy about any kind of analsys and debugging
> I get.
>
>> The changes you have mentioned below seems appropriate- I will check
>> and update you more on this by tomorrow.
>> But I tried to this flushing as part of xlog_dealloc_log - it didn't
>> work over there =A0- i will confirm this.
>
> Hmm. =A0In that case this one might not work either, but I'd love to
> see your results.
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
