Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51992 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752182AbdCOPWH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 11:22:07 -0400
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <1702693.ETbqtf3ybS@libor-nb>
 <503a4130-e6db-2d14-d377-01336022d6ee@sandeen.net>
 <74482935.PWezjV9Qp4@libor-nb>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <64592e33-6597-a4b4-3e1a-3ec41beeda8c@sandeen.net>
Date: Wed, 15 Mar 2017 10:22:05 -0500
MIME-Version: 1.0
In-Reply-To: <74482935.PWezjV9Qp4@libor-nb>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?UTF-8?B?TGlib3IgS2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 3/15/17 5:07 AM, Libor Klepáč wrote:
> Hello,

...

>> Unfortunately the read path is a bit less interesting.  We found something
>> on disk, but we're not sure how it got there.
>> If we could catch a write verifier failing that /might/ be a little more
>> useful.
> 
> I'm prepared to run all affected hosts with error_level=11 , if it doesn't mean performance hit.

It shouldn't.  It only changes logging behavior on error.  The printks to the
console probably take a bit of extra time but at that point you've already lost,
right?

-Eric
