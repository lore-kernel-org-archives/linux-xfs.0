Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33686 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751968AbeAKXMu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:12:50 -0500
Subject: Re: [PATCH 12/27] xfs_scrub: wrap the scrub ioctl
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520356170.2027.18237412048679725855.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9f5dd182-d51a-e52f-c99b-719c712f481b@sandeen.net>
Date: Thu, 11 Jan 2018 17:12:49 -0600
MIME-Version: 1.0
In-Reply-To: <151520356170.2027.18237412048679725855.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:52 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create some wrappers to call the scrub ioctls.

> +/*
> + * Sleep for 100ms * however many -b we got past the initial one.
> + * This is an (albeit clumsy) way to throttle scrub activity.
> + */
> +void
> +background_sleep(void)
> +{
> +	unsigned long long	time;
> +	struct timespec		tv;
> +
> +	if (bg_mode < 2)
> +		return;
> +
> +	time = 100000 * (bg_mode - 1);

<coverity pass>

Probably want to cast the constant(s) to something larger if someone
issues -b $HUGE ... 100000ULL?

-Eric
