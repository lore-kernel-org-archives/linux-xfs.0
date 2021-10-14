Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B712CC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 07:33:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 950C861108
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 07:33:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhJNHgA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 03:36:00 -0400
Received: from mail.itouring.de ([85.10.202.141]:46068 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230020AbhJNHf7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 03:35:59 -0400
Received: from tux.applied-asynchrony.com (p5ddd741d.dip0.t-ipconnect.de [93.221.116.29])
        by mail.itouring.de (Postfix) with ESMTPSA id 52EEF8F;
        Thu, 14 Oct 2021 09:33:54 +0200 (CEST)
Received: from tux.applied-asynchrony.com (tux.applied-asynchrony.com [192.168.100.222])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by tux.applied-asynchrony.com (Postfix) with ESMTPS id F1AD2F01604;
        Thu, 14 Oct 2021 09:33:53 +0200 (CEST)
Date:   Thu, 14 Oct 2021 09:33:53 +0200 (CEST)
From:   =?ISO-8859-15?Q?Holger_Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>
To:     Dave Chinner <david@fromorbit.com>
cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: Sorting blocks in xfs_buf_delwri_submit_buffers() still
 necessary?
In-Reply-To: <20211013205755.GJ2361455@dread.disaster.area>
Message-ID: <a3df8f39-c030-f36c-d382-8ef297412b@applied-asynchrony.com>
References: <05c69404-cc05-444b-e4b0-1e358deae272@applied-asynchrony.com> <20211013205755.GJ2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463755164-1744602348-1634196833=:6058"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463755164-1744602348-1634196833=:6058
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT


On Thu, 14 Oct 2021, Dave Chinner wrote:

> On Wed, Oct 13, 2021 at 07:13:10PM +0200, Holger Hoffstätte wrote:
>> Hi,
>>
>> Based on what's going on in blk-mq & NVMe land
>
> What's going on in this area that is any different from the past few
> years?

Nothing in particular, just watching Jens pull out all the stops is
interesting, and all sorts of other overheads are peeking out from
under the couch.

>> I though I'd check if XFS still
>> sorts buffers before sending them down the pipe, and sure enough that still
>> happens in xfs_buf.c:xfs_buf_delwri_submit_buffers() (the comparson function
>> is directly above). Before I make a fool of myself and try to remove this,
>> do we still think this is necessary?
>
> Yes, I do.

Ok - I completely forgot about merging adjacent requests, and that
only works if they are somehow sorted. Makes sense.

Thank you for the explanation!

Holger
---1463755164-1744602348-1634196833=:6058--
