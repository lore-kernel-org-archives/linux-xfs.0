Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1K2h3II052895 for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 20:43:03 -0600
Received: from mail-vx0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 478B62E7F1A
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 18:45:45 -0800 (PST)
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	tI0W1tzjpjdcBagC for <xfs@oss.sgi.com>;
	Sat, 19 Feb 2011 18:45:45 -0800 (PST)
Received: by vxb39 with SMTP id 39so241643vxb.26
	for <xfs@oss.sgi.com>; Sat, 19 Feb 2011 18:45:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
References: <AANLkTindiB_D7shZKkrdkePM=xaAXCe1HAX5tPy87SCy@mail.gmail.com>
Date: Sun, 20 Feb 2011 11:45:41 +0900
Message-ID: <AANLkTi=YJVGXrY=Jy7p1_AdPnNKWqtmbdkTXy32QP3vt@mail.gmail.com>
Subject: Re: First 128KB of XFS partition is NULL.
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
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
To: xfs@oss.sgi.com

Testing team provides a very little information, but after checking
all possiblity I cam to conclusion that he may have removed the USB
during formating when mkfs.xfs just finished "Zero out the beginning
of the device, to obliterate any old filesystem signatures out there"

Issue resolved, thanks

On Sun, Feb 20, 2011 at 11:22 AM, Ajeet Yadav <ajeet.yadav.77@gmail.com> wrote:
> Dear All,
> I have received a corrupted disk from team testing XFS, when I look
> hexdump of partiton. Its 0000 in first 128KB.
> Our kernel is 2.6.30.9 however we have backported XFS from 2.6.34,
> Arch MIP with VIPT cache.
> This arch previously had many issues but after properly implementing
> "xfs: fix xfs to work with Virtually Indexed architectures " most
> problem resolved.
>
> Can anyone make guess in what case first 128KB may become NULL, I seem
> to be impossible because file system does not modify all 128KB at the
> begining of partition at once.
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
