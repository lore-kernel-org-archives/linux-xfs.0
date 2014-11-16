Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 418AF29DF7
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 17:08:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 18B1B8F8039
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 15:07:56 -0800 (PST)
Received: from srv2.trombetti.net (srv2.trombetti.net [65.254.53.252]) by
	cuda.sgi.com with ESMTP id ls4YhMHsE1K1YLkF for
	<xfs@oss.sgi.com>; Sun, 16 Nov 2014 15:07:55 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested) (Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 16F5F31324
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 18:12:36 -0500 (EST)
Message-ID: <54692E48.80708@shiftmail.org>
Date: Mon, 17 Nov 2014 00:07:52 +0100
From: Spelic <spelic@shiftmail.org>
MIME-Version: 1.0
Subject: Re: Virtual Block device resize corrupts XFS
References: <5468FC60.10901@web.de> <20141116223630.GH23575@dastard>
In-Reply-To: <20141116223630.GH23575@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 16/11/2014 23:36, Dave Chinner wrote:
> On Sun, Nov 16, 2014 at 08:34:56PM +0100, Markus Rhonheimer wrote:
>> A few days ago I wanted to increase the size of the block device,
>> but accidently decreased it by 1 TB (from 7 to 6). I found out about
>> it and immediately increased the size of the drive to 8 TB
>> afterward.
> If that was a normal LVM block device, there would have been no
> trouble. But you're using something special, unusual and completely
> untested, so the most likely outcome is going to be that you still
> have a pile of broken bits.
>

Not true! Depends on the allocation strategy chosen for LVM and the 
position of free space.
Probably recovering LVM conf from backups (which usually is 
automatically made) can recover the exact LVM layout of prior to the shrink.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
