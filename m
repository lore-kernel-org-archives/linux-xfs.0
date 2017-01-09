Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38296 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759111AbdAITny (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Jan 2017 14:43:54 -0500
Subject: Re: [RFC PATCH 00/22] mkfs.xfs: Make stronger conflict checks
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <77136311-8df7-19c3-0567-ac387fb8af2e@sandeen.net>
Date: Mon, 9 Jan 2017 13:43:52 -0600
MIME-Version: 1.0
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 12/7/16 7:27 AM, Jan Tulak wrote:
> Hi guys,

...


> Number one is simple: What values can use block/sector sizes as user input?
> There is an inconsistency or ambiguity between manual page and the code. Look
> at man page for -d agsize.
> 
> 	agsize=value
> 		This is an alternative to using the  agcount  subop‐
> 		tion.  The  value is the desired size of the alloca‐
> 		tion group expressed in bytes (usually using  the  m
> 		                     ^^^^^^^^
> 		or  g  suffixes).   This value must be a multiple of
> 		[ ... ]
> 

Ok, 'm' and 'g' are just given as examples here, not an exhaustive list.

> The option -d agsize explicitly states that it accepts size in bytes, in a
> similar tone to the one used for describe allowed values for -s/-b size:
> 
> 	value in bytes with size=value
> 	      ^^^^^^^^
> 
> However, -d agsize=1234s input was accepted as valid until now. Is the manual
> page misleading, or are the options where b/s suffix is forbidden are
> block/sector size definitions? I decided to err on the compatibility side and
> kept the current behaviour - only blocksize or sectorsize can't be stated in
> blocks and sectors, but it can be easily changed.
> 
> I will send an update for xfstests once I know what behaviour is correct.

cvtnum() handles 'b' and 's' along with all the other more normal logarithmic
modifiers (k, m, g, t, p, e) so I think there's no real reason to exclude
'b' or 's' from options that take bytes.  cvtnum() today already makes sure
that the appropriate multiplier unit (for b or s) is available at the time
of the call, so that all seems ok code-wise.

(Honestly, while saying "-s size=512 -b size=8s" seems a bit weird, it's
not wrong, so I see no reason to exclude it.  Of course the sector size
cannot be specified in sector units... :) )

I see no problem with allowing s and b as units for any option as long as
the underlying unit is available by the time it's processed.
 
> 
> The other question about this patchset is: As we are saving all the values in
> the opt_params table, and the values have different types, I thought it
> necessary to not use a single data type for everything and created an union
> field (could be easily changed to struct, that would not change anything
> important). Do you see any non-adressed issue with this approach? Is there
> another way how to solve the problem?

I think it'll take a read through the patches to properly answer this one :)

-Eric
