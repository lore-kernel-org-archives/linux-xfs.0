Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46164 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965059AbeFNXio (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 19:38:44 -0400
Subject: Re: [PATCH 0/5] xfsprogs-4.17: mkfs config file enhancements
References: <152891829964.3968.4760134019673731615.stgit@magnolia>
 <20180614040628.GJ10363@dastard>
 <c4ae2aaf-ee28-5c35-b3f5-ffe8a57d3c01@sandeen.net>
 <20180614050844.GK10363@dastard> <20180614062949.GA6825@magnolia>
 <20180614233350.GM10363@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <28c144a2-2621-0e88-7c0c-245ac411ff14@sandeen.net>
Date: Thu, 14 Jun 2018 18:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <20180614233350.GM10363@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org



On 6/14/18 6:33 PM, Dave Chinner wrote:
> That's kinda what I'm getting at here - shipping config templates
> in /etc seems to be quite unusual, and the location for example
> config files is largely a distro packaging choice. i.e. the distro
> package mantainer decides on whether a template is shipped and where
> it is located, and that usually follows distro packaging guidelines.
> 
> IOWs, for the debian package build we should probably be putting
> mkfs config template file into
> /usr/share/doc/xfsprogs/examples/mkfs.conf, not /etc/xfs/....

So imho we should put an example in /doc, or a fully-commented-out
config file in /etc (apache/dovecot/postfix do that, IIRC)

It doesn't really matter to me which one we do, though because we
decided to print the "defaults config file" source at mkfs time, printing
that for a file which does nothing is a bit of a surprise.  From
that perspective, I guess /doc sounds a little better to me.

-Eric
