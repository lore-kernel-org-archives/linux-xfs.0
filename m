Return-Path: <SRS0=aYBA=4Q=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E10C3F2D4
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 11:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EEE246AA
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Feb 2020 11:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EJa97MJl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgB1Lqs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 06:46:48 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46327 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725730AbgB1Lqs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 06:46:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582890407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uf7//lxC1Eha2V3wtQXGxWt9gOiwWK9Nfz9/eqvJ6xM=;
        b=EJa97MJlCKf49/dWGPcwyFGV0IpzzXZ9et8piZPxwK4hs4pYJvDZTPuGEsYbEl/UNev8Fg
        71M1D3x0BcmiDN6KXxojJcIhHPzaxewi3rvz/aswICxQgdi6tmmD8lValW6gtVv1ETBCwe
        fe5uAeIsDzn8bz2veyd9psU2YaALubA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-7RtptGaZMDmrPdF1bSAE4g-1; Fri, 28 Feb 2020 06:46:45 -0500
X-MC-Unique: 7RtptGaZMDmrPdF1bSAE4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A18B107ACC5;
        Fri, 28 Feb 2020 11:46:44 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B364E101D48E;
        Fri, 28 Feb 2020 11:46:41 +0000 (UTC)
Date:   Fri, 28 Feb 2020 19:57:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstests: fix up filters & expected output for latest
 xfs_repair
Message-ID: <20200228115720.GU14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
References: <ea796af5-4f7e-e882-c918-b6ff9f10f91f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea796af5-4f7e-e882-c918-b6ff9f10f91f@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 08:50:49PM -0800, Eric Sandeen wrote:
> A handful of minor changes went into xfs_repair output in the
> last push, so add a few more filters and change the resulting
> expected output.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

This change makes sense, and I've tested it on rhel7, rhel8 and latest upstream
kernel with xfsprogs(for-next), this patch doesn't brings more failures. So it
looks good to me.

Reviewed-by Zorro Lang <zlang@redhat.com>

> 
> I confirmed that xfs/030, xfs/033, and xfs/178 pass on both
> current for-next, as well as v5.4.0
> 
> diff --git a/common/repair b/common/repair
> index 5a9097f4..6668dd51 100644
> --- a/common/repair
> +++ b/common/repair
> @@ -29,7 +29,13 @@ _filter_repair()
>  # for sb
>  /- agno = / && next;	# remove each AG line (variable number)
>  s/(pointer to) (\d+)/\1 INO/;
> -s/(sb root inode value) (\d+)( \(NULLFSINO\))?/\1 INO/;
> +# Changed inode output in 5.5.0
> +s/sb root inode value /sb root inode /;
> +s/realtime bitmap inode value /realtime bitmap inode /;
> +s/realtime summary inode value /realtime summary inode /;
> +s/ino pointer to /inode pointer to /;
> +#
> +s/(sb root inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(realtime bitmap inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(realtime summary inode) (\d+)( \(NULLFSINO\))?/\1 INO/;
>  s/(inconsistent with calculated value) (\d+)/\1 INO/;
> @@ -74,6 +80,8 @@ s/(inode chunk) (\d+)\/(\d+)/AGNO\/INO/;
>  # sunit/swidth reset messages
>  s/^(Note - .*) were copied.*/\1 fields have been reset./;
>  s/^(Please) reset (with .*) if necessary/\1 set \2/;
> +# remove new unlinked inode test
> +/^bad next_unlinked/ && next;
>  # And make them generic so we dont depend on geometry
>  s/(stripe unit) \(.*\) (and width) \(.*\)/\1 (SU) \2 (SW)/;
>  # corrupt sb messages
> diff --git a/tests/xfs/030.out b/tests/xfs/030.out
> index 2b556eec..4a7c4b8b 100644
> --- a/tests/xfs/030.out
> +++ b/tests/xfs/030.out
> @@ -14,12 +14,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> @@ -131,12 +131,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> diff --git a/tests/xfs/178.out b/tests/xfs/178.out
> index 8e0fc8e1..0bebe553 100644
> --- a/tests/xfs/178.out
> +++ b/tests/xfs/178.out
> @@ -12,12 +12,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> @@ -48,12 +48,12 @@ attempting to find secondary superblock...
>  found candidate secondary superblock...
>  verified secondary superblock...
>  writing modified primary superblock
> -sb root inode value INO inconsistent with calculated value INO
> +sb root inode INO inconsistent with calculated value INO
>  resetting superblock root inode pointer to INO
>  sb realtime bitmap inode INO inconsistent with calculated value INO
> -resetting superblock realtime bitmap ino pointer to INO
> +resetting superblock realtime bitmap inode pointer to INO
>  sb realtime summary inode INO inconsistent with calculated value INO
> -resetting superblock realtime summary ino pointer to INO
> +resetting superblock realtime summary inode pointer to INO
>  Phase 2 - using <TYPEOF> log
>          - zero log...
>          - scan filesystem freespace and inode maps...
> 

