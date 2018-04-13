Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52312 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752298AbeDMCGS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Apr 2018 22:06:18 -0400
Subject: Re: New rash of fuzzer bugs on kernel.org bugzilla
References: <0bdeb0e5-fd1d-a4d8-1a1a-f9371b829026@sandeen.net>
 <20180412233605.GC5572@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6f6ac5be-7828-26c9-90df-5953e025592e@sandeen.net>
Date: Thu, 12 Apr 2018 21:06:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180412233605.GC5572@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On 4/12/18 6:36 PM, Dave Chinner wrote:

> FWIW, I'm not that interested in fuzzing v4 filesystems. We know
> they have problems with undetected bit errors and are lacking in
> information on disk to detect a lot of error types. Hence there's
> only so much we can do to harden them.

*nod* - how are you creating these fuzzed images, i.e. what mkfs
do you start with.  Are you randomizing mkfs options, and it just happens
that the ones with problems are the v4 filesystems w/o crcs?  That would
certainly make sense.

Or are you manually restricting the type of filesystems you create for
fuzzing?

-Eric
