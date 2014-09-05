Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB8DC7F3F
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 07:15:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B9BE58F8035
	for <xfs@oss.sgi.com>; Fri,  5 Sep 2014 05:15:10 -0700 (PDT)
Received: from mail-we0-f171.google.com (mail-we0-f171.google.com
	[74.125.82.171]) by cuda.sgi.com with ESMTP id zphGMoXNNHppcrVq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 05 Sep 2014 05:15:09 -0700 (PDT)
Received: by mail-we0-f171.google.com with SMTP id u56so11804940wes.2
	for <xfs@oss.sgi.com>; Fri, 05 Sep 2014 05:15:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140829083738.GD20518@dastard>
References: <3dc9caf6f9b415f6e4c0ebac1f1626d3@zbfmail.de>
	<20140827230732.GN20518@dastard>
	<CAAxjCEy9UyjDVrTZ4GdRyDy330wUqLGWurzrLAE6-7Q0KdYzvA@mail.gmail.com>
	<20140829083738.GD20518@dastard>
Date: Fri, 5 Sep 2014 14:15:03 +0200
Message-ID: <CAAxjCExoNwWA17Mxme=VOHDREGuK6CzP7h770sbWxJqG=9tHYA@mail.gmail.com>
Subject: Re: mount options question
From: Stefan Ring <stefanrin@gmail.com>
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
To: Xfs <xfs@oss.sgi.com>

>> Mostly agreed, but using "discard" would be a no-brainer for me. I
>> suppose XFS does not automatically switch it on for non-rotational
>> storage.
>
> Yup, you're not using your brain. :P
>
> mount -o discard *sucks* on so many levels it is not funny. I don't
> recommend that anybody *ever* use it, on XFS, ext4 or btrfs.  Just
> use fstrim if you ever need to clean up a SSD.

Good to know, thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
