Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49338 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfEOUrR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 May 2019 16:47:17 -0400
Subject: Re: [PATCH] xfsdump: (style) remove spaces for pointers and negations
References: <20190515130340.45155-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <eee66375-48aa-71e5-9a34-a6861aa566be@sandeen.net>
Date: Wed, 15 May 2019 15:47:16 -0500
MIME-Version: 1.0
In-Reply-To: <20190515130340.45155-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 5/15/19 8:03 AM, Jan Tulak wrote:
> Another case of different xfsdump style, spaces around * and !
> operators. This style was used a lot through xfsdump:
> (* foo_t)xxx
>   ^ space
> While the rest of XFS omits the space. Same for negations:
> if (! foo)
> 
> This patch changes all occurrences to comply with the rest of xfs/kernel
> coding style by removing the space. Unlike the previous patches, this
> one is not fully replicable by a script - I had to manually correct many
> cases of overzealous replacements in comments or strings.
> (Regular expressions are a too weak tool for these context-sensitive
> changes.)
> 
> Still, the script that did most of the job is here:
> 
> find . -name '*.[ch]' ! -type d -exec gawk -i inplace '{
>     $0 = gensub(/^([^"]*)\(\* /, "\\1(*", "g") # foo(* bar
>     $0 = gensub(/\(\* ([^"]*)$/, "(*\\1", "g") #
>     $0 = gensub(/^([^ *#]{2}[^"]*)! /, "\\1!", "g") # space after exclamation mark
> }; {print }' {} \;
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

(starts reading it all, eventually resorts to skimming & spot-checking ...)

Looks good, thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
