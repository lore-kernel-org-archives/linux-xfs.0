Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74D3A7F54
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 22:05:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 650B7304048
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:05:47 -0700 (PDT)
Received: from mail-lb0-f170.google.com (mail-lb0-f170.google.com
	[209.85.217.170]) by cuda.sgi.com with ESMTP id
	IvgFBvafP9yYmRnE (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:05:45 -0700 (PDT)
Received: by lbbk10 with SMTP id k10so17474330lbb.0
	for <xfs@oss.sgi.com>; Sun, 11 Oct 2015 20:05:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20151012004539.GA31326@dastard>
References: <1444569791-26719-1-git-send-email-agruenba@redhat.com>
	<20151012004539.GA31326@dastard>
Date: Mon, 12 Oct 2015 05:05:43 +0200
Message-ID: <CAHc6FU6FsJJwYuKBrwbH+Dgr1zv+yj-g=gex8CykXSYPMQmhMQ@mail.gmail.com>
Subject: Re: [PATCH] xfs: Fix error path in xfs_get_acl
From: Andreas Gruenbacher <agruenba@redhat.com>
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

On Mon, Oct 12, 2015 at 2:45 AM, Dave Chinner <david@fromorbit.com> wrote:
> Test case for xfstests?

I don't see an easy way to trigger this bug.

> So the entire patch could simply be replaced by:
>
>                 if (error == -ENOATTR)
>                         goto out_update_cache;
> +               acl = ERR_PTR(error);
>                 goto out;
>         }

If you prefer, yes.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
