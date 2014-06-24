Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C69017F4E
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 14:00:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 95CF1304084
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:00:01 -0700 (PDT)
Received: from mail-qa0-f47.google.com (mail-qa0-f47.google.com
	[209.85.216.47]) by cuda.sgi.com with ESMTP id 8A5HDOPIziPOzoe5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:00:00 -0700 (PDT)
Received: by mail-qa0-f47.google.com with SMTP id hw13so620111qab.6
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 12:00:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53A9C7EF.7010707@sandeen.net>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<53A9A295.8030302@sandeen.net>
	<CA+o=1OXJZk2XjZhtEORQesDjb3VGzM1Ddk6DGXwuLhHJUEbjPQ@mail.gmail.com>
	<53A9C7EF.7010707@sandeen.net>
Date: Tue, 24 Jun 2014 21:00:00 +0200
Message-ID: <CA+o=1OXG9wY7pX3emPtRjdAQKC4MFKvJWiJsmD7yGmuJeXjPQQ@mail.gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

2014-06-24 20:48 GMT+02:00 Eric Sandeen <sandeen@sandeen.net>:
> FWIW, I've been unable to reproduce this in about 4 attempts, using
> virtualbox, and doing a guest reset.

Same here. The most breakage I can get is a log record CRC mismatch
(still a bug, I think). I will report if I run across a metadata CRC
error ever again.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
