Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 14:32:28 -0700 (PDT)
Received: from mail.goop.org (gw.goop.org [64.81.55.164])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4ALWPfB010384
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 14:32:26 -0700
Message-ID: <46438F67.9060503@goop.org>
Date: Thu, 10 May 2007 14:32:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Subject: Re: 2.6.21-git10/11: files getting truncated on xfs? or maybe an
 nlink problem?
References: <4642389E.4080804@goop.org> <20070509231643.GM85884050@sgi.com> <4642598E.3000607@goop.org> <20070510000119.GO85884050@sgi.com> <46426194.3040403@goop.org> <20070510004918.GS85884050@sgi.com> <46426D31.8070000@goop.org> <20070510012609.GU85884050@sgi.com> <46433049.4020003@goop.org> <20070510211348.GC86004887@sgi.com>
In-Reply-To: <20070510211348.GC86004887@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>, xfs@oss.sgi.com, michal.k.k.piotrowski@gmail.com

David Chinner wrote:
> Ok, so most of the of the integrity errors are processed by an
> error like this:
>
> drivers/scsi/sata_sil24.c index contains -98 extra bytes
> unpacking file drivers/scsi/sata_sil24.c 5715cdfceaca: Error -5 while decompressing data
>
> That's an -EIO and not a normal error to report. Are there any
> errors in dmesg or syslog corresponding to this?
>   

No, that's an error code from zlib:
#define Z_BUF_ERROR    (-5)

I think it means it got a truncated buffer while decompressing.

> The errors tend to imply problems decompressing and patching files,
> not that truncates are occurring once the files have been patched.
> Can you check that what is being pulled from the repository is correct
> before it gets uncompressed?
>   

The hg verify checks the integrity of all the files by decompressing
them and making sure their sha1 hashes are correct.  The fact that the
first hg verify passed is a very strong check that the whole repo's
integrity is sound, both in structure and content.  The second failing
hg verify's messages are all related to truncation.  I haven't checked
this comprehensively, but in every instance I've checked the files are
identical up to the truncation point.  All the error messages are
consistent with pure truncation, not content differences or IO errors.

    J
