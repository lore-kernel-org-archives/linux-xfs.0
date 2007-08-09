Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 08 Aug 2007 18:54:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l791sJbm029348
	for <xfs@oss.sgi.com>; Wed, 8 Aug 2007 18:54:49 -0700
Message-ID: <46BA7446.6060604@sgi.com>
Date: Thu, 09 Aug 2007 11:56:22 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_repair doesn't handle fsblock != dirblock sizes properly
References: <op.tv3xwmv03jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tv3xwmv03jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

It is looking good Barry,

Regards,
Vlad

Barry Naujok wrote:
> Part of the improved xfs_repair performance speedups, the
> prefetch/dir block handling code made sure the I/Os are the
> same size between phases. Unfortunately, the blocks are
> too small - directories were broken up into fsblock sizes
> instead of dirblock sizes.
>
> The attached patch fixes this regression up.
