Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5633AC19F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 18:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiHKSq1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 14:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbiHKSq0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 14:46:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3038498D24
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 11:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0FF3B82227
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 18:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950B7C433C1;
        Thu, 11 Aug 2022 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660243583;
        bh=pA49bibcoFSuRpdGAvf0vobL3jaiWH0EvxX+uh3+oRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qrvlsw4nAsCCFAzMn18UKLQALST5O7UgImQvq36fkWJbo55vr4i43CyFW1zKdosHa
         +5IQMktp5DgHDCsnrVqP1XQt6fXLeb758Aqfsyh5DZJDhKzYxG8224+IfF3rO7pNSn
         1sTyHi/gDjPfbTpi6Gvjl7Meo9YId1SvrVYv999inGg661RjxTTeAbq0kJCUbxlN+P
         pJRZguuU2Gn8+tyEuiv7DYqJkF3aOjr66v/IU28lvooEyX4MiXnszA0MhZ9eSCPsy0
         ZfyrnBuCtYdMpToR527W58zQiLBmrrL5+a0m7JOIDPh7e0QlvvwOo50OnZc/3OcYeP
         JEf5j9Vw7k6Bw==
Date:   Thu, 11 Aug 2022 11:46:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: retain superblock buffer to avoid write
 hook deadlock
Message-ID: <YvVOf3gl88K1RbYh@magnolia>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
 <166007921743.3294543.7334567013352169774.stgit@magnolia>
 <YvT6XjTWPKfsPbI7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvT6XjTWPKfsPbI7@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 11, 2022 at 05:47:26AM -0700, Christoph Hellwig wrote:
> Maybe we just simply need to set NEEDSREPAIR for any run that does
> not specify the no-modify flag and avoid this magic lazy behavior?

Heh, which part of the magic lazy behavior?  You asked for the bwrite
hook[1], and then Brian asked for a randomly triggered hook[2] in the
buffer cache IO path to enable testing, which now results in periodic
failures in xfs/155...

[1] https://lore.kernel.org/linux-xfs/20210209091336.GG1718132@infradead.org/
[2] https://lore.kernel.org/linux-xfs/20210212133503.GA321056@bfoster/

> That being said the code looks sane if we can't fix this better by
> just working differently.

There are too many patches in my tree for me to be able to take on more
refactoring.

--D
