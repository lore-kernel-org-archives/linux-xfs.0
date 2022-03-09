Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB15C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 23:45:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbiCIXq3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 18:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiCIXq2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 18:46:28 -0500
Received: from server.atrad.com.au (server.atrad.com.au [150.101.241.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E08C7D5E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 15:45:27 -0800 (PST)
Received: from marvin.atrad.com.au (IDENT:1008@marvin.atrad.com.au [192.168.0.2])
        by server.atrad.com.au (8.17.1/8.17.1) with ESMTPS id 229NjPth024756
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 10:15:26 +1030
Date:   Thu, 10 Mar 2022 10:15:25 +1030
From:   Jonathan Woithe <jwoithe@just42.net>
To:     linux-xfs@vger.kernel.org
Subject: Re: Clarifying XFS behaviour for dates before 1901 and after 2038
Message-ID: <20220309234524.GE11763@marvin.atrad.com.au>
References: <20220309072303.GE12332@marvin.atrad.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220309072303.GE12332@marvin.atrad.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-MIMEDefang-action: accept
X-Scanned-By: MIMEDefang 2.86 on 192.168.0.1
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all

On Wed, Mar 09, 2022 at 05:53:03PM +1030, Jonathan Woithe wrote:
> Turning to PC-2, things became confusing.  This older environment also has an
> xfs created many years ago.  Two tests were run:
> 
>  * > touch -d '1800/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 1800-01-01 02:23:45.670000000 +0914 foobar
> 
>  * > touch -d '2100/01/01 02:23:45.67' foobar
>    > ls --full-time foobar
>    -rw-r--r-- 1 jwoithe users 0 2100-01-01 02:23:45.670000000 +1030 foobar
> 
> ... However, it seems that the system somehow manages to store the
> out-of-bound years.  Doing so has an interesting effect on the timezone
> offset for the pre-1901 years, ...

Following the information provided by Darrick I still wanted to understand
the "+0914" timezone offset.  I've done some research and it turns out that
prior to 1 February 1895 the time zone in this part of the world really was
UT+0914 (or, to be entirely accurate, UT+0914.5) [1].  In those days noon
was defined to be the time that sun was directly overhead, hense the
odd-ball timezone.  The "+0914" timezone reported in the year-1800 case is
therefore correct.

Regards
  jonathan

[1] https://sahistoryhub.history.sa.gov.au/subjects/time
