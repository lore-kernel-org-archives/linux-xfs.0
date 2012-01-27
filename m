Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RGSxjZ204109 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 10:28:59 -0600
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id 6fRCZGfDXYlLtE33
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 08:28:58 -0800 (PST)
Received: by wgbdy1 with SMTP id dy1so1503429wgb.32
	for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 08:28:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120127110120.GA31093@infradead.org>
References: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
	<20120127110120.GA31093@infradead.org>
From: Eryu Guan <guaneryu@gmail.com>
Date: Sat, 28 Jan 2012 00:28:36 +0800
Message-ID: <CA+dCu8-6N3HEKSs17xuuRmcry8_xaGCJZh8JFczBswgF9XdO3A@mail.gmail.com>
Subject: Re: [PATCH] xfstests 273 274 275: do test in dedicated dir and leave
	test files in it
Reply-To: guaneryu@gmail.com
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

On Fri, Jan 27, 2012 at 7:01 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Jan 13, 2012 at 01:20:15AM +0800, Eryu Guan wrote:
>> Do all testings in dedicated dir($SCRATCH_MNT/$seq) instead of
>> $SCRATCH_MNT and don't remove test files in _cleanup() for debug
>> purpose.
>
> What it the dedicated directory useful for?

fsck.extN will complain lost+found is missing and fail 273. So my first try is
creating lost+found explicitly after removing everything in $SCRATCH_MNT.
Please see http://oss.sgi.com/archives/xfs/2012-01/msg00092.html
The whole point here is to avoid such fsck errors.

And as Dave suggested, 273 274 275 should put all files in a dedicated location
and just remove that dir instead of removing all files in
$SCRATCH_MNT. So I sent
out this as a second try. Perhaps I should mark it as v2...

Thanks,
Eryu Guan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
