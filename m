Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D0A87CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 10:40:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22625AC002
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 08:40:17 -0700 (PDT)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id I6ccsaE77HDA0CGt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 08:40:12 -0700 (PDT)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id A41C420B45
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 17:40:10 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3rX1XV3S73z5vN8
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 17:40:10 +0200 (CEST)
Date: Sat, 18 Jun 2016 17:38:55 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: Re: [PATCH 2/4] Simplify workaround for old glibc getsubopt()
Message-ID: <20160618153855.GA2091@nyan>
References: <20160618145253.GB17768@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618145253.GB17768@nyan>
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

Please ignore this patch and the next:

The installed header linux.h should not redefine the
standard function getsubopt().


Instead might it be possible to remove the workaround all together?
glibc-2.2 (first version which does not need the workaround) was
released in 2000 and even with older glibc when removing the
workaround, it should only make the compiler emit a warning.

Felix

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
