Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 09:04:31 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3BG4Bx6020029
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 09:04:12 -0700
Date: Fri, 11 Apr 2008 12:04:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] remove CONFIG_XFS_SECURITY
Message-ID: <20080411160448.GA26929@infradead.org>
References: <47819E47.4030906@sandeen.net> <47BB7774.5080401@sandeen.net> <47F985BA.7060100@sgi.com> <47FF781D.2020006@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FF781D.2020006@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Timothy Shimmin <tes@sgi.com>, xfs-oss <xfs@oss.sgi.com>

> +#define XFS_SECURITY_STRING	"security attributes, "

This one should just be killed completely, as it's not an optional
feature anymore.
