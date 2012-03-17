Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2HLf0Xk128752 for <xfs@oss.sgi.com>; Sat, 17 Mar 2012 16:41:00 -0500
Received: from mail-wi0-f173.google.com (mail-wi0-f173.google.com
	[209.85.212.173]) by cuda.sgi.com with ESMTP id
	HSOjTE5GQ07o73HZ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 17 Mar 2012 14:40:59 -0700 (PDT)
Received: by wibhq7 with SMTP id hq7so1924790wib.14
	for <xfs@oss.sgi.com>; Sat, 17 Mar 2012 14:40:58 -0700 (PDT)
Message-ID: <4F650493.7080709@gmail.com>
Date: Sat, 17 Mar 2012 22:39:31 +0100
From: Zdenek Kaspar <zkaspar82@gmail.com>
MIME-Version: 1.0
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier (GiB alignment)
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
	<20324.44842.473837.511238@tree.ty.sabi.co.UK>
In-Reply-To: <20324.44842.473837.511238@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

Dne 17.3.2012 16:35, Peter Grandi napsal(a):
> I often recommend aligning partitions to 1GiB, also because I
> like to have 1GiB or so of empty space at the very beginning and
> end of a drive.

I'm really curious why do you use such alignment? I can think about few
reasons, but most practical I think you like to slice in gigabyte sizes.

Z.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
