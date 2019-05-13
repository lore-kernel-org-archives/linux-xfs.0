Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbfEMPwF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 May 2019 11:52:05 -0400
Subject: Re: [PATCH v2] xfsdump: (style) remove spaces in front of
 commas/semicolons
References: <20190506115212.9876-1-jtulak@redhat.com>
 <20190507120223.17689-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f3361cf0-cf79-feb2-12f9-3731860bc961@sandeen.net>
Date: Mon, 13 May 2019 10:52:04 -0500
MIME-Version: 1.0
In-Reply-To: <20190507120223.17689-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 5/7/19 7:02 AM, Jan Tulak wrote:
>     Turn all the "x , y , z" into "x, y, z" and "for (moo ; foo ; bar)"
>     to "for (moo; foo; bar)". The only exception is a double semicolon surrounded
>     by some other commands, e.g. for(bar ; ; baz), for increased readability.
> 
> Created by this script:
> *****
> #!/usr/bin/env bash
> set -euo pipefail
> # remove the space before , and ;
> 
> # regex explanation:
> # We are avoiding strings - replacing only those spaces that are not surrounded
> # by ". At the same time, we want to ignore also those cases, where
> # there are only whitespace in front of the commas/semicolons, as those are
> # likely aligned. At the end, return a space between two semicolons in cases
> # like for (foo ; ; bar), where the spaces are important for readability.
> 
> find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
>     $0 = gensub(/^([^"]*[^[:space:]"][^"]*) ,/, "\\1,", "g")
>     $0 = gensub(/^([^"]*[^[:space:]"][^"]*) ;/, "\\1;", "g")
>     $0 = gensub(/^(.*[^[:space:]"].*) ,([^"]*)$/, "\\1,\\2", "g")
>     $0 = gensub(/^(.*[^[:space:]"].*) ;([^"]*)$/, "\\1;\\2", "g")
>     $0 = gensub(/([^([:space:]]);;([^\n])/, "\\1 ; ;\\2", "g")
> }; {print }' {} \;
> *****
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
> CHANGES:
> v2: special cases: for (foo ; ; bar) can keep the spaces, a few more
> lines that were skipped before have been added.

Thanks, I've committed & pushed this change.

-Eric
