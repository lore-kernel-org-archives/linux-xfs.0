Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19AAC77B61
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Apr 2023 09:40:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjDMJkw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Apr 2023 05:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDMJkv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Apr 2023 05:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7AD4EDE
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 02:40:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681378803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QQIXFJ/yhWS2fGWqO/IEHAS4YiiuwPCJsEdfCtMgQFw=;
        b=gMDOvad21Rz0GlrS9NbnNGrtG8NNHS/jTOj8JbasTaxYddsCgMpbh7iRurBljFIxAm1UpF
        L+Hh/6p51NqLSS+ljyLx9ukHWPltY/A2c10GA5+YKzLdcmfqtPnkj0oEz+qovZfdfLc1wR
        iJxMhH3RmE5iYFvtNiZfjMRH3qLxkaw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-8xXPZDfENdK_U8KRjrsn2w-1; Thu, 13 Apr 2023 05:40:01 -0400
X-MC-Unique: 8xXPZDfENdK_U8KRjrsn2w-1
Received: by mail-qv1-f70.google.com with SMTP id i8-20020a0cd848000000b005e819d53af0so8372152qvj.20
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2023 02:40:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681378800; x=1683970800;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QQIXFJ/yhWS2fGWqO/IEHAS4YiiuwPCJsEdfCtMgQFw=;
        b=Uu5ibSozcuVUdUuysmP7vE9ZnctqmOux/TlBqc6ljFqnYUbiOI98DQ6/aLw0ZAJPA5
         YNat8PPKlMML8B77779M3aOSBjJsiG9s5JrV9/RS0qQfruznyLS1rOE59WRKJoFgaKMP
         gDWSWLp0XDd+jbysdpOn6aFNBwECpQKoZaw2tH89mbDuuTkRj22SlU88GuYtrFcDZWup
         JBRBj0GG354fiALMdK1zfOdxM5SQ+HRaHyQbBUYZvoIfmBV2x2JcH4bpkcO9SRmmIQyq
         KJtourBE5qA0DWHsMbn/uSrWymPcFujBOesqHg1M8SXr53NmUxZLgbk2X+G3bCzi8DG6
         AazQ==
X-Gm-Message-State: AAQBX9f6hWfhAc6vS9yLQozFghmYUezm6dXYXnuOMTmjrZ0TzbkL08uL
        xVSLwX8C2x1bDKXMELllI0HQAnkwful1jmICGq0SMG7jySMeT8b0hvsXp+2KLJCA/t/leh/e9wI
        X/gzlk92ZTlbG/TvQQm74n3VPkhs=
X-Received: by 2002:ad4:5cc5:0:b0:570:ccb9:a4d0 with SMTP id iu5-20020ad45cc5000000b00570ccb9a4d0mr2369066qvb.16.1681378800565;
        Thu, 13 Apr 2023 02:40:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350YK7ptRz6rsQheUt0m67/LpApGpxYAVnVhGvArMmZJt6u1Qb3zExNPwVrmFJamP4SOhoBfdUA==
X-Received: by 2002:ad4:5cc5:0:b0:570:ccb9:a4d0 with SMTP id iu5-20020ad45cc5000000b00570ccb9a4d0mr2369059qvb.16.1681378800283;
        Thu, 13 Apr 2023 02:40:00 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id r3-20020ad45223000000b005ef4de2cc3bsm303004qvq.138.2023.04.13.02.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 02:39:59 -0700 (PDT)
Date:   Thu, 13 Apr 2023 11:39:56 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH] xfs/517: add missing freeze command
Message-ID: <20230413093956.qgsqoqufy3oinhaw@aalbersh.remote.csb>
References: <20230413001043.GA360885@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413001043.GA360885@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 12, 2023 at 05:10:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This test is supposed to race fsstress, fsmap, and freezing for a while,
> but when we converted it to use _scratch_xfs_stress_scrub, the freeze
> loop fell off by accident.  Add it back.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/517 |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/517 b/tests/xfs/517
> index 4481ba41da..68438e544e 100755
> --- a/tests/xfs/517
> +++ b/tests/xfs/517
> @@ -32,7 +32,7 @@ _require_xfs_stress_scrub
>  
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
> -_scratch_xfs_stress_scrub -i 'fsmap -v'
> +_scratch_xfs_stress_scrub -f -i 'fsmap -v'
>  
>  # success, all done
>  echo "Silence is golden"
> 

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

