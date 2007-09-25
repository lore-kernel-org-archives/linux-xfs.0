Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 17:32:36 -0700 (PDT)
Received: from smtp116.sbc.mail.sp1.yahoo.com (smtp116.sbc.mail.sp1.yahoo.com [69.147.64.89])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8P0WWQ3006341
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 17:32:33 -0700
Date: Mon, 24 Sep 2007 17:32:32 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: [PATCH] lose xfs_hex_dump in favor of print_hex_dump
Message-ID: <20070925003232.GA26663@puku.stupidest.org>
References: <46F85240.1060206@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F85240.1060206@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 24, 2007 at 07:11:44PM -0500, Eric Sandeen wrote:

> +extern void xfs_hex_dump(void *p, int length);
> +

> +void
> +xfs_hex_dump(void *p, int length)
> +{
> +	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
> +}

Is this symbol exported/needed?  If not then why not make it a #define
or an inline in the header where you have the prototype?
