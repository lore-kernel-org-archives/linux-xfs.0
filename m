Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C18C4332B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90F264DD8
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Mar 2021 03:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbhCCDP0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Mar 2021 22:15:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1576157AbhCBSin (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Mar 2021 13:38:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614710236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CnUd5Nv/vJw/Go/bA0Hbeyb3h7boNiIfGbOXFND/8bE=;
        b=N/t/yUAieRIbH9HOjFjbGO5O/k3EE3TPuVrvL2e2gM21pagcQEPGc4BiYtpMx1xkAxSxa4
        qiPlAW5KaEXPCQcZ2Pr9Ijm52mRYhIOF/c8iJl8HCL+Ipbcd8Y1RlSeAlcN+0/D03gc+F3
        Kz307foWrURr6NvrtoYifcH0GVB06KE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-HfBVxBp9O5SnJzOU51t9mg-1; Tue, 02 Mar 2021 13:13:10 -0500
X-MC-Unique: HfBVxBp9O5SnJzOU51t9mg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76ED11005501;
        Tue,  2 Mar 2021 18:13:09 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1156F1A864;
        Tue,  2 Mar 2021 18:13:08 +0000 (UTC)
Subject: Re: [PATCH] xfs_admin: don't add '=1' when building repair command
 line for -O
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Geert Hendrickx <geert@hendrickx.be>
References: <20210302172753.GO7272@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <dcc159fe-9dac-9023-8c0d-ad475357d22e@redhat.com>
Date:   Tue, 2 Mar 2021 12:13:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302172753.GO7272@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/2/21 11:27 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Geert Hendrickx reported an inconsistency between the xfs_admin manpage
> and its behavior -- the documentation says that users must provide the
> status explicitly, but the script injects '=1' anyway.  While this seems
> to work with the glibc getsubopt, it's a bit ugly and isn't consistent
> with the docs.
> 
> So, get rid of that extra two bytes.

Neato! Nice catch, Geert, thanks.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Reported-by: Geert Hendrickx <geert@hendrickx.be>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  db/xfs_admin.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
> index 7a467dbe..02f34b73 100755
> --- a/db/xfs_admin.sh
> +++ b/db/xfs_admin.sh
> @@ -20,7 +20,7 @@ do
>  	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
>  	l)	DB_OPTS=$DB_OPTS" -r -c label";;
>  	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
> -	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG=1";;
> +	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
>  	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
>  	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
>  	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
> 

