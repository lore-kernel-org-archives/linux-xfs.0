Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p078pmSZ018346 for <xfs@oss.sgi.com>; Fri, 7 Jan 2011 02:51:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2E01E1D1596A
	for <xfs@oss.sgi.com>; Fri,  7 Jan 2011 00:53:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id eEJ2lTD2V2phg6mC for
	<xfs@oss.sgi.com>; Fri, 07 Jan 2011 00:53:57 -0800 (PST)
Date: Fri, 7 Jan 2011 03:53:57 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] xfs: factor common write setup code
Message-ID: <20110107085357.GB10829@infradead.org>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-8-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1294116518-14908-8-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 04, 2011 at 03:48:37PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The buffered IO and direct Io write paths share a common set of
> checks and limiting code prior to issuing the write. Factor that
> into a common helper function.

Wouldn't it be better to create the helper before duplicating the code,
aka move it before the buffer/direct splits in the series?

> +	/*
> +	 * If we're writing the file then make sure to clear the setuid and
> +	 * setgid bits if the process is not being run by root.  This keeps
> +	 * people from modifying setuid and setgid binaries.
> +	 */
> +	error = file_remove_suid(file);
> +	return error;

just

	return file_remove_suid(file);
?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
