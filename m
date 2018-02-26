Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34004 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751094AbeBZXns (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Feb 2018 18:43:48 -0500
Subject: Re: [RFC] mkfs config file bikeshed now!
References: <20180226224224.GE19312@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <de068f62-970c-8d31-a838-dba0a8c75091@sandeen.net>
Date: Mon, 26 Feb 2018 17:43:47 -0600
MIME-Version: 1.0
In-Reply-To: <20180226224224.GE19312@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On 2/26/18 4:42 PM, Darrick J. Wong wrote:

> For example, say we had a /etc/xfs.conf file shipping with xfsprogs:
> 
> [defaults]
> metadata.crc = false
> naming.ftype = false
> 
> [rhel7]
> metadata.crc = true

Oh, one more thing.  Let's not arbitrarily decide that the commandline
uses 1/0 but the configfile uses true/false.  I'd really like as much 
1:1 consistency here as possible.

-Eric
