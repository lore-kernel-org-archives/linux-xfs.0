Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2ADAEB64D7
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Jun 2023 11:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbjFULg1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjFULg0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2023 07:36:26 -0400
X-Greylist: delayed 435 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Jun 2023 04:36:23 PDT
Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF1E57
        for <linux-xfs@vger.kernel.org>; Wed, 21 Jun 2023 04:36:23 -0700 (PDT)
Received: from tux.applied-asynchrony.com (p5ddd7b2c.dip0.t-ipconnect.de [93.221.123.44])
        by mail.itouring.de (Postfix) with ESMTPSA id 95179E0;
        Wed, 21 Jun 2023 13:29:03 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id 30845F01608;
        Wed, 21 Jun 2023 13:29:03 +0200 (CEST)
Subject: Re: [PATCH] po/de.po: Fix possible typo which makes gettext-0.22
 unhappy
To:     Lars Wendler <polynomial-c@gmx.de>, linux-xfs@vger.kernel.org
References: <20230621105520.17560-1-polynomial-c@gmx.de>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <a08995aa-2003-be8f-dab1-6d8ed6687e12@applied-asynchrony.com>
Date:   Wed, 21 Jun 2023 13:29:03 +0200
MIME-Version: 1.0
In-Reply-To: <20230621105520.17560-1-polynomial-c@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-06-21 12:55, Lars Wendler wrote:
> diff --git a/po/de.po b/po/de.po
> index 944b0e91..a6f8fde1 100644
> --- a/po/de.po
> +++ b/po/de.po
> @@ -3084,7 +3084,7 @@ msgstr "%llu Spezialdateien\n"
>   #: .././estimate/xfs_estimate.c:191
>   #, c-format
>   msgid "%s will take about %.1f megabytes\n"
> -msgstr "%s wird etwa %.lf Megabytes einnehmen\n"
> +msgstr "%s wird etwa %.1f Megabytes einnehmen\n"

I don't see the difference..?
Both the added and removed line are the same.

-h
