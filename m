Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35122 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdL1Vpf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Dec 2017 16:45:35 -0500
Subject: Re: [PATCH 4/7] mkfs: support arbitrary conflict specification
From: Eric Sandeen <sandeen@sandeen.net>
References: <20171218091158.14537-1-david@fromorbit.com>
 <20171218091158.14537-5-david@fromorbit.com>
 <20171220025346.GL12613@magnolia> <20171220035227.GD4094@dastard>
 <c68f5c12-f15c-8925-1a61-efb67503b212@sandeen.net>
Message-ID: <7bc06387-00a3-89e1-8159-3bb23b1fd97b@sandeen.net>
Date: Thu, 28 Dec 2017 13:45:32 -0800
MIME-Version: 1.0
In-Reply-To: <c68f5c12-f15c-8925-1a61-efb67503b212@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>



On 12/24/17 12:45 PM, Eric Sandeen wrote:
> I could do it on commit if you like (not sure I should get into that
> habit...).
> 
> :%s/{ &.*, LAST_CONFLICT/{ NULL, LAST_CONFLICT/g

Meh, that affects many follow on patches, but I've already done it,
so if you give me the thumbs up I'll go ahead and commit it that way.

Thanks,
-Eric
