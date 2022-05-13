Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6744EC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 13 May 2022 13:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380647AbiEMNSd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 May 2022 09:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380664AbiEMNS2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 May 2022 09:18:28 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 546561260D
        for <linux-xfs@vger.kernel.org>; Fri, 13 May 2022 06:18:17 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 50F327939;
        Fri, 13 May 2022 08:18:13 -0500 (CDT)
Message-ID: <f97e6357-1973-6105-b450-b36d60dc4885@sandeen.net>
Date:   Fri, 13 May 2022 08:18:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 5/6] xfs_scrub: make phase 4 go straight to fstrim if
 nothing to fix
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <165176686186.252160.2880340500532409944.stgit@magnolia>
 <165176688994.252160.6045763886457820977.stgit@magnolia>
 <82de68be-0119-8e2a-c584-def6a0680034@sandeen.net>
 <20220512231253.GJ27195@magnolia>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20220512231253.GJ27195@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/12/22 6:12 PM, Darrick J. Wong wrote:
> On Thu, May 12, 2022 at 05:34:37PM -0500, Eric Sandeen wrote:
>> On 5/5/22 11:08 AM, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> If there's nothing to repair in phase 4, there's no need to hold up the
>>> FITRIM call to do the summary count scan that prepares us to repair
>>> filesystem metadata.  Rearrange this a bit.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>
>>
>>> +
>>> +	/*
>>> +	 * If errors remain on the filesystem, do not trim anything.  We don't
>>> +	 * have any threads running, so it's ok to skip the ctx lock here.
>>> +	 */
>>> +	if (ctx->corruptions_found || ctx->unfixable_errors == 0)
>>> +		return 0;
>>> +
>>> +maybe_trim:
>>> +	trim_filesystem(ctx);
>>> +	return 0;
>>>  }
>>
>> I'm a little confused by the unfixable_errors test, is that correct?
>>
>> Why do you bail out if there are 0 unfixable errors?
> 
> Oooops.  That was a logic inversion bug. :(

I'll fix it up and commit it with:

+	if (ctx->corruptions_found || ctx->unfixable_errors != 0)
+		return 0;

if you want to confirm that's correct?

-Eric
