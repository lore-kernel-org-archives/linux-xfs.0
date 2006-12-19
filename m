Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 15:31:29 -0800 (PST)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJNVKqw007731
	for <xfs@oss.sgi.com>; Tue, 19 Dec 2006 15:31:23 -0800
Subject: Re: [PATCH] rethink removal of xattr syscall stubs (for now)
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20061219100506.GA22779@infradead.org>
References: <1166490658.5572.89.camel@edge>
	 <20061219100506.GA22779@infradead.org>
Content-Type: text/plain
Date: Wed, 20 Dec 2006 10:31:09 +1100
Message-Id: <1166571069.5572.117.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: bnaujok@sgi.com, xfs@oss.sgi.com, agruen@suse.de

On Tue, 2006-12-19 at 10:05 +0000, Christoph Hellwig wrote:
| > Please apply as an interim fix to the original problem and to
| > the accidental new problems its caused, and I'll push through a
| > new patch in the new year.
| 
| There is a way to re-export symbols you imported from another
| library with symbol versioning.  That how for example libpthread
| works on recent Solaris versions.  I'll find out how exactly that
| should be implemented.

Ah, that sounds ideal - thanks!

-- 
Nathan
