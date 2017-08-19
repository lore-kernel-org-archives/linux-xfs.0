Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:55654 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751017AbdHSBDD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 18 Aug 2017 21:03:03 -0400
Date: Sat, 19 Aug 2017 11:03:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mkfs: rename defaultval to flagval in opts
Message-ID: <20170819010300.GM10621@dastard>
References: <20170818103932.24607-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170818103932.24607-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Aug 18, 2017 at 12:39:32PM +0200, Jan Tulak wrote:
> The old name 'defaultval' was misleading - it is not the default value,
> but the value the option has when used as a flag by an user.

Hmmm - ok, what we have here is the difference between design intent
and the current use of the field.

The design intent is that the defaultval field can contain the
default value for any type of config field. It gets used when a user
either doesn't specify the option or doesn't specify a value for the
option that is being parsed. The special "need value" value tells
the code that there isn't a defined default that can be used, so the
option must be specified with a value.

The current implementation only contains default values for flag
fields, but that doesn't mean we can't use it for fields that are
not flags. And if that's the case, then renaming the field "flagval"
isn't the right thing to do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
