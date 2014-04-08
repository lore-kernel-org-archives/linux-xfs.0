Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 260D5808E
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 09:28:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0DD0F8F8052
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 07:28:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Mv2LOo6AwxSWUqaG for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 07:28:17 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [Bug] XFS: DIO random write + BufferIO read
References: <CAEH94LiJ6PBRRdFc4aZapLEPT7B7==0dUKQZqzQ6+vQpGpxHLg@mail.gmail.com>
Date: Tue, 08 Apr 2014 10:28:10 -0400
In-Reply-To: <CAEH94LiJ6PBRRdFc4aZapLEPT7B7==0dUKQZqzQ6+vQpGpxHLg@mail.gmail.com>
	(Zhi Yong Wu's message of "Fri, 4 Apr 2014 23:09:10 +0800")
Message-ID: <x49bnwbyjyd.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, jack@suse.cz, Theodore Ts'o <tytso@mit.edu>, xfstests <xfs@oss.sgi.com>

Zhi Yong Wu <zwu.kernel@gmail.com> writes:

> HI
>
> When i try something on XFS filesytem, i hit one issue as below:
>
> One main task create multiple threads at first, Then it will dio
> random write some files with random offset and length for each thread.
> When those files get ready, those multiple threads will bufferio read
> them and check if the data are same as their corresponding buffer. In
> theory, they should be same, but the actual result isn't what we
> expect
>
> By the way, i did the same try on ext3 filesystem, but didn't get any
> such issue.

What kernel version?

Cheers,
Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
