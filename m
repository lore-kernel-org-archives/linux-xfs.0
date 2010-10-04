Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o94Jg2Jn096618 for <xfs@oss.sgi.com>; Mon, 4 Oct 2010 14:42:02 -0500
Received: from mail-ey0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E92ADC1892
	for <xfs@oss.sgi.com>; Mon,  4 Oct 2010 12:43:04 -0700 (PDT)
Received: from mail-ey0-f181.google.com (mail-ey0-f181.google.com
	[209.85.215.181]) by cuda.sgi.com with ESMTP id
	MuBFj4mU4oWwxw5j for <xfs@oss.sgi.com>;
	Mon, 04 Oct 2010 12:43:04 -0700 (PDT)
Received: by eyf6 with SMTP id 6so2314207eyf.26
	for <xfs@oss.sgi.com>; Mon, 04 Oct 2010 12:43:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101003064547.GA9071@infradead.org>
References: <AANLkTi=kzGSGtmk8a_eu5n9w6wbvt_f28Va9gSeWNgCe@mail.gmail.com>
	<20101002103902.GE4681@dastard>
	<20101003064547.GA9071@infradead.org>
Date: Mon, 4 Oct 2010 16:43:02 -0300
Message-ID: <AANLkTikM=JhRQsrDPG6wuuQm4qtkEMwjLB+NygXh=zaC@mail.gmail.com>
Subject: Re: xfs_db -c frag -r /dev/sdb1 segmentation fault
From: Robert Pipca <robertpipca@gmail.com>
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

Hi,

I ran it on a mounted filesystem.

It's a squid webcache machine, and I ran it on the HD that's doing the
cache, to see how fragmented it is....

This thing is: After I ran xfs_fsr on the same partition, xfs_db
started working again (even though both times I used "-r").

Should this have happened?

Cheers,

- Robert

2010/10/3 Christoph Hellwig <hch@infradead.org>:
> On Sat, Oct 02, 2010 at 08:39:03PM +1000, Dave Chinner wrote:
>> Note that the crash could be caused by a corrupted filesystem.
>
> Or running it on a mounted filesystem. =A0Robert, did you run the command
> on a mounted or unmounted filesystem?
>
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
