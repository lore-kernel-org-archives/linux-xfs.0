Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA09F7F67
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 00:06:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B9B16304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 22:06:33 -0800 (PST)
Received: from mail-yk0-f182.google.com (mail-yk0-f182.google.com
	[209.85.160.182]) by cuda.sgi.com with ESMTP id
	hBD0jLmYr96x69Gz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 22:06:32 -0800 (PST)
Received: by mail-yk0-f182.google.com with SMTP id 131so315358ykp.41
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 22:06:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1564490.3HJmP8WlOV@shtub-cm>
References: <1806495.BCZcrVVEOf@shtub-cm> <2511571.nTXGg0tW6M@shtub-cm>
	<54ACC472.4010104@sandeen.net> <1564490.3HJmP8WlOV@shtub-cm>
Date: Tue, 6 Jan 2015 23:06:31 -0700
Message-ID: <CAJCQCtRvrUF+MvCuX4xjVVE2tEXR=zdMr5325cE0eLugrpL4tw@mail.gmail.com>
Subject: Re: What is a recommended XFS sector size for hybrid (512e) advanced
	format hard drives?
From: Chris Murphy <lists@colorremedies.com>
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
To: Hillel Lubman <shtetldik@gmail.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Jan 6, 2015 at 10:36 PM, Hillel Lubman <shtetldik@gmail.com> wrote:

> One is a recent portable WD USB3 drive (elements) and another is a regular
> 3.5" internal AF WD black in an enclosure (also attached through USB3). I
> didn't recently test the case of a drive attached through regular SATA.

A common theme emerges, so far 6 for 6 drives behaving this way are in
USB enclosures. At least one vendor ships an external drive (drive
inside an enclosure) that causes parted to report 4096B/4096B
logical/physical sectors. The drive inside is actually 512e so it's
512B/4096B, and the result of this is that partitioning/formatting it
inside the enclosure means it's completely unreadable outside the
enclosure and vice versa. So cute and adorable.


-- 
Chris Murphy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
