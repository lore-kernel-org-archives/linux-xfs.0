Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 59BD07F3F
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 15:44:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 32EE9304062
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 13:44:38 -0700 (PDT)
Received: from mail-qg0-f47.google.com (mail-qg0-f47.google.com
	[209.85.192.47]) by cuda.sgi.com with ESMTP id SnNgGfKdWMxKEpLb
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 Jun 2014 13:44:36 -0700 (PDT)
Received: by mail-qg0-f47.google.com with SMTP id q108so827511qgd.34
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 13:44:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140624201946.GJ9508@dastard>
References: <CA+o=1OW0OXhzU+b9ACMZzg0dq=B7BSj+yPXD2Vrr9F6mWK8ruQ@mail.gmail.com>
	<20140624201946.GJ9508@dastard>
Date: Tue, 24 Jun 2014 22:44:35 +0200
Message-ID: <CA+o=1OVUxwOGLUPxYMikxaMxS+dptuPshH5pTt2Yg+4CWL=fyg@mail.gmail.com>
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

2014-06-24 22:19 GMT+02:00 Dave Chinner <david@fromorbit.com>:
>
> OK, that doesn't tell us that the problem is a CRC error, just that
> the btree block on disk has problems. I'd recommend an upgrade to
> 3.15 which has much better error reporting in situations like this,
> and it is no longer experimental...

The original error was caused by 3.15, but the error messages were
from 3.14 because that's what Arch install CD uses, and I had to use
the CD because the hosed filesystem was /.
Now that I think about it, setting up another 3.15 installation to try
to recover that FS would be a better idea, but now it's too late.

At any rate, I'm still trying to reproduce this and will surely report
if I succeed. So far, the only thing I've managed to found is that log
record CRC mismatch thing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
