Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:55670 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753645AbeFLTpn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Jun 2018 15:45:43 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 92CAC450AB7
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jun 2018 14:45:19 -0500 (CDT)
Subject: Re: [PATCH 2/7] mkfs: move mkfs.xfs.8 to an .in file
From: Eric Sandeen <sandeen@sandeen.net>
References: <1528831883-21879-1-git-send-email-sandeen@sandeen.net>
 <1528831883-21879-3-git-send-email-sandeen@sandeen.net>
Message-ID: <c48879de-0704-8da8-da35-7b5a10fd0339@sandeen.net>
Date: Tue, 12 Jun 2018 14:45:40 -0500
MIME-Version: 1.0
In-Reply-To: <1528831883-21879-3-git-send-email-sandeen@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On 6/12/18 2:31 PM, Eric Sandeen wrote:
> Simple move with no changes, next patch will parameterize @sysconfdir@
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>  man/man8/Makefile      |    8 +-
>  man/man8/mkfs.xfs.8    | 1015 ------------------------------------------------
>  man/man8/mkfs.xfs.8.in | 1015 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1022 insertions(+), 1016 deletions(-)
>  delete mode 100644 man/man8/mkfs.xfs.8
>  create mode 100644 man/man8/mkfs.xfs.8.in

Well crud the point of mv-with-no-changes was to make git detect the
rename :/
