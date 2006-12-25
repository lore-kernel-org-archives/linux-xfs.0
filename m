Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Dec 2006 02:00:28 -0800 (PST)
Received: from taiwan.yingternet.net (taiwan.yingternet.net [59.124.122.220])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBPA0Iqw008793
	for <linux-xfs@oss.sgi.com>; Mon, 25 Dec 2006 02:00:21 -0800
Message-ID: <458FA0F8.1020107@yingternet.com>
Date: Mon, 25 Dec 2006 17:59:20 +0800
From: Ying-Hung Chen <ying@yingternet.com>
MIME-Version: 1.0
Subject: Re: xfs_repair xfsprogs version > 2.8.11
References: <458E643D.3090008@yingternet.com>
In-Reply-To: <458E643D.3090008@yingternet.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com
Cc: Ying-Hung Chen <ying@yingternet.com>

Hi there,

actually, i have trace the code in to xfs_repair/threads.c (taken from
2.8.18)

void
thread_init(void)
{
    ....
    if ((status = pthread_attr_getstacksize(&attr, &stacksize)) != 0)
        do_error(_("status from pthread_attr_getstacksize: %d"),
        status);

    stacksize *= 4;

    if ((status = pthread_attr_setstacksize(&attr, stacksize)) != 0)
        do_error(_("status from pthread_attr_setstacksize: %d"),
        status);
 ....
 }

the repair program dies in pthread_attr_setstacksize(&attr, stacksize)).
is there any reason why the program is trying to set the stacksize into
4 times the current size?

just for testing purposes, I remove the stacksize *= 4; the xfs_repair
seems to 'work', at least from user's point of view.

I have tested with x86 32bits machines with 2.4 and 2.6 kernels, they
both yield with the same results,

Thanks,

-Ying

Ying-Hung Chen wrote:
> Hi there,
> 
> I found that xfs_repair always returns the following message with the
> xfsprogs version > 2.8.11
> 
> [root@yroro i586]# xfs_repair /dev/hdb1
> 
> fatal error -- status from pthread_attr_setstacksize: 22
> 
> from the ChangeLog, seems like there is some internal changes with
> threads starting 2.8.11 .. the xfs_repair works for me up to 2.8.11, it
> fails to work on 2.8.16 and 2.8.18,
> 
> how do I work around this problem?
> 
> Thanks,
> 
> -Ying
> 
