Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51632 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750966AbdEIDCR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 May 2017 23:02:17 -0400
Subject: Re: [PATCH v2] xfs: make fatal assert failures conditional in debug
 mode
References: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
 <20170505230943.GG17542@dastard> <20170508125530.GA29840@bfoster.bfoster>
 <20170508231448.GH17542@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fb356789-56ab-757c-7c5f-b90d9ffbb1ea@sandeen.net>
Date: Mon, 8 May 2017 22:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <20170508231448.GH17542@dastard>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On 5/8/17 6:14 PM, Dave Chinner wrote:
>> So for me, the ability to live switch between BUG() or warn in debug
>> mode doesn't add value. In fact, it is less ideal than just being able
>> to (re)compile a kernel module and load it with expected behavior. That

> Who uses kernel modules for testing?

I do, all the time.

FWIW.  ;)

-Eric
