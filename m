Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AD5C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 20:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E5AD2081A
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 20:04:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WgUwo3jN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgERUEz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 16:04:55 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35182 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbgERUEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 16:04:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589832292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=ROL/gspeiFhGCSkdB4Nn97v1V8Atu7B7ZbgOiCigiH8=;
        b=WgUwo3jNwWARVl/0kZSvXG3DBsRyO71QLGG82LlVpJLWltj2g/5KJbZDYU6dnMlSZ/dAQk
        FFVOAxezoOjnzSZ6e3hHbTEo8R0fz0pflbcL8GDgKmEF3Em5iZ9ph+rSWhuopt4S+HV65L
        MBuU+Z1wSJ8wDfMPyLjkH7mrc51hGIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-2TB0MaaBM3KyR0JXLtBf_w-1; Mon, 18 May 2020 16:04:50 -0400
X-MC-Unique: 2TB0MaaBM3KyR0JXLtBf_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D267EBFC2
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 20:04:49 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A72526ED80
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 20:04:49 +0000 (UTC)
Subject: Re: [PATCH 1/1] xfs_quota: allow individual timer extension
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <b75aef11-0e7a-7b2d-f6f0-d36af80d5e27@redhat.com>
 <fb0b46ab-98a1-4427-fa5e-4a770c9d0805@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <cf2bd6ae-a42b-80a0-b340-d4b570341aa9@redhat.com>
Date:   Mon, 18 May 2020 15:04:49 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <fb0b46ab-98a1-4427-fa5e-4a770c9d0805@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/18/20 2:24 PM, Eric Sandeen wrote:
> The only grace period which can be set via xfs_quota today is for id 0,
> i.e. the default grace period for all users.  However, setting an
> individual grace period is useful; for example:
> 
>  Alice has a soft quota of 100 inodes, and a hard quota of 200 inodes
>  Alice uses 150 inodes, and enters a short grace period
>  Alice really needs to use those 150 inodes past the grace period
>  The administrator extends Alice's grace period until next Monday
> 
> vfs quota users such as ext4 can do this today, with setquota -T
> 
> xfs_quota can now accept an optional user id or name (symmetric with
> how warn limits are specified), in which case that user's grace period
> is extended to expire the given amount of time from now(). 
> 
> To maintain compatibility with old command lines, if none of 
> [-d|id|name] are specified, default limits are set as before.
> 
> (kernelspace requires updates to enable all this as well.)
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>


> +	/*
> +	 * If id is specified we are extending grace time by value
> +	 * Otherwise we are setting the default grace time
> +	 */
> +	if (id) {
> +		time_t	now;
> +
> +		if (xfsquotactl(XFS_GETQUOTA, dev, type, id, (void *)&d) < 0) {
> +			exitcode = 1;
> +			fprintf(stderr, _("%s: cannot get quota: %s\n"),
> +					progname, strerror(errno));
> +				return;
> +		}
> +
> +		time(&now);
> +
> +		if (d.d_blk_hardlimit && d.d_bcount > d.d_blk_hardlimit)
> +			d.d_btimer = now + value;
> +		if (d.d_ino_softlimit && d.d_icount > d.d_ino_softlimit)
> +			d.d_itimer = now + value;
> +		if (d.d_rtb_softlimit && d.d_rtbcount > d.d_rtb_softlimit)
> +			d.d_rtbtimer = now + value;

realized this might need some clarity (probably a comment).  The idea is that
we don't extend (i.e set) grace period unless the user is already into their
grace period. setquota -T does the same thing:

                if (q->dq_dqb.dqb_bsoftlimit && toqb(q->dq_dqb.dqb_curspace) > q->dq_dqb.dqb_bsoftlimit)
                        q->dq_dqb.dqb_btime = toset.dqb_btime;
                else
                        errstr(_("Not setting block grace time on %s because softlimit is not exceeded.\n"), q->dq_h->qh_quotadev);

Ugh, but also just realized I have a hardlimit/softlimit typo in there, will resend.

-Eric

