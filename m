Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 841D4C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E78223427
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 14:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfH3OgP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 10:36:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4711 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbfH3OgO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 10:36:14 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C02223D966;
        Fri, 30 Aug 2019 14:36:14 +0000 (UTC)
Received: from Liberator-6.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CF4219C69;
        Fri, 30 Aug 2019 14:36:14 +0000 (UTC)
Subject: Re: [PATCH] xfs: log proper length of btree block in scrub/repair
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
References: <f66b01bb-b4ce-8713-c3db-fbbd39703737@redhat.com>
 <20190829082618.GB18614@infradead.org>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <777aa8d3-fee7-d4b3-9a84-4d42e875127a@redhat.com>
Date:   Fri, 30 Aug 2019 09:36:13 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190829082618.GB18614@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 30 Aug 2019 14:36:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 3:26 AM, Christoph Hellwig wrote:
> On Tue, Aug 27, 2019 at 02:17:36PM -0500, Eric Sandeen wrote:
>> xfs_trans_log_buf() takes a final argument of the last byte to
>> log in the buffer; b_length is in basic blocks, so this isn't
>> the correct last byte.  Fix it.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> just found by inspection/pattern matching, not tested TBH...
> 
> Looks good.  And I wonder if we should fix the interface instead,
> as it seems to lead to convoluted coe in just about every caller.

Yup, I had considered that too.

-Eric
 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

