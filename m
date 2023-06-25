Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66049EB64DA
	for <linux-xfs@archiver.kernel.org>; Sun, 25 Jun 2023 01:48:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjFYBsP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 24 Jun 2023 21:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjFYBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 24 Jun 2023 21:48:14 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9BA4910C9
        for <linux-xfs@vger.kernel.org>; Sat, 24 Jun 2023 18:48:13 -0700 (PDT)
Received: from [10.0.0.71] (liberator.sandeen.net [10.0.0.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id D8EBC55244F;
        Sat, 24 Jun 2023 20:48:12 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net D8EBC55244F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
        s=default; t=1687657692;
        bh=/jvFBhLYMVIHDGk08ycVNa0HEfr1XNBy04UfXaOTHDA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rRXSkg/7Zjl+Kv9In+UhUNXSZ7XJ8QgkRtNBwyDR8m4g9+MF7sTWYG67rS3TqeFf3
         COqYFaytu11SL5+8gqwa+swXc9g+bg9ZObRbQQnjIvJx1hlUpWNxxiHUuOmB0Zrdmw
         yultLS6m0h8WjQhg8r1gIuSbJXhs2cGZKlcRueLONtssVo7KFCE8hPnZmQsIVbeS4N
         p17+CZsHNnmsD9Damr/RCrLttaPSzLfrOHoz9WvKU4ylMEPmLQuHjTCSwKKOORCcWD
         I6TXO9ftnbpDOKWQ+SNigirPzJNanY2X1e8mxFNytP7cd2dBa/OZ6aKAe/6YK2amEq
         PsC88iXqVPpXw==
Message-ID: <99544e27-0871-6d0e-0576-5f28bc736978@sandeen.net>
Date:   Sat, 24 Jun 2023 20:48:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: xfs_rapair fails with err 117. Can I fix the fs or recover
 individual files somehow?
Content-Language: en-US
To:     Fernando CMK <ferna.cmk@gmail.com>
Cc:     linux-xfs@vger.kernel.org
References: <CAEBim7C575WhuWGO7_VJ62+6s2g4XFFgoF6=SrGX30nBYcD12Q@mail.gmail.com>
 <3def220e-bc7b-ceb2-f875-cffe3af8471b@sandeen.net>
 <CAEBim7DSUKg6TGZ_DKZ1rhbEHpfLN0aBDkc57gkgUgtnnc7xNQ@mail.gmail.com>
 <de3023eb-4481-ae72-183b-2d91f3c25212@sandeen.net>
 <CAEBim7BZsCYxjucpN5R8HpP+BpFezSzZ1QiA1COqU3-MZ18eXQ@mail.gmail.com>
From:   Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <CAEBim7BZsCYxjucpN5R8HpP+BpFezSzZ1QiA1COqU3-MZ18eXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/24/23 1:25 PM, Fernando CMK wrote:
>> It seems that the only problem w/ the filesystem detected by repair is a
>> ridiculously large stripe width, and that's found on every superblock.
> If that's the issue, is there a way to set the correct stripe width?
> Also... the md array involved has 3 disks, if that's of any help.
> 

Yes, you can rewrite each superblock (all 42) with xfs_db in -x mode.

I would suggest trying it on a fresh copy of the image file in case 
something goes wrong.

for S in `seq 0 41`; do
  xfs_db -x -c "sb $S" -c "write swidth 256" <image_file>
done

or something similar

I'm really baffled about how your filesystem possibly got into this 
shape, though.
