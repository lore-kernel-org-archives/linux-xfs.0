Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 18D637F54
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 17:33:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0160A8F804C
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:33:07 -0700 (PDT)
Received: from mail-qg0-f52.google.com (mail-qg0-f52.google.com
	[209.85.192.52]) by cuda.sgi.com with ESMTP id biOShushkbvbCk5S
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:33:06 -0700 (PDT)
Received: by mail-qg0-f52.google.com with SMTP id f51so2346474qge.11
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2014 15:33:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140625220336.GN9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
	<CA+o=1OVnORG0Ah3Zx8dkGzs7vtT7odRH=v12KqtLW0MP_3oHjQ@mail.gmail.com>
	<20140625012144.GK9508@dastard>
	<CA+o=1OXY8Ay8CSgsdiAOTacBa9800FiMKGbr0DdkE_YVpewqBw@mail.gmail.com>
	<20140625220336.GN9508@dastard>
Date: Thu, 26 Jun 2014 00:33:06 +0200
Message-ID: <CA+o=1OWptqFq87E0ncmYH2T6yEzeGheefE-o_VAm7-E_0Z+NJA@mail.gmail.com>
Subject: Re: Metadata CRC error upon unclean unmount
From: Fanael Linithien <fanael4@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

2014-06-26 0:03 GMT+02:00 Dave Chinner <david@fromorbit.com>:
> Can you try to reproduce the AGI or AGF/freespace corruption issue
> and post the results?

Sure, looks like the bug heard you and decided to manifest itself right now.

dmesg: https://clbin.com/g52eu (the second mount error is because I
typo'd and tried to mount wrong partition)
Metadata before an attempt to mount: https://clbin.com/YDZBV
Metadata after an attempt to mount: https://clbin.com/2jayF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
