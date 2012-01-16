Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9831Aak099781 for <xfs@oss.sgi.com>; Fri, 7 Oct 2011 22:01:10 -0500
Message-ID: <4F143F57.9000207@sgi.com>
Date: Mon, 16 Jan 2012 09:16:39 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] mkfs: Refuse to initialize a misaligned device if not
	forced using libblkid [v3]
References: <1323189918-15834-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1323189918-15834-1-git-send-email-cmaiolino@redhat.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On 01/-10/63 13:59, Carlos Maiolino wrote:
> This is a new version of a patch to fix the problem about the usage of 4k
> sector devices when the device is not properly aligned. It makes mkfs to
> refuse to initialize a xfs filesystem if the -f option is not passed at the
> command line, and forces a 512b sector size if the user chooses to force
> the device initialization.
>
...
> +
> +		if (!force_overwrite) {
> +			fprintf(stderr,
> +				_("Use -f to force usage of a misaligned device\n"));


This line wraps.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
