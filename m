Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60104 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbeLFUen (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Dec 2018 15:34:43 -0500
Subject: Re: [PATCH 1/4 RESEND] xfsdump: (style) remove trailing whitespaces
References: <20181128165649.56853-2-jtulak@redhat.com>
 <20181206120430.53941-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ba8eed0a-d90b-b5db-2002-f2dfa7ef972b@sandeen.net>
Date: Thu, 6 Dec 2018 14:34:42 -0600
MIME-Version: 1.0
In-Reply-To: <20181206120430.53941-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com



On 12/6/18 6:04 AM, Jan Tulak wrote:
> RESEND. It seems that I edited the patch file with an editor that stripped
> the blank spaces that should be stripped by the patch. Sorry. :-D
> Now I verified that the file contains the whitespaces before sending, so
> hopefully it will apply.
> 
> Jan
> 
> ---
> 
> There were many trailing whitespaces through the whole code. As the rate
> of changes in xfsdump is low, it should not cause trouble if we fix it
> in all files at once and avoid issues (unintended changes) with sensibly
> configured editors that automatically remove these on a file save.
> 
> Created by this script:
> 
> #!/usr/bin/env bash
> # remove trailing whitespaces
> 
> find . -name '*.[ch]' ! -type d -exec bash -c '
> sed -i \
>     -e "s/\s*$//" \
>     $0
> ' {} \;
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

# grep "^-" 1-4-RESEND-xfsdump-style-remove-trailing-whitespaces | grep -v "^---" |  grep -v " $" | grep -vP "\t$" 
#

looks legit ;)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Note, please put informational updates like your "RESEND" note /below/
the "---" in a patch, so they don't become part of the commit log
(I'll edit this one out)

i.e.:

[ Normal commit log goes here]
[Signed off by etc goes at the end]
---
[informational info here, diffstat, version updates, etc]
[actual patch follows]

-Eric
