Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44316 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756235AbeFOVsb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 17:48:31 -0400
Subject: Re: [PATCH] libxfs: detect zoned disks and prevent their raw use
References: <20180615205011.7728-1-mcgrof@kernel.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5fbcde14-fdb8-9a4f-e578-4ad7c4ef6315@sandeen.net>
Date: Fri, 15 Jun 2018 16:48:29 -0500
MIME-Version: 1.0
In-Reply-To: <20180615205011.7728-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, snitzer@redhat.com, hare@suse.de, axboe@kernel.dk, mwilck@suse.com, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <Bart.VanAssche@wdc.com>



On 6/15/18 3:50 PM, Luis R. Rodriguez wrote:
> +	if (ret == 1) {
> +		fprintf(stderr,
> +_("%s: zoned disk detected, refer to dm-zoned-tools for how to use with XFS\n"),
> +			path);
> +		exit(1);

Sorry for not sending this before V2, but is "dm-zoned-tools" established enough
in the ecosystem at this point to embed it in help text of utilities like this?

(It's not in debian or in fedora, so that message might lead to some head-scratching,
I think)

-Eric
