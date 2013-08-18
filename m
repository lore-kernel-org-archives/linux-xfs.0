Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4190B7F6D
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 16:51:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1D43AC001
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 14:51:55 -0700 (PDT)
Received: from mail-oa0-f42.google.com (mail-oa0-f42.google.com
	[209.85.219.42]) by cuda.sgi.com with ESMTP id bUhp0PqmctfFHTwm
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 18 Aug 2013 14:51:54 -0700 (PDT)
Received: by mail-oa0-f42.google.com with SMTP id i18so4690666oag.1
	for <xfs@oss.sgi.com>; Sun, 18 Aug 2013 14:51:54 -0700 (PDT)
Message-ID: <521141F5.9030703@gmail.com>
Date: Sun, 18 Aug 2013 17:51:49 -0400
From: Joe Landman <joe.landman@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS recovery resumes...
References: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <11558272.4016.1376861936621.JavaMail.root@benjamin.baylink.com>
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

On 08/18/2013 05:38 PM, Jay Ashworth wrote:
> I'm trying to dedupe the two large XFS filesystems on which I have DVR
> recordings, so that I can walk around amongst the available HDDs and create
> new filesystems under everything.


[...]

> duckling:/appl/downloads/xfsprogs # xfs_repair /dev/sda1
> Phase 1 - find and verify superblock...
> Not enough RAM available for repair to enable prefetching.
> This will be _slow_.
> You need at least 497MB RAM to run with prefetching enabled.

                     ^^^^^

This is 1/2 GB ram, and you didn't specify the memory options of the 
xfs_repair ... so I'm going to guess at this point that you ran out of 
ram.  Paging while running xfs_repair is no fun.

How much ram do you have in this box?  Next question is, is this an ECC 
memory box?

Not sure if you are hitting a bug as much as running into something else 
like a hardware limit (RAM) or a memory stick issue.

Do you have EDAC (or mcelog) on?  Any errors from this?

Joe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
