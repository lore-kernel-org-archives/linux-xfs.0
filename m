Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8707F7F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:45:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77F618F804B
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:45:39 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 0btYAkWpi0aeLmP1 for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 12:45:37 -0700 (PDT)
Message-ID: <53A9D561.20805@sandeen.net>
Date: Tue, 24 Jun 2014 14:45:37 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Metadata CRC error upon unclean unmount
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>	<53A9A295.8030302@sandeen.net>	<CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>	<53A9C7EF.7010707@sandeen.net>
	<CA+o=1OXG9wY7pX3emPtRjdAQKC4MFKvJWiJsmD7yGmuJeXjPQQ@mail.gmail.com>
In-Reply-To: <CA+o=1OXG9wY7pX3emPtRjdAQKC4MFKvJWiJsmD7yGmuJeXjPQQ@mail.gmail.com>
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
To: Fanael Linithien <fanael4@gmail.com>
Cc: xfs@oss.sgi.com

On 6/24/14, 2:00 PM, Fanael Linithien wrote:
> 2014-06-24 20:48 GMT+02:00 Eric Sandeen <sandeen@sandeen.net>:
>> FWIW, I've been unable to reproduce this in about 4 attempts, using
>> virtualbox, and doing a guest reset.
> 
> Same here. The most breakage I can get is a log record CRC mismatch
> (still a bug, I think). I will report if I run across a metadata CRC
> error ever again.

The trouble with VMs is that we depend on the VM doing the right thing,
as well.  I can't blame VirtualBox here, but it definitely adds a layer
of complexity that we can't control.

I've still not been able to make anything go wrong in my testing.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
