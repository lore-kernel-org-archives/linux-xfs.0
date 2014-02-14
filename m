Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 36F127F73
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 21:56:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1014AC00C
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 19:56:40 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 3jK6PO6folFlezuS for <xfs@oss.sgi.com>;
	Thu, 13 Feb 2014 19:56:36 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id E43FD6519A6D
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 21:56:35 -0600 (CST)
Message-ID: <52FD93F3.4010506@sandeen.net>
Date: Thu, 13 Feb 2014 21:56:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/7] xfs: add xfs_verifier_error()
References: <52F99426.3010409@sandeen.net> <52F9957A.4050301@sandeen.net>
In-Reply-To: <52F9957A.4050301@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

On 2/10/14, 9:14 PM, Eric Sandeen wrote:
> We want to distinguish between corruption and CRC errors.
> In addition, the full stack trace on verifier errors
> seems less than helpful; it looks more like an oops than
> corruption.
> 
> Create a new function to specifically alert the user to
> verifier errors, which can differentiate between
> EFSCORRUPTED and CRC mismatches.  It doesn't dump stack
> unless the xfs error level is turned up high.
> 
> Define a new error message (EFSBADCRC) to clearly identify
> CRC errors.  (Defined to EILSEQ, bad byte sequence)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

...

> +void
> +xfs_verifier_error(
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +	xfs_alert(mp,
> +"Metadata %s detected at %pF, block 0x%llx. Unmount and run xfs_repair",
> +		  bp->b_error == EFSBADCRC ? "CRC error" : "corruption",
> +		  __builtin_return_address(0), bp->b_bn);
> +
> +	if (xfs_error_level >= XFS_ERRLEVEL_LOW)
> +		xfs_hex_dump(bp->b_addr, 64);

This needs to handle the case where we have a page array rather than a b_addr, as well.

(The existing calls to XFS_CORRUPTION_ERROR would have oopsed on this too)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
