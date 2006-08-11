Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 12:44:57 -0700 (PDT)
Received: from tetsuo.zabbo.net (tetsuo.zabbo.net [207.173.201.20])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7BJifDW026007
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 12:44:43 -0700
Received: from [192.168.110.21] (kei.pdx.zabbo.net [192.168.110.21])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by tetsuo.zabbo.net (Postfix) with ESMTP id BFA812FD0423
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 10:43:14 -0700 (PDT)
Message-ID: <44DCC1B0.70003@oracle.com>
Date: Fri, 11 Aug 2006 10:43:12 -0700
From: Zach Brown <zach.brown@oracle.com>
MIME-Version: 1.0
Subject: xfs_end_io_direct() with negative size?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


So, I was lost in fs/direct-io.c chasing yet another bug when I noticed
that a recent unrelated change might have changed the semantics of the
end_io() call.

   http://www.kernel.org/hg/linux-2.6/?cs=34c151cf341f

Notice how that changes the aio path to set 'transferred' to -EIO based
on dio->io_error before calling dio_complete() instead of after, like
the sync path does with its possibly negative 'ret'.

So it looks like xfs_end_io_direct() can now get a -ve size if, say,
someone unplugs a drive part-way through a dio+aio write.  There's an
ASSERT() in there that makes me wonder if this is something we should be
worrying about.

- z
