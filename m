Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 409CB7CA0
	for <xfs@oss.sgi.com>; Sat,  9 Apr 2016 18:24:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B6998AC001
	for <xfs@oss.sgi.com>; Sat,  9 Apr 2016 16:24:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id M0S2J53czEr2I9Aq for <xfs@oss.sgi.com>;
	Sat, 09 Apr 2016 16:24:32 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 12FE916C173
	for <xfs@oss.sgi.com>; Sat,  9 Apr 2016 18:24:31 -0500 (CDT)
Subject: Re: Apparently successful xfs_copy gives "-9" returncode
References: <CAK1feJAybrn3SGJK4u4-eNA-bSm68f6Kw2BrxKSQnL9PT8VSAQ@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <57098F2F.4080909@sandeen.net>
Date: Sat, 9 Apr 2016 18:24:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAK1feJAybrn3SGJK4u4-eNA-bSm68f6Kw2BrxKSQnL9PT8VSAQ@mail.gmail.com>
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
To: xfs@oss.sgi.com

On 4/9/16 12:55 PM, Richard C wrote:
> Hi all,
> 
> I'm writing a script that helps with hard disk cloning and am running into a problem whereby xfs_copy is returning -9 when there is nothing in the log and no indication on stdout or stderr, example below.
> 
> I've had a search and couldn't find anything mentioned. Can anyone shed any light, maybe which version I should try if you suspect this has already been fixed?
> Dist: Ubuntu Trusty
> xfsprogs: 3.1.9

# git show v3.1.9
tag v3.1.9
Tagger: Ben Myers <bpm@sgi.com>
Date:   Wed Dec 12 14:51:24 2012 -0600

> $ losetup /dev/loop2 ./disk.img
> $ xfs_copy /dev/loop1p6 /dev/loop2
>  0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ... 80%  ... 90%  ... 100%
> All copies completed.
> $ echo $?
> -9

Something not so ancient behaves as expected here:

# copy/xfs_copy fsfile fsfile2
Creating file fsfile2
 0%  ... 10%  ... 20%  ... 30%  ... 40%  ... 50%  ... 60%  ... 70%  ... 80%  ... 90%  ... 100%

All copies completed.
# echo $?
0

# copy/xfs_copy -V
xfs_copy version 4.5.0

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
