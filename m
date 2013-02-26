Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 78BF47CBF
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 16:37:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 57DEB8F8035
	for <xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:37:03 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7c2OH5qEh8FOK61U for <xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 14:37:02 -0800 (PST)
Message-ID: <512D390D.7060302@sandeen.net>
Date: Tue, 26 Feb 2013 16:37:01 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Read corruption on ARM
References: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
In-Reply-To: <CA+AKrqBQ=VG0oVsai+agywDKRgO9cG9AvT6mCTSZxKO3Si5Aiw@mail.gmail.com>
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
To: Jason Detring <detringj@gmail.com>
Cc: xfs@oss.sgi.com

On 2/26/13 3:58 PM, Jason Detring wrote:
> Hello list,

<snip>

> This also seems to impact the Raspberry Pi.  Below shows a 256 MB test
> case filesystem.
> The filesystem was created on an x86-64 box by mkfs.xfs 3.1.8 and
> populated by kernel 3.6.9.
> This failure report is Linux 3.6.11-g89caf39 built by GCC 4.7.2 from
>    <https://github.com/raspberrypi/linux/commits/rpi-3.6.y>
> The problem appears to be tied to the filesystem, not the media,
> since both an external USB reader and a loopback-mounted image on the
> unit's main SD media show the same backtrace.  The loopback image was
> captured on other hardware, then copied onto the RPi via network.

Missed this; let me fire up my pi and see if I can replicate it.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
