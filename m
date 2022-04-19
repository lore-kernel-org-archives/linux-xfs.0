Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C2AC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 18:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbiDSSiX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 14:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357705AbiDSSiA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 14:38:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A32424F0C
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650393269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AyKeDt/G+be2E1gyLoCwi+1fRzVFrvAJkghfupIO6no=;
        b=NKHgeixj8SIdf0jNJZUww5bDgmnGew+nze328i/HlVm+C+tERDGkI3zF7Xja9Mktzd1oja
        RIZVIXgfCN9iiZ+s9pr/gv4FuiTczdz+ykxIDB44uPpgiSkTkG2FT+DPpb1s8nPofOvqZt
        Ujg5LSiY7IYsVn9E3tq1IOys/V3Ke1s=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-ycXifQ9HObCqjewVONPtiA-1; Tue, 19 Apr 2022 14:34:28 -0400
X-MC-Unique: ycXifQ9HObCqjewVONPtiA-1
Received: by mail-qt1-f197.google.com with SMTP id cj27-20020a05622a259b00b002f334b76068so2255707qtb.4
        for <linux-xfs@vger.kernel.org>; Tue, 19 Apr 2022 11:34:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=AyKeDt/G+be2E1gyLoCwi+1fRzVFrvAJkghfupIO6no=;
        b=n6PvVu/OnLEBVUu1OCy/Fwc5ihBbSRyhdWbRqN9sM58OQF2gqr5vA6t0EJNMLKwNhu
         wQ6MaXDtE7S9ZrYtV4kh/rjmrZuF9XvpM9ukiDRJCGTbOI9oPNmmjHHmuFuz8DnfFuy1
         BT3C8fQEcZQdWEz0/oXe86TtY5RH1v9PP78ik2Q/bf+C+iX8pJxUEXHp4e31Evc6jD8u
         AHGqk8+JW8g6N52avqCb8h00BAjjGh1kXAXsHQbUols8B1VY7f4CFbOWZbmGlQSjDPP0
         XG0ax+2KwTv5z8z5ZXGOqgvTfJJBB3Zpp6DAV+jDkDX9sWb/PvHgHN5nFr/pYOJKk3WG
         e0JQ==
X-Gm-Message-State: AOAM5317EEZrUM/55tInzDqR9pDNbBEJsqiAcpOk0kOGMWYo8CZ6yd/n
        6VDiukoLICxCcIZifrivR7EQBs2lQGQNzrssMR2dOmlOOD5YT7UAIFI4aI8a+4NDObSuP2hBbcg
        3lf8sNqdBwvm1iSJ2Ta0F
X-Received: by 2002:ad4:5bc7:0:b0:441:53a2:169c with SMTP id t7-20020ad45bc7000000b0044153a2169cmr12977859qvt.8.1650393267595;
        Tue, 19 Apr 2022 11:34:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyiKXC2/RiQDh5CJQRXIQmnuUQY+xhfR/93kuRANErdytCKje+pae6FFWxAjEY+Jyt60VC7Lw==
X-Received: by 2002:ad4:5bc7:0:b0:441:53a2:169c with SMTP id t7-20020ad45bc7000000b0044153a2169cmr12977843qvt.8.1650393267365;
        Tue, 19 Apr 2022 11:34:27 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n8-20020ac85a08000000b002f1fc230725sm449116qta.31.2022.04.19.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 11:34:26 -0700 (PDT)
Date:   Wed, 20 Apr 2022 02:34:21 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 2/2] generic/019: fix incorrect unset statements
Message-ID: <20220419183421.ohwmohh3tl3wi6li@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>, guaneryu@gmail.com,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
References: <165038951495.1677615.10687913612774985228.stgit@magnolia>
 <165038952637.1677615.2651496553218188517.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165038952637.1677615.2651496553218188517.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 19, 2022 at 10:32:06AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Fix incorrect usage of unset -- one passes the name of the variable, not
> the *value* contained within it.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/generic/019 |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/tests/generic/019 b/tests/generic/019
> index 854ba57d..45c91624 100755
> --- a/tests/generic/019
> +++ b/tests/generic/019
> @@ -140,8 +140,8 @@ _workout()
>  	kill $fs_pid &> /dev/null
>  	wait $fs_pid
>  	wait $fio_pid
> -	unset $fs_pid
> -	unset $fio_pid
> +	unset fs_pid
> +	unset fio_pid
>  
>  	# We expect that broken FS still can be umounted
>  	run_check _scratch_unmount
> 

