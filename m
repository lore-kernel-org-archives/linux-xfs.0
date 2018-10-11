Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33600 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbeJKNXb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 09:23:31 -0400
Date: Wed, 10 Oct 2018 22:57:47 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/18 V2] xfsprogs: enable sparse checking with "make
 C=[12]"
Message-ID: <20181011055747.GA20811@infradead.org>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-2-git-send-email-sandeen@redhat.com>
 <3048f94d-191c-0e62-1a3b-a0ec0e4b8374@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3048f94d-191c-0e62-1a3b-a0ec0e4b8374@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

> -sparse and gcc using:
> +The xfsprogs Makefile has a convenient shortcut to running sparse, by setting
> +the C ("check") variable on the make commandline.  To perform generic checks,
> +
> +	make C=1
> +
> +which checks with -Wsparse-all -Wno-transparent-union -Wno-return-void
> +-Wno-undef -Wno-non-pointer-null, or to perform the bitwise checks, use
> +
> +	make C=2
> +
> +which checks with -Wbitwise -D__CHECK_ENDIAN__

Out of all the sparce checks applicable to xfsprogs endianess is by
far the most impotant one.  I don't think it makes any sense to ever
turn it off..
