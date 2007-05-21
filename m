Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 May 2007 19:15:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L2FIfB000774
	for <xfs@oss.sgi.com>; Sun, 20 May 2007 19:15:21 -0700
Message-ID: <4650FD38.4080408@sgi.com>
Date: Mon, 21 May 2007 12:00:24 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: review: make xfs_dm_punch_hole() atomic when punching EOF
References: <20070419071856.GR48531920@melbourne.sgi.com>
In-Reply-To: <20070419071856.GR48531920@melbourne.sgi.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

It is looking good Dave.

Regards,
Vlad

David Chinner wrote:
> Currently punching a hole to EOF via xfs_dm_punch_hole()
> truncates the file and then extends it. This leaves a small
> window where applications can see an incorrect file size
> while the punch is in progress. This can cause problems
> with DMF leading to premature completion of recalls and
> hence data corruption.
>
> Use the UNRESVSP ioctl rather than FREESP+setattr to punch the
> hole at EOF. This can leave specualtive allocations past EOF,
> so truncate them off so we don't leave blocks that can't be
> migrated away around in the filesystem.
>
> Cheers,
>
> Dave.
>   
