Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98111C352A1
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 14:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiLFOnk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Dec 2022 09:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbiLFOnk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2022 09:43:40 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7E4DE8B
        for <linux-xfs@vger.kernel.org>; Tue,  6 Dec 2022 06:43:36 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id E79965C00C5;
        Tue,  6 Dec 2022 09:43:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 06 Dec 2022 09:43:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=boo.tc; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1670337815; x=
        1670424215; bh=uwLA4Zu0qw2fLlHA76ivFvw0Mz2ykMPkHFnrPlj01BE=; b=B
        0ASfWDG3g9RzH8GQZEsCQevN1PxcnhUm/B7AJBstI2JBCqHr0eraD/zfvcEWV1bn
        EUz+8LHR/YXLrq2TVZcbB1vLShKRD5BJF/WwukbIvCp7BkZ5dd1u//LIc1ukTmTn
        n1T2hAQVwcpbYloyjzCSKTWxroETCEwfDJRUw3cDiJg1jd4PfRHubtzFLe87Yc1j
        YDlK8zwOntaSlpBOCX+BzYmScVgX+ICikYZn1iNCSmVMgJhxD5bCw9/Y/0RJZSy0
        3YLmRyvHZ0B96HRmhuueKT1XXlA7fmjxnh1Mq0ld4t+OZeR/5WNwoBeZFu+Q51qv
        WjXZFQpGCzF/3qKmLS+Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1670337815; x=
        1670424215; bh=uwLA4Zu0qw2fLlHA76ivFvw0Mz2ykMPkHFnrPlj01BE=; b=w
        /Y9RtLkmr2H8+ciWoEq2yqyDzHxpqokPrk1UREDFoyOGVj7/VwPH8XNog01j4WXx
        Exr/Oih/cOAVUvUFWhZeKOY3Rw/LnvHR7RNpEn4qswIs6FtlJk0cHzteyIyOX2cc
        XVrRBCJ9uzmbbVxDj6EeKQzGWNaV8g4lperpkJscmQmL8JyS8r0yW/etMjEBRYd/
        4qvNGLqpL+k24UnvyMmN+2zjwlGuxtF26y0zqlz82oTgvWAD3Z/ZouqM44RYxfOD
        ahR3gQ0tiuzBEYwbepXvJ508SoDyU82IanegS7E7s5seRXxcNNXZ8ye4Krj7H8uU
        VYygTCNzJY8dhxb3oJFqA==
X-ME-Sender: <xms:F1WPY0arZ2rxL4h0Aww7zAz14xHz8m7q0Yulgc1TT2Uatbzr_ekpvw>
    <xme:F1WPY_bsglKFPKxXAGGLefW3jqEAf-L2hA-s90sx4ovwbE0OmkfBEhAMiwNLTdVqN
    Ge6dpWqRqBaDuBE4Q>
X-ME-Received: <xmr:F1WPY-9AzIAPqDB22KUlA9JL_Tci3NWs938yDSAQo298I79kWfRvlKVKR1GdbB7gfrgmZZMmeIM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeigdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdehtddmnecujfgurhepkfffgggfuffhvfevfhgjtgfgsehtjeertddt
    feejnecuhfhrohhmpeevhhhrihhsuceuohhothcuoehlihhsthhssegsohhothgtrdgsoh
    hordhttgeqnecuggftrfgrthhtvghrnhepieeileekgfffffeujefhjeefudetleefudff
    ueelheeuteeivdekheeghfevjeeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomheplhhishhtshessghoohhttgdrsghoohdrthgt
X-ME-Proxy: <xmx:F1WPY-rLhbwBZ4l-oPdazaOtk7EjC0IOMxh6t9EjIGiP89GU--fP1w>
    <xmx:F1WPY_rSJ56jVl_AK4OLB4IJjW3HXR0Ar3V8y-UwCeufDIDNJ9m7Dw>
    <xmx:F1WPY8QM4OmVS-dFkB93rqegaVur21atE98BX3mjFd2qQvP2-OWi_Q>
    <xmx:F1WPY22FGKBRCQe5YpROGRg6fQ-EE9ozXaVx5GEISBedzdbsZJo5BQ>
Feedback-ID: i5869458d:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Dec 2022 09:43:34 -0500 (EST)
Message-ID: <3f7796b5-478a-2660-86a8-caeb2c58851a@bootc.boo.tc>
Date:   Tue, 6 Dec 2022 14:43:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: XFS corruption help; xfs_repair isn't working
Content-Language: en-GB
From:   Chris Boot <lists@bootc.boo.tc>
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
References: <c3fc1808-dbbf-b1c0-36de-1e55be1942e8@bootc.boo.tc>
 <20221129220646.GI3600936@dread.disaster.area> <Y4gNntJTb1dZLejo@magnolia>
 <a019db45-2f05-e2ec-5953-26e20aa9484b@bootc.boo.tc>
In-Reply-To: <a019db45-2f05-e2ec-5953-26e20aa9484b@bootc.boo.tc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01/12/2022 13:00, Chris Boot wrote:
>> I kinda want to see the metadump of this (possibly enormous) filesystem.
> 
> I've asked whether I can share this with you. The filesystem is indeed 
> huge (35TiB) and I wouldn't be surprised if the metadata alone was 
> rather large. What would be the most efficient way of sharing that with 
> you?

I've got approval to send a metadata dump to you. What's the best way of 
getting it over? It's 31GiB uncompressed, 6.5GiB with zstd compression.

Many thanksm
Chris

-- 
Chris Boot
bootc@boo.tc

