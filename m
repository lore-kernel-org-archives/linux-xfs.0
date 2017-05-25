Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53974 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424777AbdEYR3G (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 May 2017 13:29:06 -0400
Subject: Re: [PATCH 0/2] xfsprogs: metadump/mdrestore warns about dirty
 journal
References: <20170411141237.9274-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <997da383-22c9-6e78-12e8-f9c302e06406@sandeen.net>
Date: Thu, 25 May 2017 12:29:04 -0500
MIME-Version: 1.0
In-Reply-To: <20170411141237.9274-1-jtulak@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/11/17 9:12 AM, Jan Tulak wrote:
> If we are exporting obfuscated metadata with a dirty journal, the journal is not obfuscated. So when we restore it and then replay a log, the obfuscated metadata can clash with what is in journal and corrupt the image. So, tell the user about this risk, both when exporting and importing the dump.


I'm going to go ahead & commit these doc changes with some of the
suggestions from the list; once it's in, if people want further tweaks,
send patches.  Trying to wind up the bikeshedding, though.

Thanks,
-Eric

> 
> Git tree on github: https://github.com/jtulak/xfsprogs-dev/tree/metadump
> Based on revision fc1d645
> 
> Jan Tulak (2):
>   metadump: warn about corruption if log is dirty
>   mdrestore: warn about corruption if log is dirty
> 
>  db/metadump.c             |  3 +-
>  mdrestore/Makefile        |  4 +--
>  mdrestore/xfs_mdrestore.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 88 insertions(+), 3 deletions(-)
> 
