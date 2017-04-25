Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:53822 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1950391AbdDYQUf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Apr 2017 12:20:35 -0400
Subject: Re: [PATCH 00/12] mkfs: save user input into opts table
References: <20170423185503.31415-1-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <2bc062f7-eae5-b89a-59e6-4d10daadcd3e@sandeen.net>
Date: Tue, 25 Apr 2017 11:20:34 -0500
MIME-Version: 1.0
In-Reply-To: <20170423185503.31415-1-jtulak@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>, linux-xfs@vger.kernel.org

On 4/23/17 1:54 PM, Jan Tulak wrote:
> Hi guys,
> 
> I decided to split my big patchset into more smaller ones. So, this is the
> first set. It adds set/get functions similar to Dave's suggestion, to save and
> retrieve user values to and from the big opts table and prepares the ground for
> future patches.
> 
> 
> It is a mix of patches I already submitted and new ones:
> Patches 2, 3, 4, 5 are just slightly modified to fix their issues.
> Other patches are new.
> 
> The last few patches could be merged into one, because it should only
> substitute variables for get/set calls, but because there are so many
> places where the changes occurs, I split them into smaller chunks,
> making it (hopefully) easier for you to review.
> 
> This patchset requires my two previous uint patches.

Just to be clear, those were NAK'd, I believe, so these may need
to be rebased without them.

-Eric

> Git tree: https://github.com/jtulak/xfsprogs-dev/tree/setters
> 
> Cheers,
> Jan
> 
> P.S.:
> As a side note, I thought about adding a verification mechanism to
> the set_conf_val() function, which would guarantee that we never have
> an invalid number even later in the code -- an attempt to catch for
> bugs. However, it seems that in some cases, we convert the number
> e.g. from number of 512 byte blocks to fs blocks in situ (L_SUNIT),
> which means that in some occasions, we are getting out of the range
> of allowed values on the input side. So, I'm not adding these checks now,
> but it is an option that could give us a cheap way how to catch some bugs.
> Another question though is, how useful it would be...
> 
> 
> Jan Tulak (12):
>   mkfs: Save raw user input field to the opts struct
>   mkfs: rename defaultval to flagval in opts
>   mkfs: remove intermediate getstr followed by getnum
>   mkfs: merge tables for opts parsing into one table
>   mkfs: extend opt_params with a value field
>   mkfs: create get/set functions for opts table
>   mkfs: save user input values into opts
>   mkfs: replace variables with opts table: -b,d,s options
>   mkfs: replace variables with opts table: -i options
>   mkfs: replace variables with opts table: -l options
>   mkfs: replace variables with opts table: -n options
>   mkfs: replace variables with opts table: -r options
> 
>  mkfs/xfs_mkfs.c | 2457 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 1420 insertions(+), 1037 deletions(-)
> 
