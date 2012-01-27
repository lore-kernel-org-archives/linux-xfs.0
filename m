Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RJFbCE228415 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 13:15:38 -0600
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	lRi95sHzPXHQiJxn (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 27 Jan 2012 11:15:36 -0800 (PST)
Received: by iakl21 with SMTP id l21so2884616iak.26
	for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 11:15:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120127104413.GA12347@infradead.org>
References: <CAEBWcAT2zfDskgDjFr0KcnfsT2A65r04AM1cv2-TfnNJTB1__Q@mail.gmail.com>
	<20120127104413.GA12347@infradead.org>
Date: Fri, 27 Jan 2012 20:15:36 +0100
Message-ID: <CAEBWcATUgSKaeFG=siAFOAnKCTagHZUD=_1SB-hWe=u06Xhd1Q@mail.gmail.com>
Subject: Re: Insane file system overhead on large volume
From: Manny <dermaniac@gmail.com>
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

> Where did you get the sizes for the raw volume and the filesystem usage
> from?

Oh my god, you are so right. The raw volume was actually just 24TB. My
Raid controller decided to leave 6TB on the VDisk for a Snap pool.

Thanks for the hint, and sorry to bother you

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
