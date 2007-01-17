Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 17 Jan 2007 03:01:19 -0800 (PST)
Received: from waldorf.loreland.org (ip186.digipost.co.nz [203.110.30.186] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0HB1Cqw028140
	for <xfs@oss.sgi.com>; Wed, 17 Jan 2007 03:01:14 -0800
Received: from localhost (localhost [127.0.0.1])
	by waldorf.loreland.org (Postfix) with ESMTP id DAFCD428A0D
	for <xfs@oss.sgi.com>; Thu, 18 Jan 2007 00:00:16 +1300 (NZDT)
Received: from waldorf.loreland.org ([127.0.0.1])
	by localhost (waldorf.loreland.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id nUTMnzRbYGb8 for <xfs@oss.sgi.com>;
	Thu, 18 Jan 2007 00:00:14 +1300 (NZDT)
Received: from colo.loreland.org (localhost [127.0.0.1])
	by waldorf.loreland.org (Postfix) with ESMTP id D568341AD46
	for <xfs@oss.sgi.com>; Thu, 18 Jan 2007 00:00:14 +1300 (NZDT)
Message-ID: <53858.193.203.83.22.1169031614.squirrel@colo.loreland.org>
In-Reply-To: <32920.193.203.83.22.1168965042.squirrel@colo.loreland.org>
References: <32920.193.203.83.22.1168965042.squirrel@colo.loreland.org>
Date: Thu, 18 Jan 2007 00:00:14 +1300 (NZDT)
Subject: Re: problem with latest xfsprogs progress code
From: "James Braid" <jamesb@loreland.org>
Reply-To: jamesb@loreland.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I'm now seeing the following output - it's been sitting at this point for
over 13 hours now... earlier versions of xfs_repair would finish quite a
bit faster. Any ideas whats going on?

        - 03:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 03:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 03:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 03:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 04:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 04:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 04:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 04:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 05:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 05:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 05:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 05:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 06:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 06:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 06:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 06:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 07:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 07:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 07:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 07:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 08:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 08:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 08:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 08:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 09:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 09:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 09:30:37: traversing filesystem - 0 of 55 allocation groups done
        - 09:45:37: traversing filesystem - 0 of 55 allocation groups done
        - 10:00:37: traversing filesystem - 0 of 55 allocation groups done
        - 10:15:37: traversing filesystem - 0 of 55 allocation groups done
        - 10:30:37: traversing filesystem - 0 of 55 allocation groups done



> Running 2.8.18 xfs_repair on a largeish (65TB, ~70M inodes) filesystem on
> an x86_64 machine gives the following "progress" output:
>
> 12:15:36: process known inodes and inode discovery - 1461632 of 0 inod
> es done
> 12:15:36: Phase 3: elapsed time 14 minutes, 32 seconds - processed 100
> 571 inodes per minute
> 12:15:36: Phase 3: 0% done - estimated remaining time 3364 weeks, 3 da
> ys, 7 hours, 30 minutes, 45 seconds
>
> Is this a known bug?
>
> Thanks, James
>
>
>
