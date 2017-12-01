Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45632 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750742AbdLAQGw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Dec 2017 11:06:52 -0500
Subject: Re: [PATCH 4/5] xfs_io: provide an interface to the scrub ioctls
References: <151094860143.27182.12022983202520916281.stgit@magnolia>
 <151094862514.27182.4461761345656503324.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f35234f7-32ef-9df5-b3c0-4f5d7f671191@sandeen.net>
Date: Fri, 1 Dec 2017 10:06:51 -0600
MIME-Version: 1.0
In-Reply-To: <151094862514.27182.4461761345656503324.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 11/17/17 1:57 PM, Darrick J. Wong wrote:
> +/* Type info and names for the scrub types. */
> +enum scrub_type {
> +	ST_NONE,	/* disabled */
> +	ST_PERAG,	/* per-AG metadata */
> +	ST_FS,		/* per-FS metadata */
> +	ST_INODE,	/* per-inode metadata */
> +};

Actually, I'm a little confused by this, what is ST_NONE intended
to be used for?

You have it for probe, but that sounds more like an ST_FS fs-wide
action.

-Eric
